;;; init.el --- Emacs configuration  -*- lexical-binding: t; -*-

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("d91ef4e714f05fff2070da7ca452980999f5361209e679ee988e3c432df24347"
     default))
 '(delete-selection-mode nil)
 '(erc-nick-uniquifier "_")
 '(frame-background-mode 'dark)
 '(package-selected-packages
   '(ace-window acp ansible catppuccin-theme cfrs consult corfu
		cperl-mode csharp-mode dictionary difftastic diminish
		editorconfig eldoc-box elixir-ts-mode embark
		exec-path-from-shell faceup flymake ghostel
		git-timemachine ht hydra less-css-mode lua-mode
		marginalia markdown-mode markdown-ts-mode orderless
		org paredit peg pfuture project-x puppet-ts-mode
		pyvenv rainbow-delimiters rainbow-mode shell-maker
		terraform-ts-mode tramp ultra-scroll verilog-mode
		vertico wallpaper web-mode yasnippet))
 '(package-vc-selected-packages
   '((terraform-ts-mode :url
			"https://codeberg.org/ccbash-oss/terraform-ts-mode")))
 '(uniquify-buffer-name-style 'forward nil (uniquify)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cperl-array-face ((t (:foreground "#dfaf8f" :slant italic))))
 '(cperl-hash-face ((t (:foreground "#ac7373" :slant italic))))
 '(cperl-nonoverridable-face ((t (:foreground "#f0dfaf")))))
