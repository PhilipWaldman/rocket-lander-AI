Fleet fleet;
DroneShip droneShip;
boolean showAll = false, noShow = false;
int showMax = 10;

void setup() {
  size(1300, 650);
  frameRate(30); // when showing rockets 30. go faster when no rockets are showing.
  fleet = new Fleet(256, 256);
  droneShip = new DroneShip(width / 2 + 150);
}

void draw() {
  background(200, 200, 255);
  fill(0);
  text((int) frameRate + " FPS", 3, 12);
  if (noShow) {
    text("Showing none", 3, 24);
  } else if (showAll) {
    text("Showing all", 3, 24);
  } else {
    text("Showing " + showMax + "/" + fleet.rockets.length, 3, 24);
  }
  text("Brain Size: " + fleet.rockets[fleet.bestRocket].computer.engine.length, 3, 36);
  text("Gen: " + fleet.gen, 3, 48);
  text("Steps: " + fleet.maxSteps, 3, 60);

  if (fleet.allRocketsOnGround()) {
    fleet.naturalSelection(0.05);
  } else {
    fleet.update();
  }

  if (!noShow) {
    droneShip.show();
    fleet.show();
  }
}

void keyPressed() {
  switch(key) {
  case '+':
    if (showMax < fleet.rockets.length)
      showMax++;
    break;
  case '-':
    if (showMax > 1)
      showMax--;
    break;
  case 'a':
    showAll =! showAll;
    break;
  case 'n':
    noShow =! noShow;
    if (noShow) {
      frameRate(1000);
    } else {
      frameRate(30);
    }
    break;
  case 's':
    //save data
    break;
  case 'l':
    //load data
    break;
  default:
    break;
  }
}
