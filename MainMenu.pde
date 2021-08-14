// Variables
int VolumeController = 40;

// Class
class MainMenu{
  Button difficultyButton;
  Button interectionButton;
  Button playButton;
  Button exitButton;
  Slider volumeSetting;
  boolean settingSelected = false;
  PImage backg;
  PImage settings;
  PFont font2;
  
  // Constructor
  MainMenu(ControlP5 control){
    cp5 = control;
    backg = loadImage("Menu.png");
    settings = loadImage("Settings.png");
    settings.resize(50,50);
    font2 = createFont("Verdana", 10);
  }
  // Create the user interface plus the background
  void createMenu(){
    background(backg);
    image(settings, 30, 720);
    
    // Buttons
    fill(0);
    rect(190, 90, 320, 120);
    playButton = cp5.addButton("Play").setPosition(200,100).setSize(300,100).setColorBackground(color(80,0,0)).setColorForeground(color(128,0,0)).setColorActive(color(128,0,0)).setFont(font);
    rect(190, 250, 320, 120);
    difficultyButton = cp5.addButton("Difficulty").setPosition(200,260).setSize(300,100).setLabel("Easy").setColorBackground(color(80,0,0)).setColorForeground(color(128,0,0)).setColorActive(color(128,0,0)).setFont(font);
    rect(190, 410, 320, 120);
    interectionButton = cp5.addButton("Interaction").setPosition(200,420).setSize(300,100).setLabel("Mouse").setColorBackground(color(80,0,0)).setColorForeground(color(128,0,0)).setColorActive(color(128,0,0)).setFont(font);
    rect(190, 570, 320, 120);
    exitButton = cp5.addButton("Exit").setPosition(200,580).setSize(300,100).setColorBackground(color(80,0,0)).setColorForeground(color(128,0,0)).setColorActive(color(128,0,0)).setFont(font);
    
    // Slider
    volumeSetting = cp5.addSlider("VolumeController", 0, 100).setPosition(100, 730).setSize(200, 30)
    .setLabel("Volume").setColorBackground(0).setColorForeground(color(80,0,0)).setColorActive(color(128,0,0)).setFont(font2).hide();
    
    // Music
    mainMenuSound.play(1, VolumeController/300.0);
    mainMenuSound.loop(1, VolumeController/300.0);
  }
  // Update the amp each time so the volume bar can change the volume
  void updateSound(){
    mainMenuSound.amp(VolumeController/300.0);
  }
  // When going from the game to the main menu we need to "recreate" the main menu
  void showMainMenu(){
    background(backg);
    image(settings, 30, 720);
    
    fill(0);
    rect(190, 90, 320, 120);
    difficultyButton.show();
    rect(190, 250, 320, 120);
    interectionButton.show();
    rect(190, 410, 320, 120);
    playButton.show();
    rect(190, 570, 320, 120);
    exitButton.show();
    
    // Play music
    mainMenuSound.play(1, VolumeController/300.0);
    mainMenuSound.loop(1, VolumeController/300.0);
  }
  // We go to the actual game
  void Play(){
    // Hide MainMenu's buttons
    difficultyButton.hide();
    interectionButton.hide();
    playButton.hide();
    exitButton.hide();
    volumeSetting.hide();
    
    settingSelected = false;
    mainMenuSound.stop();
    
    // We go to the actual game
    gameMenu.showGameMenu();
    game.startGame();
  }
  // Change the difficulty of the game
  void Difficulty(){
    if(difficultyButton.getLabel() == "Easy"){
      difficultyButton.setLabel("Medium");
    }
    else if(difficultyButton.getLabel() == "Medium"){
      difficultyButton.setLabel("Hard");  
    }
    else{
      difficultyButton.setLabel("Easy");
    }
  }
  // Change how the user wants to interact with the game
  void Interaction(){
    if(interectionButton.getLabel() == "Mouse"){
      interectionButton.setLabel("Keyboard");
    }
    else{
      interectionButton.setLabel("Mouse");
    }
  }
  // Exit the game
  void Exit(){
    exit();
  }
  // Open the option to change the volume
  void Settings(){
    if (!settingSelected){
      volumeSetting.show();
      settingSelected = true;
    }
    else{
      // Hide the volume bar and put the background and the buttons's stroke
      volumeSetting.hide();
      settingSelected = false;
      
      background(backg);
      image(settings, 30, 720);
      fill(0);
      rect(190, 90, 320, 120);
      rect(190, 250, 320, 120);
      rect(190, 410, 320, 120);
      rect(190, 570, 320, 120);
    }
  }
}
