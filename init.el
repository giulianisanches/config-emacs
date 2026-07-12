;;; init.el --- Emacs configuration

;;; Commentary:

;; Thanks to:
;; Ryan McGuire Emacs cofiguration bundle: http://github.com/EnigmaCurry/emacs
;; Chris Wanstrath http://github.com/defunkt/emacs
;; Eden Cardim (http://edencardim.com)

;;; Code:

(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))

(set-default 'truncate-partial-width-windows nil)
(set-default 'truncate-lines t)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(tooltip-mode -1)

(prefer-coding-system 'utf-8)

(line-number-mode 1)
(column-number-mode 1)

(show-paren-mode 1)

(electric-pair-mode 1)

(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
(setq make-backup-files nil)
(setq scroll-step 1)
(setq major-mode 'text-mode)
(setq kill-whole-line t)

(setq vc-follow-symlinks nil)

(setq show-paren-delay 0)

(defvar local-default-font)

(setq local-default-font
      (cond ((eq system-type 'windows-nt) "Consolas-16")
            ((eq system-type 'gnu/linux) "JetBrainsMonoNL Nerd Font Mono-17")
            (t nil)))

(when (eq system-type 'darwin)
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'super)
  (setq local-default-font "Monaco-18")
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  (add-to-list 'default-frame-alist '(ns-appearance . dark)))

(when window-system
  (set-frame-size (selected-frame) 110 50))

(when local-default-font
  (add-to-list 'default-frame-alist `(font . ,local-default-font))
  (add-to-list 'initial-frame-alist `(font . ,local-default-font)))

(defalias 'yes-or-no-p 'y-or-n-p)

(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://melpa.org/packages/") t)
(package-initialize)

(add-to-list 'load-path (concat user-emacs-directory "config"))
(add-to-list 'load-path (concat user-emacs-directory "extra"))

;; The code below will install all the extensions that do not exist in the
;; directory extra-pkg
(if (not package-archive-contents)
  (package-refresh-contents))

(defvar required-packages)
(defvar lang-modes)

(setq required-packages
      '(
        exec-path-from-shell
        projectile
        magit
        treemacs
        vertico
        consult
        pyvenv
        eldoc-box
        yasnippet
        catppuccin-theme))

(setq lang-modes
      '(
        markdown-mode
        web-mode))

(dolist (package (required-packages lang-modes)
  (if (not (package-installed-p package))
      (package-install package)))

(setq custom-file (concat user-emacs-directory "config/custom/custom.el"))
(load custom-file)

(when (or (eq system-type 'darwin) (eq system-type 'gnu/linux))
  (require 'exec-path-from-shell)
  (exec-path-from-shell-initialize)
  )

(require 'yasnippet)
(yas-global-mode 1)

(require 'uniquify)

(require 'epa-file)
(epa-file-enable)

(require 'org)

(load "custom/indentation")
(load "custom/theme")
(load "custom/keymap")
(load "custom/project")
(load "custom/recentf")
(load "custom/tramp")
(load "custom/markdown")
(load "custom/lsp")
(load "custom/hook")
(load "custom/lang-modes")
