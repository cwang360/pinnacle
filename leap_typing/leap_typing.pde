import java.util.HashMap;
import de.voidplus.leapmotion.*;
import java.util.Queue;
import java.util.LinkedList;
import java.util.Collections;
import java.util.Arrays;

int length = 800;
int numCompleted = 0;
String currentWord = pickWord();
int currentIndex = 0;
HashMap<Character, Integer> fingerMapping;
boolean prevTyped = false;


LeapMotion leap;

final int WINDOW_SIZE = 20;
final int ACCEL_CUTOFF = 10;

ArrayList<Animation> animations = new ArrayList<Animation>();

// array holding queue for each finger's sliding window position data points.
ArrayList<Queue<PVector>> posFrames;
// array holding queue for each finger's sliding window velocity data points.
ArrayList<Queue<PVector>> velFrames;

// array for each finger's change in velocity
ArrayList<Double> accel;

Queue<Integer> maxFingers = new LinkedList<Integer>(Arrays.asList(0, 0, 0));
int maxFinger = 0;

void setup() {
  size(800, 650);
  background(255);
  fill(0);
  setUpFingerMapping();
  leap = new LeapMotion(this);
  waitForHands();
  setUpFingerTrackingData();
}

//simple type the letter test
void draw() {
  background(255);
  fill(0);
  textSize(20);
  text("Type in the following word:", length/8, length/8);

  displayLetters(currentWord, currentIndex);
  textSize(20);
  text("Number of words correctly inputted: " + numCompleted, length/8, (length*2.5)/8);
  calculateCurrAccel();

  Double maxAccel = Collections.max(accel);
  //int maxFinger = accel.indexOf(maxAccel);

  println(maxAccel);
  if (maxAccel > ACCEL_CUTOFF) {
    //if (!prevTyped) {
      if (accel.indexOf(maxAccel) == maxFingers.peek()) {
        maxFinger = maxFingers.remove();
        processInput((maxFinger == 0 || maxFinger == 5) ? 10 : maxFinger);
        prevTyped = true;
      } else {
        maxFingers.remove();
        prevTyped = false;
      }
      maxFingers.add(accel.indexOf(maxAccel));

      //println(maxFinger);
    } 
  //}else {
  //    print("done: " +maxAccel);
  //    prevTyped = false;
  //  }


  markMaxAccelFinger();
}

String pickWord() {
  String[] words = {"pinnacle.", "worldlink", "lulzbot", "arduino", "airbnb", "stellar", "human capital", "dorm room fund", "b", "c" };

  String word = words[(int) (Math.random() * words.length)];
  return word;
}

//replace with leapmotion things.
void keyPressed() {
  if (key == currentWord.charAt(currentIndex)) {
    currentIndex++;
    if (currentIndex == currentWord.length()) {
      numCompleted++;
      currentIndex = 0;
      currentWord = pickWord();
      delay(200);
    }
  }
}

void displayLetters(String word, int curr) {
  int x = length/8;
  int y = int (length/8 * 1.5);
  int padding = 18;
  int dis = 0;
  while (dis < word.length()) {
    if (dis < curr) {
      fill(0, 180, 0);
      stroke(0, 180, 0);
      if(word.charAt(dis) == ' '){
          fill(143, 199, 143);
          stroke(143, 199, 143);
          rect(x+padding*dis, y-18, 12, 20);
      } else{
         text(word.charAt(dis), x + padding * dis, y);
      }
      
    } else {
      fill(0);
      stroke(0);
      if(word.charAt(dis) == ' '){
          fill(200);
          stroke(200);
          rect(x+padding*(dis + 2.5), y-18, 12, 20);
      } else{
          text(word.charAt(dis), x + padding * (dis + 2.5), y);
      }
    }
    dis++;
  }
}

void setUpFingerMapping() {
  //10 indicates either thumb!!!
  fingerMapping = new HashMap<Character, Integer>();
  fingerMapping.put('1', 4);
  fingerMapping.put('2', 4);
  fingerMapping.put('q', 4);
  fingerMapping.put('a', 4);
  fingerMapping.put('z', 4);
  fingerMapping.put('3', 3);
  fingerMapping.put('w', 3);
  fingerMapping.put('s', 3);
  fingerMapping.put('x', 3);
  fingerMapping.put('4', 2);
  fingerMapping.put('e', 2);
  fingerMapping.put('d', 2);
  fingerMapping.put('c', 2);
  fingerMapping.put('5', 1);
  fingerMapping.put('6', 1);
  fingerMapping.put('r', 1);
  fingerMapping.put('t', 1);
  fingerMapping.put('f', 1);
  fingerMapping.put('g', 1);
  fingerMapping.put('v', 1);
  fingerMapping.put('b', 1);
  fingerMapping.put('7', 6);
  fingerMapping.put('8', 6);
  fingerMapping.put('y', 6);
  fingerMapping.put('u', 6);
  fingerMapping.put('h', 6);
  fingerMapping.put('j', 6);
  fingerMapping.put('m', 6);
  fingerMapping.put('n', 6);
  fingerMapping.put('9', 7);
  fingerMapping.put('i', 7);
  fingerMapping.put('k', 7);
  fingerMapping.put(',', 7);
  fingerMapping.put('0', 8);
  fingerMapping.put('o', 8);
  fingerMapping.put('l', 8);
  fingerMapping.put('.', 8);
  fingerMapping.put('p', 9);
  fingerMapping.put('-', 9);
  fingerMapping.put('[', 9); 
  fingerMapping.put(';', 9);
  fingerMapping.put('/', 9);
  fingerMapping.put('[', 9);
  fingerMapping.put(']', 9);
  fingerMapping.put('=', 9);
  fingerMapping.put('\'', 9);
  fingerMapping.put('\\', 9);
  fingerMapping.put(' ', 10);
}

boolean processInput(int input) {
  char curr = currentWord.charAt(currentIndex);
  if (fingerMapping.get(curr) == input) {
    currentIndex++;
    if (currentIndex == currentWord.length()) {
      numCompleted++;
      currentIndex = 0;
      currentWord = pickWord();
      delay(200);
    }
    return true;
  } else return false;
}

void setUpFingerTrackingData() {
  accel = new ArrayList<Double>();
  for (int i = 0; i < 10; i++) {
    accel.add(new Double(0));
  }

  posFrames = new ArrayList<Queue<PVector>>(10);
  velFrames = new ArrayList<Queue<PVector>>(10);
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
}

void waitForHands() {
  text("Please place both hands above Leap Motion Controller", 30, 100);
  print("Waiting for hands");
  while (!leap.hasHands() || leap.getHands().size() < 2) {
    print(".");
    delay(1000);
  }
  println();
}

void calculateCurrAccel() {
  for (Hand hand : leap.getHands()) {

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
}

void markMaxAccelFinger() {
  for(int i = animations.size()-1; i >= 0; i--){
    if(animations.get(i).getRadius() > 100){
      animations.remove(i);
    }else{
      animations.get(i).update();
    }
  }
  for (Hand hand : leap.getHands ()) {

    boolean handIsLeft = hand.isLeft();
    boolean handIsRight = hand.isRight();

    for (Finger finger : hand.getFingers()) {
      finger.drawJoints(10);
      finger.drawBones();
      int     fingerType = finger.getType();
      PVector fingerStabilized = finger.getStabilizedPosition();


      if ((maxFinger < 5 && handIsLeft && fingerType == maxFinger) || (maxFinger >= 5 && handIsRight && fingerType == maxFinger-5)) {
        fill(66, 135, 245);
        ellipse(fingerStabilized.x, fingerStabilized.y, 20, 20);
        animations.add(new Animation(fingerStabilized));
        switch(maxFinger % 5) {
        case 0: 
          text("Thumb", fingerStabilized.x, fingerStabilized.y-30);  
          break;
        case 1: 
          text("Index", fingerStabilized.x, fingerStabilized.y-30);
          break;
        case 2:
          text("Middle", fingerStabilized.x, fingerStabilized.y-30);
          break;
        case 3:
          text("Ring", fingerStabilized.x, fingerStabilized.y-30);  
          break;
        case 4:
          text("Pinky", fingerStabilized.x, fingerStabilized.y-30);
        }
      }
    }
  }

}
