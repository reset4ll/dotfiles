;; init.el --- Emacs 30.2 + Evil + LSP -*- lexical-binding: t; -*-

;; ---------------------------
;; Configuración básica
;; ---------------------------

(setq inhibit-startup-screen t
      make-backup-files nil
      auto-save-default nil
      default-directory "~/Code/")

(global-display-line-numbers-mode 1)
(column-number-mode 1)
(show-paren-mode 1)
(tool-bar-mode -1)

(setq-default indent-tabs-mode nil
              tab-width 4)

;; ESC universal
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; --------------------
;; Gestión de paquetes
;; --------------------

(require 'package)

(setq package-archives
      '(("gnu"   . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; -------------------------
;; Modo modelo y apariencia
;; -------------------------

;; Doom modeline
(use-package doom-modeline
  :config
  (doom-modeline-mode 1))

;; -------
;;  Temas
;; -------
(add-to-list 'custom-theme-load-path
             "/home/aesteban/.emacs.d/themes/")

(load-theme 'sexy-monochrome t)

;; -------------------------
;; Evil (Vim modal editing)
;; -------------------------

(use-package evil
  :init
  (setq evil-want-keybinding nil
        evil-want-integration t
        evil-want-C-u-scroll t
        evil-want-C-i-jump nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; --------------------------
;; Autocompletado e interfaz
;; --------------------------

(use-package corfu
  :init
  (global-corfu-mode)
  :custom
  (corfu-auto t)
  (corfu-cycle t)
  (corfu-quit-no-match 'separator))

(use-package vertico
  :init
  (vertico-mode))

;; ------------------
;; LSP nativo: Eglot
;; ------------------

(use-package eglot
  :hook
  ((c-ts-mode
    c++-ts-mode
    python-ts-mode
    js-ts-mode) . eglot-ensure)
  :config
  (add-to-list 'eglot-server-programs
               '((c-ts-mode c++-ts-mode) . ("clangd")))
  (add-to-list 'eglot-server-programs
               '(python-ts-mode . ("pyright-langserver" "--stdio")))
  (add-to-list 'eglot-server-programs
               '(js-ts-mode . ("typescript-language-server" "--stdio"))))

;; -----------
;;  Lenguajes
;; -----------

(use-package cc-mode
  :ensure nil
  :custom
  (c-basic-offset 4))

(use-package python
  :ensure nil
  :custom
  (python-indent-offset 4))

(use-package js
  :ensure nil
  :custom
  (js-indent-level 2))

;; ---------------------
;; Diagnósticos y ayuda
;; ---------------------

(use-package flymake
  :ensure nil
  :hook (prog-mode . flymake-mode))

(use-package which-key
  :init
  (which-key-mode))

;; ----------------------
;; Soporte GIT con Magit
;; ----------------------

(use-package magit
  :bind ("C-x g" . magit-status))

;; -------------------------------
;; Organizador de notas: Org-mode
;; -------------------------------

(global-set-key (kbd "C-c l") #'org-store-link) 
(global-set-key (kbd "C-c a") #'org-agenda) 
(global-set-key (kbd "C-c c") #'org-capture)

;; ------------------------------
;; Markdown-mode y configuración
;; ------------------------------

(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :custom
  (markdown-command "pandoc"))

(setq markdown-live-preview-window-function #'my-markdown-preview-function
      markdown-split-window-direction 'right
      markdown-live-preview-delete-export 'delete-on-export)

;; -------------------------------
;; Teclas útiles estilo Vim + LSP
;; -------------------------------

(with-eval-after-load 'evil
  (define-key evil-normal-state-map (kbd "gd") #'xref-find-definitions)
  (define-key evil-normal-state-map (kbd "gr") #'xref-find-references)
  (define-key evil-normal-state-map (kbd "K")  #'eldoc)
  (define-key evil-normal-state-map (kbd "<leader>rn") #'eglot-rename))

;; ----------------
;; Unicode support
;; ----------------

(unless (package-installed-p 'unicode-fonts)
  (package-refresh-contents)
  (package-install 'unicode-fonts))

(provide 'init)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(custom-safe-themes
   '("a5e8ac34fe43455e6eb3b6267b74e9454de4c40ac28a6012a663b876a880bbf2"
     "1b7e575c6681e66d8d83634c2c160b40af12f3756360a4dd81b8032f4495cb5e"
     default))
 '(global-display-line-numbers-mode t)
 '(package-selected-packages
   '(adoc-mode auto-org-md corfu doom-modeline doom-themes edit-indirect
               evil-collection magit markdown-mode org ox-epub
               ox-typst tree-sitter typst-preview vertico)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Fira Code" :foundry "CTDB" :slant normal :weight normal :height 151 :width normal)))))

;;; init.el ends here

