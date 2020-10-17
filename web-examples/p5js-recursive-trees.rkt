#lang at-exp racket

(provide recursive-trees)

(require website-js)

(define (recursive-trees #:color-1 [c1 "rgba(255, 200, 0, 0.5)"]
                         #:color-2 [c2 "rgba(237, 70, 41, 0.5)"]
                         #:bg-color [bg-color "white"]
                     . content)
  (enclose
   (apply div (flatten (list id: (id 'main)
                             content
                             @style/inline{
 @(id# 'canvas) {
  @;#pointilism-sketch-container {
  position:absolute;
  top:0;
  left:0;
  width:100%;
  height:100%;
  z-index:-1;
 }
})))
   (recursive-trees-script c1 c2 bg-color)
   ))

(define (recursive-trees-script c1 c2 bg)
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
  let theta;

  p.setup = function() {
   var parent = document.getElementById("@(id 'main)");                                
   var canvas = p.createCanvas(parent.offsetWidth, parent.offsetHeight);
   
   canvas.id('@(id 'canvas)');
   canvas.style('display','block');
   canvas.parent("@(id 'main)");
  }

  p.draw = function() {
    p.background('@bg');
    p.frameRate(30);
    //p.strokeWeight(2);
    p.strokeCap(p.SQUARE);
    p.stroke('@c1');
    // Let's pick an angle 0 to 90 degrees based on the mouse position
    let a = (p.mouseX / p.width) * 90;
    // Convert it to radians
    theta = p.radians(a);
    // Start the tree from the bottom of the screen
    p.translate(100,p.height);
    // Draw a line 120 pixels
    p.line(0,0,0,-120);
    // Move to the end of that line
    p.translate(0,-120);
    // Start the recursive branching!
    branch(140);
    
    //p.strokeWeight(2);
    p.stroke('@c2');
    p.translate(100,120);
    p.line(0,0,0,-60);
    p.translate(0,-60);
    branch(100);

  }

  function branch(h) {
    // Each branch will be 2/3rds the size of the previous one
    h *= 0.66;

    // All recursive functions must have an exit condition!!!!
    // Here, ours is when the length of the branch is 2 pixels or less
    if (h > 2) {
      p.push();    // Save the current state of transformation (i.e. where are we now)
      p.rotate(theta);   // Rotate by theta
      p.line(0, 0, 0, -h);  // Draw the branch
      p.translate(0, -h); // Move to the end of the branch
      branch(h);       // Ok, now call myself to draw two new branches!!
      p.pop();     // Whenever we get back here, we "pop" in order to restore the previous matrix state

      // Repeat the same thing, only branch off to the "left" this time!
      p.push();
      p.rotate(-theta);
      p.line(0, 0, 0, -h);
      p.translate(0, -h);
      branch(h);
      p.pop();
    }
  }

  p.windowResized = function() {
   var parent = document.getElementById("@(id 'main)");
                                         
   //p.resizeCanvas(p.windowWidth, p.windowHeight);
   p.resizeCanvas(parent.offsetWidth, parent.offsetHeight);
   
   };
};

const @(id 'onload) = function(){
  if (@(id 'isMobile).any()){
   var parent = document.getElementById("@(id 'main)");
   parent.classList.remove('bg-transparent');
   parent.style.backgroundColor = '@bg';
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
}  )

(module+ main
  (render (list
           (bootstrap
            (page index.html
                  (content
                    (js-runtime)
                    (include-p5-js)
                    (recursive-trees #:bg-color 'black
                                     #:color-1 "rgba(0, 255, 0, 0.5)"
                                     #:color-2 "rgba(255, 255, 0, 0.5)"
                                     class: "p-5 card bg-transparent"
                                     style: (properties 'overflow: "hidden"
                                                        height: "300px")
                                     (card class: "border-dark p-2 mx-auto"
                                           style: (properties 'overflow: "hidden")
                                           (h4 class: "mb-0"
                                               "Recursive Trees 1")))
                    (recursive-trees #:bg-color "#6c757d"
                                     class: "p-5 card bg-transparent"
                                     style: (properties 'overflow: "hidden"
                                                        height: "300px")
                                     (card class: "border-dark p-2 mx-auto"
                                           style: (properties 'overflow: "hidden")
                                           (h4 class: "mb-0"
                                               "Recursive Trees 2")))
                    (recursive-trees #:color-1 "rgba(0, 255, 128, 0.5)"
                                     #:color-2 "rgba(255, 0, 255, 0.5)"
                                     class: "p-5 card bg-transparent"
                                     style: (properties 'overflow: "hidden"
                                                        height: "300px")
                                     (card class: "border-dark p-2 mx-auto"
                                           style: (properties 'overflow: "hidden")
                                           (h4 class: "mb-0"
                                               "Recursive Trees 3")))
                    ))))
          #:to "out"))
