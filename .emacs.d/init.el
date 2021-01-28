;;; init.el --- My init.el  -*- lexical-binding: t; -*-

;;; Commentary:

;; Thanks
;; https://emacs-jp.github.io/tips/emacs-in-2020
;; https://github.com/conao3/leaf.el#install
;; https://asataken.hatenablog.com/entry/2020/08/28/180000

;; install check list ;;
;;    [] ace-window
;;    [] avy
;;    [] back-button
;;    [] bind-key
;;    [] c-eldoc
;;    [] company ★
;;    [] company-jedi
;;    [] company-statistics
;;    [] company-tern
;;    [] company-web
;;    [] counsel ★
;;    [] easy-repeat
;;    [] epc
;;    [] exec-path-from-shell
;;    [] expand-region
;;    [] flycheck ★
;;    [] ggtags
;;    [] git-gutter+
;;    [] haskell-mode
;;    [] htmlize
;;    [] imenu-anywhere
;;    [] ivy ★
;;    [] jedi-core
;;    [] jinja2-mode
;;    [] js2-mode,
;;    [] magit ★
;;    [] markdown-mode
;;    [x] multiple-cursors ★
;;    [] racer
;;    [x] rainbow-delimiters
;;    [] rtags
;;    [x] rust-mode
;;    [] scala-mode2
;;    [] smart-mode-line
;;    [] swiper ★
;;    [] term+
;;    [] tern
;;    [x] undo-tree
;;    [] visual-regexp
;;    [] web-mode
;;    [x] wgrep ★
;;    [x] which-key
;;    [] yaml-mode
;;    [] yasnippet


;;; Code:

;; ---------------------------------------
;; this enables this running method
;;   emacs -q -l ~/.debug.emacs.d/init.el
;; ---------------------------------------
(eval-and-compile
  (when (or load-file-name byte-compile-current-file)
    (setq user-emacs-directory
          (expand-file-name
           (file-name-directory (or load-file-name byte-compile-current-file))))))

;; <leaf-install-code>
(eval-and-compile
  (customize-set-variable
   'package-archives '(("org" . "https://orgmode.org/elpa/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("gnu" . "https://elpa.gnu.org/packages/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
    (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    (leaf blackout :ensure t)

    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init)))
;; </leaf-install-code>
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; ここにいっぱい設定を書く

;; Now you can use leaf!
(leaf leaf-tree :ensure t)
(leaf leaf-convert :ensure t)
(leaf transient-dwim
  :ensure t
  :bind (("M-=" . transient-dwim-dispatch)))

;; leafの :custom で設定するとinit.elにcustomが勝手に設定を追記します。
;; この状況になると、変数の二重管理になってしまうので、customがinit.elに追記しないように設定します。
(leaf cus-edit
  :doc "tools for customizing Emacs and Lisp packages"
  :tag "builtin" "faces" "help"
  :custom `((custom-file . ,(locate-user-emacs-file "custom.el"))))

;; You can also configure builtin package via leaf!
(leaf cus-start
  :doc "define customization properties of builtins"
  :tag "builtin" "internal"
  :preface
  (defun c/redraw-frame nil
    (interactive)
    (redraw-frame))

  :bind (("M-ESC ESC" . c/redraw-frame))
  :custom '((user-full-name . "yn")
            (user-mail-address . "kanemotoyn@gmail.com")
            (user-login-name . "yn")
            (create-lockfiles . nil)
            (debug-on-error . t)
            (init-file-debug . t)
            (frame-resize-pixelwise . t)
            (enable-recursive-minibuffers . t)
            (history-length . 1000)
            (history-delete-duplicates . t)
            (scroll-preserve-screen-position . t)
            (scroll-conservatively . 100)
            (mouse-wheel-scroll-amount . '(1 ((control) . 5)))
            (ring-bell-function . 'ignore)
            (text-quoting-style . 'straight)
            (truncate-lines . t)
            ;; (use-dialog-box . nil)
            ;; (use-file-dialog . nil)
            ;; (menu-bar-mode . t)
            ;; (tool-bar-mode . nil)
            (scroll-bar-mode . nil)
            (indent-tabs-mode . nil))
  :config
  (defalias 'yes-or-no-p 'y-or-n-p)
  (keyboard-translate ?\C-h ?\C-?))

(leaf autorevert
  :doc "revert buffers when files on disk change"
  :tag "builtin"
  :custom ((auto-revert-interval . 1)
           (auto-revert-check-vc-info . t))
  :global-minor-mode global-auto-revert-mode)

(leaf cc-mode
  :doc "major mode for editing C and similar languages"
  :tag "builtin"
  :defvar (c-basic-offset)
  :bind (c-mode-base-map
         ("C-c c" . compile))
  :mode-hook
  (c-mode-hook . ((c-set-style "bsd")
                  (setq c-basic-offset 4)))
  (c++-mode-hook . ((c-set-style "bsd")
                    (setq c-basic-offset 4))))

(leaf delsel
  :doc "delete selection if you insert"
  :tag "builtin"
  :global-minor-mode delete-selection-mode)

(leaf paren
  :doc "highlight matching paren"
  :tag "builtin"
  :custom ((show-paren-delay . 0.1))
  :global-minor-mode show-paren-mode)

(leaf simple
  :doc "basic editing commands for Emacs"
  :tag "builtin" "internal"
  :custom ((kill-ring-max . 100)
           (kill-read-only-ok . t)
           (kill-whole-line . t)
           (eval-expression-print-length . nil)
           (eval-expression-print-level . nil)))

(leaf files
  :doc "file input and output commands for Emacs"
  :tag "builtin"
  :custom `((auto-save-timeout . 15)
            (auto-save-interval . 60)
            (auto-save-file-name-transforms . '((".*" ,(locate-user-emacs-file "backup/") t)))
            (backup-directory-alist . '((".*" . ,(locate-user-emacs-file "backup"))
                                        (,tramp-file-name-regexp . nil)))
            (version-control . t)
            (delete-old-versions . t)))

(leaf startup
  :doc "process Emacs shell arguments"
  :tag "builtin" "internal"
  :custom `((auto-save-list-file-prefix . ,(locate-user-emacs-file "backup/.saves-"))))

;; 対応する括弧の自動挿入
(leaf electric
  :doc "window maker and Command loop for `electric` modes"
  :tag "builtin"
  :added "2021-01-26"
  :init (electric-pair-mode 1))
  
;; フォント設定
(setq default-frame-alist
      '(
        (font . "Cica 16")))

;; キーバインド設定
(leaf-keys (("C-h"  . backward-delete-char)
            ("C-c M-a" . align-regexp)
            ("C-c ;" . comment-region)
            ("C-c M-;" . uncomment-region)))


;;begin ivy
(leaf ivy
  :doc "Incremental Vertical completYon"
  :req "emacs-24.5"
  :tag "matching" "emacs>=24.5"
  :url "https://github.com/abo-abo/swiper"
  :emacs>= 24.5
  :ensure t
  :blackout t
  :leaf-defer nil
  :custom ((ivy-initial-inputs-alist . nil)
           (ivy-use-selectable-prompt . t))
  :global-minor-mode t
  :config
  (leaf swiper
    :doc "Isearch with an overview. Oh, man!"
    :req "emacs-24.5" "ivy-0.13.0"
    :tag "matching" "emacs>=24.5"
    :url "https://github.com/abo-abo/swiper"
    :emacs>= 24.5
    :ensure t
    :bind (("C-s" . swiper)))

  (leaf counsel
    :doc "Various completion functions using Ivy"
    :req "emacs-24.5" "swiper-0.13.0"
    :tag "tools" "matching" "convenience" "emacs>=24.5"
    :url "https://github.com/abo-abo/swiper"
    :emacs>= 24.5
    :ensure t
    :blackout t
    :bind (("C-S-s" . counsel-imenu)
           ("C-x C-r" . counsel-recentf))
    :custom `((counsel-yank-pop-separator . "\n----------\n")
              (counsel-find-file-ignore-regexp . ,(rx-to-string '(or "./" "../") 'no-group)))
    :global-minor-mode t))

(leaf prescient
  :doc "Better sorting and filtering"
  :req "emacs-25.1"
  :tag "extensions" "emacs>=25.1"
  :url "https://github.com/raxod502/prescient.el"
  :emacs>= 25.1
  :ensure t
  :custom ((prescient-aggressive-file-save . t))
  :global-minor-mode prescient-persist-mode)
  
(leaf ivy-prescient
  :doc "prescient.el + Ivy"
  :req "emacs-25.1" "prescient-4.0" "ivy-0.11.0"
  :tag "extensions" "emacs>=25.1"
  :url "https://github.com/raxod502/prescient.el"
  :emacs>= 25.1
  :ensure t
  :after prescient ivy
  :custom ((ivy-prescient-retain-classic-highlighting . t))
  :global-minor-mode t)
;;end ivy

;;begin flycheck
(leaf flycheck
  :doc "On-the-fly syntax checking"
  :req "dash-2.12.1" "pkg-info-0.4" "let-alist-1.0.4" "seq-1.11" "emacs-24.3"
  :tag "minor-mode" "tools" "languages" "convenience" "emacs>=24.3"
  :url "http://www.flycheck.org"
  :emacs>= 24.3
  :ensure t
  :bind (("M-n" . flycheck-next-error)
         ("M-p" . flycheck-previous-error))
  :global-minor-mode global-flycheck-mode)
;;end flycheck

;;begin company
(leaf company
  :doc "Modular text completion framework"
  :req "emacs-24.3"
  :tag "matching" "convenience" "abbrev" "emacs>=24.3"
  :url "http://company-mode.github.io/"
  :emacs>= 24.3
  :ensure t
  :blackout t
  :leaf-defer nil
  :bind ((company-active-map
          ("M-n" . nil)
          ("M-p" . nil)
          ("C-s" . company-filter-candidates)
          ("C-n" . company-select-next)
          ("C-p" . company-select-previous)
          ("<tab>" . company-complete-selection))
         (company-search-map
          ("C-n" . company-select-next)
          ("C-p" . company-select-previous)))
  :custom ((company-idle-delay . 0)
           (company-minimum-prefix-length . 1)
           (company-transformers . '(company-sort-by-occurrence)))
  :global-minor-mode global-company-mode)

(leaf company-c-headers
  :doc "Company mode backend for C/C++ header files"
  :req "emacs-24.1" "company-0.8"
  :tag "company" "development" "emacs>=24.1"
  :added "2020-03-25"
  :emacs>= 24.1
  :ensure t
  :after company
  :defvar company-backends
  :config
  (add-to-list 'company-backends 'company-c-headers))
;;end company

;;-------------------------------------

(leaf multiple-cursors
  :require t
  :url "https://github.com/magnars/multiple-cursors.el"
  :tag "cursor"
  :added "2021-01-29"
  :ensure t
  :bind (("C->"     . mc/mark-next-like-this)
         ("C-<"     . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)))

(leaf which-key
  :url "https://github.com/justbur/emacs-which-key"
  :ensure t
  :global-minor-mode t)

(leaf undo-tree
  :ensure t
  :bind (("M-/". undo-tree-redo))
  :global-minor-mode global-undo-tree-mode)

(leaf wgrep
  :require t
  :url "https://github.com/mhayashi1120/Emacs-wgrep"
  :added "2021-01-29"
  :ensure t
  :custom (wgrep-change-readonly-file . t))


(leaf exec-path-from-shell
  :doc "Get environment variables such as $PATH from the shell"
  :req "emacs-24.1"
  :tag "environment" "unix" "emacs>=24.1"
  :added "2021-01-26"
  :url "https://github.com/purcell/exec-path-from-shell"
  :emacs>= 24.1
  :ensure t
  :config (exec-path-from-shell-initialize))

(leaf yasnippet
  :ensure t
  :init (yas-global-mode 1)
  :custom
  (yas-snippet-dirs . '("~/.emacs.d/yasnippets")))

(leaf ivy-yasnippet
  :ensure t
  :after (yasnippet)
  :bind (("C-c y" . ivy-yasnippet)
         ("C-c C-y" . ivy-yasnippet)))
;;end yasnippet

;;begin rust
(add-to-list 'exec-path (expand-file-name "~/.cargo/bin"))
(add-to-list 'exec-path (expand-file-name "~/.local/bin"))

(leaf rust-mode
  :ensure t
  :custom (rust-format-on-save . t))

(leaf cargo
  :ensure t
  :hook (rust-mode-hook . cargo-minor-mode))
;;end rust

;;begin lsp
(leaf lsp-mode
  :ensure t
  :hook (rust-mode-hook . lsp)
  :bind ("C-c h" . lsp-describe-thing-at-point)
  :custom (lsp-rust-server . 'rust-analyzer))

(leaf lsp-ui
  :ensure t)
;;end lsp

(leaf rainbow-delimiters
  :url "https://github.com/Fanael/rainbow-delimiters"
  :ensure t
  :hook ((prog-mode-hook web-mode-hook) . rainbow-delimiters-mode)
  :custom ((rainbow-delimiters-outermost-only-face-count . 1)
           (rainbow-delimiters-depth-1-face . "#9a4040")
           (rainbow-delimiters-depth-2-face . "#ff5e5e")
           (rainbow-delimiters-depth-3-face . "#ffaa77")
           (rainbow-delimiters-depth-4-face . "#dddd77")
           (rainbow-delimiters-depth-5-face . "#80ee80")
           (rainbow-delimiters-depth-6-face . "#66bbff")
           (rainbow-delimiters-depth-7-face . "#da6bda")
           (rainbow-delimiters-depth-8-face . "#afafaf")
           (rainbow-delimiters-depth-9-face . "#f0f0f0")))

(leaf rainbow-mode
  :ensure t
  :hook ((prog-mode-hook web-mode-hook) . rainbow-mode))

;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
(provide 'init)

;; Local Variables:
;; indent-tabs-mode: nil
;; byte-compile-warnings: (not cl-functions obsolete)
;; End:

;;; init.el ends here
