;;; eltimer-test.el --- Tests for eltimer.el -*- lexical-binding: t; -*-
;;
;;; Commentary:
;; Unit test for eltimer.el.
;;
;;; Code:

(require 'ert)
(require 'eltimer)

(ert-deftest eltimer-test-eltimer--number-to-time-format-1 ()
  (should (string= "00:00:01" (eltimer--number-to-time-format 1))))

(ert-deftest eltimer-test-eltimer--number-to-time-format-59 ()
  (should (string= "00:00:59" (eltimer--number-to-time-format 59))))

(ert-deftest eltimer-test-eltimer--number-to-time-format-60 ()
  (should (string= "00:01:00" (eltimer--number-to-time-format 60))))

(ert-deftest eltimer-test-eltimer--number-to-time-format-61 ()
  (should (string= "00:01:01" (eltimer--number-to-time-format 61))))

(ert-deftest eltimer-test-eltimer--number-to-time-format-3599 ()
  (should (string= "00:59:59" (eltimer--number-to-time-format 3599))))

(ert-deftest eltimer-test-eltimer--number-to-time-format-3600 ()
  (should (string= "01:00:00" (eltimer--number-to-time-format 3600))))

(ert-deftest eltimer-test-eltimer--number-to-time-format-3601 ()
  (should (string= "01:00:01" (eltimer--number-to-time-format 3601))))

(ert-deftest eltimer-test-eltimer--number-to-time-format-3661 ()
  (should (string= "01:01:01" (eltimer--number-to-time-format 3661))))

(ert-deftest eltimer-test-eltimer--parse-string-123 ()
  (should (equal '(:hour 1 :minute 2 :second 3) (eltimer--parse-string "1h 2m 3s"))))

(ert-deftest eltimer-test-eltimer--parse-string-123-no-space ()
  (should (equal '(:hour 1 :minute 2 :second 3) (eltimer--parse-string "1h2m3s"))))

(ert-deftest eltimer-test-eltimer--parse-string-hours ()
  (should (equal '(:hour 1 :minute 0 :second 0) (eltimer--parse-string "1 hours"))))

(ert-deftest eltimer-test-eltimer--parse-string-short-hours ()
  (should (equal '(:hour 10 :minute 0 :second 0) (eltimer--parse-string "10h"))))

(ert-deftest eltimer-test-eltimer--parse-string-minutes ()
  (should (equal '(:hour 0 :minute 2 :second 0) (eltimer--parse-string "2 minutes"))))

(ert-deftest eltimer-test-eltimer--parse-string-short-minutes ()
  (should (equal '(:hour 0 :minute 20 :second 0) (eltimer--parse-string "20m"))))

(ert-deftest eltimer-test-eltimer--parse-string-seconds ()
  (should (equal '(:hour 0 :minute 0 :second 33) (eltimer--parse-string "33 seconds"))))

(ert-deftest eltimer-test-eltimer--parse-string-short-seconds ()
  (should (equal '(:hour 0 :minute 0 :second 30) (eltimer--parse-string "30s"))))

(ert-deftest eltimer-test-eltimer--parse-string-0 ()
  (should (equal '(:hour 0 :minute 0 :second 0) (eltimer--parse-string ""))))

(ert-deftest eltimer-test-eltimer--parse-string-invalid ()
  (should (equal '(:hour 0 :minute 0 :second 0) (eltimer--parse-string "abcd"))))

(ert-deftest eltimer-test-eltimer--time-to-seconds-123 ()
  (should (= 3723 (eltimer--time-to-seconds '(:hour 1 :minute 2 :second 3)))))

(ert-deftest eltimer-test-eltimer--time-to-seconds-hour ()
  (should (= 3600 (eltimer--time-to-seconds '(:hour 1 :minute 0 :second 0)))))

(ert-deftest eltimer-test-eltimer--time-to-seconds-minute ()
  (should (= 120 (eltimer--time-to-seconds '(:hour 0 :minute 2 :second 0)))))

(ert-deftest eltimer-test-eltimer--time-to-seconds-second ()
  (should (= 3 (eltimer--time-to-seconds '(:hour 0 :minute 0 :second 3)))))

(ert-deftest eltimer-test-eltimer--get-number-with-regex-number ()
  (should (= 3 (eltimer--get-number-with-regex "\\([0-9]+\\)" "hello 3 world"))))

(ert-deftest eltimer-test-eltimer--get-number-with-regex-hours ()
  (should (= 1 (eltimer--get-number-with-regex "\\([0-9]+\\)[ \t]*h\\(ours\\)?" " 1 hours"))))

(ert-deftest eltimer-test-eltimer--get-number-with-regex-hours2 ()
  (should (= 2 (eltimer--get-number-with-regex "\\([0-9]+\\)[ \t]*h\\(ours\\)?" "2h"))))

(ert-deftest eltimer-test-eltimer--get-number-with-regex-hours3 ()
  (should (= 3 (eltimer--get-number-with-regex "\\([0-9]+\\)[ \t]*h\\(ours\\)?" "3\th"))))

(ert-deftest eltimer-test-eltimer-timer-stop ()
  (let ((eltimer--timer-goal-unix-time 999999))
    (should (= 999999 eltimer--timer-goal-unix-time))
    (eltimer-timer-stop)
    (should (= 0 eltimer--timer-goal-unix-time))))

(provide 'eltimer-test)
;;; eltimer-test.el ends here
