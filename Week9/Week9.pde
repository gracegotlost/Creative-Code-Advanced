/*Week9 - Helix Sphere - Grace*/
float rotation = 0;

void setup() {
  size (1024, 768, P3D);
  background(0);
}

void draw() {
  fill(0, 20);
  rect(0, 0, width, height);

  noStroke();
  lights();

  // Hydrogen Helix
  for (int i = -10; i < 10; i++) {
    fill(100, 200);
    pushMatrix();
    translate(width/2, height/2 + i * 50, 100);
    pushMatrix();
    rotateY(rotation + i * 0.5);
    pushMatrix();
    translate(-80, 0);
    sphere(20);
    popMatrix();

    pushMatrix();
    translate(80, 0);
    sphere(20);
    popMatrix();
    popMatrix();
    popMatrix();
  }

  // Oxygen Helix
  for (int i = -10; i < 10; i++) {
    fill(10, 100, 200, 200);
    pushMatrix();
    translate(width/2, height/2 + i * 50, 100);
    pushMatrix();
    rotateY(rotation + i * 0.5);
    pushMatrix();
    translate(-100, 0);
    sphere(15);
    popMatrix();

    pushMatrix();
    translate(100, 0);
    sphere(15);
    popMatrix();
    popMatrix();
    popMatrix();
  }

  for (int i = -10; i < 10; i++) {
    fill(10, 100, 200, 200);
    pushMatrix();
    translate(width/2, height/2 + i * 50, 100);
    pushMatrix();
    rotateY(rotation + i * 0.5);
    pushMatrix();
    translate(-60, 0);
    sphere(15);
    popMatrix();

    pushMatrix();
    translate(60, 0);
    sphere(15);
    popMatrix();
    popMatrix();
    popMatrix();
  }

  rotation = (rotation + (PI/100)) % (2 * PI);
}

