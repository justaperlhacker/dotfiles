;;; doom-kimbox-theme.el --- Port of the "kimbox" theme -*- lexical-binding: t; no-byte-compile: t; -*-
;;
;; Generated from the fresh-editor palette:
;;   ~/.config/fresh/themes/kimbox.json
;;   ~/.config/nvim/colors/kimbox.lua  (where ported)
;;
;;; Commentary:
;;
;; A Doom Emacs port kept in sync with the fresh-editor, Neovim and VSCode
;; builds of the same theme, so all editors share one palette.
;;
;;; Code:

(require 'doom-themes)


;;
;;; Variables

(defgroup doom-kimbox-theme nil
  "Options for the `doom-kimbox' theme."
  :group 'doom-themes)

(defcustom doom-kimbox-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds a 4px padding to the mode-line.
Can be an integer to determine the exact padding."
  :group 'doom-kimbox-theme
  :type '(choice integer boolean))

(defcustom doom-kimbox-comment-bg nil
  "If non-nil, comments will have a subtle, darker background."
  :group 'doom-kimbox-theme
  :type 'boolean)


;;
;;; Theme definition

(def-doom-theme doom-kimbox
  "A Doom port of the kimbox theme."

  ;; name        default      256          16
  (   (bg             '("#221a02" "#221a02" nil))
   (bg-alt         '("#362712" "#362712" nil))
   (base0          '("#110d01" "#110d01" "black"))
   (base1          '("#2b2108" "#2b2108" "brightblack"))
   (base2          '("#34290f" "#34290f" nil))
   (base3          '("#3d3015" "#3d3015" nil))
   (base4          '("#5e452b" "#5e452b" nil))
   (base5          '("#362712" "#362712" nil))
   (base6          '("#745d3b" "#745d3b" nil))
   (base7          '("#c2a383" "#c2a383" nil))
   (base8          '("#d9ae80" "#d9ae80" "white"))
   (fg             '("#d9ae80" "#d9ae80" "brightwhite"))
   (fg-alt         '("#c2a383" "#c2a383" nil))
   (grey           '("#745d3b" "#745d3b" "brightblack"))
   (red            '("#ef1d55" "#ef1d55" nil))
   (light-red      '("#f35680" "#f35680" nil))
   (orange         '("#7eb2b1" "#7eb2b1" nil))
   (green          '("#938aa9" "#938aa9" nil))
   (teal           '("#819c3b" "#819c3b" nil))
   (yellow         '("#ff9500" "#ff9500" nil))
   (blue           '("#4c96a8" "#4c96a8" nil))
   (magenta        '("#4c96a8" "#4c96a8" nil))
   (violet         '("#ef1d55" "#ef1d55" nil))
   (cyan           '("#4c96a8" "#4c96a8" nil))
   (pink           '("#ff9500" "#ff9500" nil))
   (rose           '("#819c3b" "#819c3b" nil))
   (salmon         '("#ff9500" "#ff9500" nil))
   (dark-blue      '("#2e5a65" "#2e5a65" nil))
   (dark-cyan      '("#2e5a65" "#2e5a65" nil))
   (dark-violet    '("#8f1133" "#8f1133" nil))
   (dark-red       '("#9b1337" "#9b1337" nil))
   (dark-green     '("#605a6e" "#605a6e" nil))
   (light-green    '("#a9a1ba" "#a9a1ba" nil))
   (light-blue     '("#70abb9" "#70abb9" nil))
   (light-yellow   '("#ffaa33" "#ffaa33" nil))
   (highlight      '("#ef1d55" "#ef1d55" nil))
   (vertical-bar   '("#5e452b" "#5e452b" nil))
   (selection      '("#572906" "#572906" nil))
   (builtin        '("#4c96a8" "#4c96a8" nil))
   (comments       '("#7e602c" "#7e602c" nil))
   (doc-comments   '("#957441" "#957441" nil))
   (constants      '("#7eb2b1" "#7eb2b1" nil))
   (functions      '("#a06469" "#a06469" nil))
   (keywords       '("#ef1d55" "#ef1d55" nil))
   (methods        '("#a06469" "#a06469" nil))
   (operators      '("#ff5813" "#ff5813" nil))
   (type           '("#819c3b" "#819c3b" nil))
   (strings        '("#ff9500" "#ff9500" nil))
   (variables      '("#d9ae80" "#d9ae80" nil))
   (numbers        '("#7eb2b1" "#7eb2b1" nil))
   (region         '("#572906" "#572906" nil))
   (error          '("#ef1d55" "#ef1d55" nil))
   (warning        '("#ff9500" "#ff9500" nil))
   (success        '("#938aa9" "#938aa9" nil))
   (vc-modified    '("#ff9500" "#ff9500" nil))
   (vc-added       '("#938aa9" "#938aa9" nil))
   (vc-deleted     '("#ef1d55" "#ef1d55" nil))
   (modeline-bg    '("#39260e" "#39260e" nil))
   (modeline-bg-alt '("#2b2108" "#2b2108" nil))
   (modeline-fg    '("#ffffff" "#ffffff" nil))
   (modeline-fg-alt '("#c2a383" "#c2a383" nil))
   (modeline-bg-l  '("#1f1702" "#1f1702" nil))
   (modeline-bg-inactive '("#2b2108" "#2b2108" nil))
   (modeline-bg-inactive-l '("#221a02" "#221a02" nil))
   (cursor         '("#ff5813" "#ff5813" nil))
   (cur-line       '("#39260e" "#39260e" nil))
   (line-nr        '("#7e602c" "#7e602c" nil))
   (line-nr-bg     '("#221a02" "#221a02" nil))
   (sel-bg         '("#572906" "#572906" nil))
   (bracket-match  '("#ff5813" "#ff5813" nil))
   (match-bg       '("#5f7191" "#5f7191" nil))
   (match-fg       '("#ffffff" "#ffffff" nil))
   (label-bg       '("#ff5813" "#ff5813" nil))
   (label-fg       '("#ffffff" "#ffffff" nil))
   (popup-bg       '("#362712" "#362712" nil))
   (popup-fg       '("#d9ae80" "#d9ae80" nil))
   (popup-sel-bg   '("#572906" "#572906" nil))
   (border         '("#5e452b" "#5e452b" nil))
   (tab-active-bg  '("#39260e" "#39260e" nil))
   (tab-active-fg  '("#ffffff" "#ffffff" nil))
   (tab-inactive-bg '("#291804" "#291804" nil))
   (tab-inactive-fg '("#c2a383" "#c2a383" nil))
   (status-bg      '("#39260e" "#39260e" nil))
   (status-fg      '("#ffffff" "#ffffff" nil))
   (inline-bg      '("#362712" "#362712" nil))
   (err-bg         '("#961134" "#961134" nil))
   (diff-add-bg    '("#445321" "#445321" nil))
   (diff-remove-bg '("#961134" "#961134" nil))
   (diff-modify-bg '("#392702" "#392702" nil))
   (rain1          '("#ff5813" "#ff5813" nil))
   (rain2          '("#98676a" "#98676a" nil))
   (rain3          '("#819c3b" "#819c3b" nil))
   (rain4          '("#ff5813" "#ff5813" nil))
   (rain5          '("#98676a" "#98676a" nil))
   (rain6          '("#819c3b" "#819c3b" nil))
   (term0          '("#110d01" "#110d01" nil))
   (term1          '("#ef1d55" "#ef1d55" nil))
   (term2          '("#938aa9" "#938aa9" nil))
   (term3          '("#ff9500" "#ff9500" nil))
   (term4          '("#4c96a8" "#4c96a8" nil))
   (term5          '("#4c96a8" "#4c96a8" nil))
   (term6          '("#4c96a8" "#4c96a8" nil))
   (term7          '("#d9ae80" "#d9ae80" nil))
   (term8          '("#745d3b" "#745d3b" nil))
   (term9          '("#f46188" "#f46188" nil))
   (term10         '("#b3adc3" "#b3adc3" nil))
   (term11         '("#ffb54c" "#ffb54c" nil))
   (term12         '("#82b6c2" "#82b6c2" nil))
   (term13         '("#82b6c2" "#82b6c2" nil))
   (term14         '("#82b6c2" "#82b6c2" nil))
   (term15         '("#ffffff" "#ffffff" nil))

   (hidden     `(,(car bg) "black" "black"))
   (-modeline-pad
    (when doom-kimbox-padded-modeline
      (if (integerp doom-kimbox-padded-modeline) doom-kimbox-padded-modeline 4))))

  ;;;; Base theme face overrides
  (((font-lock-comment-face &override)
    :background (if doom-kimbox-comment-bg bg-alt 'unspecified)
    :slant 'italic)
   ((font-lock-keyword-face &override) :foreground keywords )
   ((font-lock-builtin-face &override) :foreground builtin)
   ((font-lock-function-name-face &override) :foreground functions)
   ((font-lock-variable-name-face &override) :foreground variables)
   ((font-lock-type-face &override) :foreground type :weight 'bold)
   ((font-lock-constant-face &override) :foreground constants)
   ((font-lock-string-face &override) :foreground strings)
   ((font-lock-warning-face &override) :foreground error :weight 'bold)
   ((line-number &override) :foreground line-nr)
   ((line-number-current-line &override)
    :foreground highlight :background cur-line :weight 'bold)

   (font-lock-comment-delimiter-face :foreground comments)
   (font-lock-doc-face :foreground doc-comments :slant 'italic)
   (font-lock-number-face :foreground numbers)
   (font-lock-operator-face :foreground operators)
   (font-lock-preprocessor-face :foreground magenta)
   (font-lock-negation-char-face :foreground operators)
   (font-lock-regexp-grouping-backslash :foreground magenta)
   (font-lock-regexp-grouping-construct :foreground violet)

   (cursor :background cursor :foreground bg)
   (region :background region :foreground fg :extend t)
   (secondary-selection :background popup-sel-bg :extend t)
   (hl-line :background cur-line :extend t)
   (highlight :background highlight :foreground base0)
   (fringe :background bg :foreground base5)
   (vertical-border :foreground vertical-bar)
   (border :foreground border :background border)
   (shadow :foreground base6)
   (link :foreground highlight :underline t :weight 'bold)
   (link-visited :foreground violet :underline t :weight 'normal)
   (success :foreground success :weight 'bold)
   (warning :foreground warning :weight 'bold)
   (error :foreground error :weight 'bold)
   (match :background match-bg :foreground match-fg :weight 'bold)

   (isearch :background label-bg :foreground label-fg :weight 'bold)
   (isearch-fail :background err-bg :foreground error :weight 'bold)
   (lazy-highlight :background match-bg :foreground match-fg :weight 'bold)
   (show-paren-match :background sel-bg :foreground bracket-match :weight 'ultra-bold)
   (show-paren-mismatch :background error :foreground bg :weight 'ultra-bold)

   (minibuffer-prompt :foreground highlight :weight 'bold)

   (mode-line
    :background modeline-bg :foreground modeline-fg
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg)))
   (mode-line-inactive
    :background modeline-bg-inactive :foreground modeline-fg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive)))
   (mode-line-emphasis :foreground fg :weight 'bold)
   (mode-line-buffer-id :foreground highlight :weight 'bold)
   (mode-line-highlight :inherit 'highlight :distant-foreground bg)

   (tooltip :background bg-alt :foreground fg)
   (file-name-shadow :foreground base6)

   ;;;; all-the-icons
   (all-the-icons-red :foreground red)
   (all-the-icons-dred :foreground error)

   ;;;; centaur-tabs
   (centaur-tabs-default :background bg-alt :foreground base7)
   (centaur-tabs-selected :background tab-active-bg :foreground tab-active-fg :weight 'bold)
   (centaur-tabs-unselected :background tab-inactive-bg :foreground tab-inactive-fg)
   (centaur-tabs-selected-modified :background tab-active-bg :foreground highlight :weight 'bold)
   (centaur-tabs-unselected-modified :background tab-inactive-bg :foreground highlight)
   (centaur-tabs-active-bar-face :background highlight)
   (centaur-tabs-modified-marker-selected :inherit 'centaur-tabs-selected :foreground highlight)
   (centaur-tabs-modified-marker-unselected :inherit 'centaur-tabs-unselected :foreground highlight)

   ;;;; company
   (company-tooltip :background bg-alt :foreground fg)
   (company-tooltip-selection :background popup-sel-bg :foreground fg :weight 'bold)
   (company-tooltip-common :foreground highlight :weight 'bold)
   (company-tooltip-common-selection :foreground highlight)
   (company-tooltip-annotation :foreground orange)
   (company-scrollbar-fg :background base4)
   (company-scrollbar-bg :background bg-alt)
   (company-preview :foreground base7 :slant 'italic)
   (company-preview-common :foreground highlight :slant 'italic)

   ;;;; corfu
   (corfu-default :background bg-alt :foreground fg)
   (corfu-current :background popup-sel-bg :foreground fg :weight 'bold)
   (corfu-bar :background highlight)
   (corfu-border :background base4)

   ;;;; css-mode <built-in> / scss-mode
   (css-proprietary-property :foreground orange)
   (css-property :foreground green)
   (css-selector :foreground keywords)

   ;;;; dired
   (dired-directory :foreground highlight :weight 'bold)
   (dired-flagged :foreground error)
   (dired-header :foreground highlight :weight 'bold)
   (dired-ignored :foreground base6)
   (dired-mark :foreground error :weight 'bold)
   (dired-marked :foreground error :weight 'bold)
   (dired-perm-write :foreground warning)
   (dired-symlink :foreground violet :slant 'italic)
   (dired-warning :foreground warning)

   ;;;; doom-modeline
   (doom-modeline-bar :background highlight)
   (doom-modeline-buffer-file :inherit 'mode-line-buffer-id :weight 'bold)
   (doom-modeline-buffer-path :foreground fg)
   (doom-modeline-buffer-major-mode :inherit 'doom-modeline-buffer-path)
   (doom-modeline-buffer-modified :foreground highlight :weight 'bold)
   (doom-modeline-buffer-minor-mode :foreground base7)
   (doom-modeline-project-dir :foreground highlight :weight 'bold)
   (doom-modeline-project-root-dir :foreground highlight)
   (doom-modeline-info :foreground success :weight 'bold)
   (doom-modeline-warning :foreground warning :weight 'bold)
   (doom-modeline-urgent :foreground error :weight 'bold)
   (doom-modeline-debug :foreground base7)
   (doom-modeline-lsp-success :foreground success :weight 'bold)

   ;;;; ediff <built-in>
   (ediff-fine-diff-A :background diff-modify-bg :weight 'bold)
   (ediff-current-diff-A :background base0)

   ;;;; help / info
   (help-key-binding :foreground highlight :background bg-alt :weight 'bold)
   (info-title-1 :foreground highlight :weight 'bold :height 1.3)
   (info-title-2 :foreground keywords :weight 'bold :height 1.2)
   (info-title-3 :foreground type :weight 'bold)
   (info-title-4 :foreground functions :weight 'bold)
   (Info-quoted :foreground orange)

   ;;;; ivy
   (ivy-current-match :background popup-sel-bg :foreground fg :weight 'bold)
   (ivy-minibuffer-match-face-1 :foreground base7)
   (ivy-minibuffer-match-face-2 :foreground highlight :weight 'extra-bold)
   (ivy-minibuffer-match-face-3 :foreground type)
   (ivy-minibuffer-match-face-4 :foreground warning)
   (ivy-posframe :background bg-alt)
   (ivy-posframe-border :background highlight)

   ;;;; magit
   (magit-section-highlight :background (doom-blend highlight bg 0.12) :extend t)
   (magit-section-heading :foreground highlight :weight 'bold)
   (magit-section-heading-selection :foreground highlight :weight 'bold)
   (magit-diff-hunk-heading :foreground bg :background (doom-blend highlight bg 0.3) :extend t)
   (magit-diff-hunk-heading-highlight :foreground bg :background highlight :weight 'bold :extend t)
   (magit-diff-context :foreground base7 :background bg :extend t)
   (magit-diff-context-highlight :foreground fg :background (doom-blend highlight bg 0.12) :extend t)
   (magit-diff-added :foreground success :background diff-add-bg)
   (magit-diff-added-highlight :foreground success :background (doom-lighten diff-add-bg 0.08))
   (magit-diff-removed :foreground error :background diff-remove-bg)
   (magit-diff-removed-highlight :foreground error :background (doom-lighten diff-remove-bg 0.08))
   (magit-diff-base :foreground warning :background diff-modify-bg)
   (magit-diff-base-highlight :foreground warning :background (doom-lighten diff-modify-bg 0.08))
   (magit-hash :foreground base6)
   (magit-branch-local :foreground highlight :weight 'bold)
   (magit-branch-remote :foreground keywords :weight 'bold)
   (magit-tag :foreground warning)
   (magit-log-author :foreground base7)
   (magit-log-date :foreground base6)
   (magit-process-ok :foreground success :weight 'bold)
   (magit-process-ng :foreground error :weight 'bold)

   ;;;; markdown-mode
   (markdown-header-face :foreground highlight :weight 'bold)
   (markdown-header-delimiter-face :foreground highlight)
   (markdown-inline-code-face :foreground highlight :background inline-bg)
   ((markdown-code-face &override) :background inline-bg)
   (markdown-link-face :foreground highlight :underline t)
   (markdown-url-face :foreground violet :underline t)
   (markdown-markup-face :foreground base6)

   ;;;; mic-paren
   ((paren-face-match &override) :foreground bracket-match :background sel-bg :weight 'ultra-bold)
   ((paren-face-mismatch &override) :foreground bg :background error :weight 'ultra-bold)

   ;;;; org <built-in>
   (org-hide :foreground hidden)
   (org-level-1 :foreground highlight :weight 'bold :height 1.2)
   (org-level-2 :foreground keywords :weight 'bold :height 1.1)
   (org-level-3 :foreground type :weight 'bold)
   (org-level-4 :foreground functions :weight 'bold)
   (org-level-5 :foreground orange :weight 'bold)
   (org-level-6 :foreground warning :weight 'bold)
   (org-level-7 :foreground success :weight 'bold)
   (org-level-8 :foreground cyan :weight 'bold)
   (org-document-title :foreground highlight :weight 'bold :height 1.35)
   (org-document-info :foreground base7)
   (org-todo :foreground error :weight 'bold)
   (org-done :foreground success :weight 'bold)
   (org-headline-done :foreground base6)
   (org-ellipsis :foreground highlight :underline nil)
   (org-table :foreground violet)
   (org-formula :foreground warning)
   (org-checkbox :foreground highlight :weight 'bold)
   (org-date :foreground highlight :underline t)
   (org-special-keyword :foreground base7)
   (org-tag :foreground base6 :weight 'normal)
   (org-link :foreground highlight :underline t :weight 'bold)
   (org-priority :foreground error :weight 'bold)
   (org-code :foreground highlight)
   (org-verbatim :foreground violet)
   ((org-block &override) :background inline-bg)
   ((org-block-background &override) :background inline-bg)
   ((org-block-begin-line &override) :background inline-bg :foreground base7 :slant 'italic)
   ((org-block-end-line &override) :background inline-bg :foreground base7 :slant 'italic)
   (org-quote :foreground base7 :background inline-bg :slant 'italic)

   ;;;; rainbow-delimiters
   (rainbow-delimiters-depth-1-face :foreground rain1)
   (rainbow-delimiters-depth-2-face :foreground rain2)
   (rainbow-delimiters-depth-3-face :foreground rain3)
   (rainbow-delimiters-depth-4-face :foreground rain4)
   (rainbow-delimiters-depth-5-face :foreground rain5)
   (rainbow-delimiters-depth-6-face :foreground rain6)
   (rainbow-delimiters-depth-7-face :foreground rain1)
   (rainbow-delimiters-depth-8-face :foreground rain2)
   (rainbow-delimiters-depth-9-face :foreground rain3)
   (rainbow-delimiters-mismatched-face :foreground error :weight 'bold)
   (rainbow-delimiters-unmatched-face :foreground error :weight 'bold)

   ;;;; solaire-mode
   (solaire-mode-line-face
    :inherit 'mode-line :background modeline-bg-l
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-l)))
   (solaire-mode-line-inactive-face
    :inherit 'mode-line-inactive :background modeline-bg-inactive-l
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive-l)))
   (solaire-default-face :background bg-alt :foreground fg)
   (solaire-hl-line-face :background cur-line :extend t)
   (solaire-region-face :background region)

   ;;;; tab-bar
   (tab-bar :background bg-alt :foreground base7 :box nil)
   (tab-bar-tab :background tab-active-bg :foreground tab-active-fg :weight 'bold :box nil)
   (tab-bar-tab-inactive :background tab-inactive-bg :foreground tab-inactive-fg :box nil)

   ;;;; tab-line
   (tab-line :background bg-alt :foreground base7 :box nil)
   (tab-line-tab :background tab-inactive-bg :foreground tab-inactive-fg :box nil)
   (tab-line-tab-current :background tab-active-bg :foreground tab-active-fg :weight 'bold :box nil)
   (tab-line-tab-inactive :background tab-inactive-bg :foreground tab-inactive-fg :box nil)
   (tab-line-highlight :background popup-sel-bg :foreground fg)

   ;;;; terminal
   (term-color-black :foreground term0 :background term0)
   (term-color-red :foreground term1 :background term1)
   (term-color-green :foreground term2 :background term2)
   (term-color-yellow :foreground term3 :background term3)
   (term-color-blue :foreground term4 :background term4)
   (term-color-magenta :foreground term5 :background term5)
   (term-color-cyan :foreground term6 :background term6)
   (term-color-white :foreground term7 :background term7)

   ;;;; treemacs
   (treemacs-root-face :foreground highlight :weight 'ultra-bold :height 1.2)
   (doom-themes-treemacs-root-face :foreground highlight :weight 'ultra-bold :height 1.2)
   (doom-themes-treemacs-file-face :foreground fg)
   (treemacs-directory-face :foreground highlight :weight 'bold)
   (treemacs-file-face :foreground fg)
   (treemacs-git-modified-face :foreground warning)
   (treemacs-git-untracked-face :foreground base7)
   (treemacs-git-added-face :foreground success)
   (treemacs-git-conflict-face :foreground error)

   ;;;; vc / diff-hl
   (diff-hl-insert :background diff-add-bg :foreground success)
   (diff-hl-delete :background diff-remove-bg :foreground error)
   (diff-hl-change :background diff-modify-bg :foreground warning)

   ;;;; vimish-fold
   ((vimish-fold-overlay &override) :inherit 'font-lock-comment-face :background base3 :weight 'light)
   ((vimish-fold-fringe &override) :foreground teal)

   ;;;; web-mode
   (web-mode-html-tag-face :foreground highlight)
   (web-mode-html-tag-bracket-face :foreground base6)
   (web-mode-html-attr-name-face :foreground type)
   (web-mode-html-attr-value-face :foreground strings)
   (web-mode-css-selector-face :foreground keywords)
   (web-mode-css-property-name-face :foreground green)
   (web-mode-css-string-face :foreground strings)

   ;;;; which-key
   (which-key-key-face :foreground keywords :weight 'bold)
   (which-key-separator-face :foreground base6)
   (which-key-note-face :foreground base7)
   (which-key-command-description-face :foreground fg)
   (which-key-group-description-face :foreground highlight)
   (which-key-local-map-description-face :foreground orange)
   (which-key-special-key-face :foreground warning :weight 'bold))

  ;;;; Base theme variable overrides
  ())
;;; doom-kimbox-theme.el ends here
