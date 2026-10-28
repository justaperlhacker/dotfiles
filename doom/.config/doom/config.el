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
;;(setq doom-font (font-spec :family "IoskeleyMonoTerm Nerd Font" :size 14 :weight 'medium)
;;    doom-variable-pitch-font (font-spec :family "Fira Sans" :size 14))

;;(setq doom-font (font-spec :family "HE_TERMINAL Nerd Font" :size 14)
;;    doom-variable-pitch-font (font-spec :family "Fira Sans" :size 14))

;;(setq doom-font (font-spec :family "BerkelyMono Nerd Font" :size 14)
;;    doom-variable-pitch-font (font-spec :family "Fira Sans" :size 14))

(setq doom-font-size
      (pcase (downcase (or (system-name) ""))
        ("blackslate" 24)  ; 2K laptop: bump size for readability
        ("destro" 16)
        (_ 16)))

;;(setq doom-font-weight 'normal)
(setq doom-font-weight 'medium)

(setq doom-font-family "BerkeleyMono Nerd Font"
      doom-variable-font-family "Fira Sans")

(setq doom-font (font-spec :family doom-font-family :size doom-font-size :weight doom-font-weight)
      doom-variable-pitch-font (font-spec :family doom-variable-font-family :size doom-font-size))

;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;;(setq doom-theme 'doom-one)
;; Custom themes living in $DOOMDIR/themes (ports of the fresh-editor palettes,
;; the nvim mini.hues seasons, naysayer, the vscode-themes repo, and all 41
;; stock 10x Editor schemes — matching ~/.config/fresh, ~/.config/nvim,
;; ~/.vscode, ~/.xwpe, ~/Projects/vscode-themes and ~/Projects/kakoune-themes).
;; 10x examples: doom-10x-sunset (the 10x default), doom-10x-terracotta,
;; doom-10x-monokai, doom-10x-gruvbox-dark, doom-10x-solarized-dark.
;; Regenerate with:
;;   python3 $DOOMDIR/scripts/gen_doom_themes.py
(setq doom-theme 'doom-kanso)

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

;; ==================== EVIL HYBRID EDITING ====================
;; Doom has no +hybrid flag; this makes Emacs-style keys (C-a C-e C-k C-y ...)
;; available in insert state, like Spacemacs's hybrid-mode.
;; NOTE: evil is currently disabled in init.el, so this is inert until re-enabled.
(setq evil-disable-insert-state-bindings t)

;; ==================== TREEMACS FOCUS ====================
(map! :leader :desc "Focus treemacs" "o RET" #'treemacs-select-window)
;; Global (rather than :n) so it works whether or not evil is enabled.
(map! :desc "Focus treemacs" "M-0" #'treemacs-select-window)

;; ==================== PERL ====================
;; perllsp over Eglot (cargo install perllsp; binary at ~/.cargo/bin/perllsp).
;; lang/perl no longer exists in Doom 2.2.4, so this is wired up by hand.
;; Project settings live in .perl-lsp.toml. Upstream Emacs/Eglot guide:
;; https://github.com/EffortlessMetrics/perl-lsp/blob/master/docs/EDITORS/EMACS_SETUP.md
(after! eglot
  (add-to-list 'eglot-server-programs
               '(((cperl-mode :language-id "perl")
                  (perl-mode :language-id "perl"))
                 . ("perllsp" "--stdio"))))

;; Fallback: PerlNavigator (AUR: nodejs-perlnavigator-server / perlnavigator).
;; To switch back, comment out the perllsp entry above and uncomment this one.
;; (after! eglot
;;   (add-to-list 'eglot-server-programs
;;                '(((cperl-mode :language-id "perl")
;;                   (perl-mode :language-id "perl"))
;;                  . ("perlnavigator" "--stdio"))))

;; Start Eglot automatically, like Doom's language modules do.
(add-hook 'cperl-mode-local-vars-hook #'lsp! 'append)
(add-hook 'perl-mode-local-vars-hook #'lsp! 'append)

;; Prefer cperl-mode over the built-in perl-mode for .pl/.pm files.
;; (Leave .t alone: Raku tests use that extension too.)
(add-to-list 'auto-mode-alist '("\\.p[lm]\\'" . cperl-mode))
