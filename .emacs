(require 'package)
(package-initialize)
(push '("marmalade" . "https://marmalade-repo.org/packages/")
      package-archives )
(push '("melpa" . "https://melpa.org/packages/")
      package-archives)
(add-to-list 'load-path "/~/.emacs.d")
(defvar my-packages '(color-theme color-theme-monokai haskell-mode
                      powerline-evil auto-highlight-symbol auctex
                      popup auto-complete auto-complete-auctex
                      ac-math auto-complete-c-headers ac-python
                      evil flycheck cmake-mode latex-preview-pane))
(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;; Color Theme
(require 'color-theme)
(color-theme-initialize)
(color-theme-monokai)
;; powerline-evil
(require 'powerline-evil)
(powerline-center-evil-theme)

;; hilight symbols
(require 'auto-highlight-symbol)
(global-auto-highlight-symbol-mode t)
(ahs-chrange-whole-buffer)

;; Auctex
(require 'tex)
(TeX-global-PDF-mode t)
(add-to-list 'TeX-view-program-list '("mupdf" "mupdf %o"))
(setq TeX-view-program-selection '((output-pdf "mupdf")))
;; Autocomplete
(require 'popup)
(require 'auto-complete)
(add-to-list 'ac-dictionary-directories "/home/branden/.emacs.d/elpa/auto-complete-20140824.1658/dict")
(require 'auto-complete-config)
(ac-config-default)
;; ac-math
(require 'ac-math)
;; ac-auctex
(add-to-list 'ac-modes 'latex-mode)
(defun ac-LaTeX-mode-setup () ; add ac-sources to default ac-sources
  (setq ac-sources
        (append '(ac-source-math-unicode ac-source-math-latex ac-source-latex-commands)
                ac-sources))
  )
(add-hook 'LaTeX-mode-hook 'ac-LaTeX-mode-setup)
(global-auto-complete-mode t)
(setq ac-math-unicode-in-math-p t)
;; ac-c-c++-headers
(defun my:ac-c-headers-init ()
	(require 'auto-complete-c-headers)
	(add-to-list 'ac-sources 'ac-source-c-headers))

(add-hook 'c++-mode-hook 'my:ac-c-headers-init)
(add-hook 'c-mode-hook 'my:ac-c-headers-init)

;; evil mode
(require 'evil)
(evil-mode 1)
(define-key evil-motion-state-map (kbd "<f13>") 'evil-insert-state)
(define-key evil-insert-state-map (kbd "<f13>") (lambda () (evil-normal-state) (interactive) (evil-forward-char) ))

;; flycheck (syntax checker)
(require 'flycheck)
(setq flycheck-gcc-language-standard `"c++11")

;; perspective
;;(require 'perspective)
;; (persp-mode)

;; org mode
(setq org-log-done 'time)
(setq org-checkbox-hierarchical-statistics t)

;;cmake-mode
(require 'cmake-mode)

;;latex-preview-pane
(require 'latex-preview-pane)

;;column marker/ruler
(require 'fill-column-indicator)
(set 'fci-rule-column 90)
(define-globalized-minor-mode my-global-fci-mode fci-mode turn-on-fci-mode)
(my-global-fci-mode 1)

;; emacs stuff
(setq linum-format (lambda (line) (propertize (format (let ((w (length (number-to-string (count-lines (point-min) (point-max)))))) (concat "%" (number-to-string w) "d ")) line) 'face 'linum)))
(electric-pair-mode 1)
(define-key global-map (kbd "RET") 'newline-and-indent)
(setq compilation-window-height 12)
(global-linum-mode 1)
(setq-default indent-tabs-mode nil)
(setq default-tab-width 4)
(setq-default c-basic-offset 4)
(setq show-trailing-whitespace t)
(show-paren-mode 1)
(setq show-paren-delay 0)
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))
;;(server-start)
(setq x-select-enable-clipboard t)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
;; disable GUI menu
(tool-bar-mode -1)
(menu-bar-mode -1)
;; ido mode
(require 'ido)
(ido-mode t)
(ido-ubiquitous-mode t)

;; backup settings
(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '(("." . "~/.backups")) ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups
(message "Deleting old backup files...")
(let ((week (* 60 60 24 7))
      (current (float-time (current-time))))
  (dolist (file (directory-files temporary-file-directory t))
    (when (and (backup-file-name-p file)
               (> (- current (float-time (fifth (file-attributes file))))
                  week))
      (message "%s" file)
      (delete-file file))))

;; screen chat mode
(define-derived-mode chat-mode text-mode "chat"
  "Major mode for screen chatting with people"
  (interactive)
  (buffer-face-set :family "inconsolata" :height 300)
  (set 'fill-column 70))
