#lang at-exp racket

(provide paint)

(require website-js)

(define (paint #:color-1 [c1 "rgba(255, 200, 0, 0.024)"]
               #:color-2 [c2 "rgba(237, 70, 41, 0.004)"]
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
   (paint-script c1 c2 bg-color)
   ))

(define (paint-script c1 c2 bg)
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
  var img;
  var smallPoint, largePoint;

  var colors = [];
  var index = 0;

  var angle = 0;

  // function preload() {
   //   img = loadImage("../images/bg.jpg");

   // }
  var alph = 10;

  p.setup = function(){
   //var canvas = p.createCanvas(p.windowWidth, p.windowHeight);
   var parent = document.getElementById("@(id 'main)");
   var canvas = p.createCanvas(parent.offsetWidth, parent.offsetHeight);
   
   canvas.id('@(id 'canvas)');
   canvas.style('display','block');
   canvas.parent("@(id 'main)");
  
   colors.push(p.color('@c1'));
   colors.push(p.color('@c2'));
   //colors.push(p.color(123, 123, 98, alph));
   // colors.push(p.color(64, 64, 64, alph));  
   smallPoint = 20;
   largePoint = 60;
   p.imageMode(p.CENTER);
   p.noStroke();
   p.clear();
   p.angleMode(p.RADIANS);
   p.background('@bg');
   };

  p.draw = function() {

   for (var i = 0; i < 15; i++) {
    var v = p5.Vector.random2D();

    var wave = p.map(p.sin(angle), -1, 1, 0, 4);

    v.mult(p.random(1, 20*wave));
    var pointillize = p.random(smallPoint, largePoint);
    var x = p.mouseX + v.x;//floor(p.random(img.width));
    var y = p.mouseY + v.y;//floor(p.random(img.height));
    //var pix = p.img.get(x, y);
    //p.fill(pix[0],pix[1], pix[2], 52);
    p.fill(colors[index]);
    p.ellipse(x, y, pointillize, pointillize);
   }

   if (p.random(1) < 0.01) {
    index = (index + 1) % colors.length;
   }

   angle += 0.02;
   };
    
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
})

(module+ main
  (render (list
           (bootstrap
            (page index.html
                  (content
                    (js-runtime)
                    (include-p5-js)
                    (paint #:bg-color "#6c757d"
                                 class: "p-5 card bg-transparent"
                                 style: (properties 'overflow: "hidden"
                                              height: "300px")
                                 (card class: "border-dark p-2 mx-auto"
                                       style: (properties 'overflow: "hidden")
                                       (h4 class: "mb-0"
                                           "Paint Demo 1")))
                    (paint #:color-1 "rgba(0, 255, 255, 0.024)"
                                 #:color-2 "rgba(255, 0, 255, 0.004)"
                                 class: "p-5 card bg-transparent"
                                 style: (properties 'overflow: "hidden"
                                              height: "300px")
                                 (card class: "border-dark p-2 mx-auto"
                                       style: (properties 'overflow: "hidden")
                                       (h4 class: "mb-0"
                                           "Paint Demo 2")))
                    (paint #:bg-color 'black
                                 #:color-1 "rgba(100, 200, 0, 0.024)"
                                 #:color-2 "rgba(128, 0, 255, 0.004)"
                                 class: "p-5 card bg-transparent"
                                 style: (properties 'overflow: "hidden"
                                              height: "300px")
                                 (card class: "border-dark p-2 mx-auto"
                                       style: (properties 'overflow: "hidden")
                                       (h4 class: "mb-0"
                                           "Paint Demo 2")))
                    ))))
          #:to "out"))
