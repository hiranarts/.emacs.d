(add-to-list 'default-frame-alist '(fullscreen . maximized))

(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)            ; Disable the menu bar

;; Set up the visible bell
(setq visible-bell t)

(load-theme 'wombat)
;;Functions 
;easy init reload
(defun reload-init-file ()
  "Reload the Emacs init file."
  (interactive)
  (load-file user-init-file))
;easy init open
(defun open-init-file ()
  "Open the Emacs init file in a new buffer."
  (interactive)
  (find-file user-init-file))

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;;number
(column-number-mode)
(global-display-line-numbers-mode t)

;; Download Evil
(unless (package-installed-p 'evil)
  (package-install 'evil))
;; Download keychord
(unless (package-installed-p 'key-chord)
  (package-install 'key-chord))
;; project files
(require 'project)
(defun my-project-current ()
  "Show the current project root directory in the minibuffer."
  (interactive)
  (let ((project (project-current)))
    (if project
        (message "Current project root: %s" (project-root project))
      (message "No project found."))))

;; Enable Evil
(require 'evil)
(evil-mode 1)
;; define evil keys, since i want both hands to access the key. i will set it to ctrl
;;key chord will make creating custom mappings a lot easier
(require 'key-chord)
(key-chord-mode 1)
(evil-define-key 'normal 'global (kbd "C-f") 'find-file)
(evil-define-key 'normal 'global (kbd "C-r") 'reload-init-file)
(evil-define-key 'normal 'global (kbd "C-w") 'save-buffer)
(evil-define-key 'normal 'global (kbd "C-b") 'previous-buffer)
(evil-define-key 'normal 'global (kbd "C-n") 'next-buffer)
;;(key-chord-define evil-replace-state-map "jj" 'evil-normal-state)
;; org shit
(setq org-directory "G:\\My Drive\\magistrate\\")  
(setq org-default-notes-file (expand-file-name "tasks.org" org-directory))
(setq org-agenda-files (list (expand-file-name "tasks.org" org-directory)))
(setq org-todo-keywords
      '((sequence "TODO" "IN-PROGRESS" "WAITING" "DONE")))
(setq org-capture-templates
      '(("t" "Todo" entry
         (file+headline org-default-notes-file "Tasks")
         "* TODO %?\n  %u\n  %a")
        ("n" "Note" entry
         (file+headline org-default-notes-file "Notes")
         "* %?\n  %u\n  %a")))
;; TODO change this keybinding to make it consistent with everything else
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)
;; startup page make it shurukaro
