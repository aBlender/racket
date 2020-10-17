# Racket Web Examples

This is a collection of examples that use the Racket **html5-lang**, **website**, and **website-js** packages.

### html5-lang

The following examples are written in Racket and when run will generate HTML, CSS, and JS files as well as run a local web server. Click on the images to see the Racket code.

| Text Adventure | Blog Template |
|:--------------:|:-------------:|
| [![alt text][ta img]][ta link] | [![alt text][bt img]][bt link] |

### website-js

The following examples are p5.js examples that have been ported over to Racket as simple modular functions. Each function generates a Jumbotron style Boostrap component with a dynamic background. Unique ids are generated automatically to allow multiple p5js canvases per page. Click on the images for live demos.

| L-System Fractals | Recursive Trees |
|:--------------:|:-------------:|
| [![alt text][fr img]][fr link] | [![alt text][rt img]][rt link] |

| Paint Canvas | Boids Algorithm |
|:--------------:|:-------------:|
| [![alt text][pa img]][pa link] | [![alt text][bo img]][bo link] |

## Required Packages
* `html5-lang`
* `website`
* `website-js`

## Running the Examples

For **html5-lang** examples:
* Run the .rkt file and a web server will start
* Stop racket program to end the web server

For **website** and **website-js** examples:
* Run the .rkt file
 * An `out` folder in the same location will be generated
* From a terminal, navigate to the location of the out folder and run: `raco webs`
 * webs is short for website-preview but typing the full command isn't necessary
 * This will start a web server from the current directory

 ## Sample Code
 
 Note that the p5js components (**l-system**, **recursive-trees**, and **boids**) are already included in website-js and can be access with `(require website-js/components/component-name)`. See below for a full example.
 
 Dragon Curve L-System:
```racket
#lang racket

(require website-js
         website-js/components/l-system)

(render (list
         (bootstrap
          (page index.html
                (content
                 (js-runtime)
                 (include-p5-js)
                 (l-system #:x "p.width/3"
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
                           style: (properties height: "100vh")
                     (card class: "border-dark p-2 mx-auto"
                           style: (properties 'overflow: "hidden")
                           (h4 class: "mb-0"
                               "Dragon Curve")))))))
        #:to "out")
```

 [ta link]: text-adventure.rkt
 [ta img]: text-adventure.png "Text Adventure Preview"
 [bt link]: blog-template.rkt
 [bt img]: blog-template.png "Blog Template Preview" 
 
 [fr link]: https://ablender.github.io/fractals/
 [fr img]: fractals.png "Fractals Preview"
 [rt link]: https://ablender.github.io/trees/
 [rt img]: recursive-trees.png "Recursive Trees Preview"
 [pa link]: https://ablender.github.io/paint/
 [pa img]: paint.png "Paint Preview"
 [bo link]: https://ablender.github.io/boids/
 [bo img]: boids.png "Boids Preview" 
