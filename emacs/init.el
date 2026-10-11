;; init.el

;; 1. Подключаем репозиторий MELPA для скачивания пакетов
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; 2. Базовые настройки редактора для терминала (emacs-nox)
(global-display-line-numbers-mode t)   ;; Включаем нумерацию строк
(setq-default indent-tabs-mode nil)    ;; Использовать пробелы вместо табуляции по умолчанию
(setq tab-width 4)
(show-paren-mode 1)                    ;; Подсветка парных скобок

;; Включаем поддержку мыши в терминале
(xterm-mouse-mode 1)

;; 3. Пример использования встроенного use-package для установки полезных утилит
;; (Пакеты скачаются автоматически в ~/.local/share/emacs/elpa/ при первом запускe)

(use-package vertico
  :ensure t
  :init
  (vertico-mode 1))                    ;; Вертикальное автодополнение в минибуфере

(use-package marginalia
  :ensure t
  :init
  (marginalia-mode 1))                 ;; Дополнительные описания в минибуфере

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles basic partial-completion)))))
