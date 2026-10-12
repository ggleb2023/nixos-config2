;; init.el

(setq inhibit-startup-screen-mode t)
(setq inhibit-startup-screen t)
(setq initial-buffer-choice t)(setq initial-buffer-choice (lambda () (dired default-directory) (current-buffer)))

(when (fboundp 'menu-bar-mode)   (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode)   (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

(global-set-key (kbd "<f5>") (lambda () (interactive) (load user-init-file)))

(global-display-line-numbers-mode t)
(column-number-mode t)
(setq-default indent-tabs-mode nil)

;; package thingies

(require 'package)
(setq package-archives '(("gnu"    . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/packages/")
                         ("melpa"  . "https://melpa.org/packages/")))
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

;;theme
(use-package yotsuba-theme
  :vc (:url "https://github.com/Senka07/yotsuba-emacs-theme")
  :config
  (load-theme 'yotsuba t))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("59e54b18c77609cbfa88d1a9b48cb865e175fe1425f453dabec938d179f0ac0d"
     default))
 '(package-selected-packages '(yotsuba-theme))
 '(package-vc-selected-packages
   '((yotsuba-theme :url "https://github.com/Senka07/yotsuba-emacs-theme"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
