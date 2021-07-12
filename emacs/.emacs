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

(set-frame-font "Envy Code R 12")

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
;(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)
(defun my/disable-scroll-bars (frame)
  (modify-frame-parameters frame
                           '((vertical-scroll-bars . nil)
                             (horizontal-scroll-bars . nil))))
(add-hook 'after-make-frame-functions 'my/disable-scroll-bars)

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
(use-package evil-numbers
  :ensure t)
(define-key evil-normal-state-map (kbd "C-a") 'evil-numbers/inc-at-pt)
(define-key evil-visual-state-map (kbd "C-a") 'evil-numbers/inc-at-pt)
(define-key evil-normal-state-map (kbd "C-z") 'evil-numbers/dec-at-pt)
(define-key evil-visual-state-map (kbd "C-z") 'evil-numbers/dec-at-pt)

;; ace-window
(use-package ace-window
  :ensure t)

;; set up windmove
(windmove-default-keybindings)
(windmove-default-keybindings 'control)


;; colors
(use-package eterm-256color
  :ensure t)

;; helm
(use-package helm
  :ensure t)
(helm-mode 1)

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
           #'TeX-revert-document-buffer
	   'TeX-view)
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

;; dnd
;(add-to-list 'load-path "~/.emacs.d/emacs-org-dnd/")
;(require 'ox-dnd)

;; org
(use-package org
  :ensure org-plus-contrib)
(setq org-image-actual-width 400)
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

;; helper functions
(defun insert-problems-todo (count)
  (interactive "nChapters count: ")
  (dolist (n (number-sequence 1 count))
    (insert (format "- [ ] problem %d\n" n))))

;; agenda configuration
(setq org-agenda-sticky 't)
(setq org-agenda-files
      (list "~/Dropbox/org" "~/mmr"))
(setq org-refile-targets '((org-agenda-files :maxlevel . 2)))
(setq org-use-fast-todo-selection 1)
(setq org-capture-templates
      '(("h" "home" entry (file "~/Dropbox/org/todo.org")
         "* TODO %? :home: \n")
      ("s" "school" entry (file "~/Dropbox/org/todo.org")
         "* TODO %? :school: \n")
      ("w" "work" entry (file "~/Dropbox/org/todo.org")
         "* TODO %? :work: \n")))
(setq org-agenda-start-day "0d")
(setq org-agenda-span 7)
(setq org-agenda-start-on-weekday nil)
(setq org-agenda-hide-tags-regexp "home\\|work\\|school\\|fellowship")
(setq org-agenda-custom-commands
      '(("b" "block view"
	 ((tags-todo "+TODO=\"PROG\""
		     ((org-agenda-overriding-header "\ntodo today\n")))
	  (tags-todo "+work+TODO=\"TODO\""
		     ((org-agenda-overriding-header "\nwork tasks\n")))
	  (tags-todo "+school+TODO=\"TODO\""
		     ((org-agenda-overriding-header "\nschool tasks\n")))
	  (tags-todo "+home+TODO=\"TODO\""
		     ((org-agenda-overriding-header "\nhome tasks\n")))
	  (agenda ""
		  ((org-agenda-overriding-header "\nagenda for today\n")))))))

;; org-download
(use-package org-download
  :ensure t)
(setq org-download-screenshot-method "import /tmp/screenshot.png")
(setq org-download-method 'attach)
(setq org-download-annotate-function (lambda (_link) ""))

(use-package company
  :ensure t)
(use-package company-quickhelp
  :ensure t)
(company-quickhelp-mode)
(add-hook 'after-init-hook 'global-company-mode)

(use-package elpy
  :ensure t
  :init
  (elpy-enable))

(setq elpy-rpc-virtualenv-path 'current)
(setq elpy-rpc-backend "jedi")

(use-package jupyter
  :ensure t
  :after (:all org python))
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (julia . t)
   (python . t)
   (jupyter . t)))


;; scroll one line at a time (less jumpy than defaults)
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
