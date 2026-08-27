/*
 * trayxeyes.c - xeyes as an i3bar system-tray icon.
 *
 * Docks a small window into the freedesktop system tray (XEmbed /
 * _NET_SYSTEM_TRAY_REQUEST_DOCK, hosted by i3bar) and draws a pair of
 * eyes that follow the pointer, like xeyes.
 *
 * Robustness: clicks never quit the app; X errors are logged and
 * ignored; if i3bar destroys/kicks the icon, the window is recreated
 * and re-docked automatically.
 *
 * Build:
 *   make
 */
#define _DEFAULT_SOURCE

#include <X11/Xlib.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define SYSTEM_TRAY_REQUEST_DOCK 0
#define XEMBED_MAPPED (1L << 0)

static Display *dpy;
static int screen;
static Window win;
static GC gc;
static Pixmap buf;
static int buf_w = 0, buf_h = 0;
static int win_w = 22, win_h = 22;
static int docked = 0;
static Window last_tray = 0;
static Atom xembed_info, net_op, net_tray_s0;

/* gruvbox bar background */
static unsigned long bg_pixel = 0x1d2021;

static int xerr_handler(Display *d, XErrorEvent *e)
{
    char msg[256];
    if (XGetErrorText(d, e->error_code, msg, sizeof(msg)) == 0)
        snprintf(msg, sizeof(msg), "X error %d", e->error_code);
    if (e->error_code != BadDrawable && e->error_code != BadWindow && e->error_code != BadMatch)
        fprintf(stderr, "trayxeyes: %s (ignored)\n", msg);
    return 0;
}

static int win_alive(void)
{
    XWindowAttributes wa;
    return XGetWindowAttributes(dpy, win, &wa) != 0;
}

static void create_icon(void)
{
    win = XCreateSimpleWindow(dpy, RootWindow(dpy, screen), 0, 0,
                              win_w, win_h, 0,
                              XBlackPixel(dpy, screen),
                              XWhitePixel(dpy, screen));
    XSelectInput(dpy, win, ExposureMask | StructureNotifyMask | ButtonPressMask);

    /* advertise XEMBED capabilities; the tray host maps us */
    unsigned long info[2] = { 0, XEMBED_MAPPED };
    XChangeProperty(dpy, win, xembed_info, xembed_info, 32,
                    PropModeReplace, (unsigned char *)info, 2);

    gc = XCreateGC(dpy, win, 0, NULL);
    docked = 0;
}

static void destroy_icon(void)
{
    if (buf) {
        XFreePixmap(dpy, buf);
        buf = 0;
        buf_w = buf_h = 0;
    }
    if (gc) {
        XFreeGC(dpy, gc);
        gc = 0;
    }
    if (win) {
        XDestroyWindow(dpy, win);
        win = 0;
    }
    docked = 0;
}

static void draw(Drawable d)
{
    Window root = RootWindow(dpy, screen);
    Window root_ret, child_ret, trans;
    int rx, ry, win_x, win_y, px = 0, py = 0;
    unsigned int mask;

    unsigned long white = XWhitePixel(dpy, screen);
    unsigned long black = XBlackPixel(dpy, screen);

    if (win_w < 4 || win_h < 4)
        return;

    XTranslateCoordinates(dpy, win, root, 0, 0, &px, &py, &trans);
    XQueryPointer(dpy, root, &root_ret, &child_ret, &rx, &ry,
                   &win_x, &win_y, &mask);
    (void)root_ret;
    (void)child_ret;
    (void)win_x;
    (void)win_y;
    (void)trans;

    if (!buf || buf_w != win_w || buf_h != win_h) {
        if (buf)
            XFreePixmap(dpy, buf);
        buf = XCreatePixmap(dpy, win, win_w, win_h,
                            DefaultDepth(dpy, screen));
        buf_w = win_w;
        buf_h = win_h;
    }

    double cx = win_w / 2.0, cy = win_h / 2.0;
    double ex[2] = { win_w * 0.27, win_w * 0.73 };
    double rx_eye = win_w * 0.19;
    double ry_eye = win_h * 0.38;
    double pupil_r = (rx_eye < ry_eye ? rx_eye : ry_eye) * 0.45;

    /* pointer direction relative to the center of this window */
    double dx = rx - (px + cx);
    double dy = ry - (py + cy);
    double len = hypot(dx, dy);
    double maxr = (rx_eye < ry_eye ? rx_eye : ry_eye) - pupil_r;
    if (len > maxr && len > 0.0001) {
        dx *= maxr / len;
        dy *= maxr / len;
    }

    XSetForeground(dpy, gc, bg_pixel);
    XFillRectangle(dpy, buf, gc, 0, 0, win_w, win_h);

    /* eye whites and outlines */
    XSetForeground(dpy, gc, white);
    for (int i = 0; i < 2; i++)
        XFillArc(dpy, buf, gc, (int)(ex[i] - rx_eye), (int)(cy - ry_eye),
                 (int)(2 * rx_eye), (int)(2 * ry_eye), 0, 360 * 64);
    XSetForeground(dpy, gc, black);
    for (int i = 0; i < 2; i++)
        XDrawArc(dpy, buf, gc, (int)(ex[i] - rx_eye), (int)(cy - ry_eye),
                 (int)(2 * rx_eye), (int)(2 * ry_eye), 0, 360 * 64);

    /* pupils */
    for (int i = 0; i < 2; i++)
        XFillArc(dpy, buf, gc, (int)(ex[i] + dx) - (int)pupil_r,
                 (int)(cy + dy) - (int)pupil_r, (int)(2 * pupil_r),
                 (int)(2 * pupil_r), 0, 360 * 64);

    XCopyArea(dpy, buf, d, gc, 0, 0, win_w, win_h, 0, 0);
    XFlush(dpy);
}

static void try_dock(void)
{
    Window tray = XGetSelectionOwner(dpy, net_tray_s0);
    if (tray != last_tray) {
        last_tray = tray;
        docked = 0;
    }
    if (tray == None || docked)
        return;

    XEvent ev;
    memset(&ev, 0, sizeof(ev));
    ev.xclient.type = ClientMessage;
    ev.xclient.window = tray;
    ev.xclient.message_type = net_op;
    ev.xclient.format = 32;
    ev.xclient.data.l[0] = CurrentTime;
    ev.xclient.data.l[1] = SYSTEM_TRAY_REQUEST_DOCK;
    ev.xclient.data.l[2] = win;
    XSendEvent(dpy, tray, False, NoEventMask, &ev);
    XSync(dpy, False);
    docked = 1;
}

int main(void)
{
    dpy = XOpenDisplay(NULL);
    if (!dpy) {
        fprintf(stderr, "trayxeyes: cannot open display\n");
        return 1;
    }
    screen = DefaultScreen(dpy);

    net_tray_s0 = XInternAtom(dpy, "_NET_SYSTEM_TRAY_S0", False);
    net_op = XInternAtom(dpy, "_NET_SYSTEM_TRAY_OPCODE", False);
    xembed_info = XInternAtom(dpy, "_XEMBED_INFO", False);

    XSetErrorHandler(xerr_handler);

    create_icon();
    try_dock();

    for (;;) {
        while (XPending(dpy)) {
            XEvent ev;
            XNextEvent(dpy, &ev);
            switch (ev.type) {
            case ConfigureNotify:
                win_w = ev.xconfigure.width;
                win_h = ev.xconfigure.height;
                break;
            case Expose:
                if (ev.xexpose.count == 0)
                    draw(ev.xexpose.window);
                break;
            case ButtonPress:
            case ButtonRelease:
                /* clicks are a no-op: the icon must never vanish */
                break;
            }
        }

        /* if the tray destroyed our window, rebuild and re-dock */
        if (win && !win_alive()) {
            destroy_icon();
            create_icon();
        }

        if (win)
            draw(win);

        usleep(30000); /* ~33 fps */
        try_dock();
    }
}