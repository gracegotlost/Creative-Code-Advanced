ArrayList<BasicShape> shapes = new ArrayList<BasicShape>();

void setup() {
  size(800, 600, P3D);
  background(0);
  noStroke();

  for (int i = 0; i < 50; i++) {
    shapes.add(new Cube());
    shapes.add(new Sphere());
  }
}

void draw() {
  //background(0);
  lights();
  for (BasicShape b : shapes) {
    b.update();
    b.display();
  }
}

