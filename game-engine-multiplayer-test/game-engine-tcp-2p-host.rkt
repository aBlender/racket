#lang racket

(require game-engine
         game-engine-demos-common)

(define the-listener (tcp-listen 9876))
(define input-msg #f)
(define REMOTE-IP #f)
(define TCP-DELAY 1)

(define (new-message? g e)
  (not (not input-msg)))

(define (get-input)
  (define-values (in out) (tcp-accept/enable-break the-listener))
  (define-values (local-ip remote-ip) (tcp-addresses in))
  (set! REMOTE-IP remote-ip)
  (set! input-msg (read/recursive in)))

(define tcp-thread (thread get-input))

(define (check-input-thread g e)
  (if (thread-running? tcp-thread)
      e
      (begin (set! tcp-thread (thread get-input))
             e))
  )

(define (kill-input-thread g e)
  (if (thread-running? tcp-thread)
      (begin (displayln "==== KILLING INPUT THREAD ====")
             (kill-thread tcp-thread)
             e)
      e))

(define (dir-pos? dp-list)
  (and (list? dp-list)
       (number? (first dp-list))
       (posn? (second dp-list))))

(define (process-input g e)
  (define input input-msg)
  ;(displayln (~a "INPUT: " input))
  (set! input-msg #f)
  (cond [(and (string? input)
              (equal? input "request-posn")) (~> e
                                                 ((send-message (get-posn e)) g _)
                                                 (add-components _ (toast-system "POSN SENT"
                                                                                 #:duration 30
                                                                                 #:speed 1)))]
        [(string? input) (~> e
                             ;((send-message "MESSAGE RECEIVED") g _)
                             (add-components _ (toast-system input
                                                             #:duration 30
                                                             #:speed 1)))]
        [(posn? input) (update-entity e posn? input)]
        [(number? input) ((set-direction input) g e)]
        [(dir-pos? input) (~> e
                              ((set-direction (first input)) g _)
                              (update-entity _ posn? (second input)))]
        [else e]))

(define (send-message msg)
  (lambda (g e)
    (define-values (in out) (tcp-connect/enable-break REMOTE-IP 6789))
    (write msg out)
    (flush-output out)
    (close-input-port in)
    (close-output-port out)
    e))

(define (say-message msg)
  (lambda (g e)
    (~> e
        (add-components _ (toast-system msg
                                        #:duration 30
                                        #:speed 1))
        ((send-message msg) g _))))

(define (send-pos g e)
  (define current-pos (get-posn e))
  ((send-message current-pos) g e))

(define (send-dir g e)
  (define current-dir (get-direction e))
  ((send-message current-dir) g e))

(define (send-dir-pos g e)
  (define current-dir (get-direction e))
  (define current-pos (get-posn e))
  ((send-message (list current-dir (posn (exact-round (posn-x current-pos))
                                         (exact-round (posn-y current-pos))))) g e))

(start-game #:x 'left
 (sprite->entity (set-animate? #t (random-character-sprite))
                 #:name "player"
                 #:position (posn 50 100)
                 #:components (physical-collider)
                              (key-movement 5)
                              (key-animator-system)
                              (do-every TCP-DELAY #:rule (and/r (λ (g e) REMOTE-IP)
                                                                (not/r new-message?)
                                                                moving?)
                                        send-dir-pos)
                              (on-key 'space
                                      #:rule (λ (g e) REMOTE-IP)
                                      (say-message "Hello!"))
                              )
 (sprite->entity (set-animate? #t (random-character-sprite))
                 #:name "remote-player"
                 #:position (posn 150 100)
                 #:components (physical-collider)
                              (direction 180)
                              (rotation-style 'left-right)
                              (do-every TCP-DELAY #:rule new-message? process-input)
                              ;(observe-change new-message? (if/r new-message?
                              ;                                   process-input))
                              )
 (sprite->entity (bordered-box-sprite 200 200)
                 #:name "bg"
                 #:position (posn 0 0)
                 #:components (every-tick check-input-thread)
                              (on-key 'k kill-input-thread)))

; ==== NETWORKING CLEANUP ====
(displayln "==== CLOSING TCP CONNECTION ===")
(kill-thread tcp-thread)
(tcp-close the-listener)