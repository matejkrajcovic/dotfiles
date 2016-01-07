;; Minimal UI
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)
(setq inhibit-startup-message t)
(setq ring-bell-function 'ignore)
(blink-cursor-mode 0) ;; do not blink
(delete-selection-mode 1) ;; allow to replace selected text
(defalias 'yes-or-no-p 'y-or-n-p)

;; Utf-8
(prefer-coding-system 'utf-8)
(set-language-environment 'utf-8)

;; Backup files settings
(setq backup-directory-alist `(("." . "~/.saves")))
(setq backup-by-copying t)
(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

;; Package manager setup
(require 'package)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
			("melpa" . "https://melpa.org/packages/")))
(package-initialize)

;; Bootstrap 'use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Configure packages
(require 'use-package)

(use-package solarized-theme
  :ensure t
  :config
  (load-theme 'solarized-dark t)
  (set-frame-parameter nil 'background-mode 'dark)
  (set-terminal-parameter nil 'background-mode 'dark)
  (add-to-list 'default-frame-alist '(font . "Inconsolata-12"))
  )

(use-package ido
  :ensure t
  :defer t
  :init
  (ido-mode 1)
  (ido-everywhere 1)
  :config
  (setq ido-enable-flex-matching t)
  (setq org-completion-use-ido t)
  (use-package ido-ubiquitous
    :init (ido-ubiquitous-mode 1)
    )
  )

(use-package dired
  :bind ("C-x d" . dired)
  :config
  ;; enable ido when moving/renaming files in dired
  (put 'dired-do-rename 'ido 'find-file)
  (put 'dired-do-move 'ido 'find-file)
  (put 'dired-do-copy 'ido 'find-file)
  (use-package dired-open
    :ensure t
    :config
    (setq dired-open-extensions
          '(("webm" . "mpv")
            ("avi" . "mpv")
            ("mp4" . "mpv")
            ("mkv" . "mpv")
            ("ogv" . "mpv")
            ("png" . "nomacs")
            ("jpeg" . "nomacs")
            ("jpg" . "nomacs")
            ("pdf" . "zathura")
            ("mobi" . "ebook-viewer")
            ("epub" . "ebook-viewer")))
    )
  )

(use-package smex
  :ensure t
  :bind
  ("M-x" . smex)
  ("M-X" . smex-major-mode-commands)
  ("C-c C-c M-x" . execute-extended-command) ;; old M-x
  :init (smex-initialize)
  )

(use-package flycheck
  :ensure t
  :defer t
  :init (global-flycheck-mode)
  )

(use-package web-mode
  :ensure t
  :mode (("\\.html?\\'" . web-mode)
         ("\\.css\\'" . web-mode)
         ("\\.jsx\\'" . web-mode)
         ("\\.js\\'" . web-mode))
  :config
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  )

(use-package company
  :ensure t
  :defer t
  :init (global-company-mode)
  :config
  (setq company-minimum-prefix-length 1)
  (setq company-idle-delay 0)
  (setq company-dabbrev-downcase nil) ;; do not make completions lowercase
  )

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(use-package org
  :ensure t
  :mode ("\\.org\\'" . org-mode)
  :bind
  ("C-c a" . org-agenda)
  ("C-c c" . org-capture)
  ("C-c C-x RET g" . org-mobile-pull)
  ("C-c C-x RET p" . org-mobile-push)
  :config
  (setq org-todo-keywords '("TODO" "NEXT" "STARTED" "|" "DONE" "WAITING"))
  (setq calendar-week-start-day 1)
  (setq org-agenda-files '("~/Sync/org/gtd.org")
        org-agenda-custom-commands
        '(("t" todo "TODO")
          ("W" agenda "" ((org-agenda-ndays 21)
                          (org-agenda-show-all-dates nil)))
          ("A" agenda ""
           ((org-agenda-ndays 1)
            (org-agenda-overriding-header "Today")))
          ("n" todo "NEXT")
          ("on" tags "online")
          ))
  (setq org-mobile-directory "~/Dropbox/mobile-org/"
        org-mobile-agendas '("W" "n" "on")
        org-mobile-inbox-for-pull "~/org/inbox.org")
  (setq org-default-notes-file (concat org-directory "inbox.org")
        org-capture-templates
        '(("i" "Inbox" entry (file "~/org/inbox.org")
           "* TODO %?\n  %T\n  %i")))
  (setq org-refile-targets
        '(("maybe.org" :maxlevel . 1)
          ("gtd.org" :maxlevel . 1)
          ))
  )

(use-package mu4e
  :bind ("C-x m" . mu4e)
  :defer t
  :config
  (setq
   mu4e-maildir       "~/.mail/elbarto512-gmail.com/" ;; top-level Maildir
   mu4e-sent-folder   "/sent"                         ;; folder for sent messages
   mu4e-drafts-folder "/drafts"                       ;; unfinished messages
   mu4e-trash-folder  "/trash"                        ;; trashed messages
   mu4e-refile-folder "/archive"                      ;; saved messages
   mu4e-get-mail-command "offlineimap"
   mu4e-sent-messages-behavior 'delete                ;; don't save messages to Sent Messages, Gmail/IMAP takes care of this
   )
  (setq mu4e-bookmarks
        '(("maildir:/inbox" "Inbox" ?i)
          ("maildir:/reply" "Reply" ?r)
          ("maildir:/long_read" "Long read" ?l)
          ("maildir:/waiting" "Waiting" ?w)))
  (setq
   user-mail-address "elbarto512@gmail.com"
   user-full-name  "Matej Krajčovič")
  (use-package mu4e-contrib
    :config
    (setq mu4e-html2text-command 'mu4e-shr2text)
    )
  (use-package smtpmail
    :config
    (setq
     message-send-mail-function 'smtpmail-send-it
     sendmail-coding-system 'utf-8
     starttls-use-gnutls t
     smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
     smtpmail-auth-credentials
     '(("smtp.gmail.com" 587 "elbarto512@gmail.com" nil))
     smtpmail-default-smtp-server "smtp.gmail.com"
     smtpmail-smtp-server "smtp.gmail.com"
     smtpmail-smtp-service 587
     smtpmail-queue-dir (concat mu4e-maildir "/mu4e-queue"))
    )
  )
