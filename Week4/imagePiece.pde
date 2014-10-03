class imagePiece {
  float posx;
  float posy;
  float velx;
  float vely;
  float gravity;
  color c;

  imagePiece(float _posx, float _posy, color _c) {
    posx = _posx;
    posy = _posy;
    c = _c;

    if (posx <= width/2 + random(-10, 10)) {
      velx = random(-5);
    } else {
      velx = random(5);
    }
    vely = random(-5);
    gravity = 0.1;
  }

  void update() {
    if (posy < position + random(200, 300)) {
      posx+=velx;
      posy+=vely;
      vely+=gravity;
    }
  }

  void display() {
    stroke(c);
    point(posx, posy);
  }
}

