(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
			 
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))


(defvar myPackages
  '(better-defaults                 ;; Set up some better Emacs defaults
	auto-complete					;; Autocomplete package
	evil
	company
	company-jedi
	epc
	jedi
    material-theme                  ;; Theme
	py-autopep8                     ;; Run autopep8 on save
	magit                           ;; Git integration
	neotree							;; file/directory viewer
	doom-modeline					;; doom modeline
	projectile						;; projectile
	atom-one-dark-theme				;; Atom one dark theme
	org-roam
	lsp-mode
	lsp-java
    )
  )
  


;; Scans the list in myPackages
;; If the package listed is not already installed, install it
(mapc #'(lambda (package)
          (unless (package-installed-p package)
            (package-install package)))
      myPackages)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("171d1ae90e46978eb9c342be6658d937a83aaa45997b1d7af7657546cae5985b" default))
 '(package-selected-packages
   '(org-roam auto-complete-c-headers all-the-icons-dired all-the-icons py-autopep8 solarized-theme evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Fira Code Retina" :foundry "outline" :slant normal :weight normal :height 108 :width normal))))
 '(scroll-bar ((t (:background "midnight blue" :foreground "navy")))))
(require 'evil)
(evil-mode 1)
(load-theme 'atom-one-dark t)

(setq x-underline-at-descent-line t)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(define-key evil-insert-state-map (kbd "TAB") 'tab-to-tab-stop)
(defun my-generate-tab-stops (&optional width max)
  "Return a sequence suitable for `tab-stop-list'."
  (let* ((max-column (or max 200))
         (tab-width (or width tab-width))
         (count (/ max-column tab-width)))
    (number-sequence tab-width (* tab-width count) tab-width)))

(setq tab-width 4)
(setq tab-stop-list (my-generate-tab-stops))

;; Start maximised (cross-platf)
(add-hook 'window-setup-hook 'toggle-frame-maximized t)

(tool-bar-mode -1)
(menu-bar-mode -1)

(split-window-horizontally)

(setq inhibit-startup-screen t)
(global-linum-mode t)


;;(neotree-show)

 (add-hook 'neotree-mode-hook
              (lambda ()
                (define-key evil-normal-state-local-map (kbd "TAB") 'neotree-enter)
                (define-key evil-normal-state-local-map (kbd "SPC") 'neotree-quick-look)
                (define-key evil-normal-state-local-map (kbd "q") 'neotree-hide)
                (define-key evil-normal-state-local-map (kbd "RET") 'neotree-enter)
                (define-key evil-normal-state-local-map (kbd "g") 'neotree-refresh)
                (define-key evil-normal-state-local-map (kbd "n") 'neotree-next-line)
                (define-key evil-normal-state-local-map (kbd "p") 'neotree-previous-line)
                (define-key evil-normal-state-local-map (kbd "A") 'neotree-stretch-toggle)
                (define-key evil-normal-state-local-map (kbd "H") 'neotree-hidden-file-toggle)))
			
(setq inhibit-compacting-font-caches t)

(require 'doom-modeline)
(doom-modeline-mode 1)

(setq doom-modeline-height 18)

;; How wide the mode-line bar should be. It's only respected in GUI.
(setq doom-modeline-bar-width 4)

;; Or use this
;; Use `window-setup-hook' if the right segment is displayed incorrectly
(add-hook 'after-init-hook #'doom-modeline-mode)

; no screwing with my middle mouse button
(global-unset-key [mouse-2])

; Bright-red TODOs
 (setq fixme-modes '(c++-mode c-mode emacs-lisp-mode))
 (make-face 'font-lock-fixme-face)
 (make-face 'font-lock-study-face)
 (make-face 'font-lock-important-face)
 (make-face 'font-lock-note-face)
 (mapc (lambda (mode)
	 (font-lock-add-keywords
	  mode
	  '(("\\<\\(TODO\\)" 1 'font-lock-fixme-face t)
	    ("\\<\\(STUDY\\)" 1 'font-lock-study-face t)
	    ("\\<\\(IMPORTANT\\)" 1 'font-lock-important-face t)
            ("\\<\\(NOTE\\)" 1 'font-lock-note-face t))))
	fixme-modes)
 (modify-face 'font-lock-fixme-face "Red" nil nil t nil t nil nil)
 (modify-face 'font-lock-study-face "Yellow" nil nil t nil t nil nil)
 (modify-face 'font-lock-important-face "Yellow" nil nil t nil t nil nil)
 (modify-face 'font-lock-note-face "Dark Green" nil nil t nil t nil nil)


(setq auto-mode-alist
      (append
       '(("\\.cpp$"    . c++-mode)
         ("\\.hin$"    . c++-mode)
         ("\\.cin$"    . c++-mode)
         ("\\.inl$"    . c++-mode)
         ("\\.rdc$"    . c++-mode)
         ("\\.h$"    . c++-mode)
         ("\\.c$"   . c++-mode)
         ("\\.cc$"   . c++-mode)
         ("\\.c8$"   . c++-mode)
         ("\\.txt$" . indented-text-mode)
         ("\\.emacs$" . emacs-lisp-mode)
         ("\\.gen$" . gen-mode)
         ("\\.ms$" . fundamental-mode)
         ("\\.m$" . objc-mode)
         ("\\.mm$" . objc-mode)
         ) auto-mode-alist))
		 

; Additional style stuff
(c-set-offset 'member-init-intro '++)

(setq c-hanging-semi&comma-criteria '((lambda () 'stop)))

; Handle super-tabbify (TAB completes, shift-TAB actually tabs)
(setq dabbrev-case-replace t)
(setq dabbrev-case-fold-search t)
(setq dabbrev-upcase-means-case-search t)

(global-hl-line-mode 1)
(set-face-background 'hl-line "midnight blue")

(setq compilation-directory-locked nil)
(scroll-bar-mode -1)
(setq shift-select-mode nil)
(setq enable-local-variables nil)

; Abbrevation expansion
(abbrev-mode 1)

(add-to-list 'default-frame-alist '(font . "Liberation Mono-11.5"))
(set-face-attribute 'default t :font "Liberation Mono-11.5")
(set-face-attribute 'font-lock-builtin-face nil :foreground "#DAB98F")
(set-face-attribute 'font-lock-comment-face nil :foreground "gray50")
(set-face-attribute 'font-lock-constant-face nil :foreground "olive drab")
(set-face-attribute 'font-lock-doc-face nil :foreground "gray50")
(set-face-attribute 'font-lock-function-name-face nil :foreground "burlywood3")
(set-face-attribute 'font-lock-keyword-face nil :foreground "DarkGoldenrod3")
(set-face-attribute 'font-lock-string-face nil :foreground "olive drab")
(set-face-attribute 'font-lock-type-face nil :foreground "burlywood3")
(set-face-attribute 'font-lock-variable-name-face nil :foreground "burlywood3")
(defun post-load-stuff ()
  (interactive)
  ;(set-foreground-color "burlywood3")
  ;(set-background-color "#161616")
  (set-cursor-color "#40FF40")
)
(add-hook 'window-setup-hook 'post-load-stuff t)

(setq projectile-project-search-path '("D:/Projects"))

(setq projectile-switch-project-action 'neotree-projectile-action)
(global-whitespace-mode -1)

(add-hook 'dired-mode-hook
  (lambda () (setq-local whitespace-style nil)))


(setq make-backup-files nil)

(add-hook 'elpy-mode-hook (lambda () (highlight-indentation-mode -1)))

(setq-default buffer-file-coding-system 'utf-8-unix)

(set-terminal-coding-system 'utf-8)
(set-language-environment 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)

(defun run-bash ()
      (interactive)
      (let ((shell-file-name "C:\\Program Files\\Git\\bin\\bash.exe"))
            (shell "*bash*")))
			
(defun run-powershell ()
  "Run powershell"
  (interactive)
  (async-shell-command "c:/windows/system32/WindowsPowerShell/v1.0/powershell.exe -Command -"
               nil
               nil))


(setenv  "PATH" (concat

                ;; "c:/Windows/System32" ";" 

                 "c:/Windows/Microsoft.NET/Framework/v4.0.30319" ";"

                 "C:\\Windows\\Microsoft.NET\\Framework\\v4.0.30319" ";"

                 ;; Unix tools 
                 "C:\\Program Files\\Git\\usr\\bin" ";"

                 ;; User binary files 
                 "C:\\User\\arch\\bin" ";"

                 ;; Mono Installation.
                 "c:\\Program Files\\Mono\\bin" ";"

                 "c:\\Program Files\\Mono\\lib\\mono\\4.5" ";"

                 (getenv "PATH")

         ))
		 

(ac-config-default)
(add-hook 'python-mode-hook 'jedi:setup)
(add-hook 'python-mode-hook 'jedi:ac-setup)
(setq jedi:complete-on-dot t)  
(setq jedi:setup-keys t)


(defun pyc ()
  "Use compile to run python programs"
  (interactive)
  (compile (concat "python " (buffer-name))))
(setq compilation-scroll-output t)

;; Add commands to python mode
(add-hook 'python-mode-hook (lambda ()
 (local-set-key "\M-m" 'pyc)))

;; (global-set-key "\M-m" 'pyc)
(global-set-key [f8] 'neotree-toggle)
(global-auto-complete-mode t)
(add-hook 'after-init-hook 'global-company-mode)

(defun fix-c-indent-offset-according-to-syntax-context (key val)
  ;; remove the old element
  (setq c-offsets-alist (delq (assoc key c-offsets-alist) c-offsets-alist))
  ;; new value
  (add-to-list 'c-offsets-alist (cons key val)))

(defun my-c-mode-common-hook ()
 ;; my customizations for all of c-mode, c++-mode, objc-mode, java-mode
 (c-set-offset 'substatement-open 0)
 ;; other customizations can go here

 (setq c++-tab-always-indent t)
 (setq c-basic-offset 4)                  ;; Default is 2
 (setq c-indent-level 4)                  ;; Default is 2

 (setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60))
 (setq tab-width 4)
 (setq indent-tabs-mode nil)  ; use spaces only if nil
 )

(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

(add-hook 'java-mode-hook #'lsp)
