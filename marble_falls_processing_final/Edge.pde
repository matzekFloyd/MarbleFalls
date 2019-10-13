class Edge {

  private float eX1;
  private float eY1;
  private float eX2;
  private float eY2;
  private int xDir = 1;  // Left or Right
  private int yDir = 1;  // Top to Bottom  
  private float speedX = 0;
  private float speedY = 0;
  
  //Defines what event the edge will trigger once a marble hits (+ Points, - Points, Collision)
  private boolean plusEdge = false;
  private boolean minusEdge = false;
  private boolean collisionEdge = false;

  public void setEdgeX1(float x) {
    eX1 = x;
  }

  public float getEdgeX1() {
    return eX1;
  }

  public void setEdgeX2(float x) {
    eX2 = x;
  }

  public float getEdgeX2() {
    return eX2;
  }

  public void setEdgeY1(float y) {
    eY1 = y;
  }

  public float getEdgeY1() {
    return eY1;
  }

  public void setEdgeY2(float y) {
    eY2 = y;
  }

  public float getEdgeY2() {
    return eY2;
  }
  
  public Boolean getPlusEdge(){
    return plusEdge;
  }
  
  public Boolean getMinusEdge(){
    return minusEdge;
  }
  public Boolean getCollisionEdge(){
    return collisionEdge;
  }
  
  public float getSpeedX() {
    return speedX;
  }

  public void setSpeedX(float s) {
    speedX = s;
  }
  
  public float getSpeedY() {
    return speedY;
  }

  public void setSpeedY(float s) {
    speedY = s;
  }
  
  public void move(){
    //Constantly add the set speed Value and the Direction to the x/y Pos;
    eX1 = eX1 + (speedX * xDir);
    eX2 = eX2 + (speedX * xDir);
    eY1 = eY1 + (speedY * yDir);
    eY2 = eY2 + (speedY * yDir);
    
    //Check if edge hits bounds; if so reverse the direction
    if (eX2 >= width) {
      xDir *= -1;
    }
    if (eX1 <= 0){
      xDir *= -1;      
    }
    
    if (eY2 >= height || eY1 >= height) {
      yDir *= -1;
    }
    if (eY1 <= 0 || eY2 <= 0){
      yDir *= -1;      
    }
  }
  
  public void display(){
    //Draw the edge on screen; Change the color depending on the type
    if(plusEdge){
        stroke(0,255,0);  
    } else if (minusEdge){
        stroke(255,0,0);
    } else if (collisionEdge){
        stroke(0,0,255);
    }
    strokeWeight(5);
    line(eX1,eY1,eX2,eY2);
    strokeWeight(1);
    stroke(0,0,0);
  } 
}