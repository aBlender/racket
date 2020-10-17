# Racket Web Examples

This is a collection of examples that use the Racket html5-lang, website, and website-js packages.

### html5-lang
<a href="text-adventure.rkt"><img src="text-adventure.png" width=400></a>
<a href="blog-template.rkt"><img src="blog-template.png" width=400></a>

### website-js
<a href="https://ablender.github.io/fractals/"><img src="fractals.png" width=400></a>
<a href="https://ablender.github.io/trees/"><img src="recursive-trees.png" width=400></a>

<a href="https://ablender.github.io/paint/"><img src="paint.png" width=400></a>
<a href="https://ablender.github.io/boids/"><img src="boids.png" width=400></a>

## Required Packages
* `html5-lang`
* `website`
* `website-js`

## Usage

For **html5-lang** examples:
* Run the .rkt file and a web server will start
* Stop racket program to end the web server

For **website** and **website-js** examples:
* Run the .rkt file
 * An `out` folder in the same location will be generated
* From a terminal, navigate to the location of the out folder and run `raco webs`
 * webs is short for website-preview but the typing the full command is optional
 * This will start a web server from the current directory
