public class Sphere extends Shape {
  public void display() {
    fill(c);
    pushMatrix();
    translate(width/2, height/2, 0);
    rotate(rotation, rot.x, rot.y, rot.z);
    translate(pos.x, pos.y, pos.z);
    sphere(size);
    popMatrix();
  }

  public void update () {
    rotation = (rotation + (PI/100)) % (2 * PI);
  }
}

