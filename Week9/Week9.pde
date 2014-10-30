/*Week9 - Helix Sphere - Grace*/
float rotation = 0;

void setup() {
  size (1024, 768, P3D);
}

void draw() {
  background(0);
  noStroke();
  lights();
  
  for (int i = -10; i < 10; i++) {
    pushMatrix();
    translate(width/2, height/2 + i * 50, 0);
    pushMatrix();
    rotateY(rotation + i * 0.5);
    pushMatrix();
    translate(-100, 0);
    sphere(20);
    popMatrix();

    pushMatrix();
    translate(100, 0);
    sphere(20);
    popMatrix();
    popMatrix();
    popMatrix();
  }
  
  rotation = (rotation + (PI/100)) % (2 * PI);
}

