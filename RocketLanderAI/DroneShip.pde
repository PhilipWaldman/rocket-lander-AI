class DroneShip {
  PVector pos, dim;
  PImage ship;

  DroneShip(int x) {
    ship = loadImage("resources/Drone Ship Big.png");
    dim = new PVector(ship.width, ship.height);
    pos = new PVector(x, height-dim.y/2);
  }

  float distanceFromTarget(PVector spot) {
    return abs(spot.x-pos.x);
  }

  void show() {
    imageMode(CENTER);
    image(ship, pos.x, pos.y, dim.x, dim.y);
  }
}
