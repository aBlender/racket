#lang at-exp racket

(provide l-system)

(require website-js)

(define (rules->js rule-list)
  (define (rule->js rule)
    (~a "['" (car rule) "', '" (cdr rule) "']"))
  (~a "["
      (apply (curry ~a #:separator ",") (map rule->js rule-list))
      "]"))

(define (l-system #:x [x 0]
                  #:y [y "p.height-1"]
                  #:start-angle [start-angle 0]
                  #:step [step 100]
                  #:angle [angle -60]
                  #:axiom [axiom "A"]
                  #:loops [loops 6]
                  #:rules [rules (list (cons "A" "BF-AF-B")
                                       (cons "B" "AF+BF+A"))]
                  #:max-radius [max-radius 64]
                  #:line-color [line-color "rgba(100,100,100,0.2)"]
                  #:bg-color [bg-color "white"]
                  . content)
  (enclose
   (apply div (flatten (list id: (id 'main)
                             content
                             @style/inline{
 @(id# 'canvas) {
  position:absolute;
  top:0;
  left:0;
  width:100%;
  height:100%;
  z-index:-1;
 }
})))
   (l-system-script x y start-angle step angle axiom loops rules max-radius line-color bg-color)
   ))

(define (l-system-script x
                         y
                         start-angle
                         step
                         angle
                         axiom
                         loops
                         rules
                         max-radius
                         line-color
                         bg-color)
  @script/inline{
 var @(id 'isMobile) = {
            Android: function () {
                return navigator.userAgent.match(/Android/i);
            },
            BlackBerry: function () {
                return navigator.userAgent.match(/BlackBerry/i);
            },
            iOS: function () {
                return navigator.userAgent.match(/iPhone|iPad|iPod/i);
            },
            Opera: function () {
                return navigator.userAgent.match(/Opera Mini/i);
            },
            Windows: function () {
                return navigator.userAgent.match(/IEMobile/i);
            },
            any: function () {
                return (@(id 'isMobile).Android() || @(id 'isMobile).BlackBerry() || @(id 'isMobile).iOS() || @(id 'isMobile).Opera() || @(id 'isMobile).Windows());
            }
        };
 var @(id 'sketch) = function(p){
  // TURTLE STUFF:
  let x, y; // the current position of the turtle
  let currentangle = @start-angle; // which way the turtle is pointing
  let step = @step; // how much the turtle moves with each 'F'
  let angle = @angle; // how much the turtle turns with a '-' or '+'

  // LINDENMAYER STUFF (L-SYSTEMS)
  let thestring = '@axiom'; // "axiom" or start of the string
  let numloops = @loops; // how many iterations to pre-compute
  let therules = @(rules->js rules); // array for rules

  let whereinstring = 0; // where in the L-system are we?

  p.setup = function() {
   //var canvas = p.createCanvas(p.windowWidth, p.windowHeight);
   var parent = document.getElementById("@(id 'main)");
   var canvas = p.createCanvas(parent.offsetWidth, parent.offsetHeight);
   
   canvas.id('@(id 'canvas)');
   //canvas.style('display','block');
   canvas.parent("@(id 'main)");
   
   p.background('@bg-color');
   p.stroke('@line-color');

   // start the x and y position at lower-left corner
   x = @x;
   y = @y;

   // COMPUTE THE L-SYSTEM
   for (let i = 0; i < numloops; i++) {
    thestring = lindenmayer(thestring);
   }
  }

  p.draw = function() {

   // draw the current character in the string:
   drawIt(thestring[whereinstring]);

   // increment the point for where we're reading the string.
   // wrap around at the end.
   whereinstring++;
   if (whereinstring > thestring.length-1) whereinstring = 0;

  }

  // interpret an L-system
  function lindenmayer(s) {
   let outputstring = ''; // start a blank output string

   // iterate through 'therules' looking for symbol matches:
   for (let i = 0; i < s.length; i++) {
    let ismatch = 0; // by default, no match
    for (let j = 0; j < therules.length; j++) {
     if (s[i] == therules[j][0])  {
      outputstring += therules[j][1]; // write substitution
      ismatch = 1; // we have a match, so don't copy over symbol
      break; // get outta this for() loop
     }
    }
    // if nothing matches, just copy the symbol over.
    if (ismatch == 0) outputstring+= s[i];
   }

   return outputstring; // send out the modified string
  }

  // this is a custom function that draws turtle commands
  function drawIt(k) {

   if (k=='F') { // draw forward
    // polar to cartesian based on step and currentangle:
    let x1 = x + step*p.cos(p.radians(currentangle));
    let y1 = y + step*p.sin(p.radians(currentangle));
    p.line(x, y, x1, y1); // connect the old and the new

    // update the turtle's position:
    x = x1;
    y = y1;
    } else if (k == '+') {
    currentangle += angle; // turn left
    } else if (k == '-') {
    currentangle -= angle; // turn right
   }

   // give me some random color values:
   let r = p.random(128, 255);
   let g = p.random(0, 192);
   let b = p.random(0, 50);
   let a = p.random(10, 24);

   // pick a gaussian (D&D) distribution for the radius:
   let radius = 0;
   radius += p.random(0, @max-radius);
   radius += p.random(0, @max-radius);
   radius += p.random(0, @max-radius);
   radius = radius / 3;

   // draw the stuff:
   p.fill(r, g, b, a);
   p.ellipse(x, y, radius, radius);
  }                                    
  p.windowResized = function() {
   //p.resizeCanvas(p.windowWidth, p.windowHeight);
   var parent = document.getElementById("@(id 'main)");
   p.resizeCanvas(parent.offsetWidth, parent.offsetHeight);
   p.background('@bg-color'); 
   x = @x;
   y = @y;
   currentangle = @start-angle;
   whereinstring = 0;
   };
  };
 const @(id 'onload) = function(){
  if (@(id 'isMobile).any()){
   var parent = document.getElementById("@(id 'main)");
   parent.classList.remove('bg-transparent');
   parent.style.backgroundColor = '@bg-color';
  }
  else {
   let @(id 'p5) = new p5(@(id 'sketch),'@(id 'canvas)');
  }
 }
 if(window.addEventListener){
  window.addEventListener('load', @(id 'onload));
  }else{
  window.attachEvent('onload', @(id 'onload));
 }
})

(module+ main
  (render (list
           (bootstrap
            (page index.html
                  (content
                    (js-runtime)
                    (include-p5-js)
                    (l-system #:x "p.width/3"      ;"240"
                              #:y "p.height/3*2"
                              #:start-angle -150
                              #:step 18
                              #:angle 90
                              #:axiom "FX"
                              #:loops 16
                              #:rules (list (cons "X" "X+YF+")
                                            (cons "Y" "-FX-Y"))
                              #:bg-color "#343a40"
                              #:line-color "rgba(0,255,128,0.4)"
                              #:max-radius 0
                              class: "p-5 card bg-transparent mb-0 text-center"
                           style: (properties height: "300px")
                           (card class: "border-dark p-2 mx-auto"
                                 style: (properties 'overflow: "hidden")
                                 (h4 class: "mb-0"
                                     "Dragon Curve")))
                    (l-system #:step 16
                              #:loops 4
                              #:max-radius 15
                              #:bg-color "#e9ecef"
                              class: "p-5 card bg-transparent text-center"
                              style: (properties 'overflow: "hidden"
                                                 height: "300px")
                              (card class: "border-dark p-2 mx-auto"
                                    style: (properties 'overflow: "hidden")
                                    (h4 class: "mb-0"
                                        "Sierpinksi Triangle with Arrowhead Curves")))
                    (l-system  #:step  20
                               #:angle  -90
                               #:axiom  "F"
                               #:loops  3
                               #:rules (list (cons "F" "F+F-F-F+F"))
                               #:max-radius 0
                               #:line-color "rgba(100,100,100,0.4)"
                               class: "p-5 card bg-transparent text-center"
                               style: (properties 'overflow: "hidden"
                                                  height: "300px")
                               (card class: "border-dark p-2 mx-auto"
                                     style: (properties 'overflow: "hidden")
                                     (h4 class: "mb-0"
                                         "Koch Curve")))
                    ))))
          #:to "out"))
