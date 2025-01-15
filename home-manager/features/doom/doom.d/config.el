(setq doom-theme 'doom-gruvbox
      doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 12 :weight 'semi-bold))

(setq doom-modeline-icon t)

(setq evil-vsplit-window-right t)

(setq evil-ex-substitute-global t)

;; Rounded corners and no title-bar
(add-to-list 'default-frame-alist '(undecorated-round . t))

(after! auth-source
  (setq auth-sources
        (remove 'macos-keychain-generic (remove 'macos-keychain-internet auth-sources))))

(defun +lookup/definition-other-window ()
  "Jump to definition around point in other window."
  (interactive)
  (let ((pos (point)))
    (switch-to-buffer-other-window (current-buffer))
    (goto-char pos)
    (+lookup/definition pos)))

(define-key evil-normal-state-map "gD" '+lookup/definition-other-window)

;; Create a derived major-mode based on yaml-mode
(define-derived-mode helmls-mode yaml-mode "helmls"
  "Major mode for editing kubernetes helm templates")

(use-package eglot
                                        ; Any other existing eglot configuration plus the following:
  :hook
                                        ; Run eglot in helm-mode buffers
  (helmls-mode . eglot-ensure)
  :config
                                        ; Run `helm_ls serve` for helm-mode buffers
  (add-to-list 'eglot-server-programs '(helmls-mode "helm_ls" "serve")))

(setq jiralib-url "https://jira-software-topmanage.atlassian.net")
(setq auth-source-debug t)

(use-package kubernetes
  :defer
  :commands (kubernetes-overview))

(use-package kubernetes-evil
  :defer
  :after kubernetes)

(map! :leader
      (:prefix "o"
       :desc "Kubernetes" "K" 'kubernetes-overview))

;; WEB MODE
(use-package web-mode
  :ensure t)

;; ASTRO
(define-derived-mode astro-mode web-mode "astro")
(setq auto-mode-alist
      (append '((".*\\.astro\\'" . astro-mode))
              auto-mode-alist))

;; EGLOT
(defun astro-eglot-init-options ()
  "Set SDK path and default options."
  (let ((tsdk-path (expand-file-name
                    "lib/node_modules/typescript/lib/"
                    (shell-command-to-string
                     (string-join '("nix-store  --query --references `which astro-ls`"
                                    "xargs -n1 nix-store -q --referrers"
                                    "grep typescript-language-server"
                                    "tr -d '\n'")
                                  " | ")))))
    `(:typescript (:tsdk ,tsdk-path))))

(use-package eglot
  :ensure t
  :config
  (add-to-list 'eglot-server-programs
               `(astro-mode . ("astro-ls" "--stdio" :initializationOptions ,(astro-eglot-init-options))))
  :init
  ;; auto start eglot for astro-mode
  (add-hook 'astro-mode-hook 'eglot-ensure))


(with-eval-after-load 'org
  (setq org-directory "~/org"))

;; ----------------------------------- SPOTIFY ------------------------------------------------
(use-package! smudge
  :bind-keymap ("C-c ." . smudge-command-map)
  :custom
  (smudge-oauth2-client-secret (+pass-get-secret "spotify/smudge/client-secret"))
  (smudge-oauth2-client-id (+pass-get-secret "spotify/smudge/client-id"))
  ;; optional: enable transient map for frequent commands
  (smudge-player-use-transient-map t))
;; ----------------------------------- SLACK ------------------------------------------------
(use-package slack
  :commands (slack-start)
  :init
  (setq slack-buffer-emojify t) ;; if you want to enable emoji, default nil
  (setq slack-prefer-current-team t)
  :config
  (slack-register-team
   :default t
   :name "topmanage"
   :token (+pass-get-secret "slack/topmanage/token")
   :cookie (+pass-get-secret "slack/topmanage/cookie")
   :full-and-display-names t)

  (evil-define-key 'normal slack-mode-map
    ",ra" 'slack-message-add-reaction
    ",rr" 'slack-message-remove-reaction
    ",rs" 'slack-message-show-reaction-users
    ",me" 'slack-message-edit
    ",md" 'slack-message-delete
    ",mu" 'slack-message-embed-mention
    ",mc" 'slack-message-embed-channel)

  (evil-define-key 'normal slack-edit-message-mode-map
    ",k" 'slack-message-cancel-edit
    ",mu" 'slack-message-embed-mention
    ",mc" 'slack-message-embed-channel))

(add-hook! 'slack-mode-hook 'variable-pitch-mode)

;; Trigger alerts
;; doc: https://github.com/jwiegley/alert

(use-package! alert
  :commands (alert)
  :custom (alert-default-style 'notifier))

;; Custom function from @noonker
;; src: https://github.com/noonker/doom-emacs/blob/main/config.org#slack-1
(defun +slack/slk ()
  "start slack"
  (interactive)
  (slack-start)
  (cl-defmethod slack-buffer-name ((_class (subclass slack-room-buffer))
                                   room team)
    (slack-if-let* ((room-name (slack-room-name room team)))
        (format  ":%s"
                 room-name)))
  (slack-change-current-team))

;; -----------------------------------    ASCII BANNER ---------------------------------------

(defun my-weebery-is-always-greater ()
  (let* ((banner '("                                __ _._.,._.__"
                   "                          .o8888888888888888P'"
                   "                        .d88888888888888888K"
                   "          ,8            888888888888888888888boo._"
                   "         :88b           888888888888888888888888888b."
                   "          `Y8b          88888888888888888888888888888b."
                   "            `Yb.       d8888888888888888888888888888888b"
                   "              `Yb.___.88888888888888888888888888888888888b"
                   "                `Y888888888888888888888888888888CG88888P\"'"
                   "                  `88888888888888888888888888888MM88P\"'"
                   " \"Y888K    \"Y8P\"\"Y888888888888888888888888oo._\"\"\""
                   "   88888b    8    8888`Y88888888888888888888888oo."
                   "   8\"Y8888b  8    8888  ,8888888888888888888888888o,"
                   "   8  \"Y8888b8    8888\"\"Y8`Y8888888888888888888888b."
                   "   8    \"Y8888    8888     Y  `Y8888888888888888888888"
                   "   8      \"Y88    8888     .d `Y88888888888888888888b"
                   " .d8b.      \"8  .d8888b..d88P   `Y88888888888888888888"
                   "                                  `Y88888888888888888b."
                   "                   \"Y888P\"\"Y8b. \"Y888888888888888888888"
                   "                     888    888   Y888`Y888888888888888"
                   "                     888   d88P    Y88b `Y8888888888888"
                   "                     888\"Y88K\"      Y88b dPY8888888888P"
                   "                     888  Y88b       Y88dP  `Y88888888b"
                   "                     888   Y88b       Y8P     `Y8888888"
                   "                   .d888b.  Y88b.      Y        `Y88888"
                   "                                                  `Y88K"
                   "                                                    `Y8"
                   "                                                      '"))
         (longest-line (apply #'max (mapcar #'length banner))))
    (put-text-property
     (point)
     (dolist (line banner (point))
       (insert (+doom-dashboard--center
                +doom-dashboard--width
                (concat line (make-string (max 0 (- longest-line (length line))) 32)))
               "\n"))
     'face 'doom-dashboard-banner)))

(setq +doom-dashboard-ascii-banner-fn #'my-weebery-is-always-greater)

(assoc-delete-all "Jump to bookmark" +doom-dashboard-menu-sections)
(assoc-delete-all "Open project" +doom-dashboard-menu-sections)

(add-to-list '+doom-dashboard-menu-sections
             '("Get In The Robot!"
               :icon (nerd-icons-faicon "nf-fa-android" :face 'doom-dashboard-menu-title)
               :face (:inherit (doom-dashboard-menu-title bold))
               :action projectile-switch-project))

(add-hook! '+doom-dashboard-functions :append
  (insert "\n" (+doom-dashboard--center +doom-dashboard--width "Powered by Magi!")))

(custom-set-faces!
  '(doom-dashboard-banner :foreground "red" :weight bold)
  '(doom-dashboard-footer :inherit font-lock-constant-face)
  '(doom-dashboard-footer-icon :inherit all-the-icons-red)
  '(doom-dashboard-loaded :inherit font-lock-warning-face)
  '(doom-dashboard-menu-desc :inherit font-lock-string-face)
  '(doom-dashboard-menu-title :inherit font-lock-function-name-face))
