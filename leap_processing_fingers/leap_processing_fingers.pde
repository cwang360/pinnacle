import de.voidplus.leapmotion.*;
import java.util.Queue;
import java.util.LinkedList;
import java.util.Collections;

LeapMotion leap;

final int WINDOW_SIZE = 20;
final int ACCEL_CUTOFF = 20;

// array holding queue for each finger's sliding window position data points.
ArrayList<Queue<PVector>> posFrames;
// array holding queue for each finger's sliding window velocity data points.
ArrayList<Queue<PVector>> velFrames;

// array for each finger's change in velocity
ArrayList<Double> accel;

void setup() {
  size(800, 500);
  background(255);

  leap = new LeapMotion(this);
  accel = new ArrayList<Double>();
  for (int i = 0; i < 10; i++) {
    accel.add(new Double(0));
  }

  posFrames = new ArrayList<Queue<PVector>>(10);
  velFrames = new ArrayList<Queue<PVector>>(10);

  print("Waiting for hands");
  while (!leap.hasHands() || leap.getHands().size() < 2) {
    print(".");
    delay(1000);
  }
  println();

  for (int i = 0; i < 10; i++) {
    posFrames.add(i, new LinkedList<PVector>());
    velFrames.add(i, new LinkedList<PVector>());
  }

  // initial position data points 
  for (int i = 0; i < WINDOW_SIZE; i++) {
    for (Hand hand : leap.getHands()) {
      if (hand.isLeft()) {
        for (Finger finger : hand.getFingers()) {
          posFrames.get(finger.getType()).add(finger.getStabilizedPosition());
        }
      } else if (hand.isRight()) {
        for (Finger finger : hand.getFingers()) {
          posFrames.get(finger.getType()+5).add(finger.getStabilizedPosition());
        }
      }
    }
    delay(10);
  }

  // initial velocity data points
  for (int i = 0; i < WINDOW_SIZE-1; i++) {
    for (Hand hand : leap.getHands()) {
      if (hand.isLeft()) {
        for (Finger finger : hand.getFingers()) {
          PVector currPos = finger.getPosition();
          velFrames.get(finger.getType()).add(PVector.sub(currPos, posFrames.get(finger.getType()).remove()));
          posFrames.get(finger.getType()).add(currPos);
        }
      } else if (hand.isRight()) {
        for (Finger finger : hand.getFingers()) {
          PVector currPos = finger.getPosition();
          velFrames.get(finger.getType()+5).add(PVector.sub(currPos, posFrames.get(finger.getType()+5).remove()));
          posFrames.get(finger.getType()+5).add(currPos);
        }
      }
    }
    delay(10);
  }
  println(velFrames);
  println(posFrames);
}


void draw() {
  background(255);

  //int fps = leap.getFrameRate();

  for (Hand hand : leap.getHands()) {
    hand.draw();
    if (hand.isLeft()) {
      for (Finger finger : hand.getFingers()) {
        PVector currPos = finger.getStabilizedPosition();
        PVector currVel = PVector.sub(currPos, posFrames.get(finger.getType()).remove());
        accel.set(finger.getType(), new Double(
          PVector.sub(currVel, velFrames.get(finger.getType()).remove()).mag())
          );
        posFrames.get(finger.getType()).add(currPos);
        velFrames.get(finger.getType()).add(currVel);
      }
    } else if (hand.isRight()) {
      for (Finger finger : hand.getFingers()) {
        PVector currPos = finger.getStabilizedPosition();
        PVector currVel = PVector.sub(currPos, posFrames.get(finger.getType()+5).remove());
        accel.set(finger.getType()+5, new Double(
          PVector.sub(currVel, velFrames.get(finger.getType()+5).remove()).mag())
          );
        posFrames.get(finger.getType()+5).add(currPos);
        velFrames.get(finger.getType()+5).add(currVel);
        
      }
    }
  }

  Double maxAccel = Collections.max(accel);
  int maxFinger = accel.indexOf(maxAccel);
  //println(posFrames);
  
  println(maxAccel);

  for (Hand hand : leap.getHands ()) {

    boolean handIsLeft         = hand.isLeft();
    boolean handIsRight        = hand.isRight();

    


    for (Finger finger : hand.getFingers()) {
      int     fingerType         = finger.getType();
      PVector fingerStabilized = finger.getStabilizedPosition();


      if (maxAccel > ACCEL_CUTOFF) {
        if ((maxFinger < 5 && handIsLeft && fingerType == maxFinger) || (maxFinger >= 5 && handIsRight && fingerType == maxFinger-5)) {
          ellipse(fingerStabilized.x, fingerStabilized.y, 10, 10);
        }
      }
    }
  }
}
