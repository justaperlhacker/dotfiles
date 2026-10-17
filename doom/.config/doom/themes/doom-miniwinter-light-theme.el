;;; doom-miniwinter-light-theme.el --- Port of the "miniwinter-light" theme -*- lexical-binding: t; no-byte-compile: t; -*-
;;
;; Generated from the justaperlhacker vscode-themes source:
;;   ~/Projects/vscode-themes/themes/miniwinter-light-color-theme.json
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

(defgroup doom-miniwinter-light-theme nil
  "Options for the `doom-miniwinter-light' theme."
  :group 'doom-themes)

(defcustom doom-miniwinter-light-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds a 4px padding to the mode-line.
Can be an integer to determine the exact padding."
  :group 'doom-miniwinter-light-theme
  :type '(choice integer boolean))

(defcustom doom-miniwinter-light-comment-bg nil
  "If non-nil, comments will have a subtle, darker background."
  :group 'doom-miniwinter-light-theme
  :type 'boolean)


;;
;;; Theme definition

(def-doom-theme doom-miniwinter-light
  "A Doom port of the miniwinter-light theme."

  :background-mode 'light
  ;; name        default      256          16
  (   (bg             '("#dce4e8" "#dce4e8" nil))
   (bg-alt         '("#e5edf1" "#e5edf1" nil))
   (base0          '("#eef2f4" "#eef2f4" "white"))
   (base1          '("#e6ecef" "#e6ecef" "brightwhite"))
   (base2          '("#e1e8eb" "#e1e8eb" nil))
   (base3          '("#c7ced1" "#c7ced1" nil))
   (base4          '("#bcc4c8" "#bcc4c8" nil))
   (base5          '("#a0a4a5" "#a0a4a5" nil))
   (base6          '("#868988" "#868988" nil))
   (base7          '("#646562" "#646562" nil))
   (base8          '("#312e29" "#312e29" "black"))
   (fg             '("#312e29" "#312e29" "black"))
   (fg-alt         '("#757775" "#757775" nil))
   (grey           '("#9ca4a7" "#9ca4a7" "brightblack"))
   (red            '("#5c0113" "#5c0113" nil))
   (light-red      '("#85404e" "#85404e" nil))
   (orange         '("#565600" "#565600" nil))
   (green          '("#014772" "#014772" nil))
   (teal           '("#312e29" "#312e29" nil))
   (yellow         '("#565600" "#565600" nil))
   (blue           '("#301d65" "#301d65" nil))
   (magenta        '("#301d65" "#301d65" nil))
   (violet         '("#301d65" "#301d65" nil))
   (cyan           '("#301d65" "#301d65" nil))
   (pink           '("#00562e" "#00562e" nil))
   (rose           '("#312e29" "#312e29" nil))
   (salmon         '("#00562e" "#00562e" nil))
   (dark-blue      '("#1d113d" "#1d113d" nil))
   (dark-cyan      '("#1d113d" "#1d113d" nil))
   (dark-violet    '("#1d113d" "#1d113d" nil))
   (dark-red       '("#3c010c" "#3c010c" nil))
   (dark-green     '("#012e4a" "#012e4a" nil))
   (light-green    '("#346c8e" "#346c8e" nil))
   (light-blue     '("#594a84" "#594a84" nil))
   (light-yellow   '("#787833" "#787833" nil))
   (highlight      '("#014772" "#014772" nil))
   (vertical-bar   '("#bcc4c8" "#bcc4c8" nil))
   (selection      '("#bcc4c8" "#bcc4c8" nil))
   (builtin        '("#016d71" "#016d71" nil))
   (comments       '("#6a6661" "#6a6661" nil))
   (doc-comments   '("#6a6661" "#6a6661" nil))
   (constants      '("#4f0b46" "#4f0b46" nil))
   (functions      '("#014772" "#014772" nil))
   (keywords       '("#312e29" "#312e29" nil))
   (methods        '("#014772" "#014772" nil))
   (operators      '("#312e29" "#312e29" nil))
   (type           '("#312e29" "#312e29" nil))
   (strings        '("#00562e" "#00562e" nil))
   (variables      '("#312e29" "#312e29" nil))
   (numbers        '("#4f0b46" "#4f0b46" nil))
   (region         '("#bcc4c8" "#bcc4c8" nil))
   (error          '("#5c0113" "#5c0113" nil))
   (warning        '("#565600" "#565600" nil))
   (success        '("#014772" "#014772" nil))
   (vc-modified    '("#565600" "#565600" nil))
   (vc-added       '("#014772" "#014772" nil))
   (vc-deleted     '("#5c0113" "#5c0113" nil))
   (modeline-bg    '("#90ceff" "#90ceff" nil))
   (modeline-bg-alt '("#e5edf1" "#e5edf1" nil))
   (modeline-fg    '("#0f2b3d" "#0f2b3d" nil))
   (modeline-fg-alt '("#757775" "#757775" nil))
   (modeline-bg-l  '("#e5edf1" "#e5edf1" nil))
   (modeline-bg-inactive '("#e5edf1" "#e5edf1" nil))
   (modeline-bg-inactive-l '("#dce4e8" "#dce4e8" nil))
   (cursor         '("#014772" "#014772" nil))
   (cur-line       '("#c7ced2" "#c7ced2" nil))
   (line-nr        '("#9ca4a7" "#9ca4a7" nil))
   (line-nr-bg     '("#dce4e8" "#dce4e8" nil))
   (sel-bg         '("#bcc4c8" "#bcc4c8" nil))
   (bracket-match  '("#014772" "#014772" nil))
   (match-bg       '("#929674" "#929674" nil))
   (match-fg       '("#312e29" "#312e29" nil))
   (label-bg       '("#748d9c" "#748d9c" nil))
   (label-fg       '("#dce4e8" "#dce4e8" nil))
   (popup-bg       '("#e5edf1" "#e5edf1" nil))
   (popup-fg       '("#312e29" "#312e29" nil))
   (popup-sel-bg   '("#bcc4c8" "#bcc4c8" nil))
   (border         '("#bcc4c8" "#bcc4c8" nil))
   (tab-active-bg  '("#dce4e8" "#dce4e8" nil))
   (tab-active-fg  '("#312e29" "#312e29" nil))
   (tab-inactive-bg '("#e5edf1" "#e5edf1" nil))
   (tab-inactive-fg '("#4c4944" "#4c4944" nil))
   (status-bg      '("#90ceff" "#90ceff" nil))
   (status-fg      '("#0f2b3d" "#0f2b3d" nil))
   (inline-bg      '("#e5edf1" "#e5edf1" nil))
   (err-bg         '("#b6a0a8" "#b6a0a8" nil))
   (diff-add-bg    '("#9ab5c5" "#9ab5c5" nil))
   (diff-remove-bg '("#b6a0a8" "#b6a0a8" nil))
   (diff-modify-bg '("#b4b9a2" "#b4b9a2" nil))
   (rain1          '("#014772" "#014772" nil))
   (rain2          '("#312e29" "#312e29" nil))
   (rain3          '("#014772" "#014772" nil))
   (rain4          '("#565600" "#565600" nil))
   (rain5          '("#5c0113" "#5c0113" nil))
   (rain6          '("#301d65" "#301d65" nil))
   (term0          '("#dce4e8" "#dce4e8" nil))
   (term1          '("#5c0113" "#5c0113" nil))
   (term2          '("#014772" "#014772" nil))
   (term3          '("#565600" "#565600" nil))
   (term4          '("#301d65" "#301d65" nil))
   (term5          '("#301d65" "#301d65" nil))
   (term6          '("#312e29" "#312e29" nil))
   (term7          '("#312e29" "#312e29" nil))
   (term8          '("#9ca4a7" "#9ca4a7" nil))
   (term9          '("#8d4d5a" "#8d4d5a" nil))
   (term10         '("#4d7e9c" "#4d7e9c" nil))
   (term11         '("#89894c" "#89894c" nil))
   (term12         '("#6e6193" "#6e6193" nil))
   (term13         '("#6e6193" "#6e6193" nil))
   (term14         '("#6f6d69" "#6f6d69" nil))
   (term15         '("#ffffff" "#ffffff" nil))

   (hidden     `(,(car bg) "black" "black"))
   (-modeline-pad
    (when doom-miniwinter-light-padded-modeline
      (if (integerp doom-miniwinter-light-padded-modeline) doom-miniwinter-light-padded-modeline 4))))

  ;;;; Base theme face overrides
  (((font-lock-comment-face &override)
    :background (if doom-miniwinter-light-comment-bg bg-alt 'unspecified)
    :slant 'italic)
   ((font-lock-keyword-face &override) :foreground keywords :slant 'italic)
   ((font-lock-builtin-face &override) :foreground builtin)
   ((font-lock-function-name-face &override) :foreground functions)
   ((font-lock-variable-name-face &override) :foreground variables)
   ((font-lock-type-face &override) :foreground type )
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
;;; doom-miniwinter-light-theme.el ends here
