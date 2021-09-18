int length = 800;
char currentLetter = pickLetter();
int numCompleted = 0;
String currentWord = pickWord();
int currentIndex = 0;

void setup() {
  size(800, 800); 
}

//simple type the letter test
void draw() {
  background(255);
  fill(0);
  textSize(20);
  text("Type in the following word:", length/8, length/8);
  text(currentWord.substring(0, currentIndex) + "  " + currentWord.charAt(currentIndex) 
  + "  " + currentWord.substring(currentIndex + 1, currentWord.length()), length/8, (length*1.5)/8);
  text("Number of words correctly inputted: " + numCompleted, length/8, (length*2.5)/8);
}

char pickLetter() {
  String alphabet = "abcdefghijklmnopqrstuvwxyz";
  char current = alphabet.charAt((int)(Math.random()*26));
  return current;
}

String pickWord() {
  String[] words = {"hackathon", "pinnacle", "worldlink", "twilio", "lulzbot", "airbnb", "level", "human", "dorm", "a", "b", "c" };
  
  String word = words[(int) (Math.random() * words.length)];
  return word;
}

//char version
//void keyPressed() {
//  if (key == currentLetter) {
//    currentLetter = pickLetter();
//    numCompleted++;
//    typeSuccess();
//  }
//}

//string and char version (version to use)
void keyPressed() {
   if (key == currentWord.charAt(currentIndex)) {
     currentIndex++;
     if (currentIndex == currentWord.length()) {
       text("Yay!", length/2, length/2);
       numCompleted++;
       currentIndex = 0;
       currentWord = pickWord();
       delay(500);
     }
   }
}
