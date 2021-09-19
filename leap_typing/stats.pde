public class KeyStat implements Comparable {
  char letter;
  int count;
  int averageTime;
  public KeyStat(char letter, int time){
    count = 1;
    this.letter = letter;
    this.averageTime = time;
  }
  public int compareTo(Object other){
    return ((KeyStat)other).getAverageTime() - this.averageTime;
  }
  public int getAverageTime(){
    return averageTime;
  }
  public void update(int time){
    averageTime = ((averageTime * count) + time)/(count+1);
    count++;
  }
  public String toString(){
    return letter + ": " + ((double)averageTime)/1000;
  }
}
