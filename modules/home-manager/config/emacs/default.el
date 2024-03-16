;;; Custom set variables
(setq-default auto-save-default nil)
(setq-default auto-save-mode nil)
(setq-default backup-directory-alist '(("." . "~/.emacs_backups")))
(setq-default company-idle-delay nil)
(setq-default fill-column 90)
(setq-default indent-tabs-mode nil)
(setq-default make-backup-files nil)
(setq-default neo-window-width 40)
(setq-default
 package-archives
 '(("melpa" . "https://melpa.org/packages/")
   ("elpa" . "https://elpa.gnu.org/packages/")))
(setq-default truncate-lines t)
(setq-default warning-suppress-types '((direnv) (comp)))

;;; Start the emacs server
(add-hook 'after-init-hook 'server-start)

;;; UI
(line-number-mode 1)
(column-number-mode 1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(global-hl-line-mode 1)

;; Font
(add-to-list 'default-frame-alist '(font . "0xProto:pixelsize=15"))

;;; Key Bindings
(defvar personal-keys-minor-mode-map
  (let ((map (make-sparse-keymap)))
    map)
  "personal-keys-minor-mode keymap.")

(define-minor-mode personal-keys-minor-mode
  "A minor mode so that my key settings override annoying major modes."
  :init-value t
  :lighter " personal-keys")

(personal-keys-minor-mode 1)

;; Disable my keys in minibuffer
(add-hook 'minibuffer-setup-hook
          (lambda () (personal-keys-minor-mode 0)))

(defun prev-window ()
  (interactive)
  (other-window -1))

(define-key personal-keys-minor-mode-map (kbd "C-c n") 'other-window)
(define-key personal-keys-minor-mode-map (kbd "C-c p") 'prev-window)

(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<down>") 'shrink-window)
(global-set-key (kbd "S-C-<up>") 'enlarge-window)

(global-set-key (kbd "C-c c") 'compile)
(global-set-key (kbd "C-c r") 'recompile)
(global-set-key (kbd "C-c C-l") 'visual-line-mode)

;; Ivy keybindings
(global-set-key (kbd "C-s") 'swiper-isearch)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "M-y") 'counsel-yank-pop)
(global-set-key (kbd "C-h f") 'counsel-describe-function)
(global-set-key (kbd "C-h v") 'counsel-describe-variable)
(global-set-key (kbd "C-h l") 'counsel-find-library)
(global-set-key (kbd "C-h i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "C-h u") 'counsel-unicode-char)
(global-set-key (kbd "C-h j") 'counsel-set-variable)
(global-set-key (kbd "C-x b") 'ivy-switch-buffer)
(global-set-key (kbd "C-c v") 'ivy-push-view)
(global-set-key (kbd "C-c V") 'ivy-pop-view)

;;; Packages
(require 'package)
(package-initialize)

; Refresh packages on first run
(when (not package-archive-contents)
  (package-refresh-contents))

; Install all use-package packages
(when (not (package-installed-p 'use-package))
  (package-install 'use-package))

(use-package use-package
  :ensure t)

;; Theme
(use-package solarized-theme
  :ensure t
  :config (load-theme 'solarized-dark))

(use-package ligature
  :ensure t
  :config
  (ligature-set-ligatures 't '("www"))
  (ligature-set-ligatures
   'prog-mode
   '("->" "<-" "=>" "=>>" ">=>"
     "=>=" "=<<" "=<=" "<=<" "<=>"
     ">>" ">>>" "<<" "<<<" "<>"
     "<|>" "==" "===" ".=" ":="
     "#=" "!=" "!==" "=!=" "=:="
     "::" ":::" ":<:" ":>:" "||"
     "|>" "||>" "|||>" "<|" "<||"
     "<|||" "**" " ***" "<*" "<*>"
     "*>" "<+" "<+>" "+>" "<$"
     "<$>" "$>" "&&" "??" "%%"
     "|]" "[|" "//" "///"))
  (global-ligature-mode))

(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :bind (("M-/" . 'company-complete-common)))

(use-package counsel
  :ensure t
  :config (ivy-mode 1))

(use-package neotree
  :ensure t
  :bind (:map personal-keys-minor-mode-map
         ("C-c f" . neotree-show)
         ("C-c C-f" . neotree-toggle)))

(use-package format-all
  :ensure t
  :hook
  ((haskell-mode . format-all-mode)))

(use-package gh-md
  :ensure t)

;; Language server
(use-package direnv
  :ensure t
  :config
  (direnv-mode))

(use-package eglot
  :ensure t
  :config
  (add-hook 'haskell-mode-hook 'eglot-ensure)
  :config
  (setq-default eglot-workspace-configuration
                '((haskell
                   (plugin
                    (stan
                     (globalOn . :json-false)))) ; disable stan
                  (haskell
                   (formattingProvider . "fourmolu"))))
  :config
  (add-to-list
   'eglot-server-programs
   '(haskell-mode . ("haskell-language-server" "--lsp")))
  :custom
  (flycheck-global-modes '(not haskell-mode)) ; Disable flycheck
  (eglot-autoshutdown t)  ; shutdown language server after closing last file
  (eglot-confirm-server-initiated-edits nil))  ; allow edits without confirmation

;; Languages
(use-package emacsql
  :ensure t)

(use-package haskell-mode
  :ensure t)

(use-package flymake-shellcheck
  :commands flymake-shellcheck-load
  :init
  (add-hook 'sh-mode-hook 'flymake-shellcheck-load))

(use-package markdown-mode
  :ensure t)

(use-package nix-mode
  :ensure t)

(use-package restclient
  :ensure t
  :mode ("\\.rest$" . restclient-mode))

(use-package yaml-mode
  :ensure t)

;; Other packages
(use-package exec-path-from-shell
  :if window-system
  :ensure t
  :config (exec-path-from-shell-initialize))

(use-package magit
  :ensure t
  :bind ("C-c g" . magit-status))

;;; Misc
; Override disabled keys
(put 'downcase-region 'disabled nil)

; Delete trailing whitespace on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)
