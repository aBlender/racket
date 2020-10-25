#lang at-exp racket

(require website-js
         racket/runtime-path)

; === NAV ICONS ===
(provide imgs-list
         home-icon
         tool-icon
         game-icon
         blockly-icon
         vr-icon
         about-icon)
         
(define (nav-icon inner)
  (span class: "pr-1 align-middle"
        inner))

(define (home-icon)
  (nav-icon @html/inline{
 <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" width="16" height="16"><path fill-rule="evenodd" d="M8.156 1.835a.25.25 0 00-.312 0l-5.25 4.2a.25.25 0 00-.094.196v7.019c0 .138.112.25.25.25H5.5V8.25a.75.75 0 01.75-.75h3.5a.75.75 0 01.75.75v5.25h2.75a.25.25 0 00.25-.25V6.23a.25.25 0 00-.094-.195l-5.25-4.2zM6.906.664a1.75 1.75 0 012.187 0l5.25 4.2c.415.332.657.835.657 1.367v7.019A1.75 1.75 0 0113.25 15h-3.5a.75.75 0 01-.75-.75V9H7v5.25a.75.75 0 01-.75.75h-3.5A1.75 1.75 0 011 13.25V6.23c0-.531.242-1.034.657-1.366l5.25-4.2h-.001z"></path></svg>
 }))

(define (tool-icon)
  (nav-icon @html/inline{
 <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" width="16" height="16"><path fill-rule="evenodd" d="M5.433 2.304A4.494 4.494 0 003.5 6c0 1.598.832 3.002 2.09 3.802.518.328.929.923.902 1.64v.008l-.164 3.337a.75.75 0 11-1.498-.073l.163-3.33c.002-.085-.05-.216-.207-.316A5.996 5.996 0 012 6a5.994 5.994 0 012.567-4.92 1.482 1.482 0 011.673-.04c.462.296.76.827.76 1.423v2.82c0 .082.041.16.11.206l.75.51a.25.25 0 00.28 0l.75-.51A.25.25 0 009 5.282V2.463c0-.596.298-1.127.76-1.423a1.482 1.482 0 011.673.04A5.994 5.994 0 0114 6a5.996 5.996 0 01-2.786 5.068c-.157.1-.209.23-.207.315l.163 3.33a.75.75 0 11-1.498.074l-.164-3.345c-.027-.717.384-1.312.902-1.64A4.496 4.496 0 0012.5 6a4.494 4.494 0 00-1.933-3.696c-.024.017-.067.067-.067.16v2.818a1.75 1.75 0 01-.767 1.448l-.75.51a1.75 1.75 0 01-1.966 0l-.75-.51A1.75 1.75 0 015.5 5.282V2.463c0-.092-.043-.142-.067-.159zm.01-.005z"></path></svg>
 }))

(define (game-icon)
  (nav-icon @html/inline{
 <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" width="16" height="16"><path fill-rule="evenodd" d="M0 2.75C0 1.784.784 1 1.75 1h12.5c.966 0 1.75.784 1.75 1.75v10.5A1.75 1.75 0 0114.25 15H1.75A1.75 1.75 0 010 13.25V2.75zm1.75-.25a.25.25 0 00-.25.25v10.5c0 .138.112.25.25.25h12.5a.25.25 0 00.25-.25V2.75a.25.25 0 00-.25-.25H1.75zM7.25 8a.75.75 0 01-.22.53l-2.25 2.25a.75.75 0 11-1.06-1.06L5.44 8 3.72 6.28a.75.75 0 111.06-1.06l2.25 2.25c.141.14.22.331.22.53zm1.5 1.5a.75.75 0 000 1.5h3a.75.75 0 000-1.5h-3z"></path></svg>
 }))

(define (blockly-icon)
  (nav-icon @html/inline{
 <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" width="16" height="16"><path fill-rule="evenodd" d="M1.75 1A1.75 1.75 0 000 2.75v4c0 .372.116.717.314 1a1.742 1.742 0 00-.314 1v4c0 .966.784 1.75 1.75 1.75h12.5A1.75 1.75 0 0016 12.75v-4c0-.372-.116-.717-.314-1 .198-.283.314-.628.314-1v-4A1.75 1.75 0 0014.25 1H1.75zm0 7.5a.25.25 0 00-.25.25v4c0 .138.112.25.25.25h12.5a.25.25 0 00.25-.25v-4a.25.25 0 00-.25-.25H1.75zM1.5 2.75a.25.25 0 01.25-.25h12.5a.25.25 0 01.25.25v4a.25.25 0 01-.25.25H1.75a.25.25 0 01-.25-.25v-4zm5.5 2A.75.75 0 017.75 4h4.5a.75.75 0 010 1.5h-4.5A.75.75 0 017 4.75zM7.75 10a.75.75 0 000 1.5h4.5a.75.75 0 000-1.5h-4.5zM3 4.75A.75.75 0 013.75 4h.5a.75.75 0 010 1.5h-.5A.75.75 0 013 4.75zM3.75 10a.75.75 0 000 1.5h.5a.75.75 0 000-1.5h-.5z"></path></svg>
 }))

(define (vr-icon)
  (nav-icon @html/inline{
 <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" width="16" height="16"><path fill-rule="evenodd" d="M14.064 0a8.75 8.75 0 00-6.187 2.563l-.459.458c-.314.314-.616.641-.904.979H3.31a1.75 1.75 0 00-1.49.833L.11 7.607a.75.75 0 00.418 1.11l3.102.954c.037.051.079.1.124.145l2.429 2.428c.046.046.094.088.145.125l.954 3.102a.75.75 0 001.11.418l2.774-1.707a1.75 1.75 0 00.833-1.49V9.485c.338-.288.665-.59.979-.904l.458-.459A8.75 8.75 0 0016 1.936V1.75A1.75 1.75 0 0014.25 0h-.186zM10.5 10.625c-.088.06-.177.118-.266.175l-2.35 1.521.548 1.783 1.949-1.2a.25.25 0 00.119-.213v-2.066zM3.678 8.116L5.2 5.766c.058-.09.117-.178.176-.266H3.309a.25.25 0 00-.213.119l-1.2 1.95 1.782.547zm5.26-4.493A7.25 7.25 0 0114.063 1.5h.186a.25.25 0 01.25.25v.186a7.25 7.25 0 01-2.123 5.127l-.459.458a15.21 15.21 0 01-2.499 2.02l-2.317 1.5-2.143-2.143 1.5-2.317a15.25 15.25 0 012.02-2.5l.458-.458h.002zM12 5a1 1 0 11-2 0 1 1 0 012 0zm-8.44 9.56a1.5 1.5 0 10-2.12-2.12c-.734.73-1.047 2.332-1.15 3.003a.23.23 0 00.265.265c.671-.103 2.273-.416 3.005-1.148z"></path></svg>
 }))

(define (about-icon)
  (nav-icon @html/inline{
 <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" width="16" height="16"><path fill-rule="evenodd" d="M10.5 5a2.5 2.5 0 11-5 0 2.5 2.5 0 015 0zm.061 3.073a4 4 0 10-5.123 0 6.004 6.004 0 00-3.431 5.142.75.75 0 001.498.07 4.5 4.5 0 018.99 0 .75.75 0 101.498-.07 6.005 6.005 0 00-3.432-5.142z"></path></svg>
 }))

; === IMAGES ===
(define-runtime-path img "img")

(define imgs-list
  '())

(define-syntax-rule (define/provide/img img-path path)
  (begin
    (provide img-path)
    (define img-path path)
    (set! imgs-list
          (append imgs-list
                  (list (page img-path
                              (apply build-path
                                     (append (list img)
                                             (drop img-path 1))))
                        )))                                           
    ))

(define/provide/img starwars-arena-img (list "img" "maker" "starwars-arena.jpg"))
(define/provide/img 8bit-pendants-img (list "img" "maker" "8bit-pendants.jpg"))
(define/provide/img minecraft-spider-bot-img (list "img" "maker" "minecraft-spider-bot.jpg"))

(define/provide/img pong-img (list "img" "game-dev" "pong.png"))
(define/provide/img brick-breaker-img (list "img" "game-dev" "brick-breaker.png"))
(define/provide/img arduboy-pong-img (list "img" "game-dev" "arduboy-pong.jpg"))
(define/provide/img arduboy-brick-breaker-img (list "img" "game-dev" "arduboy-brick-breaker.jpg"))