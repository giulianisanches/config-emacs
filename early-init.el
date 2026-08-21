;; Reference: https://github.com/bbatsov/emacs.d/blob/master/early-init.el
;; with some small personal preferences ( i still need to understand what other configurations
;; i can move here)

(setq gc-cons-threshold most-positive-fixnum)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 50 1000 1000)
                  gc-cons-percentage 0.2)))

;; the toolbar is just a waste of valuable screen estate; disabling it
;; via frame parameters here means the initial frame is never created
;; with one (calling tool-bar-mode later forces a frame resize)
(push '(tool-bar-lines . 0) default-frame-alist)

;; don't resize the frame in response to font/UI changes during
;; startup - it's expensive and pointless before the frame is visible
(setq frame-inhibit-implied-resize t)

;; native-compile packages when they are installed, instead of
;; stalling when they get loaded for the first time
(setq package-native-compile t)

;; GUI Emacs on macOS doesn't inherit the environment from the shell,
;; so without LANG it ends up in the "C" locale, which breaks things
;; like spell-checking dictionaries and subprocess sorting
(when (and (eq system-type 'darwin) (not (getenv "LANG")))
  (setenv "LANG" "en_US.UTF-8"))
