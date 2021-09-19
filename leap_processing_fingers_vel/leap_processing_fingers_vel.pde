import de.voidplus.leapmotion.*;
import java.util.Queue;
import java.util.LinkedList;
import java.util.Collections;

LeapMotion leap;

// queue for each finger's sliding window position data points.
ArrayList<Queue<PVector>> posFrames;

// array for each finger's change in position
ArrayList<Double> deltaPos;

void setup() {
  size(800, 500);
  background(255);

  leap = new LeapMotion(this);
  deltaPos = new ArrayList<Double>();
  for(int i = 0; i < 10; i++){
    deltaPos.add(new Double(0));
  }
  
  posFrames = new ArrayList<Queue<PVector>>(10);
  
    print("Waiting for hands");
  while(!leap.hasHands() || leap.getHands().size() < 2) {
    print(".");
    delay(1000);
  }
  println();
  
  for(int i = 0; i < 10; i++) {
    posFrames.add(i, new LinkedList<PVector>());
  }
  
  for(int i = 0; i < 50; i++){
    for(Hand hand : leap.getHands()) {
      if(hand.isLeft()){
        for(Finger finger : hand.getFingers()){
          posFrames.get(finger.getType()).add(finger.getPosition());
        }
      }
      else if(hand.isRight()){
        for(Finger finger : hand.getFingers()){
          posFrames.get(finger.getType()+5).add(finger.getPosition());
        }
      }
    }
    delay(10);
  }
}


void draw() {
  background(255);

  //int fps = leap.getFrameRate();
  
  for(Hand hand : leap.getHands()) {
    if(hand.isLeft()){
      for(Finger finger : hand.getFingers()){
        PVector currPos = finger.getPosition();
        deltaPos.set(finger.getType(), new Double(PVector.sub(currPos, posFrames.get(finger.getType()).remove()).mag()));
        posFrames.get(finger.getType()).add(currPos);
      }
    }
    else if(hand.isRight()){
      for(Finger finger : hand.getFingers()){
        PVector currPos = finger.getPosition();
        deltaPos.set(finger.getType()+5, new Double(PVector.sub(currPos, posFrames.get(finger.getType()+5).remove()).mag()));
        posFrames.get(finger.getType()+5).add(currPos);      
      }
    }
  }
  
  Double maxDeltaPos = Collections.max(deltaPos);
  int maxFinger = deltaPos.indexOf(maxDeltaPos);

  println(maxDeltaPos);

  for (Hand hand : leap.getHands ()) {

    boolean handIsLeft         = hand.isLeft();
    boolean handIsRight        = hand.isRight();
  
    hand.draw();


    for (Finger finger : hand.getFingers()) {
      int     fingerType         = finger.getType();
      PVector fingerPosition   = finger.getPosition();

      
      if (maxDeltaPos > 20) {
            if((maxFinger < 5 && handIsLeft && fingerType == maxFinger) || (maxFinger >= 5 && handIsRight && fingerType == maxFinger-5)) {
              ellipse(fingerPosition.x, fingerPosition.y, 10, 10);
            }

      }

    }

  }}
