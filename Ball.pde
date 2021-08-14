class Ball{
  PVector position;
  PVector velocity;
  int diameter;
  boolean fell = false;
  boolean afterPause = false;
  float maximumV = 16.0;
  
  // Constructor
  Ball(float x, float y, float vx, float vy, int d){
    position = new PVector(x, y);
    velocity = new PVector(vx, vy);
    diameter = d;
  }
  // Check and calculate the collision when the ball hit another ball.
  void calculateBallCollision(Ball ball_2){
    PVector distanceB = PVector.sub(ball_2.position, position);

    if (diameter > distanceB.mag()) {
      PVector temp1 = new PVector();
      PVector temp2 = new PVector();
      PVector temp3 = new PVector();
      PVector temp4 = new PVector();
      PVector finalVelocity1 = new PVector();
      PVector finalVelocity2 = new PVector();
      PVector finalRotation1 = new PVector();
      PVector finalRotation2 = new PVector();
      PVector dist = new PVector();
      
      dist = distanceB.copy().normalize().mult((diameter - distanceB.mag())/2.0);
      float sin = sin(distanceB.heading());
      float cos = cos(distanceB.heading());
      
      ball_2.position.x += dist.x;
      ball_2.position.y += dist.y;
      position.x -= dist.x;
      position.y -= dist.y;
      
      temp2.x  = cos * distanceB.x + sin * distanceB.y;
      temp2.y  = cos * distanceB.y - sin * distanceB.x;
      temp3.x  = cos * velocity.x + sin * velocity.y;
      temp3.y  = cos * velocity.y - sin * velocity.x;
      temp4.x  = cos * ball_2.velocity.x + sin * ball_2.velocity.y;
      temp4.y  = cos * ball_2.velocity.y - sin * ball_2.velocity.x;

      finalVelocity1.x = temp4.x;
      finalVelocity1.y = temp3.y;
      finalVelocity2.x = temp3.x;
      finalVelocity2.y = temp4.y;

      temp1.x += finalVelocity1.x;
      temp2.x += finalVelocity2.x;

      finalRotation1.x = cos * temp1.x - sin * temp1.y;
      finalRotation1.y = cos * temp1.y + sin * temp1.x;
      finalRotation2.x = cos * temp2.x - sin * temp2.y;
      finalRotation2.y = cos * temp2.y + sin * temp2.x;

      ball_2.position.x = finalRotation2.x + position.x;
      ball_2.position.y = finalRotation2.y + position.y;
      position.x += finalRotation1.x;
      position.y += finalRotation1.y;

      velocity.x = cos * finalVelocity1.x - sin * finalVelocity1.y;
      velocity.y = cos * finalVelocity1.y + sin * finalVelocity1.x;
      
      ball_2.velocity.x = cos * finalVelocity2.x - sin * finalVelocity2.y;
      ball_2.velocity.y = cos * finalVelocity2.y + sin * finalVelocity2.x;
    }
  }
  // Check and calculate the collision when the ball hit a brick.
  void calculateBrickCollision(){
    for(int i = 0; i < game.bricks.size(); i++){
      PVector temp = game.bricks.get(i).position;
      if (position.x + (diameter/2.0) > temp.x && position.x - (diameter/2.0) < temp.x + 100 && position.y + (diameter/2.0) > temp.y && position.y - (diameter/2.0) < temp.y + 35){
        if(collideOnLeftSide(temp, 35) || collideOnRightSide(temp, 100, 35)){
          velocity.x *= -1;
          ballAgainstBrickSound.play();
          game.bricks.get(i).numberOfLife--;
          score += 2;
          break;
        }
        else if(collideOnTopSide(temp, 100) || collideOnBottomSide(temp)){
          velocity.y *= -1;
          ballAgainstBrickSound.play();
          game.bricks.get(i).numberOfLife--;
          score += 2;
          break;
        }
      }
    }
  }
  // Check and calculate the collision when the ball hit the bar.
  void calculateBarCollision(){
    if(!(position.x + (diameter/2.0) > game.barPositionX && position.x - (diameter/2.0) < game.barPositionX + game.barWidth && position.y + (diameter/2.0) > game.barPositionY && position.y - (diameter/2.0) < game.barPositionY + game.barHeight)){
      return;
    }
    if(collideOnTopSide(new PVector(game.barPositionX, game.barPositionY), game.barWidth)){
      ballAgainstBarSound.play();
      velocity.y *= -1;
    }
    else if(collideOnLeftSide(new PVector(game.barPositionX, game.barPositionY), game.barHeight) || collideOnRightSide(new PVector(game.barPositionX, game.barPositionY), game.barWidth, game.barHeight)){
      ballAgainstBarSound.play();
      velocity.x *= -1;
    }
  }

  // Check and calculate the collision when the ball hit a boundary.
  void calculateBoundaryCollision(){
    if (position.x > width - (diameter/2.0)) {
      position.x = width - (diameter/2.0);
      velocity.x *= -1;
    } 
    else if (position.x < (diameter/2.0)) {
      position.x = (diameter/2.0);
      velocity.x *= -1;
    } 
    else if (position.y > height + (diameter/2.0)) {
      position.y = 798;
      velocity.x = 0;
      velocity.y = 0;
      fell = true;
    } 
    else if (position.y < 100 + (diameter/2.0)) {
      position.y = 100 + (diameter/2.0);
      velocity.y *= -1;
    }
  }
  // update the position of ball depending of the velocity and increase the velocity over time.
  void updateAndDisplay() {
    position.x += velocity.x;
    position.y += velocity.y;
    fill(255, 0, 0);
    ellipse(position.x, position.y, diameter, diameter);
    // Increase velocity over time by 0.001.
    if(millis() - sTime > 3800){
      if(velocity.x < maximumV){
        if(velocity.x > 0)
          velocity.x += 0.001;
        else
          velocity.x -= 0.001;
         
        if(velocity.y > 0)
          velocity.y += 0.001;
        else
          velocity.y -= 0.001;
      }
    }
  }
  // Collision in the left side of bar or brick
  boolean collideOnLeftSide(PVector temp, int BHeight){
    return position.x + (diameter/2.0) >= temp.x && position.x - (diameter/2.0) < temp.x && ((position.y < temp.y && temp.x - position.x > temp.y - position.y) || (position.y > temp.y + BHeight && temp.x - position.x > position.y - (temp.y + BHeight)) || (position.y >= temp.y && position.y < temp.y + BHeight)) && velocity.x > 0;
  }
  // Collision in the right side of bar or brick
  boolean collideOnRightSide(PVector temp, int BWidth, int BHeight){
    return position.x - (diameter/2.0) <= temp.x + BWidth && position.x + (diameter/2.0) > temp.x + BWidth && velocity.x < 0 && ((position.y < temp.y && position.x - (temp.x + BWidth) > temp.y - position.y) || (position.y > temp.y + BHeight && position.x - (temp.x + BWidth)  > position.y - (temp.y + BHeight)) || (position.y >= temp.y && position.y < temp.y + BHeight));
  }
  // Collision in the top side of bar or brick
  boolean collideOnTopSide(PVector temp, int BWidth){
    return position.y + (diameter/2.0) >= temp.y && position.y - (diameter/2.0) < temp.y && velocity.y > 0 && ((position.x < temp.x && temp.y - position.y > temp.x - position.x) || (position.x > temp.x + BWidth && temp.y - position.y > position.x - (temp.x + BWidth)) || (position.x >= temp.x && position.x < temp.x + BWidth));
  }
  // Collision in the bottom side of bar or brick
  boolean collideOnBottomSide(PVector temp){
    return position.y - (diameter/2.0) <= temp.y + 35 && position.y + (diameter/2.0) > temp.y + 35 && velocity.y < 0 && ((position.x < temp.x && position.y - (temp.y + 35) > temp.x - position.x) || (position.x > temp.x + 100 && position.y - (temp.y + 35)  > position.x - (temp.x + 100)) || (position.x >= temp.x && position.x < temp.x + 100));
  }
}
