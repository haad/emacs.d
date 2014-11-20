;; Turn off mouse interface early in startup to avoid momentary display
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; No splash screen please ... jeez
(setq inhibit-startup-message t)

;; Are we on a mac?
(setq is-mac (equal system-type 'darwin))

;; Set path to dependencies
(setq site-lisp-dir
      (expand-file-name "site-lisp" user-emacs-directory))

;; Set up load path
(add-to-list 'load-path user-emacs-directory)
(add-to-list 'load-path site-lisp-dir)

;; Keep emacs Custom-settings in separate file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

;; Settings for currently logged in user
(setq user-settings-dir
      (concat user-emacs-directory "users/" user-login-name))
(add-to-list 'load-path user-settings-dir)

;; Add external projects to load path
(dolist (project (directory-files site-lisp-dir t "\\w+"))
  (when (file-directory-p project)
    (add-to-list 'load-path project)))

;; Write backup files to own directory
(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "backups")))))

;; Make backups of files, even when they're in version control
(setq vc-make-backup-files t)

;; Save point position between sessions
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (expand-file-name ".places" user-emacs-directory))

;; Set up appearance early
(require 'appearance)

(require 'setup-package)

;; Install extensions if they're missing
(defun init--install-packages ()
  (packages-install
   '(magit
     paredit
     tagedit
     move-text
     gist
     htmlize
     visual-regexp
     flx
     flx-ido
     css-eldoc
     smartparens
     ido-ubiquitous
     ido-vertical-mode
     ido-at-point
     simple-httpd
     guide-key
     restclient
     highlight-escape-sequences
     whitespace-cleanup-mode
     git-commit-mode
     gitconfig-mode
     gitignore-mode
     groovy-mode
     chef-mode
     puppet-mode
     ruby-mode
     dired-details)))

(condition-case nil
    (init--install-packages)
  (error
   (package-refresh-contents)
   (init--install-packages)))

(require 'xterm)

(eval-after-load 'org '(require 'setup-org))
(eval-after-load 'ido '(require 'setup-ido))
(eval-after-load 'grep '(require 'setup-rgrep))
(eval-after-load 'dired '(require 'setup-dired))
(eval-after-load 'magit '(require 'setup-magit))

(require 'setup-hippie)
;;(require 'setup-perspective)
(require 'setup-ffip)
;;(require 'setup-html-mode)
(require 'setup-paredit)

;; Font lock dash.el
(eval-after-load "dash" '(dash-enable-font-lock))

(eval-after-load 'ruby-mode '(require 'setup-ruby-mode))
(eval-after-load 'markdown-mode '(require 'setup-markdown-mode))

(require 'mode-mappings)

;; Functions (load all files in defuns-dir)
(setq defuns-dir (expand-file-name "defuns" user-emacs-directory))
(dolist (file (directory-files defuns-dir t "\\w+"))
  (when (file-regular-p file)
    (load file)))

;; Visual regexp
(require 'visual-regexp)
(define-key global-map (kbd "M-&") 'vr/query-replace)
(define-key global-map (kbd "M-/") 'vr/replace)

;;(require 'expand-region)
(require 'multiple-cursors)
(require 'delsel)
;;(require 'jump-char)
;;(require 'eproject)
(require 'wgrep)
(require 'smart-forward)
(require 'change-inner)
(global-set-key (kbd "M-i") 'change-inner)
(global-set-key (kbd "M-o") 'change-outer)
;;(require 'multifiles)

;; Browse kill ring
(require 'browse-kill-ring)
(setq browse-kill-ring-quit-action 'save-and-restore)


;; Smart M-x is smart
(require 'smex)
(smex-initialize)

;; Setup key bindings
(require 'keys)
(require 'mouse)

(require 'my-misc)
(when is-mac (require 'mac))

;; Emacs server
(require 'server)
(unless (server-running-p)
  (server-start))

;; Run at full power please
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)

;; Conclude init by setting up specifics for the current user
(when (file-exists-p user-settings-dir)
  (mapc 'load (directory-files user-settings-dir nil "^[^#].*el$")))

(require 'aws)
;;(autoload 'ec2-describe-instances "aws")
;;(;;;autoload 'ec2-describe-volumes "aws")
;;(autoload 'ec2-describe-snapshots "aws")
;;(autoload 'ec2-describe-groups "aws")
;;(autoload 'ec2-get-console "aws")

