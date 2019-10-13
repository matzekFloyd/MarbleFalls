class Marble {

  private float xPos;
  private float yPos;
  private int xDir = 1;  // Left or Right
  private int yDir = 1;  // Top to Bottom
  private float radius;
  private float speedX = 0;
  private float speedY = 5;
  
  boolean hit; //Variable to check if Marble hit something; set to true if a collision occurs
  private int outOfBoundsCounter = 3; //the Value that stores the Amount of Out of Bounds Collision that occured;

  Marble(float xPos, float yPos, float radius) {
    this.xPos = xPos;
    this.yPos = yPos;
    this.radius = radius;
  }

  public float getX() {
    return xPos;
  }

  public float getY() {
    return yPos;
  }

  public float getRadius() {
    return radius;
  }

  public float getSpeedX() {
    return speedX;
  }

  public void setSpeedX(float s) {
    speedX = speedX*s;
  }
  
  public float getSpeedY() {
    return speedY;
  }

  public void setSpeedY(float s) {
    speedY = speedY*s;
  }

  public int getOutOfBoundsCounter(){
    return outOfBoundsCounter;
  }


  void move() {    
    //Constantly add the set speed Value and the Direction to the x/y Pos;
    xPos = xPos + (speedX * xDir);
    yPos = yPos + (speedY * yDir);
  }
  
  
  void display(){
    //Draw the Marble on screen; Change the opacity depending on how often the Marble hit the edges of the window
    if(outOfBoundsCounter == 0) fill(255,255,255, 255);
    if(outOfBoundsCounter == 1) fill(255,255,255, 170);
    if(outOfBoundsCounter == 2) fill(255,255,255, 85);    
    ellipse(xPos, yPos, radius*2, radius*2);
    fill(255,255,255);
  }
  
  Boolean checkOutOfBounds(){
    //check if the Marble hit an edge of the window; If so, change the direction, subtract 1 from the OutOfBoundsCounter and print the Event to the Console
    if (xPos + radius > width) {
      xPos = width - radius;
      xDir *= -1;
      outOfBoundsCounter -= 1;
      println("OUTOFBOUNDS RIGHT MARBLE [x: "+xPos+"; y: "+yPos+"; radius: "+radius+"; speedX: "+speedX+"; speedY:"+speedY+"; outOfBoundsCounter: "+outOfBoundsCounter+"]");
      
    } else if(xPos <= 0){
      xPos = 0 + radius;
      xDir *= -1;
      outOfBoundsCounter -= 1;
      println("OUTOFBOUNDS LEFT MARBLE [x: "+xPos+"; y: "+yPos+"; radius: "+radius+"; speedX: "+speedX+"; speedY:"+speedY+"; outOfBoundsCounter: "+outOfBoundsCounter+"]");

    }
    if (yPos + radius > height) {
      yPos = height - radius;
      yDir *= -1;
      speedX = random(-5,5);
      outOfBoundsCounter -= 1;
      println("OUTOFBOUNDS BOTTOM MARBLE [x: "+xPos+"; y: "+yPos+"; radius: "+radius+"; speedX: "+speedX+"; speedY:"+speedY+"; outOfBoundsCounter: "+outOfBoundsCounter+"]");

    } else if(yPos <= 0){
      yPos = 0 + radius;
      yDir *= -1;
      speedY = random(-5,5);
      outOfBoundsCounter -= 1;
      println("OUTOFBOUNDS TOP MARBLE [x: "+xPos+"; y: "+yPos+"; radius: "+radius+"; speedX: "+speedX+"; speedY:"+speedY+"; outOfBoundsCounter: "+outOfBoundsCounter+"]");
    }
    return false;
  } 
}