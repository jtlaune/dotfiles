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
(add-to-list 'default-frame-alist '(font . "Iosevka Term Slab 12"))
(set-face-attribute 'default nil :family "Iosevka Term Slab 12")
(set-face-attribute 'fixed-pitch nil :family "Iosevka Term Slab 12")
(set-face-attribute 'variable-pitch nil :family "IBM Plex Serif")
(use-package mixed-pitch
  :ensure t
  :hook (text-mode . mixed-pitch-mode))

(add-to-list 'default-frame-alist '(tool-bar-lines . 0))
(add-to-list 'default-frame-alist '(vertical-scroll-bars . nil))
(menu-bar-mode -1)
(global-linum-mode 0) ;; really messed up pdf-view for some reason
;; relative line numbers?
(setq display-line-numbers 'relative)

;;;;;;;;;;;;;;;;;;;;;;
;; custom functions ;;
;;;;;;;;;;;;;;;;;;;;;;
(defun p2l ()
  "Format current paragraph into single lines."
  (interactive "*")
  (save-excursion
    (forward-paragraph)
    (let ((foo (point)))
      (backward-paragraph)
      (replace-regexp "\n" " " nil (1+ (point)) foo)
      (backward-paragraph)
      (replace-regexp "\\.  ?" ".\n" nil (point) foo))))

(defun unfill-region (beg end)
  "Unfill the region, joining text paragraphs into a single
    logical line.  This is useful, e.g., for use with
    `visual-line-mode'."
  (interactive "*r")
  (let ((fill-column (point-max)))
    (fill-region beg end)))

(defun insert-problems-todo (count)
  (interactive "nChapters count: ")
  (dolist (n (number-sequence 1 count))
    (insert (format "- [ ] problem %d\n" n))))

;; Full width comment box
;; from http://irreal.org/blog/?p=374
(defun bjm-comment-box (b e)
"Draw a box comment around the region but arrange for the region
to extend to at least the fill column.  Place the point after the
comment box."
(interactive "r")
(let ((e (copy-marker e t)))
  (goto-char b)
  (end-of-line)
  (insert-char ?  (- fill-column (current-column)))
  (comment-box b e 1)
  (goto-char e)
  (set-marker e nil)))

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

(defun my/disable-scroll-bars (frame)
  (modify-frame-parameters frame
                           '((vertical-scroll-bars . nil)
                             (horizontal-scroll-bars . nil))))

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
;(global-set-key (kbd "C-x b") 'ibuffer)

;; bigger initial size
;(add-to-list 'initial-frame-alist '(height . 30))
;(add-to-list 'initial-frame-alist '(width . 100))
;(setq frame-resize-pixelwise t)

;; central save files
(setq backup-directory-alist `(("." . "~/.saves")))

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

(add-hook 'after-make-frame-functions 'my/disable-scroll-bars)

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
(evil-set-initial-state 'arxiv-mode 'emacs)

;; more evil
(use-package evil-numbers
  :ensure t)
(define-key evil-normal-state-map (kbd "+") 'evil-numbers/inc-at-pt)
(define-key evil-normal-state-map (kbd "-") 'evil-numbers/dec-at-pt)

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

(add-hook 'pdf-view-mode-hook 'pdf-tools-enable-minor-modes)

;;;;;;;;;;;
;; LaTex ;;
;;;;;;;;;;;
(use-package latex
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

;; latex src block previews
(setq exec-path (append exec-path '("/usr/bin/")))

; recently started throwing startup errors after an update. not sure why. disabling to see where if breaks stuff.
;(use-package auctex-latexmk
;  :ensure t)
;(auctex-latexmk-setup)

;; check out texfrag

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Language Server Protocol (lsp-mode) ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package lsp-mode
  :ensure t
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (python-mode . lsp)
         (c++-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp
  )

;; optionally
(use-package lsp-ui :ensure t :commands lsp-ui-mode)
;; if you are helm user
(use-package helm-lsp :ensure t :commands helm-lsp-workspace-symbol)
;; if you are ivy user
(use-package lsp-ivy :ensure t :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs :ensure t :commands lsp-treemacs-errors-list)

;; optionally if you want to use debugger
(use-package dap-mode :ensure t)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language

;; optional if you want which-key integration
(use-package which-key
  :ensure t 
  :config
  (which-key-mode))

;;;;;;;;;;;;;;;;;;;;;;;;
;; Python environment ;;
;;;;;;;;;;;;;;;;;;;;;;;;
;; pyvenv
(use-package pyvenv
  :ensure t)
(setenv "WORKON_HOME" "/home/jtlaune/miniconda3/envs")
(pyvenv-workon "science")

;; flycheck
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; jupyter
(use-package jupyter
  :ensure t
  :after (:all org python))

(setq native-comp-deferred-compilation t
            native-comp-deferred-compilation-deny-list '("jupyter" "zmq"))

(use-package gnuplot
  :ensure t)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (latex . t)
   (python . t)
   (calc . t)
   (jupyter . t)
   (gnuplot . t)))

(use-package lsp-jedi
  :ensure t
  :config
  (with-eval-after-load "lsp-mode"
    (add-to-list 'lsp-disabled-clients 'pyls)
    (add-to-list 'lsp-enabled-clients 'jedi)))

(setq lsp-jedi-workspace-extra-paths
  (vconcat lsp-jedi-workspace-extra-paths
           ["/home/jtlaune/miniconda3/envs/science/lib/python3.9/site-packages"]))

;;;;;;;;;
;; dnd ;;
;;;;;;;;;
(use-package org-d20
  :ensure t
  :after org)

;;;;;;;;;
;; org ;;
;;;;;;;;;
(use-package org
  :ensure t)
(use-package org-contrib
  :ensure t)
(use-package org-modern
  :ensure t)
; org mode for scratch buffer
(setq initial-major-mode 'org-mode)
(setq org-image-actual-width '(600))
(setq org-confirm-babel-evaluate nil)
;(add-hook 'org-mode-hook 'outline-minor-mode)
;(add-hook 'org-mode-hook 'outline-hide-body)
(add-hook 'org-mode-hook 'org-roam-bibtex-mode)
(add-hook 'org-mode-hook 'org-shifttab)
;(add-hook 'org-mode-hook 'org-indent-mode)
(add-hook 'org-mode-hook 'evil-org-mode)
(add-hook 'org-mode-hook 'linum-mode)
(add-hook 'org-mode-hook 'hl-line-mode)
(add-hook 'org-mode-hook 'literate-calc-minor-mode)
(add-hook 'org-babel-after-execute-hook 'org-display-inline-images)
(setq org-startup-with-inline-images t)
(setq org-format-latex-options (plist-put org-format-latex-options :scale 2.))
(add-to-list 'org-latex-packages-alist '("" "amsmath" t))
(add-to-list 'org-latex-packages-alist '("" "tensor" t))
(setq org-latex-prefer-user-labels t)
(require 'ox-extra)
(ox-extras-activate '(ignore-headlines))
(setq org-highlight-latex-and-related '(latex script entities))
(setq org-src-fontify-natively t)
(setq org-src-block-faces
'(("jupyter-python" (:font "FantasqueSansMono Nerd Font Mono 14"))))
(setq org-src-window-setup 'current-window)

(use-package evil-org
  :ensure t
  :after org)
(evil-org-set-key-theme '(navigation insert textobjects additional calendar))
(require 'evil-org-agenda)
(evil-org-agenda-set-keys)

(use-package org-roam
  :ensure t
  :after org)
(setq org-roam-directory (file-truename "~/org/"))
(org-roam-db-autosync-mode)
(setq org-roam-dailies-directory "dailies")
(setq org-roam-dailies-capture-templates
      '(("d" "default" entry
         "* %?"
         :target (file+head "%<%Y-%m-%d>.org"
                            "#+title: %<%Y-%m-%d>\n"))))

;; https://github.com/bdarcus/citar#installation This package provides
;; a completing-read front-end to browse and act on BibTeX, BibLaTeX,
;; and CSL JSON bibliographic data, and LaTeX, markdown, and org-cite
;; editing support.
(use-package citar
  :ensure t
  :custom (citar-biography '("~/bibliography/references.bib")))

;; ORB Org Roam Bibtex
;; https://github.com/org-roam/org-roam-bibtex

;; Org Roam BibTeX (ORB) is an Org Roam extension that integrates Org
;; Roam with bibliography/citation management software: Org Ref, Helm
;; and Ivy BibTeX and Citar.

;; ORB needs https://github.com/inukshuk/anystyle-cli
;; AnyStyle.io, available as a ruby gem. need to set this up on your
;; system to use https://github.com/org-roam/org-roam-bibtex#orb-anystyle

(use-package org-roam-bibtex
  :ensure t
  :after org-roam
  :config (require 'org-ref))

;; org keybindings
(define-key org-mode-map (kbd "C-c C-l") 'org-insert-last-stored-link)
(define-key org-mode-map (kbd "M-r M-f") 'org-roam-node-find)
(define-key org-mode-map (kbd "M-r M-i") 'org-roam-node-insert)
(define-key org-mode-map (kbd "M-[") 'org-ref-insert-cite-link)
(define-key org-mode-map (kbd "M-{") 'org-ref-insert-cite-link)

;; link to magit buffers
(use-package orgit
  :ensure t)

;; pomodoro timer
(use-package org-pomodoro
  :ensure t)

;;;;;;;;;;;;;;;
;; Text Mode ;;
;;;;;;;;;;;;;;;
;; get an error about flyspell not finding .aff file?
;; tried to fix to no avail. maybe just give up.
;(dolist (hook '(text-mode-hook))
;  (add-hook hook (lambda () (flyspell-mode 1))))

;; agenda configuration
(setq org-agenda-sticky 't)
(setq org-agenda-files
      (list "~/org"))
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
(setq reftex-default-bibliography '("~/bibliography/references.bib"))
;; pre and post text in citations
(setf (cdr (assoc 'org-mode bibtex-completion-format-citation-functions)) 'org-ref-format-citation)
;; see org-ref for use of these variables
(setq org-ref-bibliography-notes "~/bibliography/notes.org"
      org-ref-default-bibliography '("~/bibliography/references.bib")
      org-ref-pdf-directory "~/bibliography/bibtex-pdfs/")
(setq bibtex-completion-bibliography "~/bibliography/references.bib"
      bibtex-completion-library-path "~/bibliography/bibtex-pdfs/"
      bibtex-completion-notes-path "~/bibliography/bibtex-notes/")

;; open pdf with system pdf viewer
(setq bibtex-completion-pdf-open-function 'find-file-other-frame)

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

;;;;;;;;;;;;;
;; theming ;;
;;;;;;;;;;;;;
(use-package rainbow-mode
  :ensure t)

;; themes
(use-package all-the-icons
  :ensure t)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

(use-package leuven-theme
  :ensure t
  :config
  (load-theme 'leuven t))

(use-package svg-tag-mode
  :ensure t)
(setq svg-tag-tags
      '((":PROPERTIES:" . ((lambda (tag) (svg-tag-make "PROPERTIES"))))))
(setq svg-tag-tags
      '(("#+RESULTS:" . ((lambda (tag) (svg-tag-make "RESULTS"))))))
(global-svg-tag-mode)

;;;;;;;;;;;;
;; docker ;;
;;;;;;;;;;;;
;; https://github.com/spotify/dockerfile-mode
(use-package dockerfile-mode
  :ensure t)

;;;;;;;;;;;;;;
;; treemacs ;;
;;;;;;;;;;;;;;
(use-package treemacs
  :ensure t)

;;;;;;;;;;;;;
;; ibuffer ;;
;;;;;;;;;;;;;
;(use-package ibuffer-project
;  :ensure t)
;(add-hook 'ibuffer-hook
;  (lambda ()
;    (setq ibuffer-filter-groups (ibuffer-project-generate-filter-groups))))
;(custom-set-variables
; '(ibuffer-formats
;   '((mark modified read-only locked " "
;           (name 18 18 :left :elide)
;           " "
;           (size 9 -1 :right)
;           " "
;           (mode 16 16 :left :elide)
;           " " project-file-relative))))
;
;(evil-set-initial-state 'ibuffer-mode 'emacs)

;;;;;;;;;;;;;
;; vertico ;;
;;;;;;;;;;;;;

;; Enable vertico
(use-package vertico
  :ensure t
  :init
  (vertico-mode)

  ;; Different scroll margin
  ;; (setq vertico-scroll-margin 0)

  ;; Show more candidates
  ;; (setq vertico-count 20)

  ;; Grow and shrink the Vertico minibuffer
  ;; (setq vertico-resize t)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  ;; (setq vertico-cycle t)
  )

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

;; A few more useful configurations...
(use-package emacs
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t))

;;;;;;;;;;;;;;;;
;; marginalia ;;
;;;;;;;;;;;;;;;;
(use-package marginalia
  :ensure t
  :init (marginalia-mode)
  )

;;;;;;;;;;;
;; hydra ;;
;;;;;;;;;;;
(use-package hydra
  :ensure t)

;;;;;;;;;;;;
;; embark ;;
;;;;;;;;;;;;
(use-package embark
  :ensure t

  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  :config

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;;;;;;;;;;;;;;;
;; orderless ;;
;;;;;;;;;;;;;;;

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;;;;;;;;;;;;;
;; consult ;;
;;;;;;;;;;;;;
;; Example configuration for Consult at
;; https://github.com/minad/consult

;;;;;;;;;;;;;;;
;; calc mode ;;
;;;;;;;;;;;;;;;
(use-package literate-calc-mode
  :ensure t)

;;;;;;;;;
;; C++ ;;
;;;;;;;;;
(add-to-list 'lsp-enabled-clients 'clangd)
