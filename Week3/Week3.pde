/*Creative Code: Advanced - Week 3 - Grace*/

PImage finger;
PImage scratch1;
PImage scratch2;
PImage scratch3;
boolean isDragging = false;
boolean [] isChanging = new boolean[800 * 600];
boolean isWinning = false;
float count;

void setup() {
  size(800, 600);
  finger = loadImage("finger.png");
  scratch1 = loadImage("scratch1.jpg");
  scratch2 = loadImage("scratch2.jpg");
  scratch3 = loadImage("scratch3.jpg");

  for (int i = 0; i < isChanging.length; i++) {
    isChanging[i] = false;
  }

  noCursor();
}

void draw() {
  background(255);

  //check scratching
  loadPixels(); 
  scratch1.loadPixels(); 

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      int loc = x + y * width;
      float r, g, b;

      if (isDragging && mouseX == x && mouseY == y) {
        //change the current pixel and related 5 * 5 pixels
        r = red(scratch2.pixels[loc]);
        g = green(scratch2.pixels[loc]);
        b = blue(scratch2.pixels[loc]);
        for (int i = -20; i <= 20; i++) {
          for (int j = -20; j <= 20; j++) {
            if (dist(x, y, x + i, y + j) < 20) {
              isChanging[loc + i * width + j] = true;
            }
          }
        }
      } else if (isChanging[loc] == true) {
        r = red(scratch2.pixels[loc]);
        g = green(scratch2.pixels[loc]);
        b = blue(scratch2.pixels[loc]);
      } else {
        r = red(scratch1.pixels[loc]);
        g = green(scratch1.pixels[loc]);
        b = blue(scratch1.pixels[loc]);
      }

      pixels[loc] =  color(r, g, b);
    }
  }
  updatePixels();

  image(finger, mouseX - 10, mouseY);

  //check winning point
  if (isWinning == false) {
    count = 0;
    for (int i = 0; i < isChanging.length; i++) {
      if (isChanging[i] == true) {
        count++;
      }
    }
    if (count/isChanging.length > 0.1) {
      isWinning = true;
    }
  } else {
    image(scratch3, 0, 0);
  }

  //println(count/isChanging.length);
}

void mousePressed() {
  isDragging = true;
}

void mouseReleased() {
  isDragging = false;
}

