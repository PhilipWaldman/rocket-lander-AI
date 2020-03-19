class Fleet {
  Rocket[] rockets;
  float fitnessSum;
  int gen=1, bestRocket=0, maxSteps=Integer.MAX_VALUE;

  Fleet(int size, int initialBrainSize) {
    rockets = new Rocket[size];
    for (int i=0; i<size; i++)
      rockets[i] = new Rocket(initialBrainSize);
  }

  // TODO: something is wrong here
  void naturalSelection(float mutationRate) {
    calculateFitness();
    Rocket[] newRockets = new Rocket[rockets.length];

    setBestRocket();
    calculateFitnessSum();
    newRockets[0] = rockets[bestRocket].clone();
    newRockets[0].isBest = true;

    for (int i=1; i<newRockets.length; i++) {
      Rocket p1 = selectParent();
      Rocket p2 = selectParent();
      //newRockets[i] = crossover(p1, p2);
      newRockets[i] = p1.clone();
    }

    rockets = newRockets.clone();
    mutate(mutationRate);
    gen++;
  }

  Rocket crossover(Rocket p1, Rocket p2) {
    Rocket child = new Rocket(maxSteps<rockets[bestRocket].computer.engine.length ? maxSteps : rockets[bestRocket].computer.engine.length);
    for (int i=0; i<child.computer.engine.length; i++) {
      if (random(2)<1)
        child.computer.engine[i] = p1.computer.engine[i];
      else
        child.computer.engine[i] = p2.computer.engine[i];
      if (random(2)<1)
        child.computer.thrusters[i] = p1.computer.thrusters[i];
      else
        child.computer.thrusters[i] = p2.computer.thrusters[i];
    }
    return child;
  }

  Rocket selectParent() {
    float rand = random(fitnessSum);
    float runningSum=0;
    for (Rocket r : rockets) {
      runningSum+=r.fitness;
      if (runningSum>rand)
        return r;
    }
    return null; //shouldn't happen
  }

  void mutate(float mutationRate) {
    for (int i=1; i<rockets.length; i++)
      rockets[i].computer.mutate(mutationRate);
  }

  void update() {
    for (Rocket r : rockets) {
      if (r.computer.step > maxSteps)
        r.exploded=true;
      else
        r.update();
    }
  }

  boolean allRocketsOnGround() {
    for (Rocket r : rockets)
      if (!r.exploded && !r.landed)
        return false;
    return true;
  }

  void calculateFitness() {
    for (Rocket r : rockets)
      r.calculateFitness();
  }

  void calculateFitnessSum() {
    fitnessSum = 0;
    for (Rocket r : rockets)
      fitnessSum += r.fitness;
  }

  void setBestRocket() {
    float max = 0;
    int maxIndex = 0;
    for (int i=0; i<rockets.length; i++) {
      if (rockets[i].fitness>max) {
        max = rockets[i].fitness;
        maxIndex = i;
      }
    }
    bestRocket = maxIndex;

    if (rockets[bestRocket].landed && !rockets[bestRocket].exploded)
      maxSteps = rockets[bestRocket].computer.step;
  }

  void show() {
    if (showAll)
      for (int i=1; i<rockets.length; i++)
        rockets[i].show();
    else
      for (int i=1; i<showMax; i++)
        rockets[i].show();
    rockets[0].show();
    //rockets[0].showDebug();
  }
}
