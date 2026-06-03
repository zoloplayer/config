
;; =========================
;; IDENTITY
;; =========================
;; (setq user-full-name "Your Name"
;;       user-mail-address "you@email.com")

;; =========================
;; macOS PATH FIX
;; =========================
;; =========================
;; macOS KEYS
;; =========================
(setq mac-command-modifier 'super
      mac-option-modifier  'meta
      mac-right-option-modifier nil)

(map! "s-s" #'save-buffer
      "s-z" #'undo
      "s-Z" #'undo-redo
      "s-x" #'kill-region
      "s-c" #'kill-ring-save
      "s-v" #'yank
      "s-a" #'mark-whole-buffer
      "s-w" #'delete-window
      "s-n" #'evil-buffer-new
      "s-q" #'save-buffers-kill-emacs
      "s-f" #'+default/search-buffer
      "s-F" #'+default/search-project
      "s-p" #'projectile-find-file
      "s-b" #'+vertico/switch-workspace-buffer)

;; =========================
;; CLIPBOARD (GUI + Terminal)
;; =========================
(setq select-enable-clipboard t
      select-enable-primary nil)

(when (not (display-graphic-p))
  (setq interprogram-cut-function
        (lambda (text &optional _push)
          (let ((proc (start-process "pbcopy" nil "pbcopy")))
            (process-send-string proc text)
            (process-send-eof proc))))
  (setq interprogram-paste-function
        (lambda () (shell-command-to-string "pbpaste"))))

;; =========================
;; UI
;; =========================
(add-to-list 'initial-frame-alist '(fullscreen . maximized))
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(setq doom-theme 'doom-gruvbox
      doom-gruvbox-dark-variant "hard"
      frame-background-mode 'dark)

(setq doom-font (font-spec :family "JetBrains Mono" :size 14)
      doom-variable-pitch-font (font-spec :family "JetBrains Mono" :size 16))

(setq display-line-numbers-type 'relative)

;; Transparency
(defun yf/apply-frame-transparency (&optional frame)
  (with-selected-frame (or frame (selected-frame))
    (set-frame-parameter nil 'alpha-background 92)
    (set-frame-parameter nil 'alpha '(92 . 92))))

(add-to-list 'initial-frame-alist '(alpha-background . 92))
(add-to-list 'initial-frame-alist '(alpha . (92 . 92)))
(add-to-list 'default-frame-alist '(alpha-background . 92))
(add-to-list 'default-frame-alist '(alpha . (92 . 92)))
(add-hook 'after-make-frame-functions #'yf/apply-frame-transparency)
(add-hook 'doom-load-theme-hook #'yf/apply-frame-transparency)
(yf/apply-frame-transparency)

;; macOS titlebar
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))

;; Modeline polish
(setq doom-modeline-height 28
      doom-modeline-bar-width 4)
(display-time-mode 1)

;; =========================
;; DIRED
;; =========================
(setq insert-directory-program "gls")

(after! dired
  (setq dired-listing-switches "-aBhl --group-directories-first"
        dired-dwim-target t
        dired-recursive-copies 'always
        dired-recursive-deletes 'always))

;; =========================
;; ORG MODE
;; =========================
(setq org-directory "~/org/")

(after! org
  (setq org-agenda-files (list org-directory)
        org-log-done 'time
        org-hide-emphasis-markers t
        org-startup-indented t
        org-ellipsis " ▾"
        org-return-follows-link t
        org-use-speed-commands t
        org-todo-keywords
        '((sequence "TODO(t)" "IN-PROGRESS(i)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)"))))

(after! org
  (setq org-capture-templates
        '(("t" "Task" entry (file+headline "~/org/inbox.org" "Tasks")
           "* TODO %?\n  %U\n  %a")
          ("n" "Note" entry (file+headline "~/org/notes.org" "Notes")
           "* %?\n  %U")
          ("j" "Journal" entry (file+datetree "~/org/journal.org")
           "* %?\n  Entered on %U"))))

(map! :leader
      :desc "Org capture" "X" #'org-capture
      :desc "Org agenda"  "oa" #'org-agenda)

;; =========================
;; ZEN MODE (ORG)
;; =========================
(add-hook 'org-mode-hook #'writeroom-mode)
(add-hook 'org-mode-hook
          (lambda ()
            (visual-line-mode 1)
            (setq-local line-spacing 0.3)
            (display-line-numbers-mode -1)))

(after! writeroom-mode
  (setq writeroom-width 100
        writeroom-maximize-window t
        writeroom-fullscreen-effect 'maximized))

(add-hook 'writeroom-mode-hook
          (lambda ()
            (when writeroom-mode
              (delete-other-windows))))

;; =========================
;; DEV ↔ ZEN TOGGLE
;; =========================
(defvar my/dev-mode-enabled t)

(defun my/toggle-dev-zen ()
  (interactive)
  (if my/dev-mode-enabled
      (progn
        (setq my/dev-mode-enabled nil)
        (writeroom-mode 1)
        (message "🧘 Zen Mode"))
    (setq my/dev-mode-enabled t)
    (writeroom-mode -1)
    (message "⚙️ Dev Mode")))

(map! :leader :desc "Toggle Dev/Zen" "tm" #'my/toggle-dev-zen)

;; =========================
;; VTERM
;; =========================
(after! vterm
  (setq vterm-shell "/bin/zsh"
        vterm-max-scrollback 10000
        vterm-timer-delay 0.01)

  ;; Fix copy in terminal
  (define-key vterm-mode-map (kbd "s-c") #'vterm-copy-mode)
  (define-key vterm-copy-mode-map (kbd "s-c") #'kill-ring-save)
  (define-key vterm-copy-mode-map (kbd "s-v") #'yank))

(defun my/vterm-toggle ()
  (interactive)
  (if (get-buffer "*vterm*")
      (pop-to-buffer "*vterm*")
    (vterm)))

(map! :leader :desc "Toggle terminal" "ot" #'my/vterm-toggle)

;; =========================
;; DEV LAYOUT
;; =========================
(defun my/dev-layout ()
  (interactive)
  (delete-other-windows)

  (split-window-right)
  (other-window 1)
  (my/vterm-toggle)

  (other-window -1)
  (split-window-below)
  (other-window 1)
  (consult-buffer)

  (other-window -1)

  (message "⚙️ Dev layout ready"))

(map! :leader :desc "Dev layout" "od" #'my/dev-layout)

;; =========================
;; PROJECT WORKFLOW
;; =========================
(defun my/project-open ()
  (interactive)
  (call-interactively #'projectile-switch-project)
  (my/dev-layout))

(map! :leader :desc "Project + layout" "pp" #'my/project-open)

;; =========================
;; WORKSPACE PERSISTENCE
;; =========================
(setq +workspaces-auto-save t)
(setq +workspaces-auto-restore t)

(after! persp-mode
  (setq persp-auto-save-opt 1))

;; =========================
;; WINDOW NAVIGATION
;; =========================
(map! :leader
      "wh" #'windmove-left
      "wl" #'windmove-right
      "wj" #'windmove-down
      "wk" #'windmove-up)

;; =========================
;; MAGIT
;; =========================
(after! magit
  (setq magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1
        magit-diff-refine-hunk 'all))

(map! :leader :desc "Git status" "gg" #'magit-status)

;; =========================
;; LSP
;; =========================
(after! lsp-mode
  (setq lsp-headerline-breadcrumb-enable nil
        lsp-enable-symbol-highlighting t
        lsp-modeline-code-actions-enable t
        lsp-idle-delay 0.3))

(defun my/lsp-format-on-save ()
  (add-hook 'before-save-hook #'lsp-format-buffer nil :local))

(add-hook 'js2-mode-hook #'my/lsp-format-on-save)
(add-hook 'typescript-mode-hook #'my/lsp-format-on-save)
(add-hook 'tsx-ts-mode-hook #'my/lsp-format-on-save)

;; =========================
;; PERFORMANCE
;; =========================
(setq gc-cons-threshold (* 200 1024 1024)
      read-process-output-max (* 1024 1024)
      inhibit-compacting-font-caches t)

;; =========================
;; MISC
;; =========================
(setq auto-save-default t
      make-backup-files nil
      confirm-kill-emacs 'yes-or-no-p)

(setq scroll-conservatively 101
      scroll-margin 0
      mouse-wheel-scroll-amount '(2 ((shift) . 5))
      mouse-wheel-progressive-speed nil)
