;; init.el

(inhibit-startup-screen-mode t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(global-display-line-numbers-mode t)
(column-number-mode t)
(setq-default indent-tabs-mode nil)

(global-set-key (kbd "<f5>") (lambda () (interactive) (load user-init-file)))
