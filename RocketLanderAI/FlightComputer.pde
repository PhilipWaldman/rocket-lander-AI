class FlightComputer {
  int[] engine, thrusters;
  int step=0;

  FlightComputer(int size) {
    engine = new int[size]; // 0=off, 1=on
    thrusters = new int[size]; // -1=left thruster, 0=none, 1=right thruster
    for (int i=0; i<size; i++) {
      engine[i] = int(random(2));
      thrusters[i] = int(random(3))-1;
      //engine[i] = 0;
      //thrusters[i] = 0;
    }
  }

  void mutate(float mutationRate) {
    for (int i=0; i<engine.length; i++) {
      if (random(1)<mutationRate)
        engine[i] = random(2)<1 ? 0 : 1;
      if (random(1)<mutationRate) {
        float rand = random(3);
        thrusters[i] = rand<1 ? -1 : (rand<2 ? 0 : 1);
      }
    }
  }

  FlightComputer clone() {
    FlightComputer fc = new FlightComputer(engine.length);
    fc.engine = engine.clone();
    fc.thrusters = thrusters.clone();
    return fc;
  }
}
