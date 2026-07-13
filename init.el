;;; init.el --- Emacs configuration

;; References:
;; Ryan McGuire Emacs cofiguration bundle: http://github.com/EnigmaCurry/emacs
;; Chris Wanstrath http://github.com/defunkt/emacs

(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")
        ("org" . "http://orgmode.org/elpa/")))

(setq package-archive-priorities
      '(("gnu" . 3)
        ("melpa" . 2)
        ("org" . 1)))

(use-package emacs
    :init
    (setq custom-file (concat user-emacs-directory "config/custom/custom.el"))
    (load custom-file)
    (setq gc-cons-threshold 100000000)
    (setq read-process-output-max (* 1024 1024))
    (setq inhibit-startup-message t)
    (setq initial-scratch-message nil)
    (setq make-backup-files nil)
    (setq scroll-step 1)
    (setq major-mode 'text-mode)
    (setq kill-whole-line t)
    (setq vc-follow-symlinks nil)
    (setq show-paren-delay 0)

    :hook
    (before-save-hook . delete-trailing-whitespace)
    (emacs-lisp-mode-hook . enable-paredit-mode)

    :config
    (defalias 'yes-or-no-p 'y-or-n-p)
    (set-default 'truncate-partial-width-windows nil)
    (set-default 'truncate-lines t)
    (put 'downcase-region 'disabled nil)
    (put 'upcase-region 'disabled nil)

    :custom
    (use-short-answers t)
    (menu-bar-mode -1)
    (tool-bar-mode -1)
    (scroll-bar-mode -1)
    (tooltip-mode -1)
    (prefer-coding-system 'utf-8)
    (line-number-mode 1)
    (column-number-mode 1)
    (show-paren-mode 1)
    (electric-pair-mode 1))

(defvar local-default-font)

(setq local-default-font
      (cond ((eq system-type 'windows-nt) "Consolas-16")
            ((eq system-type 'gnu/linux) "JetBrainsMonoNL Nerd Font Mono-17")
            (t nil)))

(when (eq system-type 'darwin)
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'super)
  (setq local-default-font "JetBrainsMonoNL Nerd Font Mono-17")
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  (add-to-list 'default-frame-alist '(ns-appearance . dark)))

(when window-system
  (set-frame-size (selected-frame) 110 50))

(when local-default-font
  (add-to-list 'initial-frame-alist `(font . ,local-default-font)))

(add-to-list 'load-path (concat user-emacs-directory "config"))
(add-to-list 'load-path (concat user-emacs-directory "extra"))

(when (or (eq system-type 'darwin) (eq system-type 'gnu/linux))
  (use-package exec-path-from-shell
    :ensure t
    :config
    (exec-path-from-shell-initialize)))

(use-package projectile
  :ensure t)

(use-package magit
  :ensure t)

(use-package treemacs
  :ensure t)

(use-package vertico
  :ensure t
  :init
  (vertico-mode)
  :custom
  (vertico-cycle t)
  (vertico-reverse-mode t))

(use-package consult
  :ensure t)

(use-package corfu
  :ensure t
  :init
  (global-corfu-mode))

(use-package pyvenv
  :ensure t)

(use-package eldoc-box
  :ensure t)

(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))

(use-package savehist
  :ensure t
  :init
  (savehist-mode))

(use-package catppuccin-theme
  :ensure t
  :config
  (catppuccin-flavor 'mocha))

(use-package markdown-mode
  :ensure t
  :defer t
  :config
  (markdown-italic-underscore t)
  (markdown-command "pandoc")
  (markdown-asymmetric-header t))

(use-package web-mode
  :ensure t
  :defer t
    :mode
  (("\\.phtml\\'" . web-mode)
   ("\\.tpl\\.php\\'" . web-mode)
   ("\\.[agj]sp\\'" . web-mode)
   ("\\.as[cp]x\\'" . web-mode)
   ("\\.erb\\'" . web-mode)
   ("\\.mustache\\'" . web-mode)
   ("\\.djhtml\\'" . web-mode)))

(use-package org
  :mode (("\\.org$". org-mode)))

(load "custom/indentation")
(load "custom/keymap")
(load "custom/recentf")
(load "custom/tramp")
(load "custom/lsp")
(load "custom/hook")
(load "custom/lang-modes")
