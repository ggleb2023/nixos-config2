;; early-init.el

(setq inhibit-startup-screen t)
(menu-bar-mode -1)

(setq package-user-dir (expand-file-name "emacs/elpa" (or (getenv "XDG_DATA_HOME") "~/.local/share")))

(setq custom-file (expand-file-name "emacs/custom.el" (or (getenv "XDG_CACHE_HOME") "~/.cache")))
