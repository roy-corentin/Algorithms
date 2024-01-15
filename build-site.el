(require 'package)
(setq package-user-dir (expand-file-name "./.packages"))
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initialize the package system
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install dependencies
(package-install 'htmlize)

;; Load the publishing system
(require 'ox-publish)

;; Function to replace Roam links by IDs with links by locations
(defun replace-roam-links (text backend info)
  "Replace Roam links by IDs with links by locations."
  (when (org-export-derived-backend-p backend 'html)
    (replace-regexp-in-string "\\[\\[id:.*?\\/\\(.*?\\)\\]\\[.*?\\]\\]" "[[\\1]]" text)))

;; Add a custom filter to apply the replacement function
(add-to-list 'org-export-filter-link-functions 'replace-roam-links)

;; Customize the HTML output
(setq org-html-validation-link nil            ;; Don't show validation link
      org-html-head-include-scripts nil       ;; Use our own scripts
      org-html-head-include-default-style nil ;; Use our own styles
      org-html-head "<link rel=\"stylesheet\" href=\"https://cdn.simplecss.org/simple.min.css\" />")

;; Define the publishing project
(setq org-publish-project-alist
      '(("orgfiles"
         :recursive t
         :base-directory "./content"
         :publishing-function org-html-publish-to-html
         :publishing-directory "./public"
         :with-author nil
         :with-creator t
         :with-toc t
         :section-numbers nil
         :time-stamp-file nil)
        ("images"
         :base-directory "./img"
         :base-extension "png\\|jpg\\|svg\\|gif"
         :publishing-directory "./public/img"
         :publishing-function org-publish-attachment)
        ("org-site:main" :components("orgfiles" "images"))))

;; Generate the site output
(org-publish-all t)

(message "Build complete!")
