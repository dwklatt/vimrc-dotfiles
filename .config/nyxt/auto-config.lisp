(define-configuration browser
  ((external-editor-program '("emacs"))))

(define-configuration browser
  ((session-restore-prompt :never-restore)))

(define-configuration (buffer web-buffer prompt-buffer)
  ((default-modes (append '(vi-normal-mode)
                          %slot-default%))))

(let ((bg "#242730")
      (fg "#bbc2cf")
      (mlbg "#2a2e38") ; modeline bg
      (mlfg "#C57BDB")
      (ml-highlight-fg "#FCCE7B")
      (h1 "#bbc2cf")
      (a "#51afef")
      (cursor "#51afef")
      (mb-prompt "#bbc2cf") ; minibuffer prompt
      (mb-separator "#C57BDB"))

  ;; minibuffer (bg and fg colors)
  (define-configuration prompt-buffer
      ((style
        (str:concat
         %slot-default%
         (cl-css:css
          `((body
             :border-top ,(str:concat "1px solid" mb-separator)
             :background-color ,bg
             :color ,fg)
            ("#input"
	     :background-color ,bg
             :color ,fg
             :border-bottom ,(str:concat "solid 1px " mb-separator))
            ("#cursor"
             :background-color ,cursor
             :color ,fg)
            ("#prompt"
             :color ,mb-prompt)
	    (".source-content"
	     :background-color ,bg)
	    (".source-content th"
	     :background-color ,bg)
	    ("#selection"
	     :background-color ,mlbg
	     :color ,mlfg)
            (.marked
             :background-color mlbg
             :color bg)
            (.selected
             :background-color mlfg
             :color bg)))))))

  (defun override (color)
    (concatenate 'string color " !important"))

  ;; internal buffers (help, list, etc)
  (define-configuration internal-buffer
      ((style
        (str:concat
         %slot-default%
         (cl-css:css
          `((body
             :background-color ,(override bg)
             :color ,(override fg))
            (hr
             :background-color ,(override bg)
             :color ,(override cursor))
            (.button
             :background-color ,(override mlbg)
             :color ,(override mlfg))
            (".button:hover"
             :color ,(override ml-highlight-fg))
            (".button:active"
             :color ,(override ml-highlight-fg))
            (".button:visited"
             :color ,(override ml-highlight-fg))
            (a
             :color ,(override a))
            (h1
             :color ,(override h1))
            (h2
             :color ,(override h1))
            (h3
             :color ,(override h1))
            (h4
             :color ,(override h1))
            (h5
             :color ,(override h1))
            (h6
             :color ,(override h1))))))))

  ;; status bar

  (defun loadingp (&optional (buffer (current-buffer)))
    (and (web-buffer-p buffer)
         (eq (slot-value buffer 'nyxt::load-status) :loading)))

  (hooks:add-hook nyxt/web-mode:scroll-to-top-after-hook
                  (hooks:make-handler-void #'nyxt::print-status))
  (hooks:add-hook nyxt/web-mode:scroll-to-bottom-after-hook
                  (hooks:make-handler-void #'nyxt::print-status))
  (hooks:add-hook nyxt/web-mode:scroll-page-up-after-hook
                  (hooks:make-handler-void #'nyxt::print-status))
  (hooks:add-hook nyxt/web-mode:scroll-page-down-after-hook
                  (hooks:make-handler-void #'nyxt::print-status))
  (hooks:add-hook nyxt/web-mode:scroll-down-after-hook
                  (hooks:make-handler-void #'nyxt::print-status))
  (hooks:add-hook nyxt/web-mode:scroll-up-after-hook
                  (hooks:make-handler-void #'nyxt::print-status))
  (hooks:add-hook nyxt/web-mode:scroll-to-top-after-hook
                  (hooks:make-handler-void #'nyxt::print-status))
  (hooks:add-hook nyxt/web-mode:scroll-to-bottom-after-hook
                  (hooks:make-handler-void #'nyxt::print-status))

(define-parenscript %percentage ()
  (defun percentage ()
    (let* ((height-of-window (ps:@ window inner-height))
           (content-scrolled (ps:@ window page-y-offset))
           (body-height (if (not (or (eql window undefined)
                                     (eql (ps:@ window document) undefined)
                                     (eql (ps:chain window
                                                    document
                                                    (get-elements-by-tag-name "body"))
                                          undefined)
                                     (eql (ps:chain window
                                                    document
                                                    (get-elements-by-tag-name "body")
                                                    0)
                                          undefined)
                                     (eql (ps:chain window
                                                    document
                                                    (get-elements-by-tag-name "body")
                                                    0
                                                    offset-height)
                                          undefined)))
                          (ps:chain window
                                    document
                                    (get-elements-by-tag-name "body")
                                    0
                                    offset-height)
                          0))
           (total (- body-height height-of-window))
           (prc (* (/ content-scrolled total) 100)))
      (if (> prc 100)
          100
          (round prc))))
  (percentage))

(define-command percentage ()
  "Echo percentage."
  (echo (%percentage)))

  (defun my-status-formatter (window)
    (let* ((buffer (current-buffer window))
           (buffer-count (1+ (or (position buffer
                                           (sort (buffer-list) #'string< :key #'id))
                                 0))))
      (markup:markup
       (:div :id "status-formatter"
             :style (str:concat "background-color:" mlbg "; color:" mlfg)
             (:b (str:concat "[ " (format-status-modes (nyxt::current-buffer)
						       (nyxt::current-window)) " ]"))
             (markup:raw
              (format nil " (~a/~a) "
                      buffer-count
                      (length (buffer-list)))
              (format nil "~a~a — ~a"
                      (if (and (web-buffer-p buffer)
                               (eq (slot-value buffer 'nyxt::load-status) :loading))
                          "(Loading) "
                          "")
                      (render-url (url buffer))
                      (title buffer)))
             (:span :id "percentage"
                    :style "float:right"
                    (format nil "~:[0~;~:*~a~]%" (%percentage)))))))

  (define-configuration window
      ((message-buffer-style
        (str:concat
         %slot-default%
         (cl-css:css
          `((body
             :background-color ,(override bg)
             :color ,(override fg))))))
       (status-formatter #'my-status-formatter))))



(define-configuration web-buffer
  ((default-modes (append
                   '(auto-mode
                     emacs-mode
                     blocker-mode
                     reduce-tracking-mode)
                   %slot-default%))))

(define-configuration buffer
  ((request-resource-hook (reduce #'hooks:add-hook
                                  (list (url-dispatching-handler
                                         'doi-link-dispatcher
                                         (match-scheme "doi")
                                         (lambda (url)
                                           (quri:uri (format nil "https://doi.org/~a"
                                                             (quri:uri-path url)))))
                                        (url-dispatching-handler
                                         'transmission-magnet-links
                                         (match-scheme "magnet")
                                         "transmission-remote --add ~a")
                                        (url-dispatching-handler
                                         'emacs-mail
                                         (match-scheme "mailto")
                                         "emacs --eval '(browse-url-mail \"~a\")'"
                                         ))
                                  :initial-value %slot-default%))))

(ql:quickload :slynk)
(define-command-global start-slynk (&optional (slynk-port *swank-port*))
    "Start a Slynk server that can be connected to, for instance, in
Emacs via SLY.
Warning: This allows Nyxt to be controlled remotely, that is, to execute
arbitrary code with the privileges of the user running Nyxt.  Make sure
you understand the security risks associated with this before running
this command."
    (slynk:create-server :port slynk-port :dont-close t)
    (echo "Slynk server started at port ~a" slynk-port))
(start-slynk)

(echo "Config Loaded.")