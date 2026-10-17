;;; doom-vscode-red-theme.el --- Port of VSCode's built-in Red theme -*- lexical-binding: t; no-byte-compile: t; -*-
;;
;; Author: johnm
;; Source: microsoft/vscode extensions/theme-red/themes/Red-color-theme.json
;; Palette kept in sync with:
;;   ~/.config/fresh/themes/vscode-red.json
;;   ~/.config/nvim/colors/vscode-red.lua
;;
;;; Commentary:
;;
;; A dark, blood-red take on VSCode's built-in "Red" theme. The background is a
;; deep maroon (#390000) rather than grey, with red-toned syntax highlighting to
;; match the fresh-editor and Neovim ports of the same theme.
;;
;;; Code:

(require 'doom-themes)


;;
;;; Variables

(defgroup doom-vscode-red-theme nil
  "Options for the `doom-vscode-red' theme."
  :group 'doom-themes)

(defcustom doom-vscode-red-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds a 4px padding to the mode-line.
Can be an integer to determine the exact padding."
  :group 'doom-vscode-red-theme
  :type '(choice integer boolean))

(defcustom doom-vscode-red-comment-bg nil
  "If non-nil, comments will have a subtle, darker background.
Enhancing their legibility."
  :group 'doom-vscode-red-theme
  :type 'boolean)


;;
;;; Theme definition

(def-doom-theme doom-vscode-red
  "A dark red theme ported from VSCode's built-in Red theme."

  ;; name        default   256       16
  ((bg         '("#390000" "#390000" nil            ))
   (bg-alt     '("#300000" "#300000" nil            ))
   (base0      '("#2a0000" "#2a0000" "black"        ))
   (base1      '("#330000" "#330000" "brightblack"  ))
   (base2      '("#3d0000" "#3d0000" "brightblack"  ))
   (base3      '("#490000" "#490000" "brightblack"  ))
   (base4      '("#580000" "#580000" "brightblack"  ))
   (base5      '("#6b0000" "#6b0000" "brightblack"  ))
   (base6      '("#8f5050" "#8f5050" "brightblack"  ))
   (base7      '("#cf9090" "#cf9090" "brightblack"  ))
   (base8      '("#F8F8F8" "#F8F8F8" "white"        ))
   (fg         '("#F8F8F8" "#F8F8F8" "brightwhite"  ))
   (fg-alt     '("#cf9090" "#cf9090" "white"        ))

   (grey       base6)
   (red        '("#ff5555" "#ff5555" "red"          ))
   (light-red  '("#ff8888" "#ff8888" "brightred"    ))
   (bright-red '("#ff7778" "#ff7778" "brightred"    ))
   (dark-red   '("#8f5050" "#8f5050" "red"          ))
   (orange     '("#ffb86c" "#ffb86c" "brightred"    ))
   (salmon     '("#ce9178" "#ce9178" "brightred"    ))
   (green      '("#98c379" "#98c379" "green"        ))
   (teal       '("#56d4dd" "#56d4dd" "brightgreen"  ))
   (yellow     '("#ffd75f" "#ffd75f" "brightyellow" ))
   (gold       '("#ffe49c" "#ffe49c" "yellow"       ))
   (blue       '("#82aaff" "#82aaff" "brightblue"   ))
   (dark-blue  '("#3d5a99" "#3d5a99" "blue"         ))
   (magenta    '("#ff79c6" "#ff79c6" "brightmagenta"))
   (violet     '("#ffa3d6" "#ffa3d6" "magenta"       ))
   (cyan       '("#56d4dd" "#56d4dd" "brightcyan"   ))
   (dark-cyan  '("#8ee4ea" "#8ee4ea" "cyan"         ))
   (pink       '("#ff9d9d" "#ff9d9d" "brightred"    ))
   (rose       '("#ffc9c9" "#ffc9c9" "brightred"    ))

   ;; face categories -- required for all themes
   (highlight      red)
   (vertical-bar   (doom-darken bg 0.15))
   (selection      "#750000")
   (builtin        bright-red)
   (comments       '("#a8766c" "#a8766c" "brightblack"))
   (doc-comments   '("#c98a7d" "#c98a7d" "brightblack"))
   (constants      '("#ffaaaa" "#ffaaaa" "brightred"))
   (functions      '("#FFD0AA" "#FFD0AA" "brightyellow"))
   (keywords       bright-red)
   (methods        '("#FFD0AA" "#FFD0AA" "brightyellow"))
   (operators      '("#e0999a" "#e0999a" "brightred"))
   (type           rose)
   (strings        salmon)
   (variables      fg)
   (numbers        orange)
   (region         "#750000")
   (error          red)
   (warning        yellow)
   (success        green)
   (vc-modified    orange)
   (vc-added       green)
   (vc-deleted     red)

   ;; custom categories
   (modeline-bg     "#700000")
   (modeline-bg-alt (doom-darken bg 0.1))
   (modeline-fg     fg)
   (modeline-fg-alt base7)

   (hidden     `(,(car bg) "black" "black"))
   (-modeline-pad
    (when doom-vscode-red-padded-modeline
      (if (integerp doom-vscode-red-padded-modeline) doom-vscode-red-padded-modeline 4)))

   (modeline-bg-l `(,(doom-darken (car bg) 0.1) ,@(cdr base0)))
   (modeline-bg-inactive   (doom-darken bg 0.1))
   (modeline-bg-inactive-l `(,(car bg) ,@(cdr base1))))

  ;;;; Base theme face overrides
  (((font-lock-comment-face &override)
    :background (if doom-vscode-red-comment-bg bg-alt 'unspecified)
    :slant 'italic)
   ((font-lock-keyword-face &override) :weight 'bold)
   ((font-lock-function-name-face &override) :foreground functions)
   ((font-lock-variable-name-face &override) :foreground variables)
   ((font-lock-type-face &override) :foreground type)
   ((font-lock-constant-face &override) :foreground constants)
   ((font-lock-builtin-face &override) :foreground builtin)
   ((font-lock-warning-face &override) :foreground error :weight 'bold)
   ((line-number &override) :foreground "#9e5252")
   ((line-number-current-line &override)
    :foreground "#ffbbbb" :background "#4d0000" :weight 'bold)

   (font-lock-comment-delimiter-face :foreground comments)
   (font-lock-doc-face :foreground doc-comments :slant 'italic)
   (font-lock-string-face :foreground strings)
   (font-lock-number-face :foreground numbers)
   (font-lock-operator-face :foreground operators)
   (font-lock-preprocessor-face :foreground magenta)
   (font-lock-negation-char-face :foreground bright-red)
   (font-lock-regexp-grouping-backslash :foreground magenta)
   (font-lock-regexp-grouping-construct :foreground violet)

   (cursor :background red :foreground bg)
   (region :background region :foreground fg :extend t)
   (secondary-selection :background "#680000" :extend t)
   (hl-line :background "#4d0000" :extend t)
   (highlight :background highlight :foreground base0)
   (fringe :background bg :foreground base5)
   (vertical-border :foreground base4)
   (border :foreground base4 :background base4)
   (shadow :foreground base6)
   (link :foreground "#FFD0AA" :underline t :weight 'bold)
   (link-visited :foreground violet :underline t :weight 'normal)
   (success :foreground success :weight 'bold)
   (warning :foreground warning :weight 'bold)
   (error :foreground error :weight 'bold)
   (match :background "#991111" :foreground fg :weight 'bold)

   (isearch :background "#cc3333" :foreground bg :weight 'bold)
   (isearch-fail :background "#6b0000" :foreground red :weight 'bold)
   (lazy-highlight :background "#750000" :foreground fg :weight 'bold)
   (show-paren-match :background "#750000" :foreground fg :weight 'ultra-bold)
   (show-paren-mismatch :background red :foreground bg :weight 'ultra-bold)

   (minibuffer-prompt :foreground "#FFD0AA" :weight 'bold)

   (mode-line
    :background modeline-bg :foreground modeline-fg
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg)))
   (mode-line-inactive
    :background modeline-bg-inactive :foreground modeline-fg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive)))
   (mode-line-emphasis :foreground fg :weight 'bold)
   (mode-line-buffer-id :foreground "#FFD0AA" :weight 'bold)
   (mode-line-highlight :inherit 'highlight :distant-foreground bg)

   (tooltip :background bg-alt :foreground fg)
   (file-name-shadow :foreground base6)

   ;;;; all-the-icons
   (all-the-icons-red :foreground red)
   (all-the-icons-dred :foreground dark-red)

   ;;;; centaur-tabs
   (centaur-tabs-default :background bg-alt :foreground base7)
   (centaur-tabs-selected :background "#490000" :foreground fg :weight 'bold)
   (centaur-tabs-unselected :background "#300a0a" :foreground base7)
   (centaur-tabs-selected-modified :background "#490000" :foreground "#FFD0AA" :weight 'bold)
   (centaur-tabs-unselected-modified :background "#300a0a" :foreground "#FFD0AA")
   (centaur-tabs-active-bar-face :background red)
   (centaur-tabs-modified-marker-selected :inherit 'centaur-tabs-selected :foreground red)
   (centaur-tabs-modified-marker-unselected :inherit 'centaur-tabs-unselected :foreground red)

   ;;;; company
   (company-tooltip :background bg-alt :foreground fg)
   (company-tooltip-selection :background "#580000" :foreground fg :weight 'bold)
   (company-tooltip-common :foreground "#FFD0AA" :weight 'bold)
   (company-tooltip-common-selection :foreground "#FFD0AA")
   (company-tooltip-annotation :foreground orange)
   (company-scrollbar-fg :background base4)
   (company-scrollbar-bg :background bg-alt)
   (company-preview :foreground base7 :slant 'italic)
   (company-preview-common :foreground "#FFD0AA" :slant 'italic)

   ;;;; corfu
   (corfu-default :background bg-alt :foreground fg)
   (corfu-current :background "#580000" :foreground fg :weight 'bold)
   (corfu-bar :background red)
   (corfu-border :background base4)

   ;;;; css-mode <built-in> / scss-mode
   (css-proprietary-property :foreground orange)
   (css-property :foreground green)
   (css-selector :foreground bright-red)

   ;;;; dired
   (dired-directory :foreground "#FFD0AA" :weight 'bold)
   (dired-flagged :foreground red)
   (dired-header :foreground "#FFD0AA" :weight 'bold)
   (dired-ignored :foreground base6)
   (dired-mark :foreground red :weight 'bold)
   (dired-marked :foreground red :weight 'bold)
   (dired-perm-write :foreground yellow)
   (dired-symlink :foreground violet :slant 'italic)
   (dired-warning :foreground yellow)

   ;;;; doom-modeline
   (doom-modeline-bar :background red)
   (doom-modeline-buffer-file :inherit 'mode-line-buffer-id :weight 'bold)
   (doom-modeline-buffer-path :foreground fg)
   (doom-modeline-buffer-major-mode :inherit 'doom-modeline-buffer-path)
   (doom-modeline-buffer-modified :foreground "#FFD0AA" :weight 'bold)
   (doom-modeline-buffer-minor-mode :foreground base7)
   (doom-modeline-project-dir :foreground "#FFD0AA" :weight 'bold)
   (doom-modeline-project-root-dir :foreground "#FFD0AA")
   (doom-modeline-info :foreground green :weight 'bold)
   (doom-modeline-warning :foreground yellow :weight 'bold)
   (doom-modeline-urgent :foreground red :weight 'bold)
   (doom-modeline-debug :foreground base7)
   (doom-modeline-lsp-success :foreground green :weight 'bold)
   (doom-modeline-evil-insert-state :foreground green)
   (doom-modeline-evil-emacs-state :foreground violet)
   (doom-modeline-evil-normal-state :foreground red)
   (doom-modeline-evil-visual-state :foreground yellow)

   ;;;; ediff <built-in>
   (ediff-fine-diff-A :background (doom-darken red 0.55) :weight 'bold)
   (ediff-current-diff-A :background (doom-darken base0 0.25))

   ;;;; elfeed
   (elfeed-search-date-face :foreground base7)
   (elfeed-search-feed-face :foreground "#FFD0AA")

   ;;;; help / info
   (help-key-binding :foreground "#FFD0AA" :background bg-alt :weight 'bold)
   (info-title-1 :foreground "#FFD0AA" :weight 'bold :height 1.3)
   (info-title-2 :foreground bright-red :weight 'bold :height 1.2)
   (info-title-3 :foreground rose :weight 'bold)
   (info-title-4 :foreground red :weight 'bold)
   (Info-quoted :foreground orange)

   ;;;; ivy
   (ivy-current-match :background "#580000" :foreground fg :weight 'bold)
   (ivy-minibuffer-match-face-1 :foreground base7)
   (ivy-minibuffer-match-face-2 :foreground "#FFD0AA" :weight 'extra-bold)
   (ivy-minibuffer-match-face-3 :foreground rose)
   (ivy-minibuffer-match-face-4 :foreground yellow)
   (ivy-posframe :background bg-alt)
   (ivy-posframe-border :background red)

   ;;;; magit
   (magit-section-highlight :background (doom-blend red bg 0.15) :extend t)
   (magit-section-heading :foreground red :weight 'bold)
   (magit-section-heading-selection :foreground "#FFD0AA" :weight 'bold)
   (magit-diff-hunk-heading :foreground bg :background (doom-blend red bg 0.3) :extend t)
   (magit-diff-hunk-heading-highlight :foreground bg :background red :weight 'bold :extend t)
   (magit-diff-context :foreground base7 :background bg :extend t)
   (magit-diff-context-highlight :foreground fg :background (doom-blend red bg 0.15) :extend t)
   (magit-diff-added :foreground green :background (doom-blend green bg 0.15))
   (magit-diff-added-highlight :foreground green :background (doom-blend green bg 0.25))
   (magit-diff-removed :foreground red :background (doom-blend red bg 0.15))
   (magit-diff-removed-highlight :foreground red :background (doom-blend red bg 0.25))
   (magit-diff-base :foreground yellow :background (doom-blend yellow bg 0.15))
   (magit-diff-base-highlight :foreground yellow :background (doom-blend yellow bg 0.25))
   (magit-hash :foreground base6)
   (magit-branch-local :foreground "#FFD0AA" :weight 'bold)
   (magit-branch-remote :foreground red :weight 'bold)
   (magit-tag :foreground yellow)
   (magit-log-author :foreground base7)
   (magit-log-date :foreground base6)
   (magit-process-ok :foreground green :weight 'bold)
   (magit-process-ng :foreground red :weight 'bold)

   ;;;; markdown-mode
   (markdown-header-face :foreground red :weight 'bold)
   (markdown-header-delimiter-face :foreground red)
   (markdown-inline-code-face :foreground "#FFD0AA" :background bg-alt)
   ((markdown-code-face &override) :background (doom-darken bg 0.2))
   (markdown-link-face :foreground "#FFD0AA" :underline t)
   (markdown-url-face :foreground violet :underline t)
   (markdown-markup-face :foreground base6)

   ;;;; mic-paren
   ((paren-face-match &override) :foreground red :background "#750000" :weight 'ultra-bold)
   ((paren-face-mismatch &override) :foreground bg :background red :weight 'ultra-bold)

   ;;;; nlinum / linum
   (nlinum-relative-current-face :foreground "#ffbbbb" :weight 'bold)

   ;;;; org <built-in>
   (org-hide :foreground hidden)
   (org-level-1 :foreground "#FFD0AA" :weight 'bold :height 1.2)
   (org-level-2 :foreground red :weight 'bold :height 1.1)
   (org-level-3 :foreground rose :weight 'bold)
   (org-level-4 :foreground magenta :weight 'bold)
   (org-level-5 :foreground orange :weight 'bold)
   (org-level-6 :foreground yellow :weight 'bold)
   (org-level-7 :foreground green :weight 'bold)
   (org-level-8 :foreground cyan :weight 'bold)
   (org-document-title :foreground "#FFD0AA" :weight 'bold :height 1.35)
   (org-document-info :foreground base7)
   (org-todo :foreground red :weight 'bold)
   (org-done :foreground green :weight 'bold)
   (org-headline-done :foreground base6)
   (org-ellipsis :foreground red :underline nil)
   (org-table :foreground violet)
   (org-formula :foreground yellow)
   (org-checkbox :foreground "#FFD0AA" :weight 'bold)
   (org-date :foreground "#FFD0AA" :underline t)
   (org-special-keyword :foreground base7)
   (org-tag :foreground base6 :weight 'normal)
   (org-link :foreground "#FFD0AA" :underline t :weight 'bold)
   (org-priority :foreground red :weight 'bold)
   (org-code :foreground "#FFD0AA")
   (org-verbatim :foreground violet)
   ((org-block &override) :background (doom-darken bg 0.2))
   ((org-block-background &override) :background (doom-darken bg 0.2))
   ((org-block-begin-line &override) :background (doom-darken bg 0.2) :foreground base7 :slant 'italic)
   ((org-block-end-line &override) :background (doom-darken bg 0.2) :foreground base7 :slant 'italic)
   (org-quote :foreground base7 :background (doom-darken bg 0.2) :slant 'italic)

   ;;;; rainbow-delimiters (mirrors fresh vscode-red palette)
   (rainbow-delimiters-depth-1-face :foreground red)
   (rainbow-delimiters-depth-2-face :foreground yellow)
   (rainbow-delimiters-depth-3-face :foreground "#FFD0AA")
   (rainbow-delimiters-depth-4-face :foreground orange)
   (rainbow-delimiters-depth-5-face :foreground magenta)
   (rainbow-delimiters-depth-6-face :foreground cyan)
   (rainbow-delimiters-depth-7-face :foreground green)
   (rainbow-delimiters-depth-8-face :foreground violet)
   (rainbow-delimiters-depth-9-face :foreground rose)
   (rainbow-delimiters-mismatched-face :foreground red :weight 'bold)
   (rainbow-delimiters-unmatched-face :foreground red :weight 'bold)

   ;;;; solaire-mode
   (solaire-mode-line-face
    :inherit 'mode-line :background modeline-bg-l
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-l)))
   (solaire-mode-line-inactive-face
    :inherit 'mode-line-inactive :background modeline-bg-inactive-l
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive-l)))
   (solaire-default-face :background bg-alt :foreground fg)
   (solaire-hl-line-face :background "#4d0000" :extend t)
   (solaire-region-face :background region)

   ;;;; tab-bar
   (tab-bar :background bg-alt :foreground base7 :box nil)
   (tab-bar-tab :background "#490000" :foreground fg :weight 'bold :box nil)
   (tab-bar-tab-inactive :background "#300a0a" :foreground base7 :box nil)

   ;;;; tab-line
   (tab-line :background bg-alt :foreground base7 :box nil)
   (tab-line-tab :background "#300a0a" :foreground base7 :box nil)
   (tab-line-tab-current :background "#490000" :foreground fg :weight 'bold :box nil)
   (tab-line-tab-inactive :background "#300a0a" :foreground base7 :box nil)
   (tab-line-highlight :background "#580000" :foreground fg)

   ;;;; terminal
   (term-color-black :foreground "#300000" :background "#300000")
   (term-color-red :foreground "#ff5555" :background "#ff5555")
   (term-color-green :foreground "#98c379" :background "#98c379")
   (term-color-yellow :foreground "#ffd75f" :background "#ffd75f")
   (term-color-blue :foreground "#82aaff" :background "#82aaff")
   (term-color-magenta :foreground "#ff79c6" :background "#ff79c6")
   (term-color-cyan :foreground "#56d4dd" :background "#56d4dd")
   (term-color-white :foreground "#F8F8F8" :background "#F8F8F8")

   ;;;; treemacs
   (treemacs-root-face :foreground "#FFD0AA" :weight 'ultra-bold :height 1.2)
   (doom-themes-treemacs-root-face :foreground "#FFD0AA" :weight 'ultra-bold :height 1.2)
   (doom-themes-treemacs-file-face :foreground fg)
   (treemacs-directory-face :foreground "#FFD0AA" :weight 'bold)
   (treemacs-file-face :foreground fg)
   (treemacs-git-modified-face :foreground orange)
   (treemacs-git-untracked-face :foreground base7)
   (treemacs-git-added-face :foreground green)
   (treemacs-git-conflict-face :foreground red)

   ;;;; vc / diff-hl
   (diff-hl-insert :background (doom-blend green bg 0.4) :foreground green)
   (diff-hl-delete :background (doom-blend red bg 0.4) :foreground red)
   (diff-hl-change :background (doom-blend yellow bg 0.4) :foreground yellow)

   ;;;; vimish-fold
   ((vimish-fold-overlay &override) :inherit 'font-lock-comment-face :background base3 :weight 'light)
   ((vimish-fold-fringe &override) :foreground teal)

   ;;;; web-mode
   (web-mode-html-tag-face :foreground "#FFD0AA")
   (web-mode-html-tag-bracket-face :foreground base6)
   (web-mode-html-attr-name-face :foreground rose)
   (web-mode-html-attr-value-face :foreground strings)
   (web-mode-css-selector-face :foreground bright-red)
   (web-mode-css-property-name-face :foreground green)
   (web-mode-css-string-face :foreground strings)

   ;;;; which-key
   (which-key-key-face :foreground red :weight 'bold)
   (which-key-separator-face :foreground base6)
   (which-key-note-face :foreground base7)
   (which-key-command-description-face :foreground fg)
   (which-key-group-description-face :foreground "#FFD0AA")
   (which-key-local-map-description-face :foreground orange)
   (which-key-special-key-face :foreground yellow :weight 'bold))

  ;;;; Base theme variable overrides
  ())
;;; doom-vscode-red-theme.el ends here
