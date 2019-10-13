/*
  08.09.2017 - 21:30
  Projectname: Marble Falls
  Author: Mathias Mayrhofer
  Matrikelnummer: mt151062  
  Touchscreen: 3.2" tft lcd shield w/ touch panel TF Reader 
*/

//Variables needed to read Arduino sent data
import processing.serial.*;
Serial myPort;
String portStream;
int serialX;
int serialY;

//Variables, which values can be changed to setup a higher difficulty for the game
int initialEdgeCount = 3; //cant be higher than 6
int maxMarbles = 100;
int addPoints = 50;
int subtractPoints = 25;

//Lists which save the currently active components of the game
ArrayList<Marble> marbles = new ArrayList<Marble>();
ArrayList<Edge> edges = new ArrayList<Edge>();

//Variables to track the achieved Score and elapsed Time;
Timer timer;
int score;

void setup() {  
  timer = new Timer(); 
  frameRate(50);  
  size(800, 1200);
  
  String portName = Serial.list()[3];  //The usb-slot to which the arduino is connected
  myPort = new Serial(this, portName, 9600); //start a Connection to arduino
  myPort.bufferUntil('\n'); //read Data until '\n'

  println(initialize(initialEdgeCount)); //Initialize the game with set default values and print them to the console
}

String initialize(int edgeCount){
  timer.start();
  score = 0;

  //Create a few edges depending on the value of initialEdgeCount Variable
  if(edgeCount > 6) edgeCount = 6;
  for(int i = 0; i < edgeCount; i++){
     Edge newE = new Edge();
     int offset = 100;
     int edgeLength = (int)random(50,200);
     int randSpeed = (int)random(1,10);
     newE.setEdgeX1(offset);
     newE.setEdgeX2(offset + edgeLength);
     newE.setEdgeY1((height / 2) + (offset*i));
     newE.setEdgeY2((height / 2) + (offset*i));
     newE.setSpeedX(randSpeed);
     //set the type of every third edge to 'collision'
     if(i % 3 == 0){
       newE.collisionEdge = true;
     } else {
       newE.plusEdge = true;
     }
     edges.add(newE); 
  }
  return "INIT[edges: "+edgeCount+"; max. Marbles: "+maxMarbles+"; Points: +"+addPoints+" -"+subtractPoints+"]";
}

void serialEvent(Serial myPort) {
  //Wait until the touchscreen is used and data is sent from arduino
  portStream = myPort.readString();
    if(portStream != null) {
      //X and Y Values are sent in this format: 'X0801Y0875'
      //Get the characters 2 to 5 from the serial-string and save them as x
      serialX = int(portStream.substring(1,5)); 
      //Get the characters 7 to 10 from the serial-string and save them as y
      serialY = int(portStream.substring(7,10)); 
      
      //The x and y values on the touchscreen differ from the coordinates of the processing window
      //-> Map the values depending on the range of the touchscreen
      //In this case the x and y values range between 150 and 1800
      float offset = 50;
      float xMapped = map(serialX, 150,1800, offset, width - offset);
      float yMapped = map(serialY, 150,1800, offset, height / 2 - offset);
      
      //Make sure the x and y values are not negative
      if(xMapped < 0) xMapped = xMapped * -1;
      if(yMapped < 0) yMapped = yMapped * -1;
      
    //Create a Marble at the position of the mapped coordinates
    //Only possible if the maximum amount of marbles has not been reached yet
    if(marbles.size() <= maxMarbles){
      int radius = 10;
      Marble newMarble = new Marble(xMapped,yMapped, radius);
      marbles.add(newMarble); 
      //Print the values of the newly created Marble to the console
      println("CREATE MARBLE [x: "+xMapped+"; y: "+yMapped+"; radius: "+radius+"; speedX: "+newMarble.getSpeedX()+"; speedY:"+newMarble.getSpeedY()+"; outOfBoundsCounter: "+newMarble.getOutOfBoundsCounter()+"]");
    } 
  }
}

void draw() {  
  background(0);  
  checkForDeadMarbles(); //Check if a Marble "died" (= too many out of bounds collisions)
  interval();  //Do something at certain timer-intervals
  move();  //Update marble and edge values (for Example x and y Position)
  handleCollisions();  //Check for Collisions between Marbles, Edges and Bounds
  display();  //Draw the GUI and Marbles/Edges on screen
}

//Check if the outOfBoundsCounter of any marble reached 0
//If so, delete it and print the deleted Marble to the console
void checkForDeadMarbles(){
  for (int i = 0; i < marbles.size(); i++) {
    if(marbles.get(i).getOutOfBoundsCounter() == 0){
      println("REMOVE MARBLE [x: "+marbles.get(i).getX()+"; y: "+marbles.get(i).getY()+"; radius: "+marbles.get(i).radius+"; speedX: "+marbles.get(i).getSpeedX()+"; speedY:"+marbles.get(i).getSpeedY()+"; outOfBoundsCounter: "+marbles.get(i).getOutOfBoundsCounter()+"]");
      marbles.remove(marbles.get(i));
    } 
  }
}

//Do something every n seconds, depending on the set frame rate
void interval(){
  //Create a horizontally moving edge and print its values to the console
  //The values are generated randomly
  //With a Frame Rate of 50 this Event occurs every 20 seconds
  if(frameCount %  1000 == 0){   
   int randX1 = (int)random(20,300);
   int randX2 = randX1 + (int)random(50,200);
   int randY = (int)random(500,1100);   
   float randSpeed = random(1,10);      
   int randType = (int)random(0,40);   
   println(createHorizontalEdge(randX1, randX2, randY, randSpeed, randType));
  }
  
  //Create a vertically moving edge and print its values to the console
  //Its starting point is in the left half of the window
  //With a Frame Rate of 50 this Event occurs every 40 seconds
   if(frameCount % 2000 == 0){
     int randY1 = (int)random(20,150);
     int randY2 = randY1 + (int)random(50,200);
     int randX = (int)random(20,200);     
     float randSpeed = random(1,10);      
     int randType = (int)random(0,50);
     println(createVerticalEdge(randX,randY1,randY2,randSpeed,randType));  
   }  

  //Create a vertically moving edge and print its values to the console
  //Its starting point is in the right half of the window
  //With a Frame Rate of 50 this Event occurs every 40 seconds
  if(frameCount %  2000 == 0){
     int randY1 = (int)random(20,150);
     int randY2 = randY1 + (int)random(50,200);
     int randX = (int)random(width-200,width-20);
     float randSpeed = random(1,10);    
     int randType = (int)random(0,50);
     println(createVerticalEdge(randX,randY1,randY2,randSpeed,randType));  
   } 
}

String createHorizontalEdge(int x1, int x2, int y, float speed, int type){
  //set a Range for each type
  //If the randomly generated type value falls into this range, generate the edge with this type
  //If the value is below 4, dont create a horizontal edge
  //Print the created edge to the console
   if(type >= 0 && type <= 4){
     //DO NOTHING
     return "";
   } else {
     Edge newE = new Edge();
     newE.setEdgeX1(x1);
     newE.setEdgeX2(x2);
     newE.setEdgeY1(y);
     newE.setEdgeY2(y);
     newE.setSpeedX(speed);
     if(type >= 5 && type <= 19)newE.plusEdge = true;
     if(type >= 20 && type <= 29)newE.minusEdge = true;
     if(type >= 30 && type <= 40)newE.collisionEdge = true;
     edges.add(newE); 
     return "CREATE EDGE HORIZONTAL [x1: "+newE.getEdgeX1()+"; y1: "+newE.getEdgeY1()+"; x2: "+newE.getEdgeX2()+"; y2: "+newE.getEdgeY2()+"; speedX: "+newE.getSpeedX()+"; speedY: "+newE.getSpeedY()+"; plusEdge: "+newE.getPlusEdge()+"; minusEdge: "+newE.getMinusEdge()+"; collisionEdge: "+newE.getCollisionEdge()+"]";    
   }
}

String createVerticalEdge(int x, int y1, int y2, float speed, int type){
  //set a Range for each type
  //If the randomly generated type value falls into this range, generate the edge with this type
  //If the value is below 35, dont create a vertical edge
  //Print the created edge to the console
   if(type >= 0 && type <= 35){
     //DO NOTHING
     return "";
   } else {
     Edge newE = new Edge();
     newE.setEdgeX1(x);
     newE.setEdgeX2(x);
     newE.setEdgeY1(y1);
     newE.setEdgeY2(y2);
     newE.setSpeedY(speed);
     if(type >= 36 && type <= 40)newE.plusEdge = true;
     if(type >= 41 && type <= 45)newE.minusEdge = true;
     if(type >= 46 && type <= 50)newE.collisionEdge = true;
     edges.add(newE);
     return "CREATE EDGE VERTICAL [x1: "+newE.getEdgeX1()+"; y1: "+newE.getEdgeY1()+"; x2: "+newE.getEdgeX2()+"; y2: "+newE.getEdgeY2()+"; speedX: "+newE.getSpeedX()+"; speedY: "+newE.getSpeedY()+"; plusEdge: "+newE.getPlusEdge()+"; minusEdge: "+newE.getMinusEdge()+"; collisionEdge: "+newE.getCollisionEdge()+"]";    
  } 
}

void move(){  
  //Call the move() function of every marble saved in ArrayList<Marble> marbles
  for (int i = 0; i < marbles.size(); i++) {
    marbles.get(i).move();
  }
  
  //Call the move() function of every edge saved in ArrayList<Edge> edges
  for (int j = 0; j < edges.size(); j++){
    edges.get(j).move();
  } 
}

void handleCollisions(){
  //Check if any marble collided with an edge
  //In case of a collision, check the type of the edge and act accordingly 
  //(for Example: marble collides with a plus edge -> remove Marble and add Points to the score)
  //Print values of the marble and edge that collided to the console
  for (int i = 0; i < marbles.size(); i++) {
    marbles.get(i).checkOutOfBounds();    
    for (int j = 0; j < edges.size(); j++){      
      try{
        marbles.get(i).hit = lineCircle(edges.get(j).getEdgeX1(), edges.get(j).getEdgeY1(), edges.get(j).getEdgeX2(), edges.get(j).getEdgeY2(), marbles.get(i).getX(), marbles.get(i).getY(), marbles.get(i).getRadius());
        if (marbles.size() > 0 && marbles.get(i).hit){
          if(edges.get(j).getPlusEdge() == true){
            println("COLLISION MARBLE POS EDGE [x1: "+edges.get(j).getEdgeX1()+"; y1: "+edges.get(j).getEdgeY1()+"; x2: "+edges.get(j).getEdgeX2()+"; y2: "+edges.get(j).getEdgeY2()+"; speedX: "+edges.get(j).getSpeedX()+"; speedY: "+edges.get(j).getSpeedY()+"; plusEdge: "+edges.get(j).getPlusEdge()+"; minusEdge: "+edges.get(j).getMinusEdge()+"; collisionEdge: "+edges.get(j).getCollisionEdge()+"]");
            score = score + addPoints;
            println("ADD POINTS TO SCORE [ +"+addPoints+"; new Score: "+score+" ]");
            marbles.remove(marbles.get(i));
            println("REMOVE MARBLE [x: "+marbles.get(i).getX()+"; y: "+marbles.get(i).getY()+"; radius: "+marbles.get(i).radius+"; speedX: "+marbles.get(i).getSpeedX()+"; speedY:"+marbles.get(i).getSpeedY()+"; outOfBoundsCounter: "+marbles.get(i).getOutOfBoundsCounter()+"]");

          } else if(edges.get(j).getMinusEdge() == true){
            println("COLLISION MARBLE MIN EDGE [x1: "+edges.get(j).getEdgeX1()+"; y1: "+edges.get(j).getEdgeY1()+"; x2: "+edges.get(j).getEdgeX2()+"; y2: "+edges.get(j).getEdgeY2()+"; speedX: "+edges.get(j).getSpeedX()+"; speedY: "+edges.get(j).getSpeedY()+"; plusEdge: "+edges.get(j).getPlusEdge()+"; minusEdge: "+edges.get(j).getMinusEdge()+"; collisionEdge: "+edges.get(j).getCollisionEdge()+"]");
            score = score - subtractPoints;
            println("SUBTRACT POINTS FROM SCORE [ -"+subtractPoints+"; new Score: "+score+" ]");
            marbles.remove(marbles.get(i)); 
            println("REMOVE MARBLE [x: "+marbles.get(i).getX()+"; y: "+marbles.get(i).getY()+"; radius: "+marbles.get(i).radius+"; speedX: "+marbles.get(i).getSpeedX()+"; speedY:"+marbles.get(i).getSpeedY()+"; outOfBoundsCounter: "+marbles.get(i).getOutOfBoundsCounter()+"]");

          } else if(edges.get(j).getCollisionEdge() == true){
            println("COLLISION MARBLE COL EDGE [x1: "+edges.get(j).getEdgeX1()+"; y1: "+edges.get(j).getEdgeY1()+"; x2: "+edges.get(j).getEdgeX2()+"; y2: "+edges.get(j).getEdgeY2()+"; speedX: "+edges.get(j).getSpeedX()+"; speedY: "+edges.get(j).getSpeedY()+"; plusEdge: "+edges.get(j).getPlusEdge()+"; minusEdge: "+edges.get(j).getMinusEdge()+"; collisionEdge: "+edges.get(j).getCollisionEdge()+"]");
            marbles.get(i).setSpeedX(random(-2,-1));        
            marbles.get(i).setSpeedY(random(-2,-1));  
            println("CHANGE SPEED MARBLE [x: "+marbles.get(i).getX()+"; y: "+marbles.get(i).getY()+"; radius: "+marbles.get(i).radius+"; speedX: "+marbles.get(i).getSpeedX()+"; speedY: "+marbles.get(i).getSpeedY()+"; outOfBoundsCounter: "+marbles.get(i).getOutOfBoundsCounter()+"]");
          }
          
        }        
      } catch (IndexOutOfBoundsException e){
            println(e);
      } 
    }
  }
}

//Draw every component to the screen (GUI, Marbles, Edges)
void display(){
  
  //Draw GUI
  textSize(16); 
  text(score, width - 75, 50);
  text("Marbles: "+countMarbles(), 50, height-75);
  text("max.: "+maxMarbles, 50, height-50);
  text(nf(timer.hour(), 2)+":"+nf(timer.minute(), 2)+":"+nf(timer.second(), 2), 50, 50);
  text("©mt151062", width - 150, height-50);
  
  fill(255,255,255);
  stroke(255,255,255);
  strokeWeight(2);
  int offset = 5;
  line(offset,offset,width-offset,offset);
  line(width-offset,offset,width-offset,height-offset);
  line(width-offset,height-offset,offset,height-offset);
  line(offset,height-offset,offset,offset);
  strokeWeight(1);
  stroke(0,0,0);
  
  //Draw marbles
  for (int i = 0; i < marbles.size(); i++){
      marbles.get(i).display();
  }
  
  //Draw edges
  for (int j = 0; j < edges.size(); j++){
    edges.get(j).display();
  }   
}

//Count the amount of active marbles
int countMarbles(){
  if(marbles.size() == maxMarbles) println("MAXIMUM NUMBER OF MARBLES REACHED");
  return marbles.size();
}

// LINE/CIRCLE
boolean lineCircle(float x1, float y1, float x2, float y2, float cx, float cy, float r) {

  // is either end INSIDE the circle?
  // if so, return true immediately
  boolean inside1 = pointCircle(x1, y1, cx, cy, r);
  boolean inside2 = pointCircle(x2, y2, cx, cy, r);
  if (inside1 || inside2) return true;

  // get length of the line
  float distX = x1 - x2;
  float distY = y1 - y2;
  float len = sqrt( (distX*distX) + (distY*distY) );

  // get dot product of the line and circle
  float dot = ( ((cx-x1)*(x2-x1)) + ((cy-y1)*(y2-y1)) ) / pow(len, 2);

  // find the closest point on the line
  float closestX = x1 + (dot * (x2-x1));
  float closestY = y1 + (dot * (y2-y1));

  // is this point actually on the line segment?
  // if so keep going, but if not, return false
  boolean onSegment = linePoint(x1, y1, x2, y2, closestX, closestY);
  if (!onSegment) return false;

  // get distance to closest point
  distX = closestX - cx;
  distY = closestY - cy;
  float distance = sqrt( (distX*distX) + (distY*distY) );

  if (distance <= r) {
    return true;
  }
  return false;
}

// POINT/CIRCLE
boolean pointCircle(float px, float py, float cx, float cy, float r) {

  // get distance between the point and circle's center
  // using the Pythagorean Theorem
  float distX = px - cx;
  float distY = py - cy;
  float distance = sqrt( (distX*distX) + (distY*distY) );

  // if the distance is less than the circle's
  // radius the point is inside!
  if (distance <= r) {
    return true;
  }
  return false;
}


// LINE/POINT
boolean linePoint(float x1, float y1, float x2, float y2, float px, float py) {

  // get distance from the point to the two ends of the line
  float d1 = dist(px, py, x1, y1);
  float d2 = dist(px, py, x2, y2);

  // get the length of the line
  float lineLen = dist(x1, y1, x2, y2);

  // since floats are so minutely accurate, add
  // a little buffer zone that will give collision
  float buffer = 0.1;    // higher # = less accurate

  // if the two distances are equal to the line's
  // length, the point is on the line!
  // note we use the buffer here to give a range,
  // rather than one #
  if (d1+d2 >= lineLen-buffer && d1+d2 <= lineLen+buffer) {
    return true;
  }
  return false;
}