;;; eltimer.el --- eltimer is a simple timer. -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2026 jiro4989
;;
;; Author: jiro4989 <jiro4989@jiro4989>
;; Maintainer: jiro4989 <jiro4989@jiro4989>
;; Created: June 10, 2026
;; Modified: June 10, 2026
;; Version: 0.1.0
;; Keywords: tools
;; Homepage: https://github.com/jiro4989/eltimer
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;; eltimer is a simple timer that operates on the mode line.
;; Entering strings like 1h, 2m, or 3s will display the time on the mode line.
;; When the time is up, it will beep and shut down.
;;
;;; Code:

;; References:
;; - [[https://www.gnu.org/software/emacs/manual/html_node/elisp/Mode-Line-Variables.html][Mode Line Variables (GNU Emacs Lisp Reference Manual)]]
;; - [[https://www.gnu.org/software/emacs/manual/html_node/elisp/Defining-Functions.html#index-defun][Defining Functions (GNU Emacs Lisp Reference Manual)]]
;; - [[https://ayatakesi.github.io/emacs/24.5/elisp_html/Backquote.html][Backquote (GNU Emacs Lisp Reference Manual)]]
;; - [[https://w.atwiki.jp/elisp/pages/17.html][日付と時刻 - 逆引きEmacs Lisp]]

(defvar eltimer-timer-string " [00:00:00]")
(defvar eltimer-timer-object nil)
(defvar eltimer-timer-goal-unix-time 0)

(defun eltimer-number-to-time-format (n)
  "Format N seconds to time format (hh:mm:ss)."
  (format "%02d:%02d:%02d"
          (/ n 3600)
          (/ (% n 3600) 60)
          (% (% n 3600) 60)))

(defun eltimer-current-unix-time ()
  "Return current unix time seconds."
  (string-to-number (format-time-string "%s")))

(defun eltimer-get-number-with-regex (re str)
  "Get number from STR with RE."
  (when (string-match re str)
    (string-to-number (match-string 1 str))))

(defun eltimer-parse-string (str)
  "Parse a STR and return a time data."
  `(:hour ,(or (eltimer-get-number-with-regex "\\([0-9]+\\)[ \t]*h\\(ours\\)?" str) 0)
    :minute ,(or (eltimer-get-number-with-regex "\\([0-9]+\\)[ \t]*m\\(inutes\\)?" str) 0)
    :second ,(or (eltimer-get-number-with-regex "\\([0-9]+\\)[ \t]*s\\(conds\\)?" str) 0)))

(defun eltimer-time-to-seconds (time)
  "Convert TIME to seconds."
  (+ (* (plist-get time :hour) 3600)
     (* (plist-get time :minute) 60)
     (plist-get time :second)))

(defun eltimer-prompt ()
  "Open a prompt and read user input."
  (read-string "Enter timer (ex: 1h, 2m, 3s): "))

(defun eltimer-timer-update ()
  "Update a mode line timer."
  (let ((duration-seconds (- eltimer-timer-goal-unix-time (eltimer-current-unix-time))))
    (if (<= duration-seconds 0)
        (progn
          (cancel-timer eltimer-timer-object)
          (message "Time up!")
          (setq eltimer-timer-string "")
          (beep))
      (setq eltimer-timer-string
            (format " [%s]" (eltimer-number-to-time-format duration-seconds))))
    (force-mode-line-update t)))

(defun eltimer-set-mode-line ()
  "Set a timer variables to mode line."
  (add-to-list 'global-mode-string 'eltimer-timer-string t))

;;;###autoload
(defun eltimer-timer-start ()
  "Start eltimer."
  (interactive)
  (eltimer-set-mode-line)
  (setq eltimer-timer-goal-unix-time
        (+ (eltimer-current-unix-time)
           (eltimer-time-to-seconds (eltimer-parse-string (eltimer-prompt)))))
  ;; タイマーが二重起動しないようにキャンセルする
  (when eltimer-timer-object
    (cancel-timer eltimer-timer-object))
  (setq eltimer-timer-object
        (run-at-time 0 1 #'eltimer-timer-update)))

(provide 'eltimer)
;;; eltimer.el ends here
