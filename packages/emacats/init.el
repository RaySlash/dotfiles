;;; Package --- init file -*- lexical-binding: t -*-

;;; Commentary:
;; Personal Emacs Configuration of RaySlash
;; Uses MELPA as one of sources.
;; Includes evil-mode.

;;; Code:
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
      scroll-conservatively  10000)

;; Disable extra UI elements
(defun disable-ui-extras ()
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1))

;; Enable extra UI elements
(defun enable-ui-extras ()
  (menu-bar-mode)
  (tool-bar-mode)
  (scroll-bar-mode))

;; Toggle Relative Line Numbers
(defun toggle-relative-line-numbers ()
  (global-display-line-numbers-mode)
  (menu-bar--display-line-numbers-mode-relative))

;; Toggle Frame Transparency (Emacs 29+)
(defun toggle-transparency ()
   (interactive)
   (add-to-list 'default-frame-alist '(alpha-background . 90)))

(setenv "LANG" "en_US.UTF-8")
(setenv "LC_ALL" "en_US.UTF-8")
(setenv "LC_CTYPE" "en_US.UTF-8")
(setenv "LSP_USE_PLISTS" "true")
(toggle-relative-line-numbers)
(toggle-transparency)
(disable-ui-extras)
(global-hl-line-mode 1)
(global-set-key (kbd "M-[") 'previous-buffer)
(global-set-key (kbd "M-]") 'next-buffer)
;;(global-set-key (kbd "C-c t") 'toggle-full-transparency)
(add-hook 'prog-mode-hook 'electric-pair-mode)
(add-hook 'org-mode-hook #'(lambda () (electric-pair-local-mode -1)))
(add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)

(require 'use-package-ensure)
(setq use-package-always-ensure t)

;; Emacs defaults
(use-package emacs
  :custom (tab-always-indent 'complete)
  (text-mode-ispell-word-completion nil)
  (read-extended-command-predicate #'command-completion-default-include-p))

;; Kanagawa Dragon theme
(use-package base16-theme :config (load-theme 'base16-kanagawa-dragon t))

(use-package dashboard
  :config (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner 'logo
        dashboard-banner-logo-title "Evil Emacs"
        dashboard-items nil
        dashboard-set-footer nil))

;; Evil mode and complimentaries
(use-package evil
  :init (setq evil-want-C-u-scroll t)
  (setq evil-want-C-d-scroll t)
  (setq evil-undo-system 'undo-redo)
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :config (evil-mode 1)
  (evil-set-leader '(normal visual) (kbd "SPC"))
  (evil-set-initial-state 'term-mode 'emacs)
  ;; show a list of available interactive functions
  (evil-define-key 'normal 'global
    (kbd "<leader>SPC") #'(lambda ()
			    (interactive)
			    (call-interactively #'execute-extended-command)))
  (evil-define-key nil 'global (kbd "<leader>e") 'project-find-file)
  (evil-define-key nil 'global (kbd "<leader>f") 'find-file)
  (evil-define-key nil 'global (kbd "<leader>t") 'vterm)
  (evil-define-key nil 'global (kbd "<leader>k") 'kill-buffer)
  (evil-define-key nil 'global (kbd "<leader>l") 'display-line-numbers-mode)
  (evil-define-key nil 'global (kbd "<leader>n") 'evil-buffer-new)
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
  :defer t
  :custom (doom-modeline-modal-icon nil)
  (doom-modeline-buffer-file-name-style 'relative-from-project)
  :hook (after-init . doom-modeline-mode)
  (doom-modeline-mode . display-battery-mode))

(use-package nerd-icons
  :custom (nerd-icons-font-family "Symbols Nerd Font Mono"))

;; Git support in mini-buffer
(use-package magit
  :bind ("C-x g" . magit-status)
  :config (add-hook 'with-editor-mode-hook #'evil-insert-state))

;; mini-buffer completion and completion-on-point
(use-package consult
  :defer t
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :init (advice-add #'register-preview :override #'consult-register-window)
  (setq register-preview-delay 0.5)
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)
  :config (consult-customize consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep consult-man
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   :preview-key '(:debounce 0.4 any)) ;; :preview-key "M-."
  (setq consult-narrow-key "<") ;; "C-+"
  (keymap-set consult-narrow-map (concat consult-narrow-key " ?") #'consult-narrow-help))

(use-package vertico
  :defer t
  :init (vertico-mode)
  :custom (vertico-resize nil)
  (vertico-count 15))

(use-package marginalia
  :defer t
  :init (marginalia-mode))

(use-package orderless
  :defer t
 :custom (completion-styles '(orderless basic flex))
 (completion-category-defaults nil)
 (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package smartparens
  ;; add `smartparens-mode` to these hooks
  :hook (prog-mode text-mode markdown-mode web-mode zig-ts-mode nix-ts-mode rustic)
  :config (require 'smartparens-config))

(use-package corfu
  :defer t
  :custom (corfu-cycle t)
  (corfu-auto t)
  (corfu-quit-no-match t)
  :init (global-corfu-mode)
  (corfu-history-mode)
  (corfu-popupinfo-mode))

(use-package cape
  :defer t
  :bind ("C-c p" . cape-prefix-map) ;; Alternative key: M-<tab>, M-p, M-+
  :init (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block)
  (add-hook 'completion-at-point-functions #'cape-history))

(use-package which-key
  :diminish which-key-mode
  :config (which-key-mode +1)
  (setq which-key-idle-delay 0.4
        which-key-idle-secondary-delay 0.4))

;; LSP and syntax check error/warning highlighting
(use-package flycheck
  :defer t
  :commands (global-flycheck-mode)
  :init (global-flycheck-mode))

(use-package lsp-mode
  :defer t
  :init (setq lsp-keymap-prefix "C-l")
  :hook ((XXX-mode . lsp)
         (lsp-mode . lsp-enable-which-key-integration))
  :custom (lsp-keymap-prefix "C-c l")
  (lsp-completion-provider :none)
  (lsp-diagnostics-provider :flycheck)
  (lsp-session-file (locate-user-emacs-file ".lsp-session"))
  (lsp-log-io nil)
  (lsp-keep-workspace-alive nil)
  (lsp-idle-delay 0.5)
  (lsp-enable-xref t)
  (lsp-auto-configure t)
  (lsp-eldoc-enable-hover t)
  (lsp-enable-dap-auto-configure t)
  (lsp-enable-file-watchers nil)
  (lsp-enable-folding t)
  (lsp-enable-imenu t)
  (lsp-enable-indentation true)
  (lsp-enable-links nil)
  (lsp-enable-on-type-formatting t)
  (lsp-enable-suggest-server-download t)
  (lsp-enable-symbol-highlighting t)
  (lsp-enable-text-document-color nil)

  (lsp-ui-sideline-show-hover nil)
  (lsp-ui-sideline-diagnostic-max-lines 20)

  (lsp-completion-enable t)
  (lsp-completion-enable-additional-text-edit t)
  (lsp-enable-snippet t)
  (lsp-completion-show-kind t)

  (lsp-headerline-breadcrumb-enable t)
  (lsp-headerline-breadcrumb-enable-diagnostics nil)
  (lsp-headerline-breadcrumb-enable-symbol-numbers nil)
  (lsp-headerline-breadcrumb-icons-enable nil)

  (lsp-modeline-code-actions-enable nil)
  (lsp-modeline-diagnostics-enable nil)
  (lsp-modeline-workspace-status-enable nil)
  (lsp-signature-doc-lines 1)
  (lsp-ui-doc-use-childframe t)
  (lsp-eldoc-render-all nil)
  (lsp-lens-enable nil)
  (lsp-semantic-tokens-enable nil))

(use-package lsp-completion
  :no-require
  :hook ((lsp-mode . lsp-completion-mode)))

(use-package lsp-ui
  :ensure t
  :commands
  (lsp-ui-doc-show
   lsp-ui-doc-glance)
  :bind (:map lsp-mode-map
              ("C-c C-d" . 'lsp-ui-doc-glance))
  :after (lsp-mode evil)
  :config (setq lsp-ui-doc-enable t
                evil-lookup-func #'lsp-ui-doc-glance
                lsp-ui-doc-show-with-cursor nil
                lsp-ui-doc-include-signature t
                lsp-ui-doc-position 'at-point))

(use-package vterm)

(use-package envrc
  :hook (after-init . envrc-global-mode))

;; Language support modes
(use-package c-ts-mode
  :defer t
  :mode (("\\.c\\'" . c-ts-mode)))
(use-package markdown-ts-mode
  :defer t
  :mode (("\\.md\\'" . markdown-ts-mode)))
(use-package nix-ts-mode
  :defer t
  :mode (("\\.nix\\'" . nix-ts-mode)))
(use-package json-ts-mode
  :defer t
  :mode (("\\.json\\'" . json-ts-mode)))
(use-package lua-ts-mode
  :defer t
  :mode (("\\.lua\\'" . lua-ts-mode)))
(use-package zig-ts-mode
  :defer t
  :mode (("\\.zig\\'" . zig-ts-mode)))
(use-package typescript-ts-mode
  :defer t
  :mode (("\\.ts\\'" . typescript-ts-mode)
         ("\\.js\\'" . typescript-ts-mode)
	 ("\\.tsx\\'" . tsx-ts-mode)
	 ("\\.jsx\\'" . tsx-ts-mode))
  :config (add-hook! '(typescript-ts-mode-hook tsx-ts-mode-hook) #'lsp!))
(use-package css-mode
  :defer t
  :mode (("\\.css\\'" . css-mode)))
(use-package typst-ts-mode
  :defer t
  :mode (("\\.typ\\'" . typst-ts-mode)
         ("\\.typst\\'"   . typst-ts-mode)))
(use-package rust-mode
  :defer t
  :init (setq rust-mode-treesitter-derive t)
  :mode (("\\.rs\\'" . rust-mode)))
(use-package rustic
  :defer t
  :after (rust-mode)
  :mode (("\\.rs\\'" . rustic-mode))
  :config (setq rustic-format-on-save t)
  :custom (rustic-cargo-use-last-stored-arguments t))

;;; init.el ends here
