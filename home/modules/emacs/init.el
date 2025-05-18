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

;; Bootstrap straight.el and take over use-package
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
	"straight/repos/straight.el/bootstrap.el"
	(or (bound-and-true-p straight-use-package-by-default)
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
  ;; show a list of available interactive functions
  (evil-define-key 'normal 'global
    (kbd "<leader>SPC") #'(lambda ()
			    (interactive)
			    (call-interactively #'execute-extended-command)))
  (evil-define-key nil 'global (kbd "<leader>e") 'project-find-file)
  (evil-define-key nil 'global (kbd "<leader>f") 'find-file)
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
         (lsp-mode . lsp-enable-which-key-integration)))

;; Language support modes
(use-package markdown-mode :defer t)
(use-package nix-ts-mode :defer t)
(use-package zig-ts-mode :defer t)
(use-package typst-ts-mode :defer t)
(use-package rustic
  :defer t
  :config (setq rustic-format-on-save t)
  :custom (rustic-cargo-use-last-stored-arguments t))
(use-package web-mode
  :defer t
  :mode (("\\.html?\\'" . web-mode)
         ("\\.css\\'"   . web-mode)
         ("\\.jsx?\\'"  . web-mode)
         ("\\.tsx?\\'"  . web-mode)
         ("\\.json\\'"  . web-mode))
  :config
  (setq web-mode-markup-indent-offset 4) ; HTML
  (setq web-mode-css-indent-offset 4)    ; CSS
  (setq web-mode-code-indent-offset 4)   ; JS/JSX/TS/TSX
  (setq web-mode-content-types-alist '(("jsx" . "\\.js[x]?\\'"))))

;;; init.el ends here
