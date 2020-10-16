#lang html5-lang

(define c64-style
  (css 'background-color "#041109"
                    'color "#73b276"
                    'border "20px solid #9B9B69"
                    'border-radius "10px"
                    'padding "10px"
                    'width "640px"
                    'height "480px"
                    'font-family "Courier New"))

(define my-home-page
  (bootstrap-template
   (div style: c64-style
        (h1 style: (css 'text-align "center") "Adventures of Titanius Anglesmith")
        (br)
        (p "You emerge out of a forest and are presented with two paths.")
        (p "The path on the left leads into a cave and the path on the right ends at a lake. Which path do you choose?")
        (div class: "nav justify-content-between"
             (link-to "cave" (button type: "button" class: "btn btn-secondary" "Left"))
             (link-to "lake" (button type: "button" class: "btn btn-secondary" "Right")))
        )))

(define cave
  (bootstrap-template
   (div style: c64-style
        (h1 style: (css 'text-align "center") "The Cave of Embers")
        (br)
        (p "You enter the dark cave and follow the opening into a large chamber already lit with torches.")
        (p "In the center of room is a chest. Would you like to open the chest or leave it alone?")
        (div class: "nav justify-content-between"
             (link-to "open-chest" (button type: "button" class: "btn btn-secondary" "Open the Chest"))
             (link-to "leave-alone" (button type: "button" class: "btn btn-secondary" "Leave it alone")))
        )))

(define open-chest
  (bootstrap-template
   (div style: c64-style
        (h1 style: (css 'text-align "center") "The Cave of Embers")
        (br)
        (p "You open the chest slowly and find it full of valuable treasures! Quickly, you escape with the chest before anyone else can claim them.")
        (p "Congratulations. You win!")
        (div class: "nav justify-content-between"
             (link-to "home" (button type: "button" class: "btn btn-secondary" "Play Again")))
        )))

(define leave-alone
  (bootstrap-template
   (div style: c64-style
        (h1 style: (css 'text-align "center") "The Cave of Embers")
        (br)
        (p "Some time passes by as you ponder whether or not you should open the chest.")
        (p "Suddenly, a giant spider emerges out of the darkness and bites you. THE END!")
        (div class: "nav justify-content-between"
             (link-to "home" (button type: "button" class: "btn btn-secondary" "Play Again")))
        )))

(define lake
  (bootstrap-template
   (div style: c64-style
        (h1 style: (css 'text-align "center") "The Lake of Doom!")
        (br)
        (p "You arrive at a beautiful lake and decide to go for a swim.")
        (p "Unfortunately, a giant sea serpant erupts from the lake and swallows you whole!")
        (div class: "nav justify-content-between"
             (link-to "home" (button type: "button" class: "btn btn-secondary" "Play Again")))
        )))

(send-to-browser
 "home" my-home-page
 "cave" cave
 "lake" lake
 "open-chest" open-chest
 "leave-alone" leave-alone)