#lang at-exp racket

(provide index)

(require website-js
         website-js/components/l-system
         "imgs.rkt"
         "common.rkt"
         )

(define (type-lines string-list)
  (define js-string-list
    (~a "['" (apply ~a string-list #:separator "', '") "']"))
  (div id: "typeText"
  @script/inline{
 var linesArray = @js-string-list;
 var lineTimer;
 var lineIndex = 0;
 var charArray;
 var charTimer;

 function nextChar(){
  if (charArray.length > 0){
   document.getElementById("typeText").innerHTML += charArray.shift();
   } else {
   clearTimeout(charTimer);
   lineIndex++;
   lineTimer = setTimeout('nextLine()', Math.floor(Math.random() * 4000) + 2000);
   return false;
  }
  charTimer = setTimeout('nextChar()', Math.floor(Math.random() * 200) + 100);
 }
 
 function nextLine(){
  document.getElementById("typeText").innerHTML = "";
  var myLine = linesArray[lineIndex];
  if (lineIndex < linesArray.length){
   charArray = myLine.split("");
   nextChar();
   } else {
   lineIndex = 0;
   lineTimer = setTimeout('nextLine()', Math.floor(Math.random() * 4000) + 2000);
   return false;
  }
 }
 
 nextLine();
}))

(define (index)
  (page index.html
        (content #:head (list (include-p5-js))
                 (main-style)
                 (main-navbar #:active-index 0)
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
              (ibm-card #:class "h4 mt-auto mb-2"
                        #:max-width "640px"
                        (div class: "aspect aspect-4x3"
                             (div class: "aspect-inner p-4"
                                  (type-lines (list "Wake up, Neo. . ."
                                                    "The Matrix has you. . ."
                                                    "Follow the white rabbit."
                                                    "Knock, knock, Neo.")))))
              (ibm-card #:class "mt-auto mb-4"
                        #:fit? #t
                        (p class: "m-0"
                           "This website was made using a DSL (domain specific language) written in Racket. See more details "
                           (a href: "https://github.com/aBlender/racket/tree/main/web-examples" (b "here")) "."))
               )))))
