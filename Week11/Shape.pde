public abstract class Shape implements BasicShape {

  PVector pos = new PVector();
  PVector rot = new PVector();
  float rotation;
  int size;
  color c;

  public Shape () {
    pos = PVector.random3D();
    rot = PVector.random3D();
    pos.x /= sqrt(pow(pos.x, 2) + pow(pos.y, 2) + pow(pos.z, 2));
    pos.y /= sqrt(pow(pos.x, 2) + pow(pos.y, 2) + pow(pos.z, 2));
    pos.z /= sqrt(pow(pos.x, 2) + pow(pos.y, 2) + pow(pos.z, 2));
    pos.x *= 200;
    pos.y *= 200;
    pos.z *= 200;
    rotation = 0;
    size = int(random(10));
    c = color(int(random(255)), int(random(255)), int(random(255)), int(random(255)));
  }

  public abstract void display();
  public abstract void update();
}

