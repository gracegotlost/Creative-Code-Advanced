class WaterDrop {
  PVector pos = new PVector();
  PVector vel = new PVector();

  float alpha;
  color c;
  float radius;
  float gravity;
  float water;

  WaterDrop() {
    if (rotate > 0)
      pos.x = bucketPosX - bucket.height/2 + 20;
    else
      pos.x = bucketPosX + bucket.height/2 - 20;
    pos.y = bucketPosY + bucket.width/2 - 20;   

    if (rotate > 0)
      vel.x = random(-6, -1);
    else
      vel.x = random(1, 6);
    vel.y = random(1);

    alpha = 255;
    c = color(0, 198, 255, alpha);
    radius = 0;
    gravity = 0.5;
    water = random(-10, 10);
  }

  void update() {
    if (pos.y < height - random(40)) {
      vel.y += gravity;
    } else {
      vel.y = 0;
      vel.x = water;
    }
    pos.x += vel.x;
    pos.y += vel.y;
    c = color(0, 198, 255, alpha);
    if (radius < 100)radius += 5;
  }

  void display() {
    fill(c);
    noStroke();
    ellipse(pos.x, pos.y, radius, radius);
  }
}

