/* 
author:ching
update:2016/8/11
*/

final int GAME_START = 0;
final int GAME_RUN = 1;
final int GAME_END = 2;

PImage enemyImg, fighterImg, treasureImg, hpImg, bg1Img, bg2Img;
PImage start1Img, start2Img, end1Img, end2Img;

float hpFull, hp, hpDamage, hpAdd, enemy;
float treasureX, treasureY, fighterX, fighterY, enemyX, enemyY;
float enemySpeed, fighterSpeed, bg1Move, bg2Move;
float enemySpacingX, enemySpacingY;

int enemyWidth = 61; 
int enemyHeight = 61;
int fighterWidth = 51;
int fighterHeight = 51;

int gameState;
int enemyFly;

boolean upPressed = false;
boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;

void setup(){ 
  size(640,480) ;
  
  enemyImg = loadImage("img/enemy.png");
  fighterImg = loadImage("img/fighter.png");
  treasureImg = loadImage("img/treasure.png");
  hpImg = loadImage("img/hp.png");
  bg1Img = loadImage("img/bg1.png");
  bg2Img = loadImage("img/bg2.png");
  start1Img = loadImage("img/start1.png");
  start2Img = loadImage("img/start2.png");
  end1Img = loadImage("img/end1.png");
  end2Img = loadImage("img/end2.png");
      
  //hp 
  hpFull = 194;
  hp = hpFull*2/10;
  hpDamage = hpFull*2/10;
  hpAdd = hpFull/10;  

  //move control
  enemySpeed = 5;
  fighterSpeed = 5;
  bg1Move = 0;
  bg2Move = -640;  

  //subject location
  treasureX = floor(random(600));
  treasureY = floor(random(35,440));
  enemyX = 0;  
  enemyY = floor(random(height - enemyHeight));
  enemySpacingX = 80;
  enemySpacingY = 40;
  fighterX = width - fighterWidth;
  fighterY = (height - fighterHeight)/2; 
          
  gameState = GAME_START;
  enemyFly = 0;
}

void draw() { 
  switch (gameState){
    case GAME_START:
      image(start2Img, 0, 0);    
      if (mouseX > 210 && mouseX < 450 && mouseY > 370 && mouseY < 410){
        if (mousePressed){
          gameState = GAME_RUN;
        }else{
          image(start1Img, 0, 0);
        }
      }  
      break;
      
    case GAME_RUN:
      //background
      bg1Move += 1;
      if(bg1Move == width){
        bg1Move *= -1;
      }
      image(bg1Img,bg1Move,0);      
      bg2Move += 1;
      if(bg2Move == width){
        bg2Move *= -1;
      }
      image(bg2Img,bg2Move,0);  
      
      //fighter move
      image(fighterImg, fighterX, fighterY);  
      if (upPressed) {
        fighterY -= fighterSpeed;
      }
      if (downPressed) {
        fighterY += fighterSpeed;
      }
      if (leftPressed) {
        fighterX -= fighterSpeed;
      }
      if (rightPressed) {
        fighterX += fighterSpeed;
      }      
      
      //fighter boundary detection  
      fighterX = (fighterX > width - fighterWidth) ? width - fighterWidth : fighterX;
      fighterX = (fighterX < 0) ? 0 : fighterX;
      fighterY = (fighterY > height - fighterHeight) ? height - fighterHeight : fighterY;
      fighterY = (fighterY < 0) ? 0 : fighterY;

      //treasure
      image(treasureImg, treasureX, treasureY);
      if(fighterX+fighterWidth >= treasureX && fighterX <= treasureX+40 && fighterY+fighterHeight >= treasureY && fighterY <= treasureY+40){
        hp += hpAdd;
        treasureX = floor(random(600));
        treasureY = floor(random(35,440));
        hp = (hp > hpFull) ? hpFull : hp;       
      }      
      
      //enemy      
      enemyX += enemySpeed;
      enemyX %= width + 4*enemySpacingX;       
      if(enemyX == 0){
        enemyY = floor(random(height - enemyHeight));        
        enemyFly++;
      }
      if (enemyFly == 0){                   //enemy fly style1               
        for(int i = 0; i < 5; i++){
          image(enemyImg, enemyX-i*enemySpacingX, enemyY);          
        }        
      }        
      if (enemyFly == 1){                   //enemy fly style2
        //boundary detection
        enemyY = (enemyY > (height - enemyHeight) - 4*enemySpacingY) ? (height - enemyHeight) - 4*enemySpacingY : enemyY; 
        
        for(int i = 0; i < 5; i++){
          image(enemyImg, enemyX-i*enemySpacingX, enemyY+i*enemySpacingY);
        }
      }      
      if (enemyFly == 2){                   //enemy fly style3 
        //boundary detection
        enemyY = (enemyY > (height - enemyHeight) - 2*enemySpacingY) ? (height - enemyHeight) - 2*enemySpacingY : enemyY;      
        enemyY = (enemyY < 2*enemySpacingY) ? 2*enemySpacingY : enemyY;  
        
        for(int i = 0; i < 3; i++){              
          image(enemyImg, enemyX - i*enemySpacingX, enemyY + i*enemySpacingY); 
          image(enemyImg, enemyX - 4*enemySpacingX + i*enemySpacingX, enemyY + i*enemySpacingY);           
          image(enemyImg, enemyX - i*enemySpacingX, enemyY - i*enemySpacingY);
          image(enemyImg, enemyX - 4*enemySpacingX + i*enemySpacingX, enemyY - i*enemySpacingY);
        }         
      }                 
      
      enemyFly = (enemyFly > 2) ? 0 : enemyFly;
            
      //hp
      fill(255,0,0); 
      rect(13,3,hp,17);  
      noStroke();      
      image(hpImg,0,0);
      if(hp < 1){
        gameState = GAME_END;
      }             
      break;
      
    case GAME_END:
      image(end2Img, 0, 0);    
      if (mouseX > 210 && mouseX < 435 && mouseY > 304 && mouseY < 350){
        if (mousePressed){                         
          //default value
          treasureX = floor(random(600));
          treasureY = floor(random(35,440));
          enemyX = 0;  
          enemyY = floor(random(height - enemyHeight));
          fighterX = width - fighterWidth;
          fighterY = (height - fighterHeight)/2;              
          hp = hpFull*2/10;
          
          gameState = GAME_RUN;
        }else{
          image(end1Img, 0, 0);
        }
      }
      break;
  } 
}

void keyPressed(){
  if (key == CODED) { // detect special keys 
    switch (keyCode) {
      case UP:
        upPressed = true;
        break;
      case DOWN:
        downPressed = true;
        break;
      case LEFT:
        leftPressed = true;
        break;
      case RIGHT:
        rightPressed = true;
        break;
    }
  }
}
void keyReleased(){
  if (key == CODED) {
    switch (keyCode) {
      case UP:
        upPressed = false;
        break;
      case DOWN:
        downPressed = false;
        break;
      case LEFT:
        leftPressed = false;
        break;
      case RIGHT:
        rightPressed = false;
        break;
    }
  }
}
