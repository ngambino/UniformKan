
(fset 'latex-replace-outside-math
      `(lambda (regexp to-string &optional delimited start end backward)
     "Like `query-replace-regexp' but only replaces outside of LaTeX-math environments."
     ,(interactive-form 'query-replace-regexp)
     (let ((replace-re-search-function (lambda (regexp bound noerror)
                         (catch :found
                           (while (let ((ret (re-search-forward regexp bound noerror)))
                            (unless (save-match-data (texmathp)) (throw :found ret))
                            ret))))))
       (query-replace-regexp regexp to-string delimited start end backward))))

(defun remove-double-whitespace-outside-math () ""
  (interactive)
  (latex-replace-outside-math " \\{2,\\}" " "))

(defun remove-trailing-whitespace () ""
  (interactive)
  (beginning-of-buffer)
  (replace-regexp " +\n" "\n"))

(defun remove-initial-whitespace () ""
  (interactive)
  (latex-replace-outside-math "^ +" ""))

(defun add-linebreak-after-period () ""
  (interactive)
  (latex-replace-outside-math "\\. +\\([^\n]\\)" ".\n\\1"))

(defun remove-linebreak-in-sentence () ""
  (interactive)
  (latex-replace-outside-math "\\([^]\n.]\\|[^\\][][]\\)\n\\([^\n\\]\\|\\\\[^][]\\)" "\\1 \\2"))

					; "\\([^]\n.]|[^\\]\\]\\)\n\\([^\n\\]|\\\\[^[]\\)"

(fset 'latex-replace-inside-math
      `(lambda (regexp to-string &optional delimited start end backward)
     "Like `query-replace-regexp' but only replaces inside of LaTeX-math environments."
     ,(interactive-form 'query-replace-regexp)
     (let ((replace-re-search-function (lambda (regexp bound noerror)
                         (catch :found
                           (while (let ((ret (re-search-forward regexp bound noerror)))
                            (when (save-match-data (texmathp)) (throw :found ret))
                            ret))))))
       (query-replace-regexp regexp to-string delimited start end backward))))

(defun yoneda-inside-math () ""
  (interactive)
  (latex-replace-inside-math "\\([^cx]\\)y" "\\1\\\\yon"))

(defun insert-xmatrix ()
  "Insert xmatrix fragment."
  (interactive)
  (insert (concat "\\[\n"
                  "\\xymatrix{\n"
                  "&\n"
                  "\\\\\n"
                  "&\n"
                  "}\n"
                  "\\]\n")))

(defun insert-equation-xmatrix ()
  "Insert xmatrix fragment in a labelled equation environment."
  (interactive)
  (insert (concat "\\begin{equation}\n"
                  "\\label{}\n"
                  "\\begin{gathered}\n"))
  (insert-xmatrix)
  (insert (concat "\\end{gathered}\n"
                  "\\end{equation}\n")))




-- paragraph style makes multi-paragraph examples and definitions less readable
-- : vs co.

-- Leibniz product vs. Leibniz tensor 

changes:
- the pushforward -> pushforward
- the category of cubical sets -> a category
- left-hand side vs. left
- generalization vs generalistion
- factorization vs factorisation
- emphasized vs emphasised
- spacing
- comma before since, as
- comma use in enumerations
- hfill vs leavemode (hyperref)
- medskip
- y vs yon
- punctuation and references
- omega -> finitely
- swapped subsections in presheaf section
- right orthogonal
- where do we assume limits for E
- comma before diagrams
- elements vs objects of a category
- dom macro
- BC flaw
- lookup usage of Frobenius terminology
- Coquand fibrations

todo:
- decidable monomorphism

