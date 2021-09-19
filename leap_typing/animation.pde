public class Animation{
  private PVector pos;
  private int radius;
  private float alpha;
  public Animation(PVector pos){
    this.pos = pos;  
    radius = 0;
    alpha = 255;
  }
  public void update(){
    noFill();
    stroke(179, 207, 255, alpha);
    ellipse(pos.x, pos.y, radius, radius);
    radius += 2;
    alpha -= 7;
  }
  public int getRadius(){
    return radius;
  }
}
