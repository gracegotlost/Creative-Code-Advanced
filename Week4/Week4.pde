/*week 4 - Missile Hunt - Grace*/
import gab.opencv.*;

PImage place;
PImage missile;
PImage mask;
PImage myPlace;
PImage myMissile;
OpenCV opencv_place;
OpenCV opencv_missile;

int roiWidth = 200;
int roiHeight = 200;

boolean useROI = true;
boolean isUpdated = false;

ArrayList<imagePiece> pieces;
ArrayList<imageMissile> missiles;
float position;

void setup() {
  place = loadImage("place.jpg");
  missile = loadImage("missile.png");
  mask = loadImage("mask.jpg");
  opencv_place = new OpenCV(this, place);
  opencv_missile = new OpenCV(this, missile);
  size(opencv_place.width, opencv_place.height, P2D);

  pieces = new ArrayList<imagePiece>();
  missiles = new ArrayList<imageMissile>();

  noCursor();
}

void draw() {
  background(0);
  opencv_place.loadImage(place);
  opencv_missile.loadImage(missile);

  if (useROI) {
    hunting();
  }

  if (!useROI) {
    //explosion
    for (imagePiece piece : pieces) {
      piece.display();
    }
    thread("updatePiece");
    for (imageMissile missile : missiles) {
      missile.display();
    }
    thread("updateMissile");
    position += 5;
  }

  //trigger the explosion of the missile
  if (mouseX > 510
    && mouseX < 530
    && mouseY > 90
    && mouseY < 100
    && isUpdated == false) {
    addPiece();

    useROI = false;
    isUpdated = true;
  }
}

void hunting() {
  //desert
  opencv_place.setROI(mouseX - roiWidth/2, mouseY - roiHeight/2, roiWidth, roiHeight);
  opencv_place.findCannyEdges(20, 75); 

  //missile
  opencv_missile.setROI(mouseX - roiWidth/2, mouseY - roiHeight/2, roiWidth, roiHeight);
  opencv_missile.findCannyEdges(20, 75);  

  //display canny edges part of desert and missile
  if (mouseX > roiWidth/2 
    && mouseX < width - roiWidth/2
    && mouseY > roiHeight/2
    && mouseY < height - roiHeight/2) {
    myPlace = opencv_place.getOutput();
    PImage crop_place = myPlace.get(mouseX - roiWidth/2, mouseY - roiHeight/2, roiWidth, roiHeight);
    myMissile = opencv_missile.getOutput();
    PImage crop_missile = myMissile.get(mouseX - roiWidth/2, mouseY - roiHeight/2, roiWidth, roiHeight);

    //calculate the result image
    crop_place.loadPixels();
    for (int i = 0; i < crop_place.width; i++) {
      for (int j = 0; j < crop_place.height; j++) {
        int loc = i + j * crop_place.width;
        if (brightness(crop_place.pixels[loc]) > 250 || brightness(crop_missile.pixels[loc]) > 250) {
          crop_place.pixels[loc] = color(255, 255, 255);
        } else {
          crop_place.pixels[loc] = color(0, 0, 0);
        }
        //println("place: " + brightness(crop_place.pixels[loc]));
        //println("missile: " + brightness(crop_missile.pixels[loc]));
      }
    }
    crop_place.updatePixels();

    imageMode(CENTER);
    crop_place.mask(mask);
    image(crop_place, mouseX, mouseY);
  }
}

void addPiece() {
  opencv_place.releaseROI();
  opencv_missile.releaseROI();
  opencv_place.findCannyEdges(20, 75); 
  opencv_missile.findCannyEdges(20, 75);
  myPlace = opencv_place.getOutput();
  myMissile = opencv_missile.getOutput();

  myPlace.loadPixels();
  myMissile.loadPixels();
  for (int i = 0; i < myPlace.width; i++) {
    for (int j = 0; j < myPlace.height; j++) {
      int loc = i + j * myPlace.width;

      //add pieces
      pieces.add(new imagePiece(i, j, myPlace.pixels[loc]));

      //add missiles
      if (brightness(myMissile.pixels[loc]) > 250)
        missiles.add(new imageMissile(i, j, myMissile.pixels[loc]));
    }
  }
  myMissile.updatePixels();
  myPlace.updatePixels();
}

void updatePiece() {
  for (imagePiece piece : pieces) {
    piece.update();
  }
}

void updateMissile() {
  for (imageMissile missile : missiles) {
    missile.update();
  }
}

//println("mouseX: " + mouseX);
//println("mouseY: " + mouseY);

//Only check the part of Image I want to change
//  for (int i = mouseX - roiWidth/2; i < mouseX + roiWidth/2; i++) {
//    for (int j = mouseY - roiHeight/2; j < mouseY + roiWidth/2; j++) {
//      if (i > 0 && j > 0 && i < width && j < height) {
//        int loc = i + j * width;
//        float r, g, b;
//        r = red(opencv.getOutput().pixels[loc]);
//        g = green(opencv.getOutput().pixels[loc]);
//        b = blue(opencv.getOutput().pixels[loc]);
//        pixels[loc] = color(r, g, b);
//      }
//    }
//  }

