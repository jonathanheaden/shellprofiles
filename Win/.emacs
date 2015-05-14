(show-paren-mode 1)
(setq inhibit-splash-screen t)
(load-theme 'tango-dark t)
(global-linum-mode t)
(set-default-font "Verdana-12")

;; http://www.emacswiki.org/emacs/PowerShell-Mode.el
(add-to-list 'load-path  "~/.emacs.d/plugins/")

;; powershell-mode
(autoload 'powershell-mode "powershell-mode" "edit mode for PowerShell." t)
(add-to-list 'auto-mode-alist '("\\.ps1\\'" . powershell-mode))

;; autoload powershell interactive shell
(autoload 'powershell "powershell" "Start a interactive shell of PowerShell." t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (misterioso)))
 '(tool-bar-mode nil))

;disable backup
(setq backup-inhibited t)

;disable auto save
(setq auto-save-default nil)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(defvar current-date-time-format "%a %b %d %H:%M:%S %Z %Y"
  "Format of date to insert with `insert-current-date-time' func
See help of `format-time-string' for possible replacements")

(defvar current-time-format "%a %H:%M:%S"
  "Format of date to insert with `insert-current-time' func.
Note the weekly scope of the command's precision.")

(defun insert-current-date-time ()
  "insert the current date and time into current buffer.
Uses `current-date-time-format' for the formatting the date/time."
       (interactive)
       (insert "* ")
;       (insert (let () (comment-start)))
       (insert (format-time-string current-date-time-format (current-time)))
       (insert "\n")
       )

(defun insert-current-time ()
  "insert the current time (1-week scope) into the current buffer."
       (interactive)
       (insert (format-time-string current-time-format (current-time)))
       )

(global-set-key (kbd "<f5>") 'insert-current-date-time)
(global-set-key (kbd "<f6>") 'insert-current-time)

;; Org Mode Setup
(add-to-list 'load-path (expand-file-name "/40-49 Orora/44 Knowledge/44.50 Org Mode Lisp"))
(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|txt\\)$" . org-mode))
(require 'org)
;; standard key bindings
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(global-set-key (kbd "<f12>") 'org-agenda)
(global-set-key (kbd "<f7>") 'bh/org-todo)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "<f11>") 'org-clock-goto)
(global-set-key (kbd "C-<f11>") 'org-clock-in)
