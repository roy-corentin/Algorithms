;; Define the package archives
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initialize the package system
(package-initialize)

;; Ensure 'use-package' is available
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Set up use-package for automatic package management
(eval-when-compile
  (require 'use-package))

;; Install and configure org-roam and ox-hugo
(use-package org-roam
  :ensure t
  :config
  (setq org-roam-directory "./content")
  (org-roam-update-org-id-locations))

(use-package ox-hugo
  :ensure t)

;; Mandatory
(setq org-directory "./content")

;; Add function to generate Hugo markdown files
(defun generate-hugo-notes ()
  "Generate Hugo markdown files from Roam notes using ox-hugo."
  (interactive)
  (let ((org-files (directory-files org-directory t "\.org$")))
    (dolist (org-file org-files)
      (with-current-buffer (find-file-noselect org-file)
        ;; Set the base directory for Hugo export
        (setq org-hugo-base-dir "../")
        (message "Generating Hugo markdown file for %s..." org-file)
        (org-hugo-export-to-md)))))

;; Generate Hugo markdown files from Roam notes
(generate-hugo-notes)

(message "Conversion to Hugo complete!")
