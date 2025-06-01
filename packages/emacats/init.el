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
(electric-pair-mode 1)
(global-hl-line-mode 1)
(global-completion-preview-mode)
(global-prettify-symbols-mode 1)
(global-set-key (kbd "M-[") 'previous-buffer)
(global-set-key (kbd "M-]") 'next-buffer)
;;(global-set-key (kbd "C-c t") 'toggle-full-transparency)
(add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)

(require 'use-package-ensure)
(setq use-package-always-ensure t)

;; Emacs defaults
(use-package emacs
  :custom (tab-always-indent 'complete)
  (text-mode-ispell-word-completion nil)
  (set-face-attribute 'default nil :font "IosevkaTerm Nerd Font")
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
  (evil-define-key nil 'global (kbd "<leader>f") 'project-find-file)
  (evil-define-key nil 'global (kbd "<leader>g") 'rgrep)
  (evil-define-key nil 'global (kbd "<leader>p") 'find-file)
  (evil-define-key nil 'global (kbd "<leader>e") 'dired-jump)
  (evil-define-key nil 'global (kbd "<leader>t") 'vterm)
  (evil-define-key nil 'global (kbd "<leader>k") 'kill-buffer)
  (evil-define-key nil 'global (kbd "<leader>l") 'display-line-numbers-mode)
  (evil-define-key nil 'global (kbd "<leader>n") 'evil-buffer-new)
  (evil-define-key nil 'global (kbd "<leader>b") 'ibuffer))

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

(use-package nerd-icons
  :custom (nerd-icons-font-family "Symbols Nerd Font Mono"))

(use-package nerd-icons-dired
  :hook
  (dired-mode . nerd-icons-dired-mode))

(use-package nerd-icons-completion
  :after marginalia
  :config
  (nerd-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(use-package nerd-icons-ibuffer
  :ensure t
  :hook (ibuffer-mode . nerd-icons-ibuffer-mode))

;; Git support in mini-buffer
(use-package magit
  :bind ("C-x g" . magit-status)
  :config (add-hook 'with-editor-mode-hook #'evil-insert-state))

(use-package icomplete
  :init
  (setf completion-styles '(basic flex)
	completion-auto-select t ;; Show completion on first call
	completion-auto-help 'visible ;; Display *Completions* upon first request
	completions-format 'one-column ;; Use only one column
	completions-sort 'historical ;; Order based on minibuffer history
	completions-max-height 20 ;; Limit completions to 15 (completions start at line 5)
	completion-ignore-case t)
  :config
  (fido-vertical-mode))

(use-package marginalia
  :commands (marginalia-mode)
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  :init (marginalia-mode))

(use-package which-key
  :diminish which-key-mode
  :config (which-key-mode 1)
  (setq which-key-idle-delay 0.4
        which-key-idle-secondary-delay 0.4))

;; LSP and syntax check error/warning highlighting
(use-package eglot
  :defer t
  :init (setq eglot-connect-hook nil)
  :hook
  (c-ts-mode . eglot-ensure)
  (markdown-ts-mode . eglot-ensure)
  (nix-ts-mode . eglot-ensure)
  (lua-ts-mode . eglot-ensure)
  (typst-ts-mode . eglot-ensure)
  (zig-ts-mode . eglot-ensure)
  (typescript-ts-mode . eglot-ensure)
  (rust-mode . eglot-ensure))

(use-package flycheck
  :defer t
  :commands (global-flycheck-mode)
  :init (global-flycheck-mode))
(use-package corfu
  :commands (global-corfu-mode)
  (corfu-history-mode)
  (corfu-popupinfo-mode)
  :custom
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  ;; (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
  ;; (corfu-quit-no-match nil)      ;; Never quit, even if there is no match
  ;; (corfu-preview-current nil)    ;; Disable current candidate preview
  ;; (corfu-preselect 'prompt)      ;; Preselect the prompt
  ;; (corfu-on-exact-match nil)     ;; Configure handling of exact matches

  :init (global-corfu-mode)
  (corfu-history-mode)
  (corfu-popupinfo-mode))

(use-package vterm :defer t)

(use-package envrc
  :defer t
  :hook (after-init . envrc-global-mode))

;; Language support modes
(use-package c-ts-mode
  :defer t
  :mode (("\\.c\\'" . c-ts-mode)
	 ("\\.cpp\\'" . c-ts-mode)))
(use-package markdown-ts-mode
  :defer t
  :mode (("\\.md\\'" . markdown-ts-mode)
	 ("\\.mdx\\'" . markdown-ts-mode)))
(use-package bash-ts-mode
  :defer t
  :mode (("\\.sh\\'" . bash-ts-mode)))
(use-package nix-ts-mode
  :defer t
  :mode (("\\.nix\\'" . nix-ts-mode)))
(use-package json-ts-mode
  :defer t
  :mode (("\\.json\\'" . json-ts-mode)))
(use-package yaml-ts-mode
  :defer t
  :mode (("\\.yaml\\'" . yaml-ts-mode)))
(use-package clojure-ts-mode
  :defer t
  :mode (("\\.clj\\'" . clojure-ts-mode)))
(use-package lua-ts-mode
  :defer t
  :mode (("\\.lua\\'" . lua-ts-mode)))
(use-package zig-ts-mode
  :defer t
  :mode (("\\.zig\\'" . zig-ts-mode)))
(use-package typescript-ts-mode
  :defer t
  :mode (("\\.ts\\'" . typescript-ts-mode)
         ("\\.js\\'" . js-ts-mode)
	 ("\\.tsx\\'" . tsx-ts-mode)
	 ("\\.jsx\\'" . js-jsx-mode))
  :config (add-hook! '(typescript-ts-mode-hook tsx-ts-mode-hook) #'lsp!))
(use-package scss-mode
  :defer t
  :mode (("\\.scss\\'" . scss-mode)))
(use-package less-css-mode
  :defer t
  :mode (("\\.less\\'" . less-css-mode)))
(use-package html-ts-mode
  :defer t
  :mode (("\\.html\\'" . html-ts-mode)))
(use-package css-ts-mode
  :defer t
  :mode (("\\.css\\'" . css-ts-mode)))
(use-package toml-ts-mode
  :defer t
  :mode (("\\.toml\\'" . toml-ts-mode)))
(use-package typst-ts-mode
  :defer t
  :mode (("\\.typ\\'" . typst-ts-mode)))
(use-package rust-ts-mode
  :defer t
  :mode (("\\.rs\\'" . rust-ts-mode)))

;;; init.el ends here
