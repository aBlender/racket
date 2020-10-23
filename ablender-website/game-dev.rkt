#lang at-exp racket

(require website-js
         website-js/components/l-system
         "imgs.rkt"
         "common.rkt")

(provide game-dev
         pong
         brick-breaker)

(define (game-dev)
  (page game-dev.html
        (content #:head (list (include-p5-js))
                 (main-style)
                 (main-navbar #:active-index 2)
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
              (responsive-row #:columns 3 #:justify? #t
                              (ibm-card #:class "h-100"
                                        #:link "pong.html"
                                        (card-img-top class: "mb-2" src: (prefix/pathify pong-img))
                                        (h4 (b "JavaSript Pong"))
                                        "Play the classic Pong game against a basic ai. Use the mouse to move the paddle and hit closer to the edge of the paddle for extreme angles."
                                         )
                              (ibm-card #:class "h-100"
                                        #:link "brick-breaker.html"
                                        (card-img-top class: "mb-2" src: (prefix/pathify brick-breaker-img))
                                         (h4 (b "JavaScript Brick Breaker"))
                                         "Win the game by breaking all of the bricks. Use the mouse to move the paddle."
                                         ))
             
              (ibm-card #:class "mt-auto mb-4"
                        #:fit? #t
                        (p class: "m-0"
                           "This website was made using a DSL (domain specific language) written in Racket. See more details "
                           (a href: "https://github.com/aBlender/racket/tree/main/web-examples" (b "here")) "."))
              )))))

(define (pong)
  (page pong.html
        (content #:head (list (include-p5-js))
                 (main-style)
                 (main-navbar #:active-index 2)
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
              (ibm-card #:class "mt-auto mb-3 p-3 p-sm-5"
                        #:fit? #t
                        (canvas id: "gameCanvas"
                                width: 800
                                height: 600)
                        (pong-script))
              (ibm-card #:class "mt-auto mb-3"
                        #:fit? #t
                        (p class: "m-0"
                           "This website was made using a DSL (domain specific language) written in Racket. See more details "
                           (a href: "https://github.com/aBlender/racket/tree/main/web-examples" (b "here")) "."))
              )))))

(define (brick-breaker)
  (page brick-breaker.html
        (content #:head (list (include-p5-js))
                 (main-style)
                 (main-navbar #:active-index 2)
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
              (ibm-card #:class "mt-auto mb-3 p-3 p-sm-5"
                        #:fit? #t
                        (canvas id: "gameCanvas"
                                width: 800
                                height: 600)
                        (brick-breaker-script)
                        )
              (ibm-card #:class "mt-auto mb-3"
                        #:fit? #t
                        (p class: "m-0"
                           "This website was made using a DSL (domain specific language) written in Racket. See more details "
                           (a href: "https://github.com/aBlender/racket/tree/main/web-examples" (b "here")) "."))
              )))))

(define (pong-script)
  @script/inline{
var canvas;
var canvasContext;
var ballX = 50;
var ballY = 50;
var ballSpeedX = 10;
var ballSpeedY = 10;

var player1Score = 0;
var player2Score = 0;
const WINNING_SCORE = 3;

var showingWinScreen = false;

var paddle1Y = 250;
var paddle2Y = 250;

var paddle2Speed = 6;

const PADDLE_THICKNESS = 10;
const PADDLE_HEIGHT = 100;


function calculateMousePos(evt){
	var rect = canvas.getBoundingClientRect();
	var root = document.documentElement;
	var mouseX = evt.clientX - rect.left - root.scrollLeft;
	var mouseY = evt.clientY - rect.top - root.scrollTop;
	return {
		x:mouseX,
		y:mouseY
	};
}

function handleMouseClick(evt){
	if(showingWinScreen){
		player1Score = 0;
		player2Score = 0;
		showingWinScreen = false;
	}
}
window.onload = function(){
	canvas = document.getElementById('gameCanvas');
	canvasContext = canvas.getContext('2d');
        canvasContext.font = '24px Courier New'
	
	var framesPerSecond = 30;
	setInterval(function(){
		moveEverything();
		drawEverything();
	}, 1000/framesPerSecond);
	
	canvas.addEventListener('mousedown', handleMouseClick);
	canvas.addEventListener('mousemove',
		function(evt){
			var mousePos = calculateMousePos(evt);
			paddle1Y = mousePos.y-(PADDLE_HEIGHT/2);
		});
		
	//document.addEventListener('keypress', handleInput);
}

function handleInput(evt){
	console.log("Key Pressed: " + evt.keyCode);
	if (evt.keyCode == 45){
		console.log("Moving Up");
		paddle2Y = paddle2Y - 60;
	}
	if (evt.keyCode == 43){
		console.log("Moving Down");
		paddle2Y = paddle2Y + 60;
	}
}

function ballReset(){
	if(player1Score >= WINNING_SCORE ||
	   player2Score >= WINNING_SCORE) {
		showingWinScreen = true;
	}
	ballSpeedX = -ballSpeedX;
	ballX = canvas.width/2;
	ballY = canvas.height/2;
}

function computerMovement(){
	var paddle2YCenter = paddle2Y + (PADDLE_HEIGHT/2);
	if (paddle2YCenter < ballY - 35){
		paddle2Y += paddle2Speed;
	}else if(paddle2YCenter > ballY + 35){
		paddle2Y -= paddle2Speed;
	}
	//paddle2Y = ballY - PADDLE_HEIGHT/2; //Impossible AI
}

function moveEverything(){
	if(showingWinScreen){
		return;
	}
	computerMovement();
	
	ballX = ballX + ballSpeedX;
	ballY = ballY + ballSpeedY;
	
	if(ballX < 0){
		if(ballY > paddle1Y && 
		   ballY < paddle1Y + PADDLE_HEIGHT){
			ballSpeedX = -ballSpeedX;
				
			var deltaY = ballY -(paddle1Y+PADDLE_HEIGHT/2);
			ballSpeedY = deltaY * 0.35;
		}else {
			player2Score++; // must be BEFORE ballRest()
			ballReset();
		}
	}
	if(ballX > canvas.width){
		if(ballY > paddle2Y &&
		   ballY < paddle2Y + PADDLE_HEIGHT){
			ballSpeedX = -ballSpeedX;
			
			var deltaY = ballY -(paddle2Y+PADDLE_HEIGHT/2);
				ballSpeedY = deltaY * 0.35;
		}else {
			player1Score++; // must be BEFORE ballRest()
			ballReset();
		}
	}
	if(ballY < 0){
		ballSpeedY = -ballSpeedY;
	}
	if(ballY > canvas.height){
		ballSpeedY = -ballSpeedY;
	}
}

function drawNet(){
	for(var i=0; i<canvas.height; i+=40){
		colorRect(canvas.width/2-1,i,2,20,'#73b276');
	}
}
function drawEverything(){
	// next line blanks out the screen with black
	colorRect(0,0,canvas.width,canvas.height,'#343a40');
	
	if(showingWinScreen){
		canvasContext.fillStyle = '#73b276';
		
		if(player1Score >= WINNING_SCORE){
			canvasContext.fillText("Left Player Won!",290,180);
		}else if (player2Score >= WINNING_SCORE){
			canvasContext.fillText("Right Player Won!",290,180);
		}
		canvasContext.fillText("click to continue", 290, 500);
		return;
	}
	
	drawNet();
	
	// this is left player paddle
	colorRect(0,paddle1Y,PADDLE_THICKNESS,PADDLE_HEIGHT,'#73b276');

	// this is right computer paddle
	colorRect(canvas.width-PADDLE_THICKNESS,paddle2Y,
			PADDLE_THICKNESS,PADDLE_HEIGHT,'#73b276');
	
	// next line draws the ball
	colorCircle(ballX, ballY, 10, '#73b276');
	
	canvasContext.fillText(player1Score, 100,100);
	canvasContext.fillText(player2Score, canvas.width-100,100);
}

function colorCircle(centerX, centerY, radius, drawColor){
	canvasContext.fillStyle = drawColor;
	canvasContext.beginPath();
	canvasContext.arc(centerX,centerY,radius,0,Math.PI*2,true);
	canvasContext.fill();
}
function colorRect(leftX, topY, width, height, drawColor){
	canvasContext.fillStyle = drawColor;
	canvasContext.fillRect(leftX,topY,width,height);
}
 })

(define (brick-breaker-script)
  @script/inline{
var ballX = 75;
var ballY = 75;
var ballSpeedX = 5;
var ballSpeedY = 7;

const BRICK_W = 80;
const BRICK_H = 20; // temporarily doubled
const BRICK_GAP = 2;
const BRICK_COLS = 10;
const BRICK_ROWS = 14;
var brickGrid = new Array(BRICK_COLS * BRICK_ROWS);
var bricksLeft = 0;


const PADDLE_WIDTH = 100;
const PADDLE_THICKNESS = 10;
const PADDLE_DIST_FROM_EDGE = 60;
var paddleX = 400;

var canvas, canvasContext;

var mouseX = 0;
var mouseY = 0;

function updateMousePos(evt){
  var rect = canvas.getBoundingClientRect();
  var root = document.documentElement;
  
  mouseX = evt.clientX - rect.left - root.scrollLeft;
  mouseY = evt.clientY - rect.top - root.scrollTop;
  
  paddleX = mouseX - PADDLE_WIDTH/2;
  
  // cheat / hack to test ball
  /*ballX = mouseX;
  ballY = mouseY;
  ballSpeedX = 4;
  ballSpeedY = -4;*/
}

function brickReset(){
  bricksLeft = 0;
  var i;
  for(i=0; i<3*BRICK_COLS; i++){
    brickGrid[i] = false;
  }
  for(; i<BRICK_COLS*BRICK_ROWS; i++){
    brickGrid[i] = true;
    bricksLeft++;
  } // end of for each brick
} // end of brickReset func

window.onload = function(){
  canvas = document.getElementById('gameCanvas');
  canvasContext = canvas.getContext('2d');
  
  var framesPerSecond = 30;
  setInterval(updateAll, 1000/framesPerSecond);
  
  canvas.addEventListener('mousemove', updateMousePos);
  
  brickReset();
  ballReset();
}

function updateAll(){
  moveAll();
  drawAll();
}

function ballReset(){
  ballX = canvas.width/2;
  ballY = canvas.height/2;
}

function ballMove(){
  ballX += ballSpeedX;
  ballY += ballSpeedY;
  
  if (ballX < 0 && ballSpeedX < 0.0){ // left
    ballSpeedX *= -1;
  }
  if (ballX > canvas.width && ballSpeedX > 0.0){ // right
    ballSpeedX *= -1;
  }
  if (ballY < 0 && ballSpeedY < 0.0){ // top
    ballSpeedY *= -1;;
  }
  if (ballY > canvas.height){ //bottom
    ballReset();
    brickReset();
  }
}

function isBrickAtColRow(col,row){
  if(col >= 0 && col < BRICK_COLS &&
     row >= 0 && row < BRICK_ROWS) {
    var brickIndexUnderCoord = rowColToArrayIndex(col, row);
    return brickGrid[brickIndexUnderCoord];     
  }
  else {
    return false;
  }
}

function ballBrickHandling(){
  var ballBrickCol = Math.floor(ballX / BRICK_W);
  var ballBrickRow = Math.floor(ballY / BRICK_H);
  var brickIndexUnderBall = rowColToArrayIndex(ballBrickCol,ballBrickRow);
  
  if (ballBrickCol >= 0 && ballBrickCol < BRICK_COLS && 
      ballBrickRow >= 0 && ballBrickRow < BRICK_ROWS){
        
    if(isBrickAtColRow(ballBrickCol, ballBrickRow)){
      brickGrid[brickIndexUnderBall] = false;
      bricksLeft--;
      //console.log(bricksLeft);
      
      var prevBallX = ballX - ballSpeedX;
      var prevBallY = ballY - ballSpeedY;
      var prevBrickCol = Math.floor(prevBallX / BRICK_W);
      var prevBrickRow = Math.floor(prevBallY / BRICK_H);
      
      var bothTestsFailed = true;
      
      if(prevBrickCol != ballBrickCol) {
        if(isBrickAtColRow(prevBrickCol, ballBrickRow) == false){
          ballSpeedX *= -1;
          bothTestsFailed = false;
        }
      }
      if(prevBrickRow != ballBrickRow) {
        if(isBrickAtColRow(ballBrickCol, prevBrickRow) == false){
          ballSpeedY *= -1;
          bothTestsFailed = false;
        }
        
        if (bothTestsFailed) { // armpit case, prevents ball from going through
          ballSpeedX *= -1;
          ballSpeedY *= -1;
        }
      }
      
    } // end of brick found
  } // end of valid col and row
} // end of ballBrickHandling func

function ballPaddleHandling(){
  var paddleTopEdgeY = canvas.height-PADDLE_DIST_FROM_EDGE;
  var paddleBottomEdgeY = paddleTopEdgeY + PADDLE_THICKNESS;
  var paddleLeftEdgeX = paddleX;
  var paddleRightEdgeX = paddleLeftEdgeX + PADDLE_WIDTH;
  
  if (ballY > paddleTopEdgeY && // below the top of paddle
      ballY < paddleBottomEdgeY && // above bottom of paddle
      ballX > paddleLeftEdgeX && // right of the left side of paddle
      ballX < paddleRightEdgeX){ // left of the right side of paddle
    
    ballSpeedY *= -1;
    
    var centerOfPaddleX = paddleX + PADDLE_WIDTH/2;
    var ballDistFromPaddleCenterX = ballX - centerOfPaddleX;
    ballSpeedX = ballDistFromPaddleCenterX * 0.35;
    
    if(bricksLeft == 0){
      brickReset();
    } // out of bricks
  } // ball center inside paddle
} // end of ballPaddleHandling

function moveAll(){
  ballMove();
  
  ballBrickHandling();
  
  ballPaddleHandling();
}
function rowColToArrayIndex(col,row){
  return col + BRICK_COLS * row;
}

function drawBricks(){
  for(var eachRow=0; eachRow<BRICK_ROWS; eachRow++){
    for(var eachCol=0;eachCol<BRICK_COLS;eachCol++){
      
      var arrayIndex = rowColToArrayIndex(eachCol, eachRow);
      
      if(brickGrid[arrayIndex]){
        colorRect(BRICK_W*eachCol,BRICK_H*eachRow,
                  BRICK_W-BRICK_GAP,BRICK_H-BRICK_GAP,'#73b276');
      } // end of is this brick here
    } // end of for each brick
  }
} // end of drawBricks func

function drawAll(){
  colorRect(0,0, canvas.width,canvas.height,'#343a40'); //clear screen
  
  colorCircle(ballX,ballY, 10,'#73b276'); //draw ball
  
  colorRect(paddleX, canvas.height-PADDLE_DIST_FROM_EDGE,
            PADDLE_WIDTH,PADDLE_THICKNESS,'#73b276');
            
  drawBricks();
}

function colorRect(topLeftX,topLeftY,boxWidth,boxHeight,fillColor){
  canvasContext.fillStyle = fillColor;
  canvasContext.fillRect(topLeftX,topLeftY, boxWidth,boxHeight);
}

function colorCircle(centerX,centerY, radius, fillColor){
  canvasContext.fillStyle = fillColor;
  canvasContext.beginPath();
  canvasContext.arc(centerX,centerY, radius, 0,Math.PI*2,true);
  canvasContext.fill();
}

function colorText(showWords, textX,textY, fillColor){
  canvasContext.fillStyle = fillColor;
  canvasContext.fillText(showWords, textX, textY);
}
 })