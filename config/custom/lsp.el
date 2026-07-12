(require 'eglot)

(add-to-list 'eglot-server-programs
             '((json-mode js-mode js-ts-mode typescript-ts-mode tsx-ts-mode)
               . ("typescript-language-server" "--stdio")))

(add-to-list 'eglot-server-programs
             '((python-mode python-ts-mode)
               . ("basedpyright")))

(add-to-list 'eglot-server-programs
             '((go-mode go-ts-mode)
               . ("gopls")))

(add-hook 'eglot-managed-mode-hook
          (lambda ()
            (flymake-mode 1) ;; On-the-fly diagnostics
            (eldoc-mode 1))) ;; Inline docs
