int score = 0;

class Game{
  PImage bar;
  boolean countDownActive;
  boolean inGame = false;
  boolean gameLost = false;
  boolean gameWon = false;
  Ball ball1;
  Ball ball2;
  Vector<Brick> bricks = new Vector<Brick>();
  float barPositionX;
  float barPositionY;
  int barWidth;
  int barHeight;
  int level = 1;
  
  Game(){
    bar = loadImage("Bar.png");
  }
  // When the game start, create the bar, start the sounds, create the ball and the bricks.
  void startGame(){
    gameMenu.showGameMenu();
    countDownActive = true;
    inGame = true;
    gameMenu.isPause = false;
    startGameSound.play();
    sTime = millis();
    score = 0;
    level = 1;
    
    ball1 = new Ball(100, 440, 8, 8, 30);
    ball2 = new Ball(700, 440, -8, 8, 30);
    
    // Create the bar depending in the difficulty
    barHeight = 40;
    if(menu.difficultyButton.getLabel() == "Easy"){
      barWidth = 250;
      bar.resize(250,40);
    }
    else if(menu.difficultyButton.getLabel() == "Medium"){
      barWidth = 125;
      bar.resize(125,40);
    }
    else{
      barWidth = 125;
      bar.resize(125,40);
    }
    keyboardX = width / 2;
    
    gameLost = false;
    gameWon = false;
    bricks.clear();
    createBlocks();
  }
  // Creating the blocks
  void createBlocks(){
    // Level 1
    if(level == 1){
      for(int i = 0; i < 5; i++){
        PVector temp = new PVector(100 + (100 * i), 185);
        bricks.add(new Brick(temp, "Weak_block.png"));
      }
      for(int i = 0; i < 4; i++){
        PVector temp = new PVector(150 + (100 * i), 220);
        bricks.add(new Brick(temp, "Red_block.png"));
      }
      for(int i = 0; i < 3; i++){
        PVector temp = new PVector(200 + (100 * i), 255);
        bricks.add(new Brick(temp, "Red_block.png"));
      }
      for(int i = 0; i < 2; i++){
        PVector temp = new PVector(250 + (100 * i), 290);
        bricks.add(new Brick(temp, "Ice_block.png"));
      }
      bricks.add(new Brick(new PVector(300, 325), "Ice_block.png"));
    }
    // Level 2
    else if(level == 2){
      for(int i = 0; i < 8; i++){
        for(int j = 0; j < 4; j++){
          PVector temp = new PVector(0 + (j * 200), 150 + (i * 35));
          if(j == 0 || j == 3)
            bricks.add(new Brick(temp, "Red_block.png"));
          else
            bricks.add(new Brick(temp, "Ice_block.png"));
        }
      }
    }
    // Level 3
    else{
      for(int i = 0; i < 7; i++){
        for(int j = 1; j < 5; j++){
          PVector temp = new PVector(0 + (i * 100), 100 * j);
          if(j == 1 || j == 4)
            bricks.add(new Brick(temp, "Red_block.png"));
          else
            bricks.add(new Brick(temp, "Ice_block.png"));
        }
      }
    }
  }
  // Move the bar depending of the mouse location of the times the chosen keyboard's keys are pressed.
  void barMovement(int x){
    if(!gameMenu.isPause && !gameLost && !gameWon){
      // When mouse is chosen.
      if(menu.interectionButton.getLabel() == "Mouse"){
        if(x < width - (bar.width/2) && x > (bar.width/2)){
          barPositionX = x - (bar.width/2.0);
        }
        else if(x >= width - (bar.width/2)){
          barPositionX = width - bar.width;
        }
        else if(x <= (bar.width/2)){
          barPositionX = 0;
        }
      }
      // When keyboard is chosen.
      else{
        if(x < width - (bar.width/2) && x > (bar.width/2)){
          barPositionX = x - (bar.width/2);
        }
        else if(x >= width - (bar.width/2)){
          barPositionX = width - bar.width;
        }
        else if(x <= (bar.width/2)){
          barPositionX = 0;
        }
      }
    }
    barPositionY = 700;
    image(bar, barPositionX, barPositionY);
  }
  // Start the countdown when the game starts.
  void countDown(int currentTime){
    fill(255, 0, 0);
    textSize(50);
    text("3", 330, 400);
    if(currentTime - sTime > 800){
      gameMenu.showGameMenu();
      fill(255, 0, 0);
      textSize(50);
      text("2", 330, 400);
    }
    if(currentTime - sTime > 1800){
      gameMenu.showGameMenu();
      fill(255, 0, 0);
      textSize(50);
      text("1", 330, 400);
    }
    if(currentTime - sTime > 2800){
      gameMenu.showGameMenu();
      fill(255, 0, 0);
      textSize(50);
      text("Play", 300, 400);
    }
    if(currentTime - sTime > 3800){
      gameMenu.showGameMenu();
      countDownActive = false;
    }
  }
  // Update ball and check all type of collisions
  void updateBalls(){
    if(!gameMenu.isPause && !gameLost && !gameWon){
      ball1.calculateBoundaryCollision();
      ball1.calculateBarCollision();
      ball1.calculateBrickCollision();
      ball1.updateAndDisplay();
      
      if(menu.difficultyButton.getLabel() == "Hard"){
        ball2.calculateBoundaryCollision();
        ball2.calculateBarCollision();
        ball2.calculateBrickCollision();
        ball1.calculateBallCollision(ball2);
        ball2.updateAndDisplay();
      }
    }
    else{
      fill(255, 0, 0);
      ellipse(ball1.position.x, ball1.position.y, ball1.diameter, ball1.diameter);
      if(menu.difficultyButton.getLabel() == "Hard"){
        ellipse(ball2.position.x, ball2.position.y, ball2.diameter, ball2.diameter);
      }
    }
  }
  // After the intro(the countdown) finishes display the bricks if they have lifes, update ball, check if game is lost, etc.
  void afterIntro(int x){
    gameMenu.showGameMenu();
    // Display the bricks if they have lifes left.
    for(int i = 0; i < bricks.size(); i++){
      bricks.get(i).display();
      if(bricks.get(i).numberOfLife == 0){
        bricks.remove(i);
      }
    }
    // Update bar
    updateBalls();
    barMovement(x);
    // When the ball fell.
    if(ball1.fell){
      gameLost = true;
      ball1.fell = false;
      gameOverSound.play();
    }
    if(menu.difficultyButton.getLabel() == "Hard"){
        if(ball2.fell){
          gameLost = true;
          ball2.fell = false;
          gameOverSound.play();
        }
     }
    // When game is lost display Game Over and give the option of restarting.
    if(gameLost){
      gameMenu.menuButton.hide();
      fill(0, 150);
      rect(0, 0, 700, 800);
      fill(255, 0, 0);
      textSize(50);
      text("Game Over", 210, 400);
      gameMenu.restartButton.show();
    }
    // When game is won display You Win and give the option of restarting.
    if (bricks.size() == 0){
      gameWon = true;
      gameMenu.menuButton.hide();
      fill(0, 150);
      rect(0, 0, 700, 800);
      fill(255, 0, 0);
      if(level == 3){
        textSize(50);
        text("You Win", 250, 400);
        gameMenu.restartButton.show();
      }
      else{
        textSize(40);
        if(level == 1)
          text("You Passed Level 1 Out of 3", 70, 400);
        else
          text("You Passed Level 2 Out of 3", 70, 400);
          
        gameMenu.nextButton.show();
      }
    }
  }
}
