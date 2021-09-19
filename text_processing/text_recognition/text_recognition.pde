import java.util.HashMap;

int length = 800;
int numCompleted = 0;
String currentWord = pickWord();
int currentIndex = 0;
HashMap<Character, Integer> fingerMapping;

void setup() {
  size(800, 800);
  setUpFingerMapping();
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
}

String pickWord() {
  String[] words = {"hackathon", "pinnacle", "worldlink", "twilio", "lulzbot", "airbnb", "level", "human", "dorm", "a", "b", "c" };

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
      text(word.charAt(dis), x + padding * dis, y);
    } else {
      fill(0);
      text(word.charAt(dis), x + padding * (dis + 2.5), y);
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
  fingerMapping.put('n', 6);
  fingerMapping.put('n', 6);
  fingerMapping.put('9', 7);
  fingerMapping.put('i', 7);
  fingerMapping.put('k', 7);
  fingerMapping.put(',', 7);
  fingerMapping.put('0', 8);
  fingerMapping.put('o', 8);
  fingerMapping.put('l', 8);
  fingerMapping.put('.', 8);
  fingerMapping.put('-', 9);
  fingerMapping.put('[', 9); 
  fingerMapping.put(';', 9);
  fingerMapping.put('/', 9);
  fingerMapping.put('[', 9);
  fingerMapping.put(']', 9);
  fingerMapping.put('=', 9);
  fingerMapping.put('\\', 9);
  fingerMapping.put(' ', 10);
}

boolean processInput(int input) {
  char curr = currentWord.charAt(currentIndex);
  if (fingerMapping.get(curr) == input) {
    return true;
  } else return false;
}
