;;; eltimer.el --- eltimer is a simple timer. -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2026 jiro4989
;;
;; Author: jiro4989 <jiro4989@jiro4989>
;; Maintainer: jiro4989 <jiro4989@jiro4989>
;; Created: June 10, 2026
;; Modified: June 10, 2026
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex text tools unix vc wp
;; Homepage: https://github.com/jiro4989/eltimer
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;; Test.
;;
;;; Code:

;; References:
;; - [[https://www.gnu.org/software/emacs/manual/html_node/elisp/Mode-Line-Variables.html][Mode Line Variables (GNU Emacs Lisp Reference Manual)]]
;; - [[https://www.gnu.org/software/emacs/manual/html_node/elisp/Defining-Functions.html#index-defun][Defining Functions (GNU Emacs Lisp Reference Manual)]]
;; - [[https://ayatakesi.github.io/emacs/24.5/elisp_html/Backquote.html][Backquote (GNU Emacs Lisp Reference Manual)]]
;; - [[https://w.atwiki.jp/elisp/pages/17.html][日付と時刻 - 逆引きEmacs Lisp]]

(defvar eltimer-timer-string " test")

(defun eltimer-number-to-time-format (n)
  "Format N seconds to time format (hh:mm:ss)."
  (format "%02d:%02d:%02d"
          (/ n 3600)
          (/ (% n 3600) 60)
          (% (% n 3600) 60)))

(defun eltimer-current-time-seconds ()
  "Return current unix time seconds."
  (string-to-number (format-time-string "%s")))

(defun eltimer-parse-string (str)
  "Parse a STR and return a time data."
  `(:hour ,(when (string-match "\\([0-9]+\\)\s*h\\(ours\\)?" str)
             (string-to-number (match-string 0 str)))
    :minute ,(when (string-match "\\([0-9]+\\)\s*m\\(inutes\\)?" str)
               (string-to-number (match-string 0 str)))
    :second ,(when (string-match "\\([0-9]+\\)\s*s\\(conds\\)?" str)
               (string-to-number (match-string 0 str)))))

(defun eltimer-time-to-seconds (time)
  "Convert TIME to seconds."
  (+ (* (plist-get time :hour) 3600)
     (* (plist-get time :minute) 60)
     (plist-get time :second)))

; TODO: ミニバッファからテキストを受けとる。
; TODO: タイマーでモードラインを自動更新する

; (add-to-list 'global-mode-string 'eltimer-timer-string t)

(provide 'eltimer)
;;; eltimer.el ends here
