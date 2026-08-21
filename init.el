;;; init.el --- Emacs configuration
;; Reference: https://github.com/bbatsov/emacs.d/blob/master/init.el

(setq custom-file (concat user-emacs-directory "config/custom.el"))

(load custom-file)

(setq read-process-output-max (* 1024 1024))

(setq inhibit-startup-message t)

(setq use-package-always-ensure t
	  use-package-verbose t
      use-package-expand-minimally nil
      use-package-compute-statistics t
      debug-on-error nil)

(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")
        ("org" . "http://orgmode.org/elpa/")))

(setq package-archive-priorities
      '(("gnu" . 3)
        ("melpa" . 2)
        ("org" . 1)))

(setq major-mode 'text-mode)

(setq ring-bell-function 'ignore)

(setq use-short-answers t)

(setq make-backup-files nil
	  auto-save-default nil)

;; nice scrolling
(setq scroll-margin 0 ; ultra-scroll requires 0 for glitch-free scrolling
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

(set-default 'truncate-partial-width-windows nil)
(set-default 'truncate-lines t)

(setq kill-whole-line t)
(setq vc-follow-symlinks nil)
(setq show-paren-delay 0)
(setq read-extended-command-predicate #'command-completion-default-include-p)

;; indent configuration
(setq tab-width 4
	  c-basic-offset 4
	  yaml-basic-offset 4
	  tab-stop-list (number-sequence 4 120 4)
	  tab-always-indent 'complete)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(line-number-mode 1)
(column-number-mode 1)

(tooltip-mode -1)

(prefer-coding-system 'utf-8)
(show-paren-mode 1)
(indent-tabs-mode nil)
(blink-cursor-mode -1)

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
  (set-frame-size (selected-frame) 110 45))

(when local-default-font
  (apply #'set-face-attribute 'default nil local-default-font)
  (let ((font-str (format "%s-%d"
                          (plist-get local-default-font :family)
                          (/ (plist-get local-default-font :height) 10))))
    (add-to-list 'initial-frame-alist `(font . ,font-str))
    (add-to-list 'default-frame-alist `(font . ,font-str))))

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(global-set-key (kbd "RET") 'newline-and-indent)

(global-set-key (kbd "<C-tab>") 'buffer-menu)

(defun gds/find-projects (start-dir dir-list max-depth)
  "Scan START-DIR for project roots and remember them with `project.el'.
Descend up to MAX-DEPTH levels below START-DIR. A directory is a project
root when it contains any entry named in DIR-LIST (e.g. \\='(\".git\")).
Matched directories are registered via `project-remember-project'; the
search keeps descending into them so nested projects are also found."
  (when (> max-depth 0)
    (dolist (entry (directory-files start-dir t directory-files-no-dot-files-regexp))
      (when (file-directory-p entry)
        (when (seq-some (lambda (marker) (file-exists-p (expand-file-name marker entry))) dir-list)
          (when-let ((pr (project-current nil entry)))
            (project-remember-project pr)))
        (gds/find-projects entry dir-list (1- max-depth))))))

;;
;; external packages
;;
(use-package diminish
  :config
  (diminish 'abbrev-mode)
  (diminish 'eldoc-mode))

(use-package ultra-scroll
  :config
  (ultra-scroll-mode +1))

(setq package-install-upgrade-built-in t)
(use-package transient)

(use-package compat)

(use-package project-x
  :after project

  :config
  (setq project-x-auto-save-delay 10) ; nil to disable autosave
  (setq project-prompter #'project-x--project-prompt)
  (setq project-x-save-extra-buffers 1)
  (project-x-mode 1))

(use-package magit
  :bind (("C-x g" . magit-status)))

(use-package vertico
  :init (vertico-mode +1)

  :custom
  (vertico-cycle t)
  (vertico-reverse-mode t)

  :bind (:map vertico-map
			  ;; Use page-up/down to scroll vertico buffer, like ivy does by default.
			  ("<prior>" . 'vertico-scroll-down)
			  ("<next>"  . 'vertico-scroll-up)))

;; part of vertico
(use-package vertico-directory
  :ensure nil

  :after vertico

  :bind (:map vertico-map
			  ("DEL" . vertico-directory-delete-char)))

(use-package orderless
  :custom
  ;; Activate orderless completion
  (completion-styles '(orderless basic))
  ;; Enable partial completion for file wildcard support
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil))

(use-package consult
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
  :bind
  (("C-."   . embark-act)       ;; Begin the embark process
   ("C-;"   . embark-dwim)      ;; good alternative: M-.
   ("C-h B" . embark-bindings))) ;; alternative for `describe-bindings'

(use-package corfu
  :init
  (global-corfu-mode)

  :custom
  (corfu-auto t)
  (corfu-cycle t)
  (corfu-preview-current nil)
  (corfu-min-width 20)
  (corfu-on-exact-match 'insert)
  (corfu-quit-no-match t)
  (corfu-quit-at-boundary t)

  :config
  (setq corfu-popupinfo-delay '(1.25, 0.5))
  (corfu-popupinfo-mode 1))

(use-package eldoc-box)

(use-package yasnippet
  :config
  (yas-global-mode 1))

(use-package catppuccin-theme
  :custom
  (catppuccin-flavor 'macchiato)

  :config
  (load-theme 'catppuccin :no-confirm))

(use-package markdown-mode
  :defer t

  :custom
  (markdown-italic-underscore t)
  (markdown-asymmetric-header t))

(use-package web-mode
  :defer t

  :mode
  (("\\.phtml\\'" . web-mode)
   ("\\.tpl\\'" . web-mode)
   ("\\.php\\'" . web-mode)
   ("\\.[agj]sp\\'" . web-mode)
   ("\\.as[cp]x\\'" . web-mode)
   ("\\.erb\\'" . web-mode)
   ("\\.mustache\\'" . web-mode)
   ("\\.djhtml\\'" . web-mode)))

(use-package ghostel
  :defer t

  :bind (("C-x m" . ghostel)
         :map ghostel-semi-char-mode-map
         ("C-s"  . consult-line)
         ("C-k"  . gds/ghostel-send-C-k-and-kill)
         :map project-prefix-map
         ("m" . ghostel-project)
         ("M" . ghostel-project-list-buffers))
  :config
  (defun gds/ghostel-send-C-k-and-kill ()
    "Send `C-k' to ghostel.
Like normal Emacs `C-k'.  Kill to end of line and put content in kill-ring."
    (interactive)
    (kill-ring-save (point) (line-end-position))
    (ghostel-send-key "k" "ctrl"))

  (add-to-list 'project-switch-commands '(ghostel-project "Ghostel") t)
  (add-to-list 'project-switch-commands '(ghostel-project-list-buffers "Ghostel buffers") t)
  (add-to-list 'ghostel-eval-cmds '("magit-status-setup-buffer" magit-status-setup-buffer)))

(use-package org
  :ensure nil

  :mode (("\\.org$". org-mode)))

(use-package tramp
  :ensure nil

  :config
  (setq tramp-default-method "ssh")
  (if (eq system-type 'windows-nt)
      (tramp-default-method "plink"))

  (setq tramp-auto-save-directory temporary-file-directory))


(use-package treesit
  :ensure nil

  :config
  (setq treesit-language-source-alist
		'((bash "https://github.com/tree-sitter/tree-sitter-bash")
		  (go "https://github.com/tree-sitter/tree-sitter-go")
		  (javascript "https://github.com/tree-sitter/tree-sitter-javascript")
		  (json "https://github.com/tree-sitter/tree-sitter-json")
		  (yaml "https://github.com/tree-sitter-grammars/tree-sitter-yaml")
		  (python "https://github.com/tree-sitter/tree-sitter-python")
		  (toml "https://github.com/tree-sitter/tree-sitter-toml")
		  (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "v0.23.2" "tsx/src")
		  (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "v0.23.2" "typescript/src")
		  (hcl "https://github.com/tree-sitter-grammars/tree-sitter-hcl")
		  (terraform "https://github.com/tree-sitter-grammars/tree-sitter-hcl")
		  (puppet "https://github.com/smoeding/tree-sitter-puppet")))

  ;; Auto-install missing grammars
  (dolist (lang treesit-language-source-alist)
    (unless (treesit-language-available-p (car lang))
      (treesit-install-language-grammar (car lang))))

  :mode
  (("\\.json\\'" . json-ts-mode)
   ("\\.ts\\'" . typescript-ts-mode)
   ("\\.js\\'" . js-ts-mode)
   ("\\.tsx\\'" . tsx-ts-mode)
   ("\\.z?sh\\'" . bash-ts-mode)
   ("\\.ya?ml\\'" . yaml-ts-mode)
   ("\\.py\\'" . python-ts-mode)
   ("\\.toml\\'" . toml-ts-mode)
   ("\\.go\\'". go-ts-mode)))

(use-package puppet-ts-mode
  :defer t

  :mode
  (("\\.pp\\'" . puppet-ts-mode)))

(use-package terraform-ts-mode
  :vc (:url "https://codeberg.org/ccbash-oss/terraform-ts-mode"
       :rev :newest)

  :defer t

  :mode
  (("\\.tf\\'" . terraform-ts-mode)
   ("\\.hcl\\'" . terraform-ts-mode)))

(use-package ansible
  :defer t)

(use-package git-timemachine
  :bind (("C-c g" . git-timemachine)
         ("s-g" . git-timemachine)))

(use-package difftastic-bindings
  :ensure difftastic
  :config
  (difftastic-bindings-mode +1))

(use-package paredit
  :hook ((emacs-lisp-mode
          lisp-interaction-mode
          ielm-mode
          lisp-mode
          eval-expression-minibuffer-setup) . paredit-mode)
  :config
  ;; paredit steals RET for auto-newline-and-indent, which is annoying
  (define-key paredit-mode-map (kbd "RET") nil)
  (add-hook 'paredit-mode-hook (lambda () (electric-pair-local-mode -1)))
  (diminish 'paredit-mode "()"))

(use-package exec-path-from-shell
  :config
  ;; only needed for GUI Emacs on macOS, where the shell env isn't inherited
  (when (memq window-system '(mac ns))
    (exec-path-from-shell-initialize)))

(use-package rainbow-delimiters
  :defer t)

(use-package rainbow-mode
  :hook prog-mode
  :config
  (diminish 'rainbow-mode))

;;
;; built-in packages
;;
(use-package paren
  :ensure nil
  :config
  (show-paren-mode +1)
  ;; show matching paren context when it's offscreen
  (setq show-paren-context-when-offscreen 'overlay))

(use-package elec-pair
  :config
  (electric-pair-mode +1))

(use-package project
  :ensure nil

  :config
  (gds/find-projects (expand-file-name "~/dev/src") '(".git") 3))

(use-package time
  :ensure nil
  :defer t
  :config
  ;; TZs to display with `world-clock'
  (setq world-clock-list
        '(("America/Los_Angeles" "Seattle")
          ("America/New_York" "New York")
          ("America/Sao_Paulo" "Sao Paulo")
          ("Europe/London" "London")
          ("Europe/Paris" "Paris"))))

(use-package hl-line
  :ensure nil
  :config
  (global-hl-line-mode +1))

(use-package savehist
  :ensure nil
  :init
  (savehist-mode))

(use-package recentf
  :ensure nil
  :config
  (setq recentf-max-saved-items 50
        recentf-max-menu-items 5
        recentf-auto-cleanup 'never)
  (recentf-mode +1))

(use-package dired
  :ensure nil
  :defer t
  :config
  ;; dired - reuse current buffer by pressing 'a'
  (put 'dired-find-alternate-file 'disabled nil)

  ;; always delete and copy recursively
  (setq dired-recursive-deletes 'always)
  (setq dired-recursive-copies 'always)

  ;; if there is a dired buffer displayed in the next window, use its
  ;; current subdir, instead of the current subdir of this dired buffer
  (setq dired-dwim-target t)

  ;; drag files from dired to other apps
  (setq dired-mouse-drag-files t)

  ;; enable some really cool extensions like C-x C-j(dired-jump)
  (require 'dired-x))

(use-package which-key
  :ensure nil
  :config
  (which-key-mode +1))

(use-package ediff
  :ensure nil
  :defer t
  :config
  ;; keep the control panel in the same frame instead of a separate one
  (setq ediff-window-setup-function #'ediff-setup-windows-plain)
  ;; diff side by side, not stacked
  (setq ediff-split-window-function #'split-window-horizontally))

(use-package editorconfig
  :ensure nil
  :config
  (editorconfig-mode +1)
  (diminish 'editorconfig-mode))

(use-package flymake
  :ensure nil

  :bind
  (("M-n" . 'flymake-goto-next-error)
   ("M-p" . 'flymake-goto-prev-error)))

(use-package eglot
  :ensure nil

  :config
  (add-to-list 'eglot-server-programs
               '((python-mode python-ts-mode)
                 . ("basedpyright-langserver" "--stdio")))

  (add-to-list 'eglot-server-programs
               '((go-mode go-ts-mode)
                 . ("gopls")))

  (add-to-list 'eglot-server-programs
               '((yaml-mode yaml-ts-mode)
                 . ("yaml-language-server" "--stdio")))

  (add-to-list 'eglot-server-programs
               '((json-mode json-ts-mode)
                 . ("vscode-json-languageserver" "--stdio")))

  (add-to-list 'eglot-server-programs
               '((js-mode js-ts-mode typescript-ts-mode tsx-ts-mode)
                 . ("typescript-language-server" "--stdio")))

  (add-to-list 'eglot-server-programs
               '((terraform-ts-mode terraform-mode hcl-mode) . ("terraform-ls" "serve")))

  (add-to-list 'eglot-server-programs
               '(ansible-mode . ("ansible-language-server" "--stdio")))

  :hook
  (eglot-managed-mode-hook . (lambda ()
                               (flymake-mode 1)
                               (eldoc-mode 1)))
  (prog-mode . eglot-ensure))
