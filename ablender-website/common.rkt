#lang at-exp racket

(provide main-style
         main-navbar
         ibm-card
         )

(require website-js
         "imgs.rkt")

(define (my-nav-link to text #:active? [active? #f])
  (div class: (if active? "nav-item active" "nav-item")
    (a class: "nav-link"
       href: to
       text)))

(define (main-navbar #:active-index [a-index 0])
  (nav class: "navbar navbar-expand-lg navbar-dark bg-dark py-0 fixed-top border-bottom"
       style: (properties 'border-color: "#041109!important"
                          'border-width: "thick!important")
       (a class: "navbar-brand" href: "index.html"
          "aBlender")
       (button class: "navbar-toggler border-0" type: "button" data-toggle: "collapse"
               data-target: "#navbarContent" 'aria-controls: "navbarContent" 'aria-expanded: "false" 'aria-label: "Toggle navigation"
               (span class: "navbar-toggler-icon"))
       (div class: "collapse navbar-collapse justify-content-end" id: "navbarContent"
            (ul class: "navbar-nav"
                (my-nav-link "index.html"   (list (home-icon)    "Home")           #:active? (= a-index 0))
                (my-nav-link "maker.html"   (list (tool-icon)    "Maker Projects") #:active? (= a-index 1))
                (my-nav-link "game-dev.html"    (list (game-icon)    "Game Dev")       #:active? (= a-index 2))
                (my-nav-link "blocklyduino/index.html" (list (blockly-icon) "BlocklyDuino")   #:active? (= a-index 3))
                (my-nav-link "vr.html"      (list (vr-icon)      "VR")             #:active? (= a-index 4))
                (my-nav-link "https://www.linkedin.com/in/jason-long-le/"   (list (about-icon)   "About")          #:active? (= a-index 5))
                ))))

(define (ibm-card #:class [class ""]
                  #:link [link #f]
                  . content)
  (if link
      (a href: link
         (card class: (~a "bg-light p-3 mx-auto " class)
               style: (properties font-family: "'Courier New', Courier, monospace")
               (card class: "bg-dark border-secondary p-3 text-primary text-left h-100"
                     style: (properties 'overflow: "hidden")
                     content)))
      (card class: (~a "bg-light p-3 mx-auto " class)
            style: (properties font-family: "'Courier New', Courier, monospace")
            (card class: "bg-dark border-secondary p-3 text-primary text-left h-100"
                  style: (properties 'overflow: "hidden")
                  content))))

(define (main-style)
  @style/inline{
                
p{
	color: #73b276;
	margin-left: 20px;
	margin-right: 20px;
	font-family: 'Courier New', Courier, monospace;
}

body {
        color: #73b276; 
	background-color: #041109;
}

.navbar-dark .navbar-nav .active a{
        color: #041109!important;
        fill: #041109;
	background-color: #73b276;
}

a, .navbar-dark .navbar-nav li a, .navbar-dark .navbar-nav li a:focus{
	color: #73b276!important;
        fill: #73b276;
}

.navbar-dark .navbar-nav .open a, .navbar-dark .navbar-nav .open a:focus{
	color: #73b276;
        fill: #73b276;
	background-color: #253E1E;
}

a:hover, .navbar-dark .navbar-nav li a:hover, .navbar-dark .navbar-brand a:hover, .navbar-dark .navbar-nav .active a:hover,
.navbar-dark .navbar-nav .open a:hover, .dropdown-menu li a:hover {
	color: #253E1E!important;
        fill: #253E1E;
	background-color: #BFB8B8;
}

//.navbar-dark{
//	background-color: #253E1E;
//}

.navbar-dark .navbar-brand{
    color: #73b276;                
}

.navbar-dark .navbar-brand:hover{
    color: #253E1E;
}

.dropdown-menu {
	color: #73b276;
	background-color: #253E1E;
}

.dropdown-menu li a {
	color: #73b276;
}

.text-primary{
        color: #73b276!important; 
}

.border-secondary{
        border-color: #8C7D77!important;          
}

.bg-light{
        background-color: #BFB8B8!important;  
}

})