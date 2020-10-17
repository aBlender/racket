#lang at-exp racket

; https://creativecommons.org/licenses/by-nc-sa/4.0/

(provide boids)

(require website-js)

(define (boids #:color [c "rgba(255, 222, 0, 0.5)"] ;255, 222, 0, 127 (0.5)
               #:bg-color [bg "rgb(255, 255, 255)"]
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
   (script ([mainDivId (id 'main)]
            [canvasId (id 'canvas)]
            [myp5 (call 'start)])
     (function (start)
       @js{
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
  var flock;
  var text;

  var mouseV;
            
  p.setup = function(){
   var parent = @getEl{@mainDivId};
                                                   
   console.log("SETUP")
   console.log(@mainDivId)

   var canvas = p.createCanvas(parent.offsetWidth, parent.offsetHeight);
             
   canvas.id(@canvasId);
   canvas.parent(@mainDivId);
            
   flock = new Flock();
   // Add an initial set of boids into the system
   for (var i = 0; i < 50; i++) {
    var b = new Boid(p.width/2,p.height/2);
    flock.addBoid(b);
   }
   mouseV = p.createVector();
   };

  p.draw = function() {
   p.background('@bg');
   flock.run();
   mouseV.set(p.mouseX, p.mouseY);
   };

  // Add a new boid into the System
  // p.mouseDragged = function() {
   //   flock.addBoid(new Boid(p.mouseX,p.mouseY));
   // };
            
  // The Nature of Code
  // Daniel Shiffman
  // http://natureofcode.com

  // Flock object
  // Does very little, simply manages the array of all the boids

  function Flock() {
   // An array for all the boids
   this.boids = []; // Initialize the array
  }

  Flock.prototype.run = function() {
   for (var i = 0; i < this.boids.length; i++) {
    this.boids[i].run(this.boids);  // Passing the entire list of boids to each boid individually
   }
  }

  Flock.prototype.addBoid = function(b) {
   this.boids.push(b);
  }

  // The Nature of Code
  // Daniel Shiffman
  // http://natureofcode.com

  // Boid class
  // Methods for Separation, Cohesion, Alignment added

  function Boid(x,y) {
   this.acceleration = p.createVector(0,0);
   this.velocity = p.createVector(p.random(-1,1),p.random(-1,1));
   this.position = p.createVector(x,y);
   this.r = 3.0;
   this.maxspeed = 3;    // Maximum speed
   this.maxforce = 0.05; // Maximum steering force
   this.points = []; 

  }

  Boid.prototype.run = function(boids) {
   this.flock(boids);
   this.update();
   this.borders();
   this.render();
   this.points.push(this.position.copy()); 
   if (this.points.length > 10) {
    this.points.splice(0,1);
   }
  }

  Boid.prototype.applyForce = function(force) {
   // We could add mass here if we want A = F / M
   this.acceleration.add(force);
  }

  // We accumulate a new acceleration each time based on three rules
  Boid.prototype.flock = function(boids) {
   var sep = this.separate(boids);   // Separation
   var ali = this.align(boids);      // Alignment
   var coh = this.cohesion(boids);   // Cohesion
   var mouse = this.afraid();
   // Arbitrarily weight these forces
   sep.mult(1.5);
   ali.mult(1.0);
   coh.mult(1.0);
   mouse.mult(5.0);
   // Add the force vectors to acceleration
   this.applyForce(sep);
   this.applyForce(ali);
   this.applyForce(coh);
   this.applyForce(mouse);
  }

  Boid.prototype.afraid = function() {
   if (p5.Vector.dist(mouseV, this.position) < 100) {
    var v = this.seek(mouseV);
    v.mult(-1);
    return v;
    } else {
    return p.createVector();
   }
  }

  // Method to update location
  Boid.prototype.update = function() {
   // Update velocity
   this.velocity.add(this.acceleration);
   // Limit speed
   this.velocity.limit(this.maxspeed);
   this.position.add(this.velocity);
   // Reset accelertion to 0 each cycle
   this.acceleration.mult(0);
  }

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  Boid.prototype.seek = function(target) {
   var desired = p5.Vector.sub(target,this.position);  // A vector pointing from the location to the target
   // Normalize desired and scale to maximum speed
   desired.normalize();
   desired.mult(this.maxspeed);
   // Steering = Desired minus Velocity
   var steer = p5.Vector.sub(desired,this.velocity);
   steer.limit(this.maxforce);  // Limit to maximum steering force
   return steer;
  }

  Boid.prototype.render = function() {
   // Draw a triangle rotated in the direction of velocity
   var theta = this.velocity.heading() + p.radians(90);
   // p.fill(255, 222, 0);
   // p.stroke(255, 222, 0);
   // p.push();
   // p.translate(this.position.x,this.position.y);
   // p.rotate(theta);
   // p.beginShape();
   // p.vertex(0, -this.r*2);
   // p.vertex(-this.r, this.r*2);
   // p.vertex(this.r, this.r*2);
   // p.endShape(p.CLOSE);
   // p.pop();

   // Draw everything
   for (var i = 0; i < this.points.length; i++) {
    // Draw an ellipse for each element in the arrays. 
    // Color and size are tied to the loop's counter: i.
    p.noStroke();
    // fill(255, 222, 0, map(i,0,this.points.length-1,0,255));
    p.fill('@c');
    p.ellipse(this.points[i].x,this.points[i].y,i,i);
   }

  }

  // Wraparound
  Boid.prototype.borders = function() {
   if (this.position.x < -this.r)  this.position.x = p.width +this.r;
   if (this.position.y < -this.r)  this.position.y = p.height+this.r;
   if (this.position.x > p.width +this.r) this.position.x = -this.r;
   if (this.position.y > p.height+this.r) this.position.y = -this.r;
  }

  // Separation
  // Method checks for nearby boids and steers away
  Boid.prototype.separate = function(boids) {
   var desiredseparation = 25.0;
   var steer = p.createVector(0,0);
   var count = 0;
   // For every boid in the system, check if it's too close
   for (var i = 0; i < boids.length; i++) {
    var d = p5.Vector.dist(this.position,boids[i].position);
    // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
    if ((d > 0) && (d < desiredseparation)) {
     // Calculate vector pointing away from neighbor
     var diff = p5.Vector.sub(this.position,boids[i].position);
     diff.normalize();
     diff.div(d);        // Weight by distance
     steer.add(diff);
     count++;            // Keep track of how many
    }
   }
   // Average -- divide by how many
   if (count > 0) {
    steer.div(count);
   }

   // As long as the vector is greater than 0
   if (steer.mag() > 0) {
    // Implement Reynolds: Steering = Desired - Velocity
    steer.normalize();
    steer.mult(this.maxspeed);
    steer.sub(this.velocity);
    steer.limit(this.maxforce);
   }
   return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  Boid.prototype.align = function(boids) {
   var neighbordist = 50;
   var sum = p.createVector(0,0);
   var count = 0;
   for (var i = 0; i < boids.length; i++) {
    var d = p5.Vector.dist(this.position,boids[i].position);
    if ((d > 0) && (d < neighbordist)) {
     sum.add(boids[i].velocity);
     count++;
    }
   }
   if (count > 0) {
    sum.div(count);
    sum.normalize();
    sum.mult(this.maxspeed);
    var steer = p5.Vector.sub(sum,this.velocity);
    steer.limit(this.maxforce);
    return steer;
    } else {
    return p.createVector(0,0);
   }
  }

  // Cohesion
  // For the average location (i.e. center) of all nearby boids, calculate steering vector towards that location
  Boid.prototype.cohesion = function(boids) {
   var neighbordist = 50;
   var sum = p.createVector(0,0);   // Start with empty vector to accumulate all locations
   var count = 0;
   for (var i = 0; i < boids.length; i++) {
    var d = p5.Vector.dist(this.position,boids[i].position);
    if ((d > 0) && (d < neighbordist)) {
     sum.add(boids[i].position); // Add location
     count++;
    }
   }
   if (count > 0) {
    sum.div(count);
    return this.seek(sum);  // Steer towards the location
    } else {
    return p.createVector(0,0);
   }
  }
           
  p.windowResized = function() {
   var parent = document.getElementById(@mainDivId);
   p.resizeCanvas(parent.offsetWidth, parent.offsetHeight);
   p.background('@bg');
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
       
       )))

(module+ main
  (render (list
           (bootstrap
            (page index.html
                  (content
                    (js-runtime)
                    (include-p5-js)
                    (boids class: "p-5 card bg-transparent"
                           style: (properties 'overflow: "hidden"
                                              height: "400px")
                           (card class: "border-dark p-2 mx-auto"
                                 style: (properties 'overflow: "hidden")
                                 (h4 class: "mb-0"
                                     "Boids Demo 1")))
                    (boids #:color "magenta"
                           #:bg-color "#e9ecef"
                           class: "p-5 card bg-transparent"
                           style: (properties 'overflow: "hidden"
                                              height: "400px")
                           (card class: "border-dark p-2 mx-auto"
                                 style: (properties 'overflow: "hidden")
                                 (h4 class: "mb-0"
                                     "Boids Demo 2")))
                    ))))
          #:to "out"))
