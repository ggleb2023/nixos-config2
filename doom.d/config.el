;;;-*- lexical-binding: t; -*-
;; init.el

(let ((local-config
       (expand-file-name "config-local.el" doom-data-dir)))
  (when (file-exists-p local-config)
    (load local-config nil 'nomessage)))
