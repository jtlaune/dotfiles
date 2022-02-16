;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(require 'package)
;org moved to nongnu. delete in future.
;(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(package-initialize)

;; get rid of the annoying custom code in .emacs
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)


;; have to use default-frame-alist for daemon emacs
(add-to-list 'default-frame-alist '(font . "FantasqueSansMono Nerd Font Mono 14"))
(add-to-list 'default-frame-alist '(tool-bar-lines . 0))
(add-to-list 'default-frame-alist '(vertical-scroll-bars . nil))
(menu-bar-mode -1)

;; custom functions
;;(defun ...
(defun my-file-contents (file)
  (with-temp-buffer
    (insert-file-contents file)
    (buffer-string)))

(defun random-alnum () ()
  (let* ((alnum "abcdefghijklmnopqrstuvwxyz0123456789")
         (i (% (abs (random)) (length alnum))))
    (substring alnum i (1+ i))))

(defun random-5-letter-string () ()
   (concat 
    (random-alnum)
    (random-alnum)
    (random-alnum)
    (random-alnum)
    (random-alnum)))

(defun kill-random-5-letter-string ()
  (interactive)
  (kill-new (random-5-letter-string)))

; TODO
;(defun goto-bibtex-buffer-or-start-one 

;; global keybindings
(global-set-key (kbd "M-o") 'ace-window)
(global-set-key (kbd "M-r") 'isearch-backward-regexp)
(global-set-key (kbd "M-s") 'isearch-forward-regexp)
(global-set-key (kbd "M-l") 'linum-mode)
(global-set-key (kbd "C-c g") 'magit-status)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c s s") 'org-screenshot-take)
(global-set-key (kbd "C-c C-y") 'term-paste)
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c x r") 'eval-buffer)
(global-set-key (kbd "C-c r b") 'revert-buffer)
(global-set-key (kbd "C-c b") 'helm-bibtex)

;; bigger initial size
;(add-to-list 'initial-frame-alist '(height . 30))
;(add-to-list 'initial-frame-alist '(width . 100))
;(setq frame-resize-pixelwise t)

;; central save files
(setq backup-directory-alist `(("." . "~/.saves")))

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
 ;initial-scratch-message ";; Happy Hacking!!"
 initial-scratch-message "#+TITLE: Scratch Buffer"
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
(setq evil-want-keybinding nil)
(use-package evil
  :ensure t)
(evil-mode t)
(add-to-list 'evil-emacs-state-modes 'image-mode)
(use-package evil-collection
  :ensure t)
(evil-collection-init)

;; more evil
(use-package evil-numbers
  :ensure t)
(define-key evil-normal-state-map (kbd "C-z a") 'evil-numbers/inc-at-pt)
(define-key evil-normal-state-map (kbd "C-z z") 'evil-numbers/dec-at-pt)

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
;; helm bibtex
(use-package helm-bibtex
  :ensure t)
(add-to-list 'display-buffer-alist
             '("\\`\\*helm"
               (display-buffer-in-side-window)
               (window-height . 0.4)))
(setq helm-display-function #'display-buffer)

;; projectile
(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("s-p" . projectile-command-map)
              ("C-c p" . projectile-command-map)))
(use-package helm-projectile
  :ensure t)
(setq projectile-project-search-path
      '(("~/multi-planet-architecture/projects/" . 1) ("~/" . 1)))

;; git
(use-package magit
  :ensure t)
;; turn off magit-auto-revert-mode, causes lots of problems with pdf-tools
;; and latex export. (error "Trying to use a menu from within a menu-entry")
;(global-auto-revert-mode nil)
;;(magit-auto-revert-mode nil)

;; pdf
(use-package pdf-tools
  :ensure t)
(pdf-tools-install)
(setq pdf-tools-enable t)

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
;(use-package outline-magic
;  :ensure t)
;(setq TeX-outline-extra
;      '(("%chapter" 1)
;        ("%section" 2)
;        ("%subsection" 3)
;        ("%subsubsection" 4)
;        ("%paragraph" 5)))
;(define-key outline-minor-mode-map (kbd "<C-tab>") 'outline-cycle)

;; powerline
(use-package powerline
  :ensure t
  :config
  (powerline-default-theme))


;; for some reason spaceline is throwing startup errors even
;; after reinstalling
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

;;;;;;;;;;;;;;;;;;;;;;;;
;; Python environment ;;
;;;;;;;;;;;;;;;;;;;;;;;;
;; for some reason, elpy.el doesn't explicity require hideshow fixed
;; by requiring hideshow before downloading/bytecompiling elpy.  see
;; issue here: https://github.com/jorgenschaefer/elpy/issues/1824
(add-hook 'python-mode-hook 'hs-minor-mode)
(use-package elpy
  :ensure t
  :config (progn (elpy-enable) (elpy-folding-hide-leafs)))
(define-key elpy-mode-map (kbd "M-t") 'elpy-folding-toggle-at-point)
(define-key elpy-mode-map (kbd "M-f l") 'elpy-folding-hide-leafs)
(global-set-key (kbd "M-o") 'ace-window)
(setq elpy-rpc-virtualenv-path 'current)
(setq elpy-rpc-backend "jedi")
;(defun my-elpy-hook ()
;  (progn
;  (hs-minor-mode)
;  (hs-hide-level 1)))
;(add-hook 'elpy-mode-hook #'my-elpy-hook)


;; pyvenv
(setenv "WORKON_HOME" "/home/jtlaune/miniconda3/envs")
(pyvenv-workon "science")

;; jupyter
(use-package jupyter
  :ensure t
  :after (:all org python))

(use-package gnuplot
  :ensure t)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (latex . t)
   (python . t)
   (jupyter . t)
   (gnuplot . t)))


;; dnd
;(add-to-list 'load-path "~/.emacs.d/emacs-org-dnd/")
;(require 'ox-dnd)

;;;;;;;;;
;; org ;;
;;;;;;;;;
(use-package org
  :ensure t)
(use-package org-contrib
  :ensure t)
; org mode for scratch buffer
(setq initial-major-mode 'org-mode)
(setq org-image-actual-width '(600))
(setq org-confirm-babel-evaluate nil)
;(add-hook 'org-mode-hook 'outline-minor-mode)
;(add-hook 'org-mode-hook 'outline-hide-body)
(add-hook 'org-mode-hook 'org-shifttab)
(add-hook 'org-mode-hook 'org-indent-mode)
(add-hook 'org-mode-hook 'evil-org-mode)
(add-hook 'org-babel-after-execute-hook 'org-display-inline-images)
(setq org-startup-with-inline-images t)
(setq org-format-latex-options (plist-put org-format-latex-options :scale 1.5))
(setq org-latex-prefer-user-labels t)
(require 'ox-extra)
(ox-extras-activate '(ignore-headlines))
(setq org-highlight-latex-and-related '(latex script entities))
(setq org-src-fontify-natively t)
(setq org-src-block-faces '(("jupyter-python" (:background "#000000"))))

(use-package evil-org
  :ensure t
  :after org)
(evil-org-set-key-theme '(navigation insert textobjects additional calendar))
(require 'evil-org-agenda)
(evil-org-agenda-set-keys)

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
      (list "~/Dropbox/org" "~/multi-planet-architecture/notes"))
(setq org-refile-targets '((org-agenda-files :maxlevel . 2)))
(setq org-use-fast-todo-selection 1)
;(setq org-capture-templates
;      '(("h" "home" entry (file "~/Dropbox/org/todo.org")
;         "* TODO %? :home: \n")
;      ("s" "school" entry (file "~/Dropbox/org/todo.org")
;         "* TODO %? :school: \n")
;      ("w" "work" entry (file "~/Dropbox/org/todo.org")
;         "* TODO %? :work: \n")))
(setq org-agenda-start-day "0d")
(setq org-agenda-span 7)
(setq org-agenda-start-on-weekday nil)
;(setq org-agenda-hide-tags-regexp "home\\|work\\|school\\|fellowship")
;(setq org-agenda-custom-commands
;      '(("b" "block view"
;	 ((tags-todo "+TODO=\"PROG\""
;		     ((org-agenda-overriding-header "\ntodo today\n")))
;	  (tags-todo "+work+TODO=\"TODO\""
;		     ((org-agenda-overriding-header "\nwork tasks\n")))
;	  (tags-todo "+school+TODO=\"TODO\""
;		     ((org-agenda-overriding-header "\nschool tasks\n")))
;	  (tags-todo "+home+TODO=\"TODO\""
;		     ((org-agenda-overriding-header "\nhome tasks\n")))
;	  (agenda ""
;		  ((org-agenda-overriding-header "\nagenda for today\n")))))))

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

;;;;;;;;;;;;;;;;;;;;;;;
;; Reference Manager ;;
;;;;;;;;;;;;;;;;;;;;;;;

;; org-ref
(use-package org-ref
  :ensure t)
(setq reftex-default-bibliography '("~/Dropbox/bibliography/references.bib"))
;; pre and post text in citations
(setf (cdr (assoc 'org-mode bibtex-completion-format-citation-functions)) 'org-ref-format-citation)
;; see org-ref for use of these variables
(setq org-ref-bibliography-notes "~/Dropbox/bibliography/notes.org"
      org-ref-default-bibliography '("~/Dropbox/bibliography/references.bib")
      org-ref-pdf-directory "~/Dropbox/bibliography/bibtex-pdfs/")
(setq bibtex-completion-bibliography "~/Dropbox/bibliography/references.bib"
      bibtex-completion-library-path "~/Dropbox/bibliography/bibtex-pdfs/"
      bibtex-completion-notes-path "~/Dropbox/bibliography/bibtex-notes/")

;; open pdf with system pdf viewer
(setq bibtex-completion-pdf-open-function
  (lambda (fpath)
    (start-process "evince" "*evince*" "evince" fpath)))
;; alternative
;; (setq bibtex-completion-pdf-open-function 'org-open-file)

(use-package arxiv-mode
  :ensure t)

;; BUG/WARNING: this does not find bibliography files in other
;; directions while in a symlinked directory. current workaround is to
;; symlink the master ~/Dropbox/bibliography/references.bib file to
;; the working directory while im writing. afterwards, can use
;; org-ref-extract-bibtex-to-file to create a final .bib file.
(setq org-latex-pdf-process '("latexmk -pdflatex='pdflatex -interaction nonstopmode' -pdf -bibtex -f %f"))

(with-eval-after-load 'ox-latex
   (add-to-list 'org-latex-classes
                '("mnras"
                  "\\documentclass{mnras}"
                  ("\\section{%s}" . "\\section*{%s}")
                  ("\\subsection{%s}" . "\\subsection*{%s}")
                  ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))))
;;;;;;;;;;;
;; Prose ;;
;;;;;;;;;;;

;; focus mode
(use-package focus
  :ensure t)

;; good-scroll package seems to crash emacs on scratch
;(use-package good-scroll
;  :ensure t)
;(good-scroll-mode 1)

;; scroll one line at a time (less jumpy than defaults), possibly
;; replaced by good-scroll?
;(setq mouse-wheel-scroll-amount '(3 ((shift) . 3))) ;; 3 lines at a time
;(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
;(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
;(setq scroll-step 1) ;; keyboard scroll one line at a time

;;;;;;;;;;;;;;;
;; yasnippet ;;
;;;;;;;;;;;;;;;
(use-package yasnippet
  :ensure t)
(yas-global-mode 1)
(use-package yasnippet-snippets
  :ensure t)

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
;; this is a shitty package bc this literally was mentioned in the
;; README to quiet minibuffer errors
(setq imagex-quiet-error t)


;; upcase region is tight
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

(use-package rainbow-mode
  :ensure t)

;; themes
(use-package all-the-icons
  :ensure t)

(use-package sublime-themes
  :ensure t)
(load-theme 'junio t)
