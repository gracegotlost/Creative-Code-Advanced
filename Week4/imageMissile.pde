class imageMissile {
  float posx;
  float posy;
  float velx;
  float vely;
  float force;
  color c;

  imageMissile(float _posx, float _posy, color _c) {
    posx = _posx;
    posy = _posy;
    c = _c;

    if (posx <= width/2 + random(-10, 10)) {
      velx = random(-5);
    } else {
      velx = random(5);
    }
    vely = 5;
    force = 0.5;
  }

  void update() {
    if (posy > height * 0.6 - position/10) {
      posx += velx;
      vely -= force;
    }
    posy += vely;
  }

  void display() {
    stroke(c);
    point(posx, posy);
  }
}

