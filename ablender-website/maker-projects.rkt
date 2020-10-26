#lang racket

(require website-js
         website-js/components/l-system
         "imgs.rkt"
         "common.rkt")

(provide maker-projects)

(define (maker-projects)
  (page maker.html
        (content #:head (list (include-p5-js))
                 (main-style)
                 (main-navbar #:active-index 1)
                 (div id: "main"
    (l-system #:x "p.width/3"      ;"240"
              #:y "p.height/3*2"
              #:start-angle -150
              #:step 18
              #:angle 90
              #:axiom "FX"
              #:loops 16
              #:rules (list (cons "X" "X+YF+")
                            (cons "Y" "-FX-Y"))
              #:bg-color "#041109" ;"#343a40"
              #:line-color "rgba(0,255,128,0.4)"
              #:max-radius 0
              class: "p-3 pt-5 card bg-transparent mb-0 text-center"
              style: (properties height: "100vh")
              (responsive-row #:columns 3 #:justify? #t
                              (ibm-card #:class "h-100"
                                        #:link "https://youtu.be/oJ98h3CaXP0"
                                        (card-img-top class: "mb-2" src: (prefix/pathify starwars-arena-img))
                                        (h4 (b "Star Wars Blaster Arena"))
                                        "Star Wars themed IR shooting gallery coded with Microsoft MakeCode on a Circuit Playground Express micro-controller and crafted using paper, cardstock, cardboard, and paint."
                                         )
                              (ibm-card #:class "h-100"
                                        #:link "https://github.com/aBlender/arduino/tree/main/GemmaPendant"
                                        (card-img-top class: "mb-2" src: (prefix/pathify 8bit-pendants-img))
                                         (h4 (b "8-Bit Gemma Pendants"))
                                         "Wearable Arduino Gemma based pendant that cycles through 3 custom animations at timed intervals or via button presses."
                                         )
                              (ibm-card #:class "h-100"
                                        #:link "https://youtu.be/E8-iBMkCRxE?t=19"
                                        (card-img-top class: "mb-2" src: (prefix/pathify minecraft-spider-bot-img))
                                         (h4 (b "Minecraft Controlled Spider Bots"))
                                         "A Raspberry Pi running a LearnToMod Minecraft server takes player inputs and sends IR signals to control a Battle Spider Bot."
                                         ))
             
              (ibm-card #:class "mt-auto mb-4"
                        #:fit? #t
                        (p class: "m-0"
                           "This website was made using a DSL (domain specific language) written in Racket. See more details "
                           (a href: "https://github.com/aBlender/racket/tree/main/web-examples" (b "here")) "."))
              )))))