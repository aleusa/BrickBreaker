class GameMenu{
  Button menuButton;
  Button restartButton;
  Button nextButton;
  boolean isPause = false;
  PImage backg;
  PImage pause;
  PFont font2;
  
  // Constructor
  GameMenu(){
    backg = loadImage("GameBackground.png");
    pause = loadImage("Pause.png");
    pause.resize(35,35);
    font2 = createFont("Verdana", 15);
  }
  // Background plus a button that sends the user to the main menu
  void createInterface(){
    background(backg);
    menuButton = cp5.addButton("Menu").setPosition(20,30).setSize(125,40).setColorBackground(color(80,0,0)).setColorForeground(color(128,0,0)).setColorActive(color(128,0,0)).setFont(font2).hide();
    restartButton = cp5.addButton("Restart").setPosition(280,450).setSize(125,40).setColorBackground(color(80,0,0)).setColorForeground(color(128,0,0)).setColorActive(color(128,0,0)).setFont(font2).hide();
    nextButton = cp5.addButton("Next").setPosition(280,450).setSize(125,40).setColorBackground(color(80,0,0)).setColorForeground(color(128,0,0)).setColorActive(color(128,0,0)).setFont(font2).hide();
  }
  // "Create" the interface that is present in the actual game
  void showGameMenu(){
    background(backg);
    strokeWeight(5);
    
    fill(72,61,139, 50);
    rect(0, 0, 700, 100);
    
    // Button and stroke
    fill(0);
    rect(17.5, 27.5, 130, 45);
    menuButton.show();
    
    // Score
    rect(320, 25, 100, 50);
    fill(150,0,0);
    textSize(40);
    if (score < 10){
      text("0" + score, 345, 65);
    }
    else{
      if(score >= 100){
        text(score, 330, 65);
      }
      else{
        text(score, 345, 65);
      }
    }
    
    // Pause
    fill(0);
    circle(640, 50, 60);
    image(pause, 624, 32.5);
  }
  // When the "Menu" button is pressend the user returns to the main menu
  void Menu(){
    // Hide GameMenu's buttons
    menuButton.hide();
  
    // Going again to the main menu
    menu.showMainMenu();
    startGameSound.stop();
    game.countDownActive = false;
    game.inGame = false;
  }
  // Pause the game
  void Pause(){
    if(isPause){
      isPause = false;
    }
    else{
      isPause = true;
    }
  }
  // Restart the game
  void Restart(){
    game.gameLost = false;
    game.startGame();
    restartButton.hide();
  }
  // Next Level
  void Next(){
    nextButton.hide();
    game.level++;
    gameMenu.showGameMenu();
    game.countDownActive = true;
    game.inGame = true;
    gameMenu.isPause = false;
    startGameSound.play();
    sTime = millis();
    
    game.ball1 = new Ball(100, 440, 8, 8, 30);
    game.ball2 = new Ball(700, 440, -8, 8, 30);
    
     // Create the bar depending in the difficulty
    game.barHeight = 40;
    if(menu.difficultyButton.getLabel() == "Easy"){
      game.barWidth = 250;
      game.bar.resize(250,40);
    }
    else if(menu.difficultyButton.getLabel() == "Medium"){
      game.barWidth = 125;
      game.bar.resize(125,40);
    }
    else{
      game.barWidth = 125;
      game.bar.resize(125,40);
    }
    keyboardX = width / 2;
    game.gameWon = false;
    game.bricks.clear();
    game.createBlocks();
  }
}
