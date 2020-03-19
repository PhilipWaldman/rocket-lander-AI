class Rocket {
  PVector pos, vel, acc, size;
  final float maxFuel = 128, mass=26000, gravity = 9.8/30, I_CM=5000000, I_leg=100000000, F_thruster=5880, F_merlin=845000;
  float angle = 0, omega = 0, alpha = 0, fuel, fitness=0;
  boolean exploded = false, landed=false, merlin = false, rightThruster = false, leftThruster = false, legs = false, isBest=false;
  FlightComputer computer;

  Rocket(int computerSize) {    
    loadImages();
    computer = new FlightComputer(computerSize);
    size = new PVector(body.width, body.height);
    pos = new PVector(width/2-22, 0);
    vel = new PVector(0, 0);
    acc = new PVector(0, gravity);
    fuel = maxFuel;
  }

  void calculateFitness() {
    // method 1: scaling
    //fitness += 1 / map(droneShip.distanceFromTarget(pos), 0, 100, 0.1, 10);
    //println(1 / map(droneShip.distanceFromTarget(pos), 0, 100, 0.1, 10));
    //fitness += 1 / map(abs(omega), 0, 0.08743/30, 0.1, 10);
    //println(1 / map(abs(omega), 0, 0.08743/30, 0.1, 10));
    //fitness += 1 / map(abs(angle), 0, PI/20, 0.1, 10);
    //println(1 / map(abs(angle), 0, PI/20, 0.1, 10));
    //fitness += 1 / map(abs(vel.x), 0, 5.4/30, 0.1, 10);
    //println(1 / map(abs(vel.x), 0, 5.4/30, 0.1, 10));
    //fitness += 1 / map(abs(vel.y), 0, 5.0/30, 0.1, 10);
    //println(1 / map(abs(vel.y), 0, 5.0/30, 0.1, 10));
    //fitness += 1 / map(maxFuel-fuel, 0, maxFuel, 0.1, 10);
    //println(1 / map(maxFuel-fuel, 0, maxFuel, 0.1, 10));
    //println();
    //fitness += 1 / map(computer.step, 0, computer.engine.length, 0.1, 10);
    //fitness = exploded ? fitness/5 : fitness;

    // method 2: kind of inverse Chi Squared
    //fitness += 0.00001 / pow(droneShip.distanceFromTarget(pos), 2);
    //println(0.00001 / pow(droneShip.distanceFromTarget(pos), 2));
    //fitness += 0.00001 / pow(vel.y, 2);
    //println(0.00001 / pow(vel.y, 2));
    //fitness += 0.00001 / pow(vel.x, 2);
    //println(0.00001 / pow(vel.x, 2));
    //fitness += 0.0000000001 / pow(omega, 2);
    //println(0.0000000001 / pow(omega, 2));
    //fitness += 0.0000001 / pow(angle, 2);
    //println(0.0000001 / pow(angle, 2));
    //fitness += 0.00001 * maxFuel / pow(maxFuel - fuel, 2);
    //println(0.00001 * maxFuel / pow(maxFuel - fuel, 2));
    //println();

    // method 2: kind of LSRL inversed
    fitness += pow(droneShip.distanceFromTarget(pos), 2);
    println(pow(droneShip.distanceFromTarget(pos), 2));
    fitness += pow(vel.y, 2);
    println(pow(vel.y, 2));
    fitness += pow(vel.x, 2);
    println(pow(vel.x, 2));
    fitness += pow(omega, 2);
    println(pow(omega, 2));
    fitness += pow(angle, 2);
    println(pow(angle, 2));
    //fitness += pow(maxFuel - fuel, 2);
    //println(pow(maxFuel - fuel, 2));
    println(fitness);
    fitness = 1/fitness;
    println(fitness);
    println();
  }

  void tick() {
    if (computer.engine[computer.step] == 1)
      merlin=true;

    if (computer.thrusters[computer.step] == -1)
      leftThruster=true;
    else if (computer.thrusters[computer.step] == 1)
      rightThruster=true;
    computer.step++;
  }

  void update() {
    touchdown();
    if (!(landed || exploded)) {
      rightThruster = false;
      leftThruster = false;
      merlin=false;
      if (computer.step<computer.engine.length)
        tick();

      updateFuel();

      // Merlin engine
      if (merlin)
        acc = PVector.fromAngle(angle-PI/2).setMag(0.5*F_merlin/mass/30);
      else
        acc = new PVector();

      // Cold gas thrusters
      if (rightThruster)
        alpha-=F_thruster/I_CM/30;
      else if (leftThruster)
        alpha+=F_thruster/I_CM/30;
      else
        alpha = 0;

      acc.y += gravity;

      if (!legs) {
        int dist = (int)((pos.y+size.y/2-16 - height*0.7)*((float)legPics.length/(height*0.2)));
        int num = dist <0 ? 0 : dist;
        legPic = num>=legPics.length ? legPics.length-1 : num;
        //if (legPic==legPics.length-1)
        //legs=true;
      }

      move();
    } else {
      acc = new PVector();
      if (landed)
        pos.y = droneShip.pos.y-size.y/2+16;
      else
        pos.y = height-size.y/2+16;
    }
  }

  void move() {
    pos.add(vel);
    vel.add(acc);
    omega += alpha;
    angle += omega;
    angle %= 2*PI;
  }

  void touchdown() {
    if (droneShip.distanceFromTarget(pos)<32 && pos.y+size.y/2-16 > droneShip.pos.y) {
      if ((0.5 * mass * vel.x*vel.x + 0.5 * I_leg * omega*omega >= mass * 9.8 * 1.5) || abs(angle) > PI/20 || vel.y > 5.0/30)
        exploded = true;
      landed=true;
    } else if (droneShip.distanceFromTarget(pos)>32 && pos.y+size.y/2-16 > height) 
      exploded=true;
  }

  void updateFuel() {
    if (fuel>0) {
      if (merlin)
        fuel--;
      if (leftThruster)
        fuel-=0.1;
      if (rightThruster)
        fuel-=0.1;
    } else {
      merlin=false;
      leftThruster=false;
      rightThruster=false;
      fuel = 0;
    }
  }

  void show() {
    showRocket();
    if (isBest)
      showFuel();
  }

  void showRocket() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(angle);

    imageMode(CENTER);
    if (exploded)
      image(explosion, 0, -10, explosion.width, explosion.height);
    else {
      image(body, 0, 0, size.x, size.y);
      image(legPics[legPic], 0, 0, size.x, size.y);
      if (merlin)
        image(flame, 0, 0, size.x, size.y);
      if (leftThruster)
        image(puffLeft, 0, 0, size.x, size.y);
      if (rightThruster)
        image(puffRight, 0, 0, size.x, size.y);
    }

    popMatrix();
  }

  void showFuel() {
    fill(0, 200, 0);
    noStroke();
    rect(width/50 + width/20, height*0.3 + height*0.4, -width/20, -height*0.4 * (fuel/maxFuel));

    noFill();
    stroke(0);
    strokeWeight(3);
    rect(width/50, height*0.3, width/20, height*0.4);
    strokeWeight(1);
  }

  //Images
  PImage flame, body, puffRight, puffLeft, explosion;
  int legPic = 0;
  PImage[] legPics;
  void loadImages() {
    flame = loadImage("resources/flame.png");
    body = loadImage("resources/body.png");
    puffRight = loadImage("resources/puff_right.png");
    puffLeft = loadImage("resources/puff_left.png");
    explosion = loadImage("resources/explosion/explosion.png");
    legPics = new PImage[18];
    for (int i=0; i<legPics.length; i++)
      legPics[i] = loadImage("resources/legs/legs_"+i+".png");
  }

  Rocket clone() {
    Rocket newRocket = new Rocket(0);
    newRocket.computer = computer.clone();
    return newRocket;
  }

  void showDebug() {
    strokeWeight(5);
    stroke(255, 0, 0); // vel
    line(pos.x-size.x/2, pos.y-size.y/2, pos.x-size.x/2+vel.x*10, pos.y-size.y/2+vel.y*10);
    stroke(0, 255, 0); // acc
    line(pos.x+size.x/2, pos.y-size.y/2, pos.x+size.x/2+acc.x*100, pos.y-size.y/2+acc.y*100);
    fill(0);
    text(this.toString(), 100, 50);
  }

  String toString() {
    String str = "pos:\t\t"+pos;
    str += "\nvel:\t\t"+vel;
    str += "\nangle:\t\t"+angle;
    str += "\nomega\t\t"+omega;
    str += "\nmaxFuel:\t\t"+maxFuel;
    str += "\nfuel:\t\t"+fuel;
    return str;
  }
}
