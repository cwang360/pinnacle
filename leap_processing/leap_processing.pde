import processing.serial.*;
import cc.arduino.*;
import de.voidplus.leapmotion.*;
import java.util.Queue;
import java.util.LinkedList;

LeapMotion leap;
Arduino arduino;
int ledPin = 13;
Queue<PVector> leftIndexPos;
Queue<PVector> rightIndexPos;

void setup(){
  size(400, 400);
  background(255);

  leap = new LeapMotion(this);
  //arduino = new Arduino(this, Arduino.list()[2], 57600);
  //arduino.pinMode(ledPin, Arduino.OUTPUT);
  //arduino.pinMode(9, Arduino.SERVO);
  leftIndexPos = new LinkedList<PVector>();
  rightIndexPos = new LinkedList<PVector>();

  while(!leap.hasHands() || leap.getHands().size() < 2) {
    println("Waiting for hands...");
  }

  // Fill queue with 5 initial data points
  for (int i = 0; i < 5; i++) {
    leftIndexPos.add(leap.getHands().get(0).getIndexFinger().getPositionOfJointTip());
    rightIndexPos.add(leap.getHands().get(1).getIndexFinger().getPositionOfJointTip());
    delay(10);
  }

 
}

void draw(){
  background(255);
  //for(Hand hand : leap.getHands()){
  //  Finger thumb = hand.getThumb();
  //  Finger index = hand.getIndexFinger();
  //  Finger ring = hand.getRingFinger();
  //  Finger pinky = hand.getPinkyFinger();
  //  PVector pos = index.getPositionOfJointTip();
    
  //  //hand.draw();
  //}
  
  // Find velocity of each finger
  if(leap.hasHands() && leap.getHands().size() == 2){
    PVector currLeftIndexPos = leap.getHands().get(0).getIndexFinger().getPositionOfJointTip();
    PVector currRightIndexPos = leap.getHands().get(1).getIndexFinger().getPositionOfJointTip();
    PVector deltaLeftIndexPos = currLeftIndexPos.sub(leftIndexPos.remove());
    PVector deltaRightIndexPos = currRightIndexPos.sub(rightIndexPos.remove());
    //print
    println("Left index: " + deltaLeftIndexPos.mag());
    println("Right index: " + deltaRightIndexPos.mag());
    
    leftIndexPos.add(currLeftIndexPos);
    rightIndexPos.add(currRightIndexPos);
  }
  

//  if (frameCount % 50 == 0) {
//    thread("controlArduino");
//  }
}

//void controlArduino() {
//  arduino.digitalWrite(ledPin, Arduino.HIGH);
//  arduino.servoWrite(9, 0);
//  delay(1000);
//  arduino.digitalWrite(ledPin, Arduino.LOW);
//  arduino.servoWrite(9, 180);
//  delay(1000);
  

//}
