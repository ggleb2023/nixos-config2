;;;-*- lexical-binding: t; -*-
;; init.el

(setq inhibit-startup-screen-mode t)
(setq inhibit-startup-screen t)

(modify-frame-parameters nil '((undecorated . t)))
(when (fboundp 'menu-bar-mode)   (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode)   (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

(global-set-key (kbd "<f5>") (lambda () (interactive) (load user-init-file)))

;;font

(defun font-exists-p (font) (if (null (x-list-fonts font)) nil t))
(when (window-system)
  (cond ((font-exists-p "Iosevka") (set-frame-font "Iosevka:size=20" t nil))
    ((font-exists-p "Iosevka") (set-frame-font "Iosevka:size=20" nil t))))

(global-display-line-numbers-mode t)
(column-number-mode t)
(setq-default indent-tabs-mode nil)

(setq select-enable-clipboard t)

(when (executable-find "wl-copy")
  (setq interprogram-cut-function
        (lambda (text)
          (let ((process-connection-type nil))
            (call-process "wl-copy" nil nil nil text))))
  (setq interprogram-paste-function
        (lambda ()
          (shell-command-to-string "wl-paste -n"))))

(when (and (not (executable-find "wl-copy")) (executable-find "xclip"))
  (setq interprogram-cut-function
        (lambda (text)
          (let ((process-connection-type nil))
            (call-process "xclip" nil nil nil "-selection" "clipboard" text))))
  (setq interprogram-paste-function
        (lambda ()          (shell-command-to-string "xclip -o -selection clipboard"))))
