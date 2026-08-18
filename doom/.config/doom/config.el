;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;; (setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;     doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))

;;(setq doom-font (font-spec :family "JetBrains Mono Nerd Font" :size 14 :weight 'medium)
;;    doom-variable-pitch-font (font-spec :family "Fira Sans" :size 14))
(setq doom-font (font-spec :family "IoskeleyMonoTerm Nerd Font" :size 14 :weight 'medium)
    doom-variable-pitch-font (font-spec :family "Fira Sans" :size 14))

;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;;(setq doom-theme 'doom-one)
(setq doom-theme 'doom-rouge)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

(setq doom-modeline-icon t)

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Ensure the cursor stays a bar or box consistently without modal states
;;(setq-default cursor-type 'box)

;; If you want to use standard Emacs 'C-x C-c' to quit without Evil asking questions
(global-set-key (kbd "C-x C-c") 'save-buffers-kill-terminal)

;; start doom emacs maximized
(add-to-list 'default-frame-alist '(fullscreen . maximized))


;; ==================== CURSOR CONFIGURATION ====================

;; 1. Set the default fallback typing cursor to a vertical bar
(setq-default cursor-type '(bar . 2))

;; 2. Hide the frozen cursor in background windows to keep focus clear
(setq cursor-in-non-selected-windows nil)

;; 3. Unified engine to dynamically change cursor shape
(defun my-update-cursor-style ()
  "Dynamically adjust cursor based on buffer state."
  (cond
   (buffer-read-only (setq cursor-type 'box))         ; Read-only = Box
   (overwrite-mode   (setq cursor-type '(hbar . 2)))  ; Overwrite = Underbar
   (t                (setq cursor-type '(bar . 2))))) ; Default = Vertical Bar

;; 4. Trigger the cursor check immediately on state changes
(add-hook 'overwrite-mode-hook #'my-update-cursor-style)
(add-hook 'read-only-mode-hook #'my-update-cursor-style)

;; 5. Safely check and update the cursor whenever you interact with a window.
;; The 'fboundp' check ensures that if Emacs is shutting down and clears this
;; function, it won't throw an error.
(add-hook 'post-command-hook
          (lambda ()
            (when (fboundp 'my-update-cursor-style)
              (my-update-cursor-style))))

;; Associate all files under ~/.config/bash with sh-mode
(add-to-list 'auto-mode-alist '("\\.config/bash/" . sh-mode))
(add-to-list 'auto-mode-alist '("\\.profile\\'" . sh-mode))
(add-to-list 'auto-mode-alist '("\\.bash_aliases\\'" . sh-mode))
(add-to-list 'auto-mode-alist '("\\.bashrc\\'" . sh-mode))
(add-to-list 'auto-mode-alist '("\\.bash_profile\\'" . sh-mode))
(add-to-list 'auto-mode-alist '("\\.inputrc\\'" . conf-mode))