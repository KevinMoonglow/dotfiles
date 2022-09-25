(setq custom-theme-directory "~/.emacs.d/themes")
(load-theme 'Lunacy t)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(setq inhibit-startup-message t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(set-fringe-mode 10)

(menu-bar-mode -1)

(set-face-attribute 'default nil
		    :font "Terminus"
		    :weight 'bold
		    :height 160)

(set-face-attribute 'fixed-pitch nil
		    :font "Terminus"
		    :weight 'bold
		    :height 160)

(set-face-attribute 'variable-pitch nil
		    :font "Cantarell"
		    :weight 'regular
		    :height 160)

(set-default 'tab-width 4)
(set-default 'require-final-newline t)

(require 'package)

(setq package-archives `(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(defun luna/exwm-hook ()
  (exwm-config-ido)
  (exwm-config-misc)
  (start-process-shell-command "xkbmap1" nil "setxkbmap -option compose:ralt")
  (start-process-shell-command "xkbmap2" nil "setxkbmap -option caps:ctrl_modifier")
  ;(start-process-shell-command "xkbmap2" nil "setxkbmap -option caps:escape_shifted_capslock")
)
(defun luna/exwm ()  
  (require 'exwm)
  (setq exwm-workspace-number 6)

  (add-hook 'exwm-update-class-hook
	    (lambda ()
	      (exwm-worksapce-rename-buffer exwm-class-name)))

  (setq exwm-input-global-keys
	`(
	  ([?\s-R] . exwm-reset)
	  ([?\s-w] . exwm-workspace-switch)
	  ([?\s-r] . (lambda (command)
		       (interactive (list (read-shell-command "$ ")))
		       (start-process-shell-command command nil command)))
	  ,@(mapcar (lambda (i)
		      `(,(kbd (format "s-%d" i)) .
			(lambda ()
			  (interactive)
			  (exwm-workspace-switch-create ,(- i 1)))))
		    (number-sequence 1 9))))
  (define-key exwm-mode-map (kbd "s-z") 'exwm-input-send-next-key)
 
  (require 'exwm-randr)
  (setq exwm-randr-workspace-monitor-plist '(5 "HDMI-0"))
   
;(add-hook 'exwm-randr-screen-change-hook
;          (lambda ()
;            (start-process-shell-command
;             "xrandr" nil "xrandr --output DP-1 --right-of DP-2 --auto")))
  (exwm-randr-enable)

  (require 'exwm-systemtray)
  (exwm-systemtray-enable)
  
  (add-hook 'exwm-init-hook #'luna/exwm-hook)

  (exwm-enable)
)


(use-package ivy
  :diminish
  :config
  (ivy-mode)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
)

(use-package counsel
  :diminish
  :after ivy
  :config
  (counsel-mode)
)

(use-package ivy-rich
  :after ivy
  :config
  (ivy-rich-mode)
)

(global-display-line-numbers-mode -1)

(use-package which-key
  :diminish
  :config
  (which-key-mode)
)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-u-delete t)
  (setq evil-want-Y-yank-to-eol t)
  (setq evil-want-C-w-in-emacs-state t)
  :config
  (evil-mode 1)
)
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init)
)


(use-package helpful
  :custom
  (counsel-describe-function-function 'helpful-callable)
  (counsel-describe-variable-function 'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key)
)

(use-package general
  :after evil
  :config
  (general-evil-setup t)

  (general-create-definer luna/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC"
  )
  (global-set-key (kbd "<escape>") 'keyboard-escape-quit)

  (luna/leader-keys
    "." '(find-file :which-key ".")
    ":" '(counsel-M-x :which-key "M-x")
    ";" '(eval-expression :which-key "Eval Expression")
    "/" '(swiper :which-key "Swiper Search")
    "]" '(next-buffer :which-key "Next Buffer")
    "[" '(previous-buffer :which-key "Previous Buffer")
    "h" '(:ignore t :which-key "help")
    "h f" '(describe-function :which-key "Describe Function")
    "h k" '(describe-key :which-key "Describe Key")
    "h v" '(describe-variable :which-key "Describe Variable")

    "b" '(:ignore t :which-key "buffers")
    "b b" '(counsel-switch-buffer :which-key "Switch Buffer")
    "b ]" '(next-buffer :which-key "Next Buffer")
    "b [" '(previous-buffer :which-key "Previous Buffer")
    "b n" '(next-buffer :which-key "Next Buffer")
    "b p" '(previous-buffer :which-key "Previous Buffer")
    "b N" '(evil-buffer-new :which-key "New Buffer")
    "b d" '(kill-current-buffer :which-key "Kill Buffer")
    "b k" '(kill-current-buffer :which-key "Kill Buffer")
    "p" '(projectile-command-map :which-key "projectile")
    "p s" '(:ignore t :which-key "search")
    "p x" '(:ignore t :which-key "shell")

    "g" '(:ignore t :which-key "git")
    "g g" '(magit-status :which-key "Status")
    "-" '(dired :which-key "DirEd")
  )

  ;; Or :keymaps 'map-name
  ;(general-nmap org-mode-map "TAB" 'org-cycle)
  (general-imap "C-g" 'evil-normal-state)
  ;(general-imap term-mode-map "C-d" 'term-delchar-or-maybe-eof)
)

(use-package diminish)

(use-package hydra)
(use-package magit)
(use-package ivy-hydra
  :after hydra ivy)

(use-package projectile
  :diminish
  :config
  (projectile-mode)
)

(setq auth-sources '("~/.authinfo"))

(use-package forge
  :after magit)

(defun luna/org-mode-hook ()
  (org-indent-mode)
  (setq evil-auto-indent nil)
  
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  (dolist (face '((org-level-1 . 1.2)
		  (org-level-2 . 1.15)
		  (org-level-3 . 1.1)
		  (org-level-4 . 1.05)
		  (org-level-5 . 1.05)
		  (org-level-6 . 1.05)
		  (org-level-7 . 1.05)
		  (org-level-8 . 1.05)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))
  (face-remap-add-relative 'default 'org-default)
)
(defun luna/org-visual-fill ()
  (setq visual-fill-column-width 100
	visual-fill-column-center-text t)
  (visual-fill-column-mode 1)
)

(use-package org
  :hook (org-mode . luna/org-mode-hook)
  :config
  (setq org-ellipsis " ▼")
  (set-face-attribute 'org-block nil :foreground nil :weight 'bold :inherit '(fixed-pitch shadow))
  (set-face-attribute 'org-block-begin-line nil :weight 'bold :inherit '(fixed-pitch shadow))
  (set-face-attribute 'org-code nil :weight 'bold :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil :weight 'bold :inherit '(shadow fixed-pitch))
  ;(set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)
  (org-babel-do-load-languages
    'org-babel-load-languages
    '((emacs-lisp . t)
      (python . t)
      (js . t)
      )
  )
  (setq org-confirm-babel-evaluate nil)

  (require 'org-tempo)

  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("py" . "src python"))
  (add-to-list 'org-structure-template-alist '("js" . "src js"))
  
) 
		    


(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "⚬" "●" "○" "●" "○" "●"))
)

(use-package visual-fill-column
  :defer t
  :hook (org-mode . luna/org-visual-fill)
)

		
(font-lock-add-keywords 'org-mode
			'(("^ *\\([-]\\) "
			   (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

