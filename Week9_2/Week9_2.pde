/*Week9 - 2 - Helix Sphere 2 - Grace*/
float rotation = 0;

void setup() {
  size (1024, 768, P3D);
  background(0);
}

void draw() {
  fill(0, 100);
  rect(0, 0, width, height);

  noStroke();
  lights();

  for (int i = -10; i < 10; i++) {
    for (int j = -1; j <= 1; j++) {
      fill((abs(j) + 1) * 80, 50, 100);
      pushMatrix();
      translate(width/2 + j * 150, height/2 + i * 50, 100);
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
  }

  rotation = (rotation + (PI/100)) % (2 * PI);
}

