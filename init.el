;;; init.el --- Emacs configuration

(use-package emacs
    :init
    (setq custom-file (concat user-emacs-directory "config/custom.el"))
    (load custom-file)
    (setq gc-cons-threshold 100000000)
    (setq read-process-output-max (* 1024 1024))
    (setq inhibit-startup-message t)
    (setq initial-scratch-message nil)
    (if init-file-debug
        (setq use-package-verbose t
            use-package-expand-minimally nil
            use-package-compute-statistics t
            debug-on-error t)
    (setq use-package-verbose nil
            use-package-expand-minimally t))

    (setq package-archives
        '(("gnu" . "https://elpa.gnu.org/packages/")
            ("melpa" . "https://melpa.org/packages/")
            ("org" . "http://orgmode.org/elpa/")))

    (setq package-archive-priorities
        '(("gnu" . 3)
            ("melpa" . 2)
            ("org" . 1)))

    :custom
    (use-short-answers t)
    (make-backup-files nil)
    (scroll-step 1)
    (major-mode 'text-mode)
    (kill-whole-line t)
    (vc-follow-symlinks nil)
    (show-paren-delay 0)
    (tab-width 4)
    (tab-stop-list (number-sequence 4 120 4))

    :config
    (menu-bar-mode -1)
    (tool-bar-mode -1)
    (scroll-bar-mode -1)
    (tooltip-mode -1)
    (prefer-coding-system 'utf-8)
    (line-number-mode 1)
    (column-number-mode 1)
    (show-paren-mode 1)
    (electric-pair-mode 1)
    (indent-tabs-mode nil)

    (defalias 'yes-or-no-p 'y-or-n-p)
    (set-default 'truncate-partial-width-windows nil)
    (set-default 'truncate-lines t)
    (put 'downcase-region 'disabled nil)
    (put 'upcase-region 'disabled nil)

    (defvar local-default-font nil)

    (setq local-default-font
        (cond ((eq system-type 'windows-nt) '(:family "Consolas" :height 160))
                ((eq system-type 'gnu/linux)  '(:family "JetBrainsMonoNL Nerd Font Mono" :height 170))
                (t nil)))

    (when (eq system-type 'darwin)
    (setq mac-command-modifier 'meta)
    (setq mac-option-modifier 'super)
    (setq local-default-font '(:family "JetBrainsMonoNL Nerd Font Mono" :height 170))
    (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
    (add-to-list 'default-frame-alist '(ns-appearance . dark)))

    (when window-system
    (set-frame-size (selected-frame) 110 50))

    (when local-default-font
    (apply #'set-face-attribute 'default nil local-default-font)
    (let ((font-str (format "%s-%d"
                            (plist-get local-default-font :family)
                            (/ (plist-get local-default-font :height) 10))))
        (add-to-list 'initial-frame-alist `(font . ,font-str))
        (add-to-list 'default-frame-alist `(font . ,font-str))))
	(setq tab-always-indent 'complete)

    :hook
    (before-save-hook . delete-trailing-whitespace)
    ; (emacs-lisp-mode-hook . enable-paredit-mode)

    :bind
    (("RET" . newline-and-indent)
     ("C-c f" . recentf-open-files)
     ("C-c r" . revert-buffer)
     ("<C-tab>" . buffer-menu)))

; (when (or (eq system-type 'darwin) (eq system-type 'gnu/linux))
;   (use-package exec-path-from-shell
;     :ensure t
;
;     :config
;     (exec-path-from-shell-initialize)))
;
(defun python-venv-autoload ()
  "Automatically activates pyvenv version if .venv directory exists."
  (f-traverse-upwards
   (lambda (path)
     (let ((venv-path (f-expand ".venv" path)))
       (if (f-exists? venv-path)
           (progn
             (pyvenv-activate venv-path))
             ;;(setq python-shell-virtualenv-root venv-path))
             t)))))

(use-package projectile
  :ensure t

  :init
  (projectile-mode t)

  :config
  (setq projectile-project-search-path '(("~/dev/src/" . 3)))

  :bind
  (("C-c C-p" . projectile-command-map))

  :hook
  (projectile-after-switch-project-hook . python-venv-autoload))

(use-package magit
  :ensure t)

(use-package vertico
  :ensure t

  :init
  (vertico-mode +1)

  :custom
  (vertico-cycle t)
  (vertico-reverse-mode t)

  :bind (:map vertico-map
    ;; Use page-up/down to scroll vertico buffer, like ivy does by default.
    ("<prior>" . 'vertico-scroll-down)
    ("<next>"  . 'vertico-scroll-up)))

(use-package vertico-directory
  :ensure nil

  :after vertico

  :bind (:map vertico-map
    ("DEL" . vertico-directory-delete-char)))

(use-package orderless
  :ensure t

  :custom
  ;; Activate orderless completion
  (completion-styles '(orderless basic))
  ;; Enable partial completion for file wildcard support
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package consult
  :ensure t

  :custom
  ;; Disable preview
  (consult-preview-key nil)

  :bind
  (("C-x b" . 'consult-buffer)    ;; Switch buffer, including recentf and bookmarks
   ("M-l"   . 'consult-git-grep)  ;; Search inside a project
   ("M-y"   . 'consult-yank-pop)  ;; Paste by selecting the kill-ring
   ("M-s"   . 'consult-line)      ;; Search current buffer, like swiper
   ))

(use-package embark
  :ensure t

  :bind
  (("C-."   . embark-act)       ;; Begin the embark process
   ("C-;"   . embark-dwim)      ;; good alternative: M-.
   ("C-h B" . embark-bindings))) ;; alternative for `describe-bindings'

(use-package corfu
  :ensure t

  :init
  (global-corfu-mode)

  :custom
  (corfu-cycle t)
  (corfu-preview-current nil)
  (corfu-min-width 20)
  (corfu-on-exact-match 'insert)
  (corfu-quit-no-match t)
  (corfu-quit-at-boundary t)

  :config
  (setq corfu-popupinfo-delay '(1.25, 0.5))
  (corfu-popupinfo-mode 1))


(use-package pyvenv
  :ensure t

  :defer t)

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

  :custom
  (catppuccin-flavor 'mocha)

  :config
  (load-theme 'catppuccin :no-confirm))

(use-package markdown-mode
  :ensure t

  :defer t

  :custom
  (markdown-italic-underscore t)
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
  :ensure nil

  :mode (("\\.org$". org-mode)))

(use-package tramp
    :ensure nil

    :config
    (setq tramp-default-method "sftp")
    (if (eq system-type 'windows-nt)
        (setq tramp-default-method "plink"))

    (setq tramp-auto-save-directory temporary-file-directory))

(use-package eglot
    :ensure nil

    :config
    (add-to-list 'eglot-server-programs
                '((json-mode js-mode js-ts-mode typescript-ts-mode tsx-ts-mode)
                . ("typescript-language-server" "--stdio")))

    (add-to-list 'eglot-server-programs
                '((python-mode python-ts-mode)
                . ("basedpyright")))

    (add-to-list 'eglot-server-programs
                '((go-mode go-ts-mode)
                . ("gopls")))

    :hook
    (eglot-managed-mode-hook . (lambda ()
                                (flymake-mode 1)
                                (eldoc-mode 1))))

(use-package treesit
  :ensure nil

  :config
  (setq treesit-language-source-alist
   '((bash "https://github.com/tree-sitter/tree-sitter-bash")
     (go "https://github.com/tree-sitter/tree-sitter-go")
     (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
     (json "https://github.com/tree-sitter/tree-sitter-json")
     (python "https://github.com/tree-sitter/tree-sitter-python")
     (toml "https://github.com/tree-sitter/tree-sitter-toml")
     (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
     (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
	 (puppet "https://github.com/smoeding/tree-sitter-puppet")))

    ;; Auto-install missing grammars
    (dolist (lang treesit-language-source-alist)
    (unless (treesit-language-available-p (car lang))
        (treesit-install-language-grammar (car lang))))

    ;; Associate file extensions
    (add-to-list 'auto-mode-alist '("\\.json\\'" . json-ts-mode))
    (add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))
    (add-to-list 'auto-mode-alist '("\\.js\\'" . js-ts-mode))
    (add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
    (add-to-list 'auto-mode-alist '("\\.sh\\.zsh\\'" . bash-ts-mode))
    (add-to-list 'auto-mode-alist '("\\.yml\\.yaml\\'" . yaml-ts-mode))
    (add-to-list 'auto-mode-alist '("\\.py\\'" . python-ts-mode))
    (add-to-list 'auto-mode-alist '("\\.toml\\'" . toml-ts-mode)))

(use-package puppet-ts-mode
  :ensure t

  :defer t

  :config
  (add-to-list 'auto-mode-alist '("\\.pp\\'" . puppet-ts-mode)))
