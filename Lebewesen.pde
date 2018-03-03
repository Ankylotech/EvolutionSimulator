
public class Animal {

  public final static int maxRotationAngle = 20; /////////////////////////////// Version mit veraenderter Mutation
  public final static int maxRotationAngleSensor = 10;

  private PVector velocity;
  private PVector position;

  private float mutationRate = 0.5;
  private float diameter; // muss an World skaliert werden
  private float feedingRate = World.stdFeedingRate;
  private float maxVelocity = World.stdmaxVelocity; //GEN
  private float Energy = 500.0;
  private float maxEnergy = 2000.0; 
  private color furColor;
  private float verbrauchBewegung = 3;
  private float verbrauchwaterbewegung = 5;
  private float waterreibung = 0.1;
  private float Energyverbrauch = 2;
  private boolean lebend = true;
  public final static float geburtsEnergy = 200;
  private float reproduktionswTypeezeit = World.stdReproduktionswTypeezeit;
  private float angriffswert = World.stdAngriffswert;
  public final static float reproduktionswille = 0.4;
  private boolean geburtsbereit = false;
  private float letzteGeburt = 0;
  private float reproduktionsschwellwert = 0.5;
  private boolean rot = false;
  private float rotzeit = 0;
  private int generation;
  private int SensorZahl;
  private float feedingRatenAnteil;
  private float maxGeschwAnteil;
  private float angriffsAnteil;
  private float repwTypeeAnteil;
  float praeferenzfeedingRate;
  float praeferenzmaxVelocity;
  float praeferenzAngriffswert;
  float praeferenzReproduktionswTypeezeit;


  private int id;

  private double alter = 0;

  private Sensor[] Sensor;

  private NeuralNetwork NN;
  private float memory = 1; // GEN


  // sollte bei 1. Generation verwendet werden
  Animal(int x, int y, float fB, int ID) {
    id = ID;
    diameter = fB*1.5;
    SensorZahl = 2;

    generation = 0;

    NN = new NeuralNetwork(18);

    praeferenzfeedingRate = random(0.5, 1.5);
    praeferenzmaxVelocity = random(0.5, 1.5);
    praeferenzAngriffswert = random(0.5, 1.5);
    praeferenzReproduktionswTypeezeit = random(0.5, 1.5);

    feedingRatenAnteil = 1;
    maxGeschwAnteil = 1;
    angriffsAnteil = 1;
    repwTypeeAnteil = 1;

    float anteilSumme = feedingRatenAnteil+ maxGeschwAnteil +angriffsAnteil + repwTypeeAnteil;

    feedingRate = (feedingRatenAnteil/anteilSumme)*4*World.stdFeedingRate;
    maxVelocity = (maxGeschwAnteil/anteilSumme)*4*World.stdmaxVelocity;
    angriffswert = (angriffsAnteil/anteilSumme)*World.stdAngriffswert*4;
    reproduktionswTypeezeit= (repwTypeeAnteil/anteilSumme)*World.stdReproduktionswTypeezeit*4;

    velocity = new PVector(maxVelocity, maxVelocity);
    velocity.limit(maxVelocity);

    position = new PVector(x, y);

    Sensor = new Sensor[SensorZahl];
    for (int i = 0; i<SensorZahl; i++) {
      Sensor[i] = new Sensor(this);
    }

    furColor = color((int)random(0, 256), (int)random(0, 256), (int)random(0, 256));
  }

  // 2. Konstruktor, damit die Farbe bei den Nachkommen berücksichtigt werden kann und die Gewichte übergeben werden können
  Animal(int x, int y, Matrix c11, Matrix c12, Matrix c13, Matrix c14, Matrix c15, Matrix c16, Matrix c17, Matrix c21, Matrix c22, Matrix c23, Matrix c24, Matrix c25, Matrix c26, Matrix c27, color fellfarbe1, color fellfarbe2, int g, float f1, float mG1, float r1, float a1, float f2, float mG2, float r2, float a2, int ID, float pF, float pMG, float pAn, float pRW, float fA, float mGA, float aA, float rWA) {
    id = ID;
    diameter = map.getTileWidth()*1.5;
    SensorZahl = 2;

    praeferenzfeedingRate = constrain(mutieren(pF), 0, 2);
    praeferenzmaxVelocity =  constrain(mutieren(pMG), 0, 2);
    praeferenzAngriffswert =  constrain(mutieren(pAn), 0, 2);
    praeferenzReproduktionswTypeezeit =  constrain(mutieren(pRW), 0, 2);

    feedingRate = mutieren(mixGenes(f1, f2));
    maxVelocity = mutieren(mixGenes(mG1, mG2));
    reproduktionswTypeezeit = mutieren(mixGenes(r1, r2));
    angriffswert = mutieren(mixGenes(a1, a2));

    generation = g+1;
    Energy = geburtsEnergy;

    feedingRatenAnteil = mutieren(fA, 0, 99); // 99 muss geaendert werden
    maxGeschwAnteil = mutieren(mGA, 0, 99);
    angriffsAnteil = mutieren(aA, 0, 99);
    repwTypeeAnteil = mutieren(rWA, 0, 99);

    float anteilSumme = feedingRatenAnteil+ maxGeschwAnteil +angriffsAnteil + repwTypeeAnteil;

    feedingRate = (feedingRatenAnteil/anteilSumme)*4*World.stdFeedingRate;
    maxVelocity = (maxGeschwAnteil/anteilSumme)*4*World.stdmaxVelocity;
    angriffswert = (angriffsAnteil/anteilSumme)*World.stdAngriffswert*4;
    reproduktionswTypeezeit= (repwTypeeAnteil/anteilSumme)*World.stdReproduktionswTypeezeit*4;  

    // fellfarbe wird random aus beiden Elternteilen gewaehlt
    if (random(0, 1)>0.5) {
      furColor = fellfarbe1;
    } else {
      furColor = fellfarbe2;
    }

    furColor = fellfarbeMutieren(furColor);

    // Connections
    Matrix c1;
    Matrix c2;
    Matrix c3;
    Matrix c4;
    Matrix c5;
    Matrix c6;
    Matrix c7;

    c1 = this.mixMatrix(c11, c21);
    c2 = this.mixMatrix(c12, c22);
    c3 = this.mixMatrix(c13, c23);
    c4 = this.mixMatrix(c14, c24);
    c5 = this.mixMatrix(c15, c25);
    c6 = this.mixMatrix(c16, c26);
    c7 = this.mixMatrix(c17, c27);

    c1 = mutieren(c1);
    c2 = mutieren(c2);
    c3 = mutieren(c3);
    c4 = mutieren(c4);
    c5 = mutieren(c5);
    c6 = mutieren(c6);
    c7 = mutieren(c7);

    NN = new NeuralNetwork(18, c1, c2, c3, c4, c5, c6, c7);

    velocity = new PVector(maxVelocity, maxVelocity);
    velocity.limit(maxVelocity);

    position = new PVector(x, y);

    Sensor = new Sensor[SensorZahl];
    for (int i = 0; i<SensorZahl; i++) {
      Sensor[i] = new Sensor(this);
    }
  }

  public void drawAnimal() {
    PVector Heading = new PVector(velocity.x, velocity.y);
    diameter = map.stddiameter * Energy/2000 + 10 ;
    if (rotzeit == 0) {
      fill(furColor);
    } else if (rot) {
      fill(255, 0, 0);
      rotzeit--;
    } else {
      fill(furColor);
      rotzeit--;
    }
    if (rotzeit %4==0) {
      rot = !rot;
    }
    for (Sensor f : Sensor) {
      f.drawSensor();
    }
    Heading.setMag(diameter/2);
    ellipse(position.x, position.y, diameter, diameter );
    line(position.x, position.y, position.x + Heading.x, position.y + Heading .y);
  }

  // NeuralNetwork input
  public void input() {
    // velocity
    NN.setInputNvelocity(map(velocity.mag(), 0, maxVelocity, -6, 6));
    // eigene Energy
    NN.setInputNEnergy(map(Energy, 0, maxEnergy, -6, 6));
    //TileType
    //println("\n\ngetInputNTileType");
    NN.setInputNTileType(map(map.getTile((int)position.x, (int)position.y).isLandInt(), 0, 1, -6, 6));
    // Memory
    NN.setInputNMemory(map(memory, 0, 1, -6, 6));
    // Bias // immer 1
    NN.setInputNBias(1);
    // Heading
    NN.setInputNHeading(map(degrees(velocity.heading()), -180, 180, -6, 6));


    //// Sensor 

    for (int i = 0; i<Sensor.length; i++) {
      // Heading Sensor 
      NN.setInputNSensorHeading(map(Sensor[i].getHeading(), -180, 180, -6, 6), i);//                                                                  Hier könnte es Probleme mit map geben
      // EnemyEnergy
      //float[] EnemyEnergy1 = Sensor1.getSensorEnemyEnergy();
      NN.setInputNSensorEnemyEnergy(map(Sensor[i].getSensorEnemyEnergy(), 0, maxEnergy, -6, 6), i);// maxEnergy muss geändert werden, falls die maximale Energy von Tier zu Tier variieren kann
      //TileEnergy
      //float[]TileEnergy1 = Sensor1.getSensorTileEnergy();
      NN.setInputNSensorTileEnergy(map(Sensor[i].getSensorTileEnergy(), 0,Tile.maxOverallEnergy, -6, 6), i);
      //TileType
      NN.setInputNSensorTileType(map(Sensor[i].getSensorTileType(), 0, 1, -6, 6), i);
      // Genetic Difference
      NN.setInputNSensorGenDiff(map(Sensor[i].getSensorTileType(), 0, 4, -6, 6), i);
    }
  }

  // Bewewgung
  public void bewegen(float v, float angle) { // RotationAngle in Grad
    if (v<maxVelocity && v>=0) { // Bewegungsverbrauch passt sich an momentane velocity an
      Energy-=verbrauchBewegung*(v*0.75);
      velocity.rotate(radians(angle));
      velocity.setMag(v);

      // im water bewegen sich die Animal langsamer und verbrauchen mehr Energy
      if (!map.getTile((int)position.x, (int)position.y).isLand()) {
        position.add(velocity.mult(1-waterreibung));
        Energy -= verbrauchwaterbewegung;
      } else {
        position.add(velocity);
      }

      // Animal werden auf die gegenüberliegende Seite teleportiert, wenn sie außerhalb der Map sind
      if (position.x > screenSize) { // wenn zu weit rechts        
        position.set(position.x-screenSize, position.y);
      }
      if (position.x < 0) { // wenn zu weit links       
        position.set(screenSize+position.x, position.y); // + position.x, weil es immer ein negativer Wert ist
      }
      if (position.y > screenSize) { // wenn zu weit unten
        position.set(position.x, position.y-screenSize);
      }
      if (position.y < 0) { // wenn zu weit oben
        position.set(position.x, screenSize+position.y); // + position.y, weil es immer ein negativer Wert ist
      }
    }
  }
  // Angriff auf Enemy
  public void angriff(float wille) {
    if (wille > 0.5) {
      addEnergy(-Energyverbrauch*(angriffswert*0.5));
      // Opfer nur DIREKT vor dem Animal (d.h. in velocitysHeading) kann angegriffen werden
      PVector opferPosition = new PVector(cos(velocity.heading())*diameter+position.x, position.y-sin(velocity.heading())*diameter);

      Animal opfer = map.getTier((int)(opferPosition.x), (int)(opferPosition.y));

      if (!(opfer == null)) {
        if (opfer.getEnergy() >= angriffswert) {
          opfer.addEnergy(-angriffswert);
          this.addEnergy(angriffswert);
        } else {
          this.addEnergy(opfer.getEnergy());
          opfer.setEnergy(0);
        }
        if (Energy>maxEnergy) { // Animal-Energy ist über dem Maximum
          Energy = maxEnergy;
        }
        opfer.hit();
      }
    }
  }

  // Grundverbrauch
  public void leben() {
    Energy -= Energyverbrauch*(alter/10);
  }
  public void hit() {
    rotzeit = 30;
  }

  // Fitnessfunktion // Fitness wird nur beim Rufen der Methode gerufen
  public float calculateFitnessStandard() { // berechnet die Fitness des Tieres im Bezug auf die Standardwerte
    float alter = sq((float)this.getAlter())*0.5;
    float feedingRate = (this.getfeedingRate() - World.stdFeedingRate)/World.stdFeedingRate;
    float maxV = (this.getmaxVelocity() - World.stdmaxVelocity)/World.stdmaxVelocity;
    float angriff = (this.getAngriffswert() - World.stdAngriffswert)/World.stdAngriffswert;
    float wTypeezeit = World.stdReproduktionswTypeezeit/this.getReproduktionswTypeezeit() - 1;
    float result = alter + feedingRate + maxV + angriff + wTypeezeit;
    //println(alter + " " + feedingRate + " " + maxV + " " + angriff + " " + wTypeezeit + " " + result);
    return result;
  }

  public float calculateGeneticDifference(Animal pTypener) { // berechnet die Fitness des Tieres im Bezug auf eigene Werte
    float feedingRate = map(abs(pTypener.getfeedingRate() - getfeedingRate()), 0, 4*World.stdFeedingRate, 0, 1);
    float maxV = map(abs(pTypener.getmaxVelocity() - getmaxVelocity()), 0, 4*World.stdmaxVelocity, 0, 1);
    float angriff = map(abs(pTypener.getAngriffswert() - getAngriffswert()), 0, 4* World.stdAngriffswert, 0, 1);
    float wTypeezeit = map(abs(pTypener.getReproduktionswTypeezeit() - getReproduktionswTypeezeit() ), 0, 4* World.stdReproduktionswTypeezeit, 0, 1);
    float result = feedingRate + maxV + angriff + wTypeezeit;
    return result;
  }
  // Fressen
  public void fressen(float wille) {
    if (wille > 0.5) {
      Energy -= Energyverbrauch*(alter/4);
      //println("\n\nfressen");
     Tile Tile = map.getTile((int)position.x, (int)position.y);
      float neueTileEnergy =Tile.getEnergy() - feedingRate;

      if (neueTileEnergy>=0) { //Tile hat genug Energy
        Energy += feedingRate;
       Tile.setEnergy((int)neueTileEnergy);
      } else { //Tile hat zu wenig Energy
        Energy +=Tile.getEnergy();
       Tile.setEnergy(0);
      }

      if (Energy>maxEnergy) { // Animal-Energy ist über dem Maximum
       Tile.setEnergy((int)(Tile.getEnergy()+(Energy-maxEnergy)));
        Energy = maxEnergy;
      }
    }
  }

  // Gebaeren
  // wird in World Klasse verlegt

  /*
  if(wille > 0.5 && Energy >= geburtsEnergy && ((float)alter % reproduktionsWTypeezeit == 0)){ // Bedingung ist so seltsam, weil das Alter ungenau ist
   Energy -= geburtsEnergy;
   map.addAnimal(new Animal((int)position.x, (int)position.y, NN.getConnections1(), NN.getConnections2(), furColor));
   println("Ein neues Früchtchen ist entsprungen!");
   }
   */  // Das wird viel :((

  public boolean collision(Animal lw) {
    float distance = map.entfernungAnimal(this, lw);
    if (distance <= diameter) {
      return true;
    } else {
      return false;
    }
  }
  public color fellfarbeMutieren(color fellfarbe) {

    float r = red(fellfarbe) + red(fellfarbe) * random(-0.3, 0.3);
    float g = green(fellfarbe) + green(fellfarbe) * random(-0.3, 0.3);
    float b = blue(fellfarbe) + blue(fellfarbe) * random(-0.3, 0.3);

    if (r < 0) {
      r = 0;
    } else if (r > 255) {
      r = 255;
    }
    if (g < 0) {
      g = 0;
    } else if (g > 255) {
      g = 255;
    }
    if (b < 0) {
      b = 0;
    } else if (b > 255) {
      b = 255;
    }
    return color(r, g, b);
  }

  // Sensor 1 rotieren
  public void rotateSensor(float angle, int i) {
    Sensor[i].rotateSensor(angle);
  }

  // Sensor 2 rotieren


  // mutiert Gewichte
  public Matrix mutieren(Matrix m) {
    for (int x=0; x<m.rows; x++) {
      for (int y=0; y<m.cols; y++) {
        if (random(0, 1)>0.3) {
          float multiplikator = random(-mutationRate, mutationRate);
          float neuerWert = m.get(x, y)+multiplikator*m.get(x, y);
          if (neuerWert > 1) {
            neuerWert = 1;
          } else if (neuerWert < -1) {
            neuerWert = -1;
          }
          m.set(x, y, neuerWert);
        }
      }
    }
    return m;
  }
  public float mutieren(float x) { // x ist der Wert, der mutiert wird
    float a = x;
    if (random(0, 1)>0.5) {
      a += random(-mutationRate, mutationRate)*x/4;
    }
    return a;
  }
  public float mutieren(float x, float v1, float v2) { // x ist der Wert, der mutiert wird
    float a = x;
    if (random(0, 1)>0.5) {
      a += random(-mutationRate, mutationRate)*x/4;
    }

    return constrain(a, v1, v2);
  }

  public Matrix mixMatrix(Matrix c1, Matrix c2) { // nimmt an, dass c1 und c2 gleich gross sind
    Matrix mixedConnections = new Matrix(c1.rows, c1.cols);
    mixedConnections.copyM(c1);
    // mixedConnections wird zu Kopie von c1
    // Gewichte werden vermischt
    for (int x=0; x<c1.rows; x++) {
      for (int y=0; y<c1.cols; y++) {
        if (random(0, 1) > reproduktionsschwellwert) {
          mixedConnections.set(x, y, c2.get(x, y));
        }
      }
    }
    return mixedConnections;
  }

  public float mixGenes(float g1, float g2) {
    if (random(0, 1)>reproduktionsschwellwert) {
      return g1;
    } else return g2;
  }


  public void altern() {
    alter += map.getZeitProFrame();
    float neuesAlter = (float)(alter * map.getZeitMultiplikator());
    alter = (double)floor(neuesAlter) / (double)map.getZeitMultiplikator();

    // geburtsbereit
    if (alter - letzteGeburt >= reproduktionswTypeezeit) {
      geburtsbereit = true;
    } else {
      geburtsbereit = false;
    }
  }

  public void erinnern(float m) {
    memory = m;
  }

  public void fellfarbeAendern(float r, float g, float b) {
    furColor = color(r, g, b);
  }

  public void addEnergy(float e) {
    Energy += e;
  }

  public void setEnergy(float e) {
    Energy = e;
  }

  public void setLetzteGeburt(float lG) {
    letzteGeburt = lG;
  }

  // getter 
  public boolean getStatus() {
    if (Energy<0) {
      lebend = false;
    }
    return lebend;
  }
  public float getmaxVelocity() {
    return maxVelocity;
  }
  public float getEnergy() {
    return Energy;
  }
  public float getMaxEnergy() {
    return maxEnergy;
  }
  public PVector getPosition() {
    return position;
  }
  public double getAlter() {
    return alter;
  }
  public boolean isGeburtsbereit() {
    return geburtsbereit;
  }
  public color getFellfarbe() {
    return furColor;
  }
  public float getDiameter() {
    return diameter;
  }
  public int getGeneration() {
    return generation;
  }
  public float getfeedingRate() {
    return feedingRate;
  }
  public float getAngriffswert() {
    return angriffswert;
  }
  public float getReproduktionswTypeezeit() {
    return reproduktionswTypeezeit;
  }
  public int getID() {
    return id;
  }
}