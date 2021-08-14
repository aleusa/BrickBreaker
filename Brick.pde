class Brick{
  PImage brick;
  PVector position;
  String file;
  int numberOfLife;
  boolean broke = false;
  
  // Constructor
  Brick(PVector p, String f){
    position = p;
    file = f;
    brick = loadImage(file);
    brick.resize(100,35);
    checkNumberOfLife();
  }
  // Depending on the type of block, the number of lifes change.
  void checkNumberOfLife(){
    if (file == "Weak_block.png")
      numberOfLife = 1;
    else if(file == "Red_block.png")
      numberOfLife = 2;
    else
      numberOfLife = 3;
  }
  // Display the block depending in the number of life the brick has left.
  void display(){
    // Depending in number of lifes, change the image of the brick.
    if(file == "Red_block.png" && numberOfLife == 1){
      brick = loadImage("Red_block_broke.png");
    }
    else if(file == "Ice_block.png" && numberOfLife == 2){
      brick = loadImage("Ice_block_broke1.png");
    }
    else if(file == "Ice_block.png" && numberOfLife == 1){
      brick = loadImage("Ice_block_broke2.png");
    }
    brick.resize(100,35);
    image(brick, position.x, position.y);
  }
}
