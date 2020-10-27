#lang racket

(require website-js
         website-js/components/l-system
         "imgs.rkt"
         "common.rkt")

(provide code-editors)

(define (code-editors)
  (page code-editors.html
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
                                        #:link "blocklyduino/index.html"
                                        (card-img-top class: "mb-2" src: (prefix/pathify blocklyduino-rokit-img))
                                        (h4 (b "Rokit Support for BlocklyDuino"))
                                        "A set of visual programming blocks for the Robolink Rokit Smart, a programmable robot kit, that generates Arduino code. Enable the the blocks first in the settings menu."
                                         )
                              (ibm-card #:class "h-100"
                                        #:link "https://github.com/aBlender/ardublockly/tree/arduboy_blocks"
                                        (card-img-top class: "mb-2" src: (prefix/pathify ardublockly-arduboy-img))
                                         (h4 (b "Arduboy Support for ArduBlockly"))
                                         "A set of visual programming blocks for the Arduboy, a credit card sized game system, that generates Arduino Code."
                                         ))
              (ibm-card #:class "mt-auto mb-4"
                        #:fit? #t
                        (p class: "m-0"
                           "This website was made using a DSL (domain specific language) written in Racket. See more details "
                           (a href: "https://github.com/aBlender/racket/tree/main/web-examples" (b "here")) "."))
              )))))