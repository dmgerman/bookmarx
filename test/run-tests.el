;;; run-tests.el --- Load every bmkx test file   -*- lexical-binding: t -*-

;;; Code:

(require 'bmkx-test-helper)

(dolist (f (directory-files (file-name-directory load-file-name) t
                            "\\`bmkx-test-.*\\.el\\'"))
  (unless (string-match-p "test-helper" f)
    (load f nil 'nomessage)))

(provide 'run-tests)
;;; run-tests.el ends here
