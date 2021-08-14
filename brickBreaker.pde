// Libraries
import java.util.*;
import controlP5.*;
import processing.sound.*;
import java.util.*;

// Variables
MainMenu menu;
GameMenu gameMenu;
Game game;
ControlP5 cp5;
SoundFile mainMenuSound;
SoundFile clickedButtonSound;
SoundFile startGameSound;
SoundFile gameOverSound;
SoundFile ballAgainstBarSound;
SoundFile ballAgainstBrickSound;
int sTime;
PFont font;
int keyboardX;

void setup(){
  size(700, 800);
  cp5 = new ControlP5(this);
  font = createFont("Verdana", 30);
  
  // SoundFile
  mainMenuSound = new SoundFile(this, "MainMenuMusic.wav");
  clickedButtonSound = new SoundFile(this, "ButtonClicking.wav");
  startGameSound = new SoundFile(this, "IntroGame.wav");
  gameOverSound = new SoundFile(this, "GameOver.wav");
  ballAgainstBarSound = new SoundFile(this, "BallAgainstBar.wav");
  ballAgainstBrickSound = new SoundFile(this, "BallHittingBrick.wav");
  
  // Make the Interface
  gameMenu = new GameMenu();
  gameMenu.createInterface();
  menu = new MainMenu(cp5);
  menu.createMenu();
  game = new Game();
}
void draw(){
  // Set the volume of the Sounds depending on the volume bar
  startGameSound.amp(VolumeController/300.0);
  clickedButtonSound.amp(VolumeController/300.0);
  gameOverSound.amp(VolumeController/300.0);
  ballAgainstBarSound.amp(VolumeController/300.0);
  ballAgainstBrickSound.amp(VolumeController/300.0);
  menu.updateSound();
  
  // When the game begins, the count down starts
  if (game.countDownActive){
    game.countDown(millis());
  }
  // After the count down and the game starts
   else if(!game.countDownActive && game.inGame){
     if(menu.interectionButton.getLabel() == "Mouse")
       game.afterIntro(mouseX);
     else
       game.afterIntro(keyboardX);
  }
}

// Menu
void Play(){
  clickedButtonSound.play();
  menu.Play();
}
void Difficulty(){
  clickedButtonSound.play();
  menu.Difficulty();
}
void Interaction(){
  clickedButtonSound.play();
  menu.Interaction();
}
void Exit(){
    clickedButtonSound.play();
    menu.Exit();
}

// GameMenu
void Menu(){
  clickedButtonSound.play();
  gameMenu.Menu();
}
void Restart(){
  gameMenu.Restart();
}
void Next(){
  gameMenu.Next();
}

// Interaction
void mousePressed(){
  // If the mouse is pressed in the setting location, show the slide to change the volume.
  if (mouseX >= 30 && mouseX <= 80 && mouseY >= 720 && mouseY <= 770){
    clickedButtonSound.play();
    menu.Settings();
  }
  
  // If the mouse is pressed in the restart location, the game restart.
  if(!game.gameLost){
    if (mouseX >= 610 && mouseX <= 670 && mouseY >= 20 && mouseY <= 80){
      clickedButtonSound.play();
      gameMenu.Pause();
    }
  }
}
// Sets a, A, and left arrow to move the bar to the left. d, D, and right arrow moves the bar to the right or space to pause.
void keyPressed() {
  if(game.inGame && menu.difficultyButton.getLabel() == "Easy"){
    if(key == 'a' || key == 'A' || keyCode == LEFT){
      if(keyboardX > game.bar.width/2)
        keyboardX -= 150;
      else
        keyboardX = game.bar.width/2;
    }
    if(key == 'd' || key == 'D' || keyCode == RIGHT){
      if(keyboardX < width - (game.bar.width/2))
        keyboardX += 150;
      else
        keyboardX = width - (game.bar.width/2);
    }
  }
  else{
    if(key == 'a' || key == 'A' || keyCode == LEFT){
      if(keyboardX > game.bar.width/2)
        keyboardX -= 125;
      else
        keyboardX = game.bar.width/2;
    }
    if(key == 'd' || key == 'D' || keyCode == RIGHT){
      if(keyboardX < width - (game.bar.width/2))
        keyboardX += 125;
      else
        keyboardX = width - (game.bar.width/2);
    }
  }
  if(key == ' ' && !game.countDownActive && game.inGame){
    gameMenu.Pause();
  }
}
