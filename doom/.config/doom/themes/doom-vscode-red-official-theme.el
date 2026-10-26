;;; doom-vscode-red-official-theme.el --- Port of the "vscode-red-official" theme -*- lexical-binding: t; no-byte-compile: t; -*-
;;
;; Generated from the fresh-editor palette:
;;   ~/.config/fresh/themes/vscode-red-official.json
;;   ~/.config/nvim/colors/vscode-red-official.lua  (where ported)
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

(defgroup doom-vscode-red-official-theme nil
  "Options for the `doom-vscode-red-official' theme."
  :group 'doom-themes)

(defcustom doom-vscode-red-official-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds a 4px padding to the mode-line.
Can be an integer to determine the exact padding."
  :group 'doom-vscode-red-official-theme
  :type '(choice integer boolean))

(defcustom doom-vscode-red-official-comment-bg nil
  "If non-nil, comments will have a subtle, darker background."
  :group 'doom-vscode-red-official-theme
  :type 'boolean)


;;
;;; Theme definition

(def-doom-theme doom-vscode-red-official
  "A Doom port of the vscode-red-official theme."

  ;; name        default      256          16
  (   (bg             '("#390000" "#390000" nil))
   (bg-alt         '("#300000" "#300000" nil))
   (base0          '("#1c0000" "#1c0000" "black"))
   (base1          '("#430c0c" "#430c0c" "brightblack"))
   (base2          '("#4c1919" "#4c1919" nil))
   (base3          '("#562525" "#562525" nil))
   (base4          '("#580000" "#580000" nil))
   (base5          '("#c10000" "#c10000" nil))
   (base6          '("#8f7070" "#8f7070" nil))
   (base7          '("#8f5050" "#8f5050" nil))
   (base8          '("#f8f8f8" "#f8f8f8" "white"))
   (fg             '("#f8f8f8" "#f8f8f8" "brightwhite"))
   (fg-alt         '("#8f5050" "#8f5050" nil))
   (grey           '("#8f7070" "#8f7070" "brightblack"))
   (red            '("#ff6262" "#ff6262" nil))
   (light-red      '("#ff8989" "#ff8989" nil))
   (orange         '("#994646" "#994646" nil))
   (green          '("#9df39f" "#9df39f" nil))
   (teal           '("#fec758" "#fec758" nil))
   (yellow         '("#ffe862" "#ffe862" nil))
   (blue           '("#fb9a4b" "#fb9a4b" nil))
   (magenta        '("#ffb454" "#ffb454" nil))
   (violet         '("#f12727" "#f12727" nil))
   (cyan           '("#ffb454" "#ffb454" nil))
   (pink           '("#cd8d8d" "#cd8d8d" nil))
   (rose           '("#fec758" "#fec758" nil))
   (salmon         '("#cd8d8d" "#cd8d8d" nil))
   (dark-blue      '("#975c2d" "#975c2d" nil))
   (dark-cyan      '("#996c32" "#996c32" nil))
   (dark-violet    '("#911717" "#911717" nil))
   (dark-red       '("#a64040" "#a64040" nil))
   (dark-green     '("#669e67" "#669e67" nil))
   (light-green    '("#b1f5b2" "#b1f5b2" nil))
   (light-blue     '("#fcae6f" "#fcae6f" nil))
   (light-yellow   '("#ffed81" "#ffed81" nil))
   (highlight      '("#f12727" "#f12727" nil))
   (vertical-bar   '("#580000" "#580000" nil))
   (selection      '("#750000" "#750000" nil))
   (builtin        '("#ffb454" "#ffb454" nil))
   (comments       '("#e7c0c0" "#e7c0c0" nil))
   (doc-comments   '("#ebcece" "#ebcece" nil))
   (constants      '("#994646" "#994646" nil))
   (functions      '("#fec758" "#fec758" nil))
   (keywords       '("#f12727" "#f12727" nil))
   (methods        '("#fec758" "#fec758" nil))
   (operators      '("#f8f8f8" "#f8f8f8" nil))
   (type           '("#fec758" "#fec758" nil))
   (strings        '("#cd8d8d" "#cd8d8d" nil))
   (variables      '("#fb9a4b" "#fb9a4b" nil))
   (numbers        '("#994646" "#994646" nil))
   (region         '("#750000" "#750000" nil))
   (error          '("#ff6262" "#ff6262" nil))
   (warning        '("#ffe862" "#ffe862" nil))
   (success        '("#9df39f" "#9df39f" nil))
   (vc-modified    '("#ffe862" "#ffe862" nil))
   (vc-added       '("#9df39f" "#9df39f" nil))
   (vc-deleted     '("#ff6262" "#ff6262" nil))
   (modeline-bg    '("#700000" "#700000" nil))
   (modeline-bg-alt '("#430c0c" "#430c0c" nil))
   (modeline-fg    '("#ffffff" "#ffffff" nil))
   (modeline-fg-alt '("#8f5050" "#8f5050" nil))
   (modeline-bg-l  '("#330000" "#330000" nil))
   (modeline-bg-inactive '("#430c0c" "#430c0c" nil))
   (modeline-bg-inactive-l '("#390000" "#390000" nil))
   (cursor         '("#970000" "#970000" nil))
   (cur-line       '("#610000" "#610000" nil))
   (line-nr        '("#a33f3f" "#a33f3f" nil))
   (line-nr-bg     '("#390000" "#390000" nil))
   (sel-bg         '("#750000" "#750000" nil))
   (bracket-match  '("#ffd0aa" "#ffd0aa" nil))
   (match-bg       '("#990000" "#990000" nil))
   (match-fg       '("#f8f8f8" "#f8f8f8" nil))
   (label-bg       '("#cc3333" "#cc3333" nil))
   (label-fg       '("#ffffff" "#ffffff" nil))
   (popup-bg       '("#300000" "#300000" nil))
   (popup-fg       '("#f8f8f8" "#f8f8f8" nil))
   (popup-sel-bg   '("#580000" "#580000" nil))
   (border         '("#580000" "#580000" nil))
   (tab-active-bg  '("#490000" "#490000" nil))
   (tab-active-fg  '("#f8f8f8" "#f8f8f8" nil))
   (tab-inactive-bg '("#300a0a" "#300a0a" nil))
   (tab-inactive-fg '("#cf9090" "#cf9090" nil))
   (status-bg      '("#700000" "#700000" nil))
   (status-fg      '("#ffffff" "#ffffff" nil))
   (inline-bg      '("#300000" "#300000" nil))
   (err-bg         '("#6a1818" "#6a1818" nil))
   (diff-add-bg    '("#3a1e0b" "#3a1e0b" nil))
   (diff-remove-bg '("#591b1c" "#591b1c" nil))
   (diff-modify-bg '("#5d2a12" "#5d2a12" nil))
   (rain1          '("#f12727" "#f12727" nil))
   (rain2          '("#fec758" "#fec758" nil))
   (rain3          '("#9df39f" "#9df39f" nil))
   (rain4          '("#ffb454" "#ffb454" nil))
   (rain5          '("#cd8d8d" "#cd8d8d" nil))
   (rain6          '("#fb9a4b" "#fb9a4b" nil))
   (term0          '("#1c0000" "#1c0000" nil))
   (term1          '("#ff6262" "#ff6262" nil))
   (term2          '("#9df39f" "#9df39f" nil))
   (term3          '("#ffe862" "#ffe862" nil))
   (term4          '("#fb9a4b" "#fb9a4b" nil))
   (term5          '("#ffb454" "#ffb454" nil))
   (term6          '("#ffb454" "#ffb454" nil))
   (term7          '("#f8f8f8" "#f8f8f8" nil))
   (term8          '("#8f7070" "#8f7070" nil))
   (term9          '("#ff9191" "#ff9191" nil))
   (term10         '("#baf7bc" "#baf7bc" nil))
   (term11         '("#ffef91" "#ffef91" nil))
   (term12         '("#fcb881" "#fcb881" nil))
   (term13         '("#ffca87" "#ffca87" nil))
   (term14         '("#ffca87" "#ffca87" nil))
   (term15         '("#ffffff" "#ffffff" nil))

   (hidden     `(,(car bg) "black" "black"))
   (-modeline-pad
    (when doom-vscode-red-official-padded-modeline
      (if (integerp doom-vscode-red-official-padded-modeline) doom-vscode-red-official-padded-modeline 4))))

  ;;;; Base theme face overrides
  (((font-lock-comment-face &override)
    :background (if doom-vscode-red-official-comment-bg bg-alt 'unspecified)
    :slant 'italic)
   ((font-lock-keyword-face &override) :foreground keywords )
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
;;; doom-vscode-red-official-theme.el ends here
