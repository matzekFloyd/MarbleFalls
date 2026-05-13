/*
  08.09.2017 - 21:30
  Projectname: Marble Falls
  Author: Mathias Mayrhofer
  Matrikelnummer: mt151062  
  Touchscreen: 3.2" tft lcd shield w/ touch panel TF Reader 
*/

#include <ArduCAM_Touch.h>
#include <SD.h>

// Declare which fonts we will be using
extern uint8_t SmallFont[];

//myTouch(TCS,IRQ);
ArduCAM_Touch  myTouch(10,9);

int cx, cy;
int rx[10], ry[10];
float px, py;
int ox, oy;

void setup()
{
  Serial.begin(9600);
  myTouch.InitTouch();
  myTouch.setPrecision(PREC_LOW);
}
void readCoordinates()
{
  int iter = 2000;
  int cnt = 0;
  unsigned long tx=0;
  unsigned long ty=0;
  boolean OK = false;
  
  while (OK == false)
  {
    while (myTouch.dataAvailable() == false) {}
    while ((myTouch.dataAvailable() == true) && (cnt<iter))
    {
      myTouch.read();
      tx += myTouch.TP_X;
      ty += myTouch.TP_Y;
      Serial.print("X");
      if(myTouch.TP_X <= 1000){
        Serial.print("0");
        Serial.print(myTouch.TP_X);     
      } else {
        Serial.print(myTouch.TP_X);             
      }
      Serial.print("Y");
      if(myTouch.TP_Y <= 1000){
        Serial.print("0");
        Serial.print(myTouch.TP_Y);     
      } else {
        Serial.print(myTouch.TP_Y);             
      }
      Serial.print('\n');
      delay(75);
      cnt++;
    }
    if (cnt>=iter)
    {
      OK = true;
    }
    else
    {
      tx = 0;
      ty = 0;
      cnt = 0;
    }
  }

  cx = tx / iter;
  cy = ty / iter;
}

void loop()
{
  readCoordinates();
}
