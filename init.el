(add-to-list 'default-frame-alist '(fullscreen . maximized))

(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)            ; Disable the menu bar

;; Set up the visible bell
(setq visible-bell t)
;;emacs creates backup files whenever you save anything with the ending ~. it mucks up the directory and makes finding files harder
;; this is getting rid of that
(setq make-backup-files nil)
;; Theme
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

(evil-define-key 'normal 'global (kbd "C-t") 'other-window)
; switch the following under spc commands
(evil-define-key 'normal 'global (kbd "C-f") 'find-file)
; switch the following under spc commands
(evil-define-key 'normal 'global (kbd "C-r") 'reload-init-file)
(evil-define-key 'normal 'global (kbd "C-w") 'save-buffer)
(evil-define-key 'normal 'global (kbd "C-b") 'previous-buffer)
(evil-define-key 'normal 'global (kbd "C-n") 'next-buffer)
(evil-define-key 'normal 'global (kbd "C-q")
  (lambda ()
    (interactive)
    (when (not (window-minibuffer-p)) ;; Don't kill minibuffer accidentally
      (let ((buffer-read-only nil))  ;; Disable read-only mode
        (kill-buffer-and-window)))))  ;; Kill buffer and close window

(key-chord-define evil-replace-state-map "jj" 'evil-normal-state)
;; key chords for more mapping options

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
;; switching between header and source files
(defun switch-between-header-source ()
  "Switch between header and source files with the same base name in the same directory."
  (interactive)
  (let* ((current-file (buffer-file-name))
         (extension (file-name-extension current-file))
         (base-name (file-name-sans-extension current-file))
         (dir (file-name-directory current-file))
         (counterpart-exts (cond
                            ((string-match-p "\\(c\\|cpp\\|cc\\|cxx\\)" extension) '("h" "hpp" "hh" "hxx"))
                            ((string-match-p "\\(h\\|hpp\\|hh\\|hxx\\)" extension) '("c" "cpp" "cc" "cxx"))
                            (t nil)))  ;; No switch for unsupported extensions
         (counterpart (seq-find (lambda (ext)
                                  (let ((candidate (concat base-name "." ext)))
                                    (file-exists-p (expand-file-name candidate dir))))
                                counterpart-exts)))
    (if counterpart
        (find-file (expand-file-name (concat base-name "." counterpart) dir))
      (message "No corresponding header or source file found."))))
(evil-define-key 'normal 'global (kbd "C-s") 'switch-between-header-source)
;; c++ style guide
(use-package clang-format
  :ensure t
  :hook ((c-mode c++-mode) . (lambda ()
                               (add-hook 'before-save-hook 'clang-format-buffer nil t)))
  :config
  (setq clang-format-style-option "Google"))

;; startup page make it shurukaro
(setq initial-buffer-choice "C:\\Users\\aham\\Workspace\\shurukaro")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(clang-format key-chord evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;;Running build.bat from root.
(defun project-quick-compile()
  "Run build.bat from the root of the project."
  (interactive)
  (let ((default-directory (project-root (project-current t))))
    (compile "cmd.exe /c build.bat")))
(evil-define-key 'normal 'global (kbd "C-a") 'project-quick-compile)
;; open init.el file from anywhere 
(key-chord-define evil-normal-state-map "fh" (lambda () (interactive) (find-file "C:\\Users\\aham\\AppData\\Roaming\\.emacs.d\\init.el")))
;; open task list from anywhere
(key-chord-define evil-normal-state-map "fp" (lambda () (interactive) (find-file "G:\\My Drive\\magistrate\\plan.org")))
