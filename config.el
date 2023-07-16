;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Jesse Herrick"
      user-mail-address "jesse@remote.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Office Code Pro D" :size 18 :weight 'normal))
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!
;;
;; Set line height and center the text in the new line height
(setq-default default-text-properties '(line-spacing 0.25 line-height 1.25))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

(add-to-list 'exec-path "~/code/elixir-ls/release")
(setq evil-escape-key-sequence "ht") ;; change this if you don't use dvorak
(setq lsp-elixir-suggest-specs nil)
(setq lsp-elixir-mix-env "dev")
(setq lsp-elixir-dialyzer-enabled nil)
(setq lsp-elixir-signature-after-complete nil)
(setq lsp-elixir-ls-server-dir "~/code/elixir-ls/release")
(setq lsp-enable-file-watchers nil)
(setq lsp-elixir-fetch-deps t)
;; (setq lsp-elixir-ls-version "0.15.1")

(setq evil-snipe-smart-case t
      evil-snipe-scope 'whole-buffer
      evil-snipe-repeat-scope 'whole-buffer
      evil-snipe-char-fold t)

(setq projectile-sort-order 'recently-active)

(menu-bar-mode -1)

;; Emacs 29 Weirdness
(setq text-quoting-style 'grave)

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(map! :leader
      ;; "u" 'evil-undo
      "fs" 'save-buffer
      ;; "s"  'save-buffer
      ;; "pf" 'projectile-find-file
      ;; ":"  'execute-extended-command
      ;; "/"  'counsel-projectile-rg
      "y"  'copy-project-file-to-clipboard
      ;; "y" 'copy-file-name-to-clipboard

      ;; convenience
      "cl" 'evilnc-comment-or-uncomment-lines

      ;; quick open
      "on" 'open-todo-list

      ;; git
      "gb" 'magit-blame
      "gg" 'magit

      ;; lsp
      "va" 'lsp-find-definition
      "vo" 'lsp-find-references

      ;; treemacs
      ;; "TAB" 'treemacs

      ;; window movement
      "|" 'split-window-right
      "q" 'evil-window-delete
      "1" 'evil-window-left
      "2" 'evil-window-right
      "j" 'evil-window-down
      "k" 'evil-window-up
      "ne" 'flycheck-next-error
      "TAB" 'treemacs
      )

(map!
 "C-c C-f" 'exunit-toggle-file-and-test
 "C-c C-t" 'exunit-toggle-file-and-test
 )

;; Elixir Tree-Sitter Mode

(after! elixir-ts-mode
  (add-hook 'elixir-ts-mode-hook #'lsp)
  (require 'smartparens-elixir)
  )

(with-eval-after-load 'elixir-ts-mode '(require 'smartparens-elixir))

(with-eval-after-load 'lsp-mode
  (setq lsp-language-id-configuration
        (append lsp-language-id-configuration
                '((elixir-ts-mode . "elixir")
                  (heex-ts-mode . "elixir"))))
  )

(defun copy-file-name-to-clipboard ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (kill-new filename)
      (message "Copied buffer file name '%s' to the clipboard." filename))))

(defun copy-project-file-to-clipboard ()
  "Copy the current buffer file name (local to the project) to the clipboard."
  (interactive)

  (let ((filename (string-replace (projectile-project-root) "" (buffer-file-name))))
    (when filename
      (kill-new filename)
      (message "Copied buffer file name '%s' to the clipboard." filename)
      ))
  )

(defun get-ex-test-file ()
  (replace-regexp-in-string "\.ex$" "_test.exs" (replace-regexp-in-string "lib\/" "test/" (buffer-file-name)))
  )

(defun get-ex-module-file()
  (replace-regexp-in-string "test\/" "lib/" (replace-regexp-in-string "_test\.exs$" ".ex" (buffer-file-name)))
  )

(defun create-ex-test-file ()
  "Makes a new Elixir test file given the current module file."
  (interactive)

  (setq test-file (get-ex-test-file))

  (create-file-buffer test-file)
  (find-file test-file)
  )

(defun create-ex-module-file ()
  "Makes or finds an Elixir module file given the current test file."
  (interactive)

  (setq module-file (get-ex-module-file))

  (create-file-buffer module-file)
  (find-file module-file)
  )

(defun open-todo-list ()
  "Opens the main org mode todo list."
  (interactive)
  (find-file "~/org/main.org")
  )

;; ORG

(map! :map 'org-mode-map
      :n "T" 'org-insert-todo-heading-respect-content)

(map! :leader
      :map 'org-mode-map
      "rf" 'org-refile)

(map! :leader
      :map 'elixir-ts-mode-map
      "mtv" 'exunit-verify
      "mts" 'exunit-verify-single
      "mtr" 'exunit-rerun)

;; General useful editing bindings
(map! :v "C-c C-c" 'fill-region)

;; (add-hook 'org-mode-hook
;;   (lambda ()
;;     (define-key evil-normal-state-local-map (kbd "TAB") 'org-cycle)
;;     (define-key evil-normal-state-local-map (kbd "T") 'org-insert-todo-heading-respect-content)
;;     (define-key evil-normal-state-local-map (kbd "<<") 'org-promote-subtree)
;;     (define-key evil-normal-state-local-map (kbd ">>") 'org-demote-subtree)
;;     (define-key evil-insert-state-local-map (kbd "RET") 'org-meta-return)
;;     (evil-org-mode)
;;     (visual-line-mode)
;;   )
;; )

;; (evil-leader/set-key-for-mode 'org-mode
;;   "m t" 'org-set-tags
;;   "m d" 'org-deadline
;;   "m i" 'org-clock-in
;;   "m o" 'org-clock-out
;;   "m p" 'org-pomodoro
;;   "m l" 'org-insert-link-at-end
;;   "r f" 'org-refile
;;   "<"   'org-promote-subtree
;;   ">"   'org-demote-subtree
;;   )


(setq org-todo-keywords
      '((sequence "TODO(t)" "IN PROGRESS(i)" "WAITING(w)" "IN REVIEW(r)" "|" "DONE(d)")))

(setq org-todo-keyword-faces
      '(("TODO" . "red")
        ("IN PROGRESS" . (:foreground "green" :background "black" :weight bold))
        ("WAITING" . "orange")
        ("IN REVIEW" . "yellow")
        ("DONE" . "green")
        ("LOGGED" . (:foreground "black" :background "green" :weight bold))
        ("FEATURE" . (:foreground "orange" :weight bold))
        ("CANCELED" . (:foreground "blue" :weight bold))))

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/org/main.org" "* Inbox")
         "** TODO %?\n  %i\n  %a")))

(defun rename-current-buffer-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let* ((name (buffer-name))
         (filename (buffer-file-name))
         (basename (file-name-nondirectory filename)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " (file-name-directory filename) basename nil basename)))
        (if (get-buffer new-name)
            (error "A buffer named '%s' already exists!" new-name)
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil)
          (message "File '%s' successfully renamed to '%s'"
                   name (file-name-nondirectory new-name)))))))
