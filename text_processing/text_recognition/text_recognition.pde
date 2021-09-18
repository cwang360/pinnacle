int length = 800;
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
  
  displayLetters(currentWord, currentIndex);
  
  //textSize(30);
  //fill(0, 180, 0);
  //text(currentWord.substring(0, currentIndex), length/8, (length*1.5)/8);
  //fill(0);
  //text(currentWord.charAt(currentIndex), length/8 + 20 * currentIndex, (length*1.5)/8);
  //text(currentWord.substring(currentIndex + 1, currentWord.length()), length/8 + 20 * (currentIndex + 2), (length*1.5)/8);
  textSize(20);
  text("Number of words correctly inputted: " + numCompleted, length/8, (length*2.5)/8);
}

String pickWord() {
  String[] words = {"hackathon", "pinnacle", "worldlink", "twilio", "lulzbot", "airbnb", "level", "human", "dorm", "a", "b", "c" };
  
  String word = words[(int) (Math.random() * words.length)];
  return word;
}

void keyPressed() {
   if (key == currentWord.charAt(currentIndex)) {
     currentIndex++;
     if (currentIndex == currentWord.length()) {
       text("Yay!", length/2, length/2);
       numCompleted++;
       currentIndex = 0;
       currentWord = pickWord();
       delay(300);
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
      text(word.charAt(dis), x + padding * dis, y);
    } else {
      fill(0);
      text(word.charAt(dis), x + padding * (dis + 2.5), y);
    }
    dis++;
  }
}
