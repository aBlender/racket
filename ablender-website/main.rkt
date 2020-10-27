#lang racket

(require website-js
         "imgs.rkt"
         "index.rkt"
         "maker-projects.rkt"
         "game-dev.rkt"
         "code-editors.rkt"
         )

(render (list (bootstrap-files)
              imgs-list
              (index)
              (maker-projects)
              (game-dev)
              (pong)
              (brick-breaker)
              (code-editors))
        #:to "out")