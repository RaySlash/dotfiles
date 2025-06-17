;;; Package --- init file -*- lexical-binding: t -*-

;;; Commentary:
;; Personal Emacs Configuration of RaySlash
;; Uses MELPA as one of sources.
;; Includes evil-mode.

;;; Code:
;; Bootstrap straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Configure recipe sources (MELPA only)
(setq straight-recipe-repositories '(melpa org-elpa gnu-elpa-mirror nongnu-elpa el-get)) ; Critical: exclude emacsmirror
(use-package use-package)
(setq straight-use-package-by-default t)

(setq debug-on-error t
      enable-recursive-minibuffers t
      inhibit-startup-message t
      ring-bell-function 'ignore)

(setq default-directory (expand-file-name "~/")
      custom-file "~/.emacs-custom.el"
      backup-directory-alist `(("." . ,(concat user-emacs-directory
                                               "backups"))))
(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

(setq scroll-step 1
      scroll-conservatively 10000)

;; Toggle Frame Transparency (Emacs 29+)

; (setenv "LANG" "en_US.UTF-8")
; (setenv "LC_ALL" "en_US.UTF-8")
; (setenv "LC_CTYPE" "en_US.UTF-8")
(setenv "LSP_USE_PLISTS" "true")

;; Set Frame Decoration and Fonts
(add-to-list 'default-frame-alist '(alpha-background . 90))
(set-frame-font "IosevkaTermNerdFont-13" nil t)
(set-face-font 'fixed-pitch "IosevkaTermNerdFont") ;; Show same font in codeblocks

;; Toggle Relative Line Numbers
(global-display-line-numbers-mode)
(menu-bar--display-line-numbers-mode-relative)

;; Disable extra UI elements
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Autocomplete brackets and quotes
(electric-pair-mode 1)
(global-hl-line-mode 1)
(global-prettify-symbols-mode 1)
(global-completion-preview-mode)

;; Set global key to switch buffers
(global-set-key (kbd "M-[") 'previous-buffer)
(global-set-key (kbd "M-]") 'next-buffer)
(add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)

(setq which-key-popup-type 'minibuffer)
(which-key-mode)

;; Emacs defaults
(use-package emacs
  :custom (tab-always-indent 'complete)
  (text-mode-ispell-word-completion nil)
  (read-extended-command-predicate #'command-completion-default-include-p)
  (enable-recursive-minibuffers t)
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt)))

;; Kanagawa Dragon theme
(use-package base16-theme
  :config (load-theme 'base16-kanagawa-dragon t))

(use-package dashboard
  :config (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner 'logo
        dashboard-banner-logo-title "Evil Emacs"
        dashboard-items nil
        dashboard-set-footer nil))

;; Evil mode and complimentaries
(use-package evil
  :init (setq evil-want-C-u-scroll t
	      evil-want-C-d-scroll t
	      evil-undo-system 'undo-redo
	      evil-want-integration t
	      evil-undo-system 'undo-fu
	      evil-want-keybinding nil)
  :config (evil-mode 1)
  (evil-set-leader '(normal visual) (kbd "SPC"))
  (evil-set-initial-state 'term-mode 'emacs)
  ;; show a list of available interactive functions
  (evil-define-key 'normal 'global
    (kbd "<leader>SPC") #'(lambda ()
			    (interactive)
			    (call-interactively #'execute-extended-command)))
  (evil-define-key nil 'global (kbd "<leader>f") 'project-find-file)
  (evil-define-key nil 'global (kbd "<leader>g") 'rgrep)
  (evil-define-key nil 'global (kbd "<leader>p") 'find-file)
  (evil-define-key nil 'global (kbd "<leader>e") 'dired-jump)
  (evil-define-key nil 'global (kbd "<leader>t") 'vterm)
  (evil-define-key nil 'global (kbd "<leader>u") 'vundo)
  (evil-define-key nil 'global (kbd "<leader>k") 'kill-buffer)
  (evil-define-key nil 'global (kbd "<leader>l") 'display-line-numbers-mode)
  (evil-define-key nil 'global (kbd "<leader>n") 'evil-buffer-new)
  (evil-define-key nil 'global (kbd "<leader>d") 'consult-flymake)
  (evil-define-key nil 'global (kbd "<leader>b") 'consult-buffer))

(use-package evil-collection
  :after evil
  :custom (evil-collection-setup-minibuffer t)
  :config (evil-collection-init))

(use-package evil-matchit
  :after evil
  :config (global-evil-matchit-mode 1))

(use-package evil-commentary
  :after (evil)
  :config (evil-commentary-mode))

;; Statusbar with evil support
(use-package doom-modeline
  :hook (after-init . doom-modeline-mode))

(use-package dirvish
  :init (dirvish-override-dired-mode)
  :config
  ;; (dirvish-peek-mode)             ; Preview files in minibuffer
  ;; (dirvish-side-follow-mode)      ; similar to `treemacs-follow-mode'
  (setq dirvish-mode-line-format
        '(:left (sort symlink) :right (omit yank index)))
  (setq dirvish-attributes           ; The order *MATTERS* for some attributes
        '(vc-state subtree-state nerd-icons collapse git-msg file-time file-size)
        dirvish-side-attributes
        '(vc-state nerd-icons collapse file-size))
  (setq dirvish-large-directory-threshold 20000)
  :bind ; Bind `dirvish-fd|dirvish-side|dirvish-dwim' as you see fit
  (("C-c f" . dirvish)
   :map dirvish-mode-map               ; Dirvish inherits `dired-mode-map'
   (";"   . dired-up-directory)        ; So you can adjust `dired' bindings here
   ("?"   . dirvish-dispatch)          ; [?] a helpful cheatsheet
   ("n"   . make-empty-file)        ; [a]ttributes settings:`t' toggles mtime, `f' toggles fullframe, etc.
   ("d"   . make-directory)        ; [a]ttributes settings:`t' toggles mtime, `f' toggles fullframe, etc.
   ("e"   . dired-toggle-read-only)        ; [a]ttributes settings:`t' toggles mtime, `f' toggles fullframe, etc.
   ("f"   . dirvish-file-info-menu)    ; [f]ile info
   ("o"   . dirvish-quick-access)      ; [o]pen `dirvish-quick-access-entries'
   ("s"   . dirvish-quicksort)         ; [s]ort flie list
   ("r"   . dirvish-history-jump)      ; [r]ecent visited
   ("v"   . dirvish-vc-menu)           ; [v]ersion control commands
   ("*"   . dirvish-mark-menu)
   ("y"   . dirvish-yank-menu)
   ("N"   . dirvish-narrow)
   ("^"   . dirvish-history-last)
   ("TAB" . dirvish-subtree-toggle)
   ("M-f" . dirvish-history-go-forward)
   ("M-b" . dirvish-history-go-backward)
   ("M-e" . dirvish-emerge-menu)))

(use-package nerd-icons
  :custom (nerd-icons-font-family "Symbols Nerd Font Mono"))

(use-package nerd-icons-completion
  :after marginalia
  :config
  (nerd-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(use-package nerd-icons-ibuffer
  :hook (ibuffer-mode . nerd-icons-ibuffer-mode))

(use-package kind-icon
  :after corfu
  (kind-icon-blend-background t)
  (kind-icon-default-face 'corfu-default) ; only needed with blend-background
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

;; Git support in mini-buffer
(use-package magit
  :bind ("C-x g" . magit-status)
  :config (add-hook 'with-editor-mode-hook #'evil-insert-state))

(use-package undo-fu)
(use-package vundo)

(use-package vertico
  :init (vertico-mode)
  (savehist-mode))

(use-package orderless
  :custom
  (orderless-component-separator #'orderless-escapable-split-on-space)
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  :init (marginalia-mode))

(use-package embark
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :config
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package consult
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x t b" . consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flycheck)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ("M-s d" . consult-fd)                  ;; Alternative: consult-fd
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  :hook (completion-list-mode . consult-preview-at-point-mode)
  :init (advice-add #'register-preview :override #'consult-register-window)
  (setq register-preview-delay 0.5)
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  :config
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep consult-man
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file :preview-key '(:debounce 0.4 any))
  (setq consult-narrow-key "<"))

(use-package embark-consult
  :hook (embark-collect-mode . consult-preview-at-point-mode))


(use-package flycheck
  :defer t
  :config (global-flycheck-mode))

(use-package flycheck-inline
  :config (global-flycheck-inline-mode))

(use-package flycheck-rust
  :config (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  ;; (corfu-on-exact-match nil)     ;; Configure handling of exact matches
  :init (global-corfu-mode)
  (corfu-history-mode)
  (corfu-popupinfo-mode))

(use-package markdown-mode)

(use-package cape
  :bind ("C-c p" . cape-prefix-map) ;; Alternative key: M-<tab>, M-p, M-+
  ;; Alternatively bind Cape commands individually.
  :commands (global-corfu-mode)
  ;; :bind (("C-c p d" . cape-dabbrev)
  ;;        ("C-c p h" . cape-history)
  ;;        ("C-c p f" . cape-file)
  ;;        ...)
  :init
  ;; Add to the global default value of `completion-at-point-functions' which is
  ;; used by `completion-at-point'.  The order of the functions matters, the
  ;; first function returning a result wins.  Note that the list of buffer-local
  ;; completion functions takes precedence over the global list.
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block)
  (add-hook 'completion-at-point-functions #'cape-history))

(use-package websocket)
(use-package typst-preview
  :straight '(typst-preview :type git :host github :repo "havarddj/typst-preview.el")
  :config (setq typst-preview-invert-colors "never"))

(use-package format-all
  :commands format-all-mode
  :hook (prog-mode . format-all-mode)
  :config (setq-default format-all-formatters '(
						("Typst" (typstyle))
						("C" (clang-format))
						("Nix" (alejandra))))
  (define-format-all-formatter typstyle
    (:executable "typstyle")
    (:install "cargo install typstyle")
    (:languages "Typst")
    (:features)
    (:format (format-all--buffer-easy executable))))

(use-package vterm :defer t)

(use-package envrc
  :defer t
  :hook (after-init . envrc-global-mode))

;; Language support modes
(add-to-list 'auto-mode-alist '("\\.c\\'" . c-ts-mode))
(add-to-list 'auto-mode-alist '("\\.cpp\\'" . c++-ts-mode))
(add-to-list 'auto-mode-alist '("\\.cmake\\'" . cmake-ts-mode))
(add-to-list 'auto-mode-alist '("\\.cs\\'" . csharp-ts-mode))
(add-to-list 'auto-mode-alist '("\\.sh\\'" . bash-ts-mode))
(add-to-list 'auto-mode-alist '("\\.json\\'" . json-ts-mode))
(add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-ts-mode))
(add-to-list 'auto-mode-alist '("\\.lua\\'" . lua-ts-mode))
(add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode))
(add-to-list 'auto-mode-alist '("\\.less\\'" . less-css-mode))
(add-to-list 'auto-mode-alist '("\\.css\\'" . css-ts-mode))
(add-to-list 'auto-mode-alist '("\\.html\\'" . html-ts-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-ts-mode))
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . js-ts-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))

(use-package zig-ts-mode
  :straight (:type git :host codeberg :repo "meow_king/zig-ts-mode")
  :mode ("\\.zig\\'" . zig-ts-mode))

(use-package nix-ts-mode
  :mode ("\\.nix\\'" . nix-ts-mode))

(use-package markdown-ts-mode
  :mode ("\\.md\\'" . markdown-ts-mode))

(use-package typst-ts-mode
  :mode ("\\.typ\\'" . typst-ts-mode)
  :config
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
		 `((typst-ts-mode) . ,(eglot-alternatives
				       `(,typst-ts-lsp-download-path
					  "tinymist"
					  "typst-lsp"))))))

(use-package eglot
  :config (setq eglot-ignored-server-capabilities '(:inlayHintProvider))
  :hook
  (c-ts-mode . eglot-ensure)
  (c++-ts-mode . eglot-ensure)
  (cmake-ts-mode . eglot-ensure)
  (lua-ts-mode . eglot-ensure)
  (csharp-ts-mode . eglot-ensure)
  (bash-ts-mode . eglot-ensure)
  (yaml-ts-mode . eglot-ensure)
  (css-ts-mode . eglot-ensure)
  (html-ts-mode . eglot-ensure)
  (markdown-ts-mode . eglot-ensure)
  (rust-ts-mode . eglot-ensure)
  (typescript-ts-mode . eglot-ensure)
  (js-ts-mode . eglot-ensure)
  (tsx-ts-mode . eglot-ensure)
  (zig-ts-mode . eglot-ensure)
  (nix-ts-mode . eglot-ensure)
  (typst-ts-mode . eglot-ensure))

(use-package treesit-auto
  :custom (treesit-auto-install t)
  :config (global-treesit-auto-mode))

;;; init.el ends here
