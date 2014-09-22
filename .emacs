(require 'package)
(package-initialize)

(push '("marmalade" . "http://marmalade-repo.org/packages/")
      package-archives )
(push '("melpa" . "http://melpa.milkbox.net/packages/")
      package-archives)

;; Color Theme
;(require 'color-theme)
;(color-theme-initialize)
;(load-theme 'spolsky)
;(color-theme-dg)
;(color-theme-complexity)
(load-theme 'evenhold)

;; Auctex
(add-to-list 'load-path "/home/branden/.emacs.d/elpa/auctex-11.87.7/")
(require 'tex)
(TeX-global-PDF-mode t)
;; Autocomplete
(add-to-list 'load-path "/home/branden/.emacs.d/elpa/popup-20140815.629")
(add-to-list 'load-path "/home/branden/.emacs.d/elpa/auto-complete-20140824.1658/")
(require 'popup)
(require 'auto-complete)
(add-to-list 'ac-dictionary-directories "/home/branden/.emacs.d/elpa/auto-complete-20140824.1658/dict")
(require 'auto-complete-config)
(ac-config-default)
;; ac-math
(add-to-list 'load-path "/home/branden/.emacs.d/elpa/ac-math-20131003.1604/")
(require 'ac-math)
;; ac-auctex
(add-to-list 'load-path "/home/branden/.emacs.d/elpa/auto-complete-auctex-20140223.958/")
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
(add-to-list 'load-path "~/.emacs.d/elpa/evil-20140910.441")
(require 'evil)
(evil-mode 1)
(define-key evil-motion-state-map (kbd "<f13>") 'evil-insert-state)
(define-key evil-insert-state-map (kbd "<f13>") (lambda () (evil-normal-state) (interactive) (evil-forward-char) ))

;; emacs stuff
(electric-indent-mode 1)
(menu-bar-mode -1)
(global-linum-mode 1)
(setq default-tab-width 2)
(setq show-trailing-whitespace t)
(show-paren-mode 1)
(setq show-paren-delay 0)
(when (fboundp 'windmove-default-keybindings)
	  (windmove-default-keybindings))
