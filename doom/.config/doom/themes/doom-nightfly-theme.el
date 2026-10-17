;;; doom-nightfly-theme.el --- Port of the "nightfly" theme -*- lexical-binding: t; no-byte-compile: t; -*-
;;
;; Generated from the fresh-editor palette:
;;   ~/.config/fresh/themes/nightfly.json
;;   ~/.config/nvim/colors/nightfly.lua  (where ported)
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

(defgroup doom-nightfly-theme nil
  "Options for the `doom-nightfly' theme."
  :group 'doom-themes)

(defcustom doom-nightfly-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds a 4px padding to the mode-line.
Can be an integer to determine the exact padding."
  :group 'doom-nightfly-theme
  :type '(choice integer boolean))

(defcustom doom-nightfly-comment-bg nil
  "If non-nil, comments will have a subtle, darker background."
  :group 'doom-nightfly-theme
  :type 'boolean)


;;
;;; Theme definition

(def-doom-theme doom-nightfly
  "A Doom port of the nightfly theme."

  ;; name        default      256          16
  (   (bg             '("#011627" "#011627" nil))
   (bg-alt         '("#09243a" "#09243a" nil))
   (base0          '("#000b14" "#000b14" "black"))
   (base1          '("#0b1f30" "#0b1f30" "brightblack"))
   (base2          '("#142839" "#142839" nil))
   (base3          '("#1e3142" "#1e3142" nil))
   (base4          '("#2c3043" "#2c3043" nil))
   (base5          '("#1b2633" "#1b2633" nil))
   (base6          '("#586878" "#586878" nil))
   (base7          '("#4b6479" "#4b6479" nil))
   (base8          '("#c3ccdc" "#c3ccdc" "white"))
   (fg             '("#c3ccdc" "#c3ccdc" "brightwhite"))
   (fg-alt         '("#4b6479" "#4b6479" nil))
   (grey           '("#586878" "#586878" "brightblack"))
   (red            '("#ff5874" "#ff5874" nil))
   (light-red      '("#ff8297" "#ff8297" nil))
   (orange         '("#f78c6c" "#f78c6c" nil))
   (green          '("#a1cd5e" "#a1cd5e" nil))
   (teal           '("#21c7a8" "#21c7a8" nil))
   (yellow         '("#f78c6c" "#f78c6c" nil))
   (blue           '("#7fdbca" "#7fdbca" nil))
   (magenta        '("#a1cd5e" "#a1cd5e" nil))
   (violet         '("#c792ea" "#c792ea" nil))
   (cyan           '("#7fdbca" "#7fdbca" nil))
   (pink           '("#ecc48d" "#ecc48d" nil))
   (rose           '("#21c7a8" "#21c7a8" nil))
   (salmon         '("#ecc48d" "#ecc48d" nil))
   (dark-blue      '("#4c8379" "#4c8379" nil))
   (dark-cyan      '("#4c8379" "#4c8379" nil))
   (dark-violet    '("#77588c" "#77588c" nil))
   (dark-red       '("#a6394b" "#a6394b" nil))
   (dark-green     '("#69853d" "#69853d" nil))
   (light-green    '("#b4d77e" "#b4d77e" nil))
   (light-blue     '("#99e2d5" "#99e2d5" nil))
   (light-yellow   '("#f9a389" "#f9a389" nil))
   (highlight      '("#c792ea" "#c792ea" nil))
   (vertical-bar   '("#2c3043" "#2c3043" nil))
   (selection      '("#1d3b53" "#1d3b53" nil))
   (builtin        '("#a1cd5e" "#a1cd5e" nil))
   (comments       '("#7c8f8f" "#7c8f8f" nil))
   (doc-comments   '("#8e9ea2" "#8e9ea2" nil))
   (constants      '("#f78c6c" "#f78c6c" nil))
   (functions      '("#82aaff" "#82aaff" nil))
   (keywords       '("#c792ea" "#c792ea" nil))
   (methods        '("#82aaff" "#82aaff" nil))
   (operators      '("#ff5874" "#ff5874" nil))
   (type           '("#21c7a8" "#21c7a8" nil))
   (strings        '("#ecc48d" "#ecc48d" nil))
   (variables      '("#c3ccdc" "#c3ccdc" nil))
   (numbers        '("#f78c6c" "#f78c6c" nil))
   (region         '("#1d3b53" "#1d3b53" nil))
   (error          '("#ff5874" "#ff5874" nil))
   (warning        '("#f78c6c" "#f78c6c" nil))
   (success        '("#a1cd5e" "#a1cd5e" nil))
   (vc-modified    '("#f78c6c" "#f78c6c" nil))
   (vc-added       '("#a1cd5e" "#a1cd5e" nil))
   (vc-deleted     '("#ff5874" "#ff5874" nil))
   (modeline-bg    '("#081e2f" "#081e2f" nil))
   (modeline-bg-alt '("#0b1f30" "#0b1f30" nil))
   (modeline-fg    '("#c3ccdc" "#c3ccdc" nil))
   (modeline-fg-alt '("#4b6479" "#4b6479" nil))
   (modeline-bg-l  '("#011423" "#011423" nil))
   (modeline-bg-inactive '("#0b1f30" "#0b1f30" nil))
   (modeline-bg-inactive-l '("#011627" "#011627" nil))
   (cursor         '("#82aaff" "#82aaff" nil))
   (cur-line       '("#092236" "#092236" nil))
   (line-nr        '("#4b6479" "#4b6479" nil))
   (line-nr-bg     '("#011627" "#011627" nil))
   (sel-bg         '("#1d3b53" "#1d3b53" nil))
   (bracket-match  '("#82aaff" "#82aaff" nil))
   (match-bg       '("#38507a" "#38507a" nil))
   (match-fg       '("#d6deeb" "#d6deeb" nil))
   (label-bg       '("#c792ea" "#c792ea" nil))
   (label-fg       '("#1c1c1c" "#1c1c1c" nil))
   (popup-bg       '("#09243a" "#09243a" nil))
   (popup-fg       '("#c3ccdc" "#c3ccdc" nil))
   (popup-sel-bg   '("#1d3b53" "#1d3b53" nil))
   (border         '("#2c3043" "#2c3043" nil))
   (tab-active-bg  '("#1d3b53" "#1d3b53" nil))
   (tab-active-fg  '("#82aaff" "#82aaff" nil))
   (tab-inactive-bg '("#011627" "#011627" nil))
   (tab-inactive-fg '("#7c8f8f" "#7c8f8f" nil))
   (status-bg      '("#081e2f" "#081e2f" nil))
   (status-fg      '("#c3ccdc" "#c3ccdc" nil))
   (inline-bg      '("#092236" "#092236" nil))
   (err-bg         '("#3a1622" "#3a1622" nil))
   (diff-add-bg    '("#123a2e" "#123a2e" nil))
   (diff-remove-bg '("#3a1622" "#3a1622" nil))
   (diff-modify-bg '("#12283a" "#12283a" nil))
   (rain1          '("#82aaff" "#82aaff" nil))
   (rain2          '("#ecc48d" "#ecc48d" nil))
   (rain3          '("#ff5874" "#ff5874" nil))
   (rain4          '("#7fdbca" "#7fdbca" nil))
   (rain5          '("#c792ea" "#c792ea" nil))
   (rain6          '("#21c7a8" "#21c7a8" nil))
   (term0          '("#000b14" "#000b14" nil))
   (term1          '("#ff5874" "#ff5874" nil))
   (term2          '("#a1cd5e" "#a1cd5e" nil))
   (term3          '("#f78c6c" "#f78c6c" nil))
   (term4          '("#7fdbca" "#7fdbca" nil))
   (term5          '("#a1cd5e" "#a1cd5e" nil))
   (term6          '("#7fdbca" "#7fdbca" nil))
   (term7          '("#c3ccdc" "#c3ccdc" nil))
   (term8          '("#586878" "#586878" nil))
   (term9          '("#ff8a9e" "#ff8a9e" nil))
   (term10         '("#bddc8e" "#bddc8e" nil))
   (term11         '("#f9ae98" "#f9ae98" nil))
   (term12         '("#a5e6da" "#a5e6da" nil))
   (term13         '("#bddc8e" "#bddc8e" nil))
   (term14         '("#a5e6da" "#a5e6da" nil))
   (term15         '("#ffffff" "#ffffff" nil))

   (hidden     `(,(car bg) "black" "black"))
   (-modeline-pad
    (when doom-nightfly-padded-modeline
      (if (integerp doom-nightfly-padded-modeline) doom-nightfly-padded-modeline 4))))

  ;;;; Base theme face overrides
  (((font-lock-comment-face &override)
    :background (if doom-nightfly-comment-bg bg-alt 'unspecified)
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
;;; doom-nightfly-theme.el ends here
