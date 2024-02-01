(require 'package)

(setq package-user-dir (expand-file-name "./.packages"))
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initialize the package system
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install dependencies
(package-install 'ox-hugo)
(package-install 'org-roam)

;; Load the installed packages
(require 'ox-hugo)
(require 'org-roam)

;; Set the directory for Roam notes
(setq org-directory "./content")
(setq org-roam-directory "./content")
(org-roam-update-org-id-locations)

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
