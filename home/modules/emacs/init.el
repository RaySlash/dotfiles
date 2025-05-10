;;; Package --- init file -*- lexical-binding: t -*-
(setq debug-on-error t)
(setq default-directory (expand-file-name "~/"))
(setq inhibit-startup-message t)
(setq ring-bell-function 'ignore)
(setq custom-file "~/.emacs-custom.el")
(setq backup-directory-alist `(("." . ,(concat user-emacs-directory
                                               "backups"))))
(setq delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  version-control t)

(defun disable-ui-extras ()
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1))

(defun enable-ui-extras ()
  (menu-bar-mode)
  (tool-bar-mode)
  (scroll-bar-mode))

(defun toggle-relative-line-numbers ()
  (global-display-line-numbers-mode)
  (menu-bar--display-line-numbers-mode-relative))


(defun toggle-full-transparency ()
   (interactive)
   (add-to-list 'default-frame-alist '(alpha-background . 90)))

(toggle-relative-line-numbers)
(toggle-full-transparency)
(disable-ui-extras)
(global-hl-line-mode 1)
(global-set-key (kbd "M-[") 'previous-buffer)
(global-set-key (kbd "M-]") 'next-buffer)
(setenv "LANG" "en_US.UTF-8")
(setenv "LC_ALL" "en_US.UTF-8")
(setenv "LC_CTYPE" "en_US.UTF-8")
(setq scroll-step 1
      scroll-conservatively  10000)
(global-unset-key (kbd "C-x C-c"))

;;(global-set-key (kbd "C-c t") 'toggle-full-transparency)

(use-package package
  :ensure t
  :config
  (package-initialize)
  :custom
  (package-native-compile t)
  (package-archives '(("gnu"   . "http://elpa.gnu.org/packages/")
                      ("melpa" . "https://melpa.org/packages/"))))
(use-package base16-theme
  :ensure t
  :demand t
  :config (load-theme 'base16-kanagawa-dragon t))

(use-package evil
  :ensure t
  :init (setq evil-want-C-u-scroll t)
  (setq evil-want-C-d-scroll t)
  (setq evil-undo-system 'undo-redo)
  :config (evil-mode 1)
  (evil-set-leader '(normal visual) (kbd "SPC"))
  ;; show a list of available interactive functions
  (evil-define-key 'normal 'global (kbd "<leader>SPC") #'(lambda ()
                                                           (interactive)
                                                           (call-interactively #'execute-extended-command)))
  (evil-define-key nil 'global (kbd "<leader>a") 'consult-ripgrep)
  ;; find in project using fuzzy search
  (evil-define-key nil 'global (kbd "<leader>e") 'project-find-file)
  (evil-define-key nil 'global (kbd "<leader>f") 'find-file)
  (evil-define-key nil 'global (kbd "<leader>k") 'kill-buffer)
  ;; toggle native line numbers
  (evil-define-key nil 'global (kbd "<leader>l") 'display-line-numbers-mode)
  (evil-define-key nil 'global (kbd "<leader>n") 'evil-buffer-new)
  ;; fuzzy search for current buffer content
  (evil-define-key nil 'global (kbd "<leader>q") 'consult-line)
  (evil-define-key nil 'global (kbd "<leader>y") 'consult-yank-from-kill-ring))

(use-package evil-matchit
  :ensure t
  :config (global-evil-matchit-mode 1))

(use-package evil-commentary
  :ensure t
  :after (evil)
  :config
  (evil-commentary-mode))

(use-package markdown-mode
  :ensure t
  :defer t)

(use-package rustic
  :ensure t
  :config
  (setq rustic-format-on-save t)
  :custom
  (rustic-cargo-use-last-stored-arguments t))

;; add pair parenthesis, square brackets, etc
(add-hook 'prog-mode-hook 'electric-pair-mode)

;; disable `electric-pair-mode' in `org-mode', to avoid conflict with
;; `<s' source block
(add-hook 'org-mode-hook #'(lambda ()
                             (electric-pair-local-mode -1)))

(use-package consult
  :ensure t)

(use-package doom-modeline
  :ensure t
  :defer t
  :custom
  ;; show evil state in modeline
  (doom-modeline-modal-icon nil)
  ;; file path will be relative to project root
  (doom-modeline-buffer-file-name-style 'relative-from-project)
  :hook
  (after-init . doom-modeline-mode)
  (doom-modeline-mode . display-battery-mode))

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(use-package lsp-mode
  :init (setq lsp-keymap-prefix "C-l")
  :ensure t
  :hook ((XXX-mode . lsp)
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

(use-package ivy
  :ensure t
  :config (ivy-mode)
  (setopt ivy-use-virtual-buffers t)
  (setopt enable-recursive-minibuffers t))

(use-package lsp-ivy
  :ensure t
  :commands lsp-ivy-workspace-symbol)

(use-package lsp-treemacs
  :ensure t
  :commands lsp-treemacs-errors-list)

(use-package dap-mode :ensure t)

;; Show help about the keys pressed
(use-package which-key
  :ensure t
  :config
  (which-key-mode)
  (which-key-setup-minibuffer))

;; Show a marker in fringe area when there is a change in the current
;; buffer
(use-package diff-hl
  :ensure t
  :custom
  (diff-hl-show-staged-changes nil)
  :init
  (add-hook 'dired-mode-hook 'diff-hl-dired-mode)
  :config
  (global-diff-hl-mode))

;; UI for completion
(use-package vertico
  :ensure t
  :init
  (vertico-mode)
  :custom
  (vertico-resize nil)
  (vertico-count 15))

;; Enhance information in completion
(use-package marginalia
  :ensure
  :init
  (marginalia-mode))

;; Better completion style
(use-package orderless
  :ensure t
  :config
  (setq (completion-styles '(orderless basic))
	(completion-category-overrides '((file (styles basic partial-completion))))))

;; Completion at point support
(use-package company
  :ensure t
  :init
  (setq company-idle-delay 0.1
        company-tooltip-limit 10
        company-minimum-prefix-length 3)
  :hook (after-init . global-company-mode)
  :config
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous))

