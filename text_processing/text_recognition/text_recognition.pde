int length = 800;
char currentLetter = pickLetter();
int numCompleted = 0;

void setup() {
  size(800, 800);
     
}


//simple type the letter test
void draw() {
  background(255);
  fill(0);
  textSize(20);
  text("Type in the following letter:", length/8, length/8);
  text(currentLetter + "", length/8, (length*1.5)/8);
  text("Number of characters correctly inputted: " + numCompleted, length/8, (length*2.5)/8);
}

char pickLetter() {
  String alphabet = "abcdefghijklmnopqrstuvwxyz";
  char current = alphabet.charAt((int)(Math.random()*26));
  return current;
}

String pickWord() {
  
  return "";
}


//char version
void keyPressed() {
  if (key == currentLetter) {
    currentLetter = pickLetter();
    numCompleted++;
    typeSuccess();
  }
}

//string and char version (version to use)



//why no turn green
void typeSuccess() {
  background(255);
  fill(0);
  textSize(20);
  text("Type in the following letter:", length/8, length/8);
  fill(0,255,0);
  text(currentLetter + "", length/8, (length*1.5)/8);
  fill(0);
  text("Number of characters correctly inputted: " + numCompleted, length/8, (length*2.5)/8);
  delay(500);
}
