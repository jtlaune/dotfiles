;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(require 'package)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(package-initialize)

;; get rid of the annoying custom code in .emacs
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

(use-package flucui-themes
  :ensure t)
;(flucui-themes-load-style 'light)
(use-package color-theme-sanityinc-tomorrow
  :ensure t)
(color-theme-sanityinc-tomorrow-night)

(set-default-font "Envy Code R 12")

;; global keybindings
(global-set-key (kbd "M-o") 'ace-window)
(global-set-key (kbd "M-r") 'isearch-backward-regexp)
(global-set-key (kbd "M-s") 'isearch-forward-regexp)
(global-set-key (kbd "M-l") 'linum-mode)
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c s s") 'org-download-screenshot)
(global-set-key (kbd "C-c C-y") 'term-paste)
(global-set-key (kbd "C-c l") 'org-store-link)

;; bigger initial size
;(add-to-list 'initial-frame-alist '(height . 30))
;(add-to-list 'initial-frame-alist '(width . 100))
;(setq frame-resize-pixelwise t)

;; central save files
(setq backup-directory-alist `(("." . "~/.saves")))

;; Fuck outta here with those bars
(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)

;; give me my nice margins
;;(set-frame-parameter nil 'internal-border-width 12)
(add-to-list 'default-frame-alist '(internal-border-width . 12))

;; gimme some nice windows pls
(setq-default
 inhibit-startup-screen t
 initial-scratch-message ";; Happy Hacking!!"
 left-margin-width 1 right-margin-width 1     ; Add left and right margins
 select-enable-clipboard t       ; Merge system's and Emacs' clipboard
 cursor-type '(bar . 5)          ; set cursor type to bar
 line-spacing 4)                 ; line spacing

;; mu4e
;; don't use use-package because it comes with mail-utils package
(require 'mu4e)
;;(setq mu4e-contexts
;; `( ,(make-mu4e-context
;;     :name "Gmail"
;;     :match-func (lambda (msg) (when msg
;;       (string-prefix-p "/Gmail" (mu4e-message-field msg :maildir))))
;;     :vars '(
;;       (mu4e-trash-folder . "/Gmail/[Gmail].Trash")
;;       (mu4e-refile-folder . "/Gmail/[Gmail].Archive")
;;       ))
;;   ))
(setq mu4e-mailfolder "/home/jtlaune/Maildir"
      mu4e-trash-folder "/Gmail/[Gmail].Trash"
      mu4e-sent-folder "/Gmail/[Gmail].Sent Mail"
      ;; mu4e-sent-messages-behavior 'delete ;; Unsure how this should be configured
      mu4e-drafts-folder "/Gmail/[Gmail].Drafts"
      mu4e-refile-folder "/Gmail/Archive")
;; SMTP settings
;; I have my "default" parameters from Gmail
(setq user-mail-address "jtlaune@gmail.com"
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587)

;; Now I set a list of 
(defvar my-mu4e-account-alist
  '(("Gmail"
     (user-mail-address "jtlaune@gmail.com")
     (smtpmail-smtp-user "jtlaune")
     (smtpmail-local-domain "gmail.com")
     (smtpmail-default-smtp-server "smtp.gmail.com")
     (smtpmail-smtp-server "smtp.gmail.com")
     (smtpmail-smtp-service 587)
     )
     ;; Include any other accounts here ...
    ))

(defun my-mu4e-set-account ()
  "Set the account for composing a message.
   This function is taken from: 
     https://www.djcbsoftware.nl/code/mu/mu4e/Multiple-accounts.html"
  (let* ((account
    (if mu4e-compose-parent-message
        (let ((maildir (mu4e-message-field mu4e-compose-parent-message :maildir)))
    (string-match "/\\(.*?\\)/" maildir)
    (match-string 1 maildir))
      (completing-read (format "Compose with account: (%s) "
             (mapconcat #'(lambda (var) (car var))
            my-mu4e-account-alist "/"))
           (mapcar #'(lambda (var) (car var)) my-mu4e-account-alist)
           nil t nil nil (caar my-mu4e-account-alist))))
   (account-vars (cdr (assoc account my-mu4e-account-alist))))
    (if account-vars
  (mapc #'(lambda (var)
      (set (car var) (cadr var)))
        account-vars)
      (error "No email account found"))))
(add-hook 'mu4e-compose-pre-hook 'my-mu4e-set-account)

;; don't keep message buffers around
(setq message-kill-buffer-on-exit t)

;; term
(setq explicit-shell-filename "/bin/bash")
(setq term-scroll-show-maximum-output 1)
(add-hook 'term-mode-hook #'eterm-256color-mode)
(eval-after-load "term"
  '(progn
     ;; ensure that scrolling doesn't break on output
     (setq term-scroll-to-bottom-on-output t)))
;; multiterm
(use-package multi-term
  :ensure t)
(setq multi-term-program "/bin/bash")
(setq multi-term-scroll-show-maximum-output 1)
(add-hook 'term-mode-hook (lambda ()
                            (define-key term-raw-map (kbd "M-o") 'ace-window)
                            ))

;; use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))

;; evil
(use-package evil
  :ensure t)
(evil-mode t)
(add-to-list 'evil-emacs-state-modes 'image-mode)

;; more evil
(use-package evil-mu4e
  :ensure t)

;; ace-window
(use-package ace-window
  :ensure t)

;; colors
(use-package eterm-256color
  :ensure t)

;; helm
(use-package helm
  :ensure t)
(helm-mode 1)

;; projectile 
(use-package projectile
  :ensure t)
(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(use-package helm-projectile
  :ensure t)
(setq projectile-completion-system 'helm)
(helm-projectile-on)

;; git
(use-package magit
  :ensure t)

;; pdf
(use-package pdf-tools
  :ensure t)
(pdf-tools-install)
(setq pdf-tools-enable 1)

;; latex
(use-package tex
  :ensure auctex)
(setq TeX-view-program-selection '((output-pdf "PDF Tools")))
(setq TeX-source-correlate-method
      '((dvi . source-specials)
       (pdf . synctex)))
(setq TeX-source-correlate-mode t)
(setq TeX-auto-save t)
(setq TeX-PDF-mode t)
(setq TeX-parse-self t)
(setq-default TeX-source-correlate-start-server t)
(add-hook 'TeX-after-compilation-finished-functions
           #'TeX-revert-document-buffer)
(global-font-lock-mode 1)
(set-default 'preview-scale-function 3.0)
(setq font-latex-fontify-script nil)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)
(add-hook 'LaTeX-mode-hook 'outline-minor-mode)
(add-hook 'LaTeX-mode-hook 'outline-hide-body)

(use-package auctex-latexmk
  :ensure t)
(auctex-latexmk-setup)

;; outline-magic
(use-package outline-magic
  :ensure t)
(setq TeX-outline-extra
      '(("%chapter" 1)
        ("%section" 2)
        ("%subsection" 3)
        ("%subsubsection" 4)
        ("%paragraph" 5)))
(define-key outline-minor-mode-map (kbd "<C-tab>") 'outline-cycle)

;; spaceline
(use-package spaceline
  :ensure t
  :config
  (setq-default mode-line-format '("%e" (:eval (spaceline-ml-main)))))

(use-package spaceline-config
  :ensure spaceline
  :config
  (spaceline-helm-mode 1)
  (spaceline-spacemacs-theme))

;; org
(use-package org
  :ensure org-plus-contrib)
(setq org-image-actual-width 800)
(setq org-confirm-babel-evaluate nil)
;(setq org-mode-hook nil) ;;for some reason there's a lot of shit in the org hook that breaks it?
(add-hook 'org-mode-hook 'outline-minor-mode)
(add-hook 'org-mode-hook 'outline-hide-body)
(add-hook 'org-mode-hook 'org-indent-mode)
(add-hook 'org-mode-hook 'org-toggle-inline-images)
(setq org-format-latex-options (plist-put org-format-latex-options :scale 2.5))
(require 'ox-extra)
(ox-extras-activate '(ignore-headlines))
(setq org-highlight-latex-and-related '(latex script entities))

;; org keybindings
(define-key org-mode-map (kbd "C-c C-l") 'org-insert-last-stored-link)


;; agenda configuration
(setq org-agenda-sticky 't)
(setq org-agenda-files
      (list "~/Dropbox/org/todo.org" "~/Dropbox/org/calendar.org"))
(setq org-refile-targets '((org-agenda-files :maxlevel . 2)))
(setq org-use-fast-todo-selection 1)
(setq org-capture-templates
      '(("t" "todo" entry (file "~/Dropbox/org/todo.org")
         "* TODO %?\n")))
(setq org-agenda-start-day "0d")
(setq org-agenda-span 7)
(setq org-agenda-start-on-weekday nil)
(setq org-agenda-hide-tags-regexp "home\\|work\\|school")
(setq org-agenda-custom-commands
      '(("b" "block view"
	 ((tags-todo "+TODO=\"PROG\""
		     ((org-agenda-overriding-header "\nin progress\n")))
	  (tags-todo "+@work+TODO=\"TODO\""
		     ((org-agenda-overriding-header "\nwork tasks\n")))
	  (tags-todo "+TODO=\"HW\""
		     ((org-agenda-overriding-header "\nschool tasks\n")))
	  (tags-todo "-@work+TODO=\"TODO\""
		     ((org-agenda-overriding-header "\nhome tasks\n")))
	  (agenda ""
		  ((org-agenda-overriding-header "\nagenda for today\n")))))))

;; org-download
(use-package org-download
  :ensure t)
(setq org-download-screenshot-method "import /tmp/screenshot.png")
(setq org-download-method 'attach)
(setq org-download-annotate-function (lambda (_link) ""))

;; jupyter notebook integration
(use-package ein
  :ensure t)

;; load python and jupyter
(org-babel-do-load-languages
 'org-babel-load-languages
 '((ein . t)
   ;; other languages..
   ))
(add-hook 'org-babel-after-execute-hook 'org-display-inline-images 'append)

;; if i need to use python virtual envs
(use-package pyvenv
  :ensure t)
(use-package virtualenvwrapper
  :ensure t)
(setq venv-location "~/.pythonenvs/")

;; scroll one line at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(3 ((shift) . 3))) ;; 3 lines at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time

;; yasnippet
(use-package yasnippet
  :ensure t)
(yas-global-mode 1)
(put 'downcase-region 'disabled nil)

;; change all prompts to y or n
(fset 'yes-or-no-p 'y-or-n-p)

;; nonblinking cursor ffs
(blink-cursor-mode 0)

;; better image viewing
(use-package image+
  :ensure t)
(eval-after-load 'image '(require 'image+))
(eval-after-load 'image+ '(imagex-global-sticky-mode 1))
(eval-after-load 'image+ '(imagex-auto-adjust-mode 1))

;; upcase region is tight
(put 'upcase-region 'disabled nil)
