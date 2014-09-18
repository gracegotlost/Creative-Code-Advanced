/*Creative Code: Advanced - Week2 - Ice Bucket Challenge - Grace*/
//Similar speed around 5000
//but will become slower after that using one thread
//keep the same speed after that using two threads

ArrayList<WaterDrop> drops;

PImage man;
PImage bucket;
float bucketPosX;
float bucketPosY;
boolean isDragging = false;
float dx;
float dy;
boolean isPouring = false;
float rotate;

void setup() {
  size(800, 600);
  drops = new ArrayList<WaterDrop>();

  man = loadImage("man.png");
  bucket = loadImage("bucket.png");
  imageMode(CENTER);

  bucketPosX = width * 0.75;
  bucketPosY = height * 0.75;

  noSmooth();
}

void draw() {
  background(255);

  //pouring
  if (abs(radians(rotate)) > 1.40) {
    isPouring = true;
  } else {
    isPouring = false;
  }

  if (isPouring == true) {
    drops.add(new WaterDrop());
  }

  //display one part of water drops
  for (WaterDrop a : drops) {
    if ((rotate > 0 && a.vel.x < -3) || (rotate < 0 && a.vel.x > 3)) {
      a.display();
    }
  }

  //display man and bucket
  image(man, width * 0.5, height * 0.54);
  pushMatrix();
  translate(bucketPosX, bucketPosY);
  rotate(-radians(rotate));
  image(bucket, 0, 0);
  popMatrix();

  //display the other part of water drops
  for (WaterDrop a : drops) {
    if ((rotate > 0 && a.vel.x > -3) || (rotate < 0 && a.vel.x < 3)) {
      a.display();
    }
  }

  thread("updateDrops");
}

void updateDrops() {
  for (WaterDrop a : drops) {
    a.update();
  }
}

//detect dragging
void mousePressed() {
  //dragging
  if (mouseX > bucketPosX - bucket.width/2
    && mouseX < bucketPosX + bucket.width/2
    && mouseY > bucketPosY - bucket.height/2
    && mouseY < bucketPosY + bucket.height/2) {
    isDragging = true;
    dx = bucketPosX - mouseX;
    dy = bucketPosY - mouseY;
  }
}

void mouseDragged() {
  if (isDragging) {
    bucketPosX = mouseX + dx;
    bucketPosY = mouseY + dy;
  }
}

void mouseReleased() {
  isDragging = false;
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      rotate += 5;
    }
    if (keyCode == RIGHT) {
      rotate -= 5;
    }
  }
}

