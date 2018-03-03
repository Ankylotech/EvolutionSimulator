public class World {

  private Tile[][] World;
  private ArrayList<Animal> bewohner;
  private ArrayList<Tile> land;
  private int lwZahl;
  private float WorldX;
  private float WorldY;
  private double jahr;
  private float spacing;
  private float fB;
  private double zeitProFrame = 0.0005;
  private int multiplikator = 10000;
  private float gesamtFitness = 0;
  private float gesamtAlter = 0;
  private int geburtenProJahr;
  private int todeProJahr;
  private int geburten = 0;
  Plot fitness;
  Plot altersschnitt;
  Plot aeltestes;
  Button bFitness;
  Button bAltersschnitt;
  Button bAeltestes;
  Button keiner;

  String graph = "keiner";



  // Tiere: Standard Werte
  final public static float stdFeedingRate = 20;
  final public static float stdmaxVelocity = 2;
  final public static float stdAngriffswert = 20;
  final public static float stdReproduktionswTypeezeit = 0.25;
  float stddiameter;


  public World(int WorldG, int lw) {

    jahr = 0;
    lwZahl = lw;
    worldSize = WorldG;
    //plots
    fitness = new Plot(0, 150, 200, 200);
    altersschnitt = new Plot(0, 150, 200, 200);
    aeltestes = new Plot(0, 150, 200, 200);
    fitness.addValues(0, 0);
    altersschnitt.addValues(0, 0);
    aeltestes.addValues(0, 0);

    //Buttons Interface: x:200, y: 250
    bFitness = new Button(0, 50, 100, 50, "DurchschnittsFitness");
    bAltersschnitt = new Button(100, 50, 100, 50, "DurchschnittsAlter");
    bAeltestes = new Button(0, 100, 100, 50, "AeltestesAlter");
    keiner = new Button(100, 100, 100, 50, "kein Graph");


    // skaliert dieTileWidth and die screenSize und dieTileanzahl pro Reihe
    fB = screenSize/worldSize;
    stddiameter = fB ;

    // generiert World
    World = new Tile[worldSize][worldSize];
    float yNoise = 0.0;
    for (int y=0; y<worldSize; y++) {
      float xNoise = 0.0;
      for (int x=0; x<worldSize; x++) {
        World[x][y] = new Tile(x*fB, y*fB, noise(xNoise, yNoise)*100, fB, x, y);
        xNoise += 0.038;
      }
      yNoise += 0.038;
    }
    land = new ArrayList<Tile>();

    for (int i = 0; i<worldSize; i++) {
      for (Tile f : World[i]) {
        if (f.isLand()) {
          land.add(f);
        }
      }
    }

    // generiert Anfangs-Animal
    bewohner = new ArrayList<Animal>(lw);
    for (int i=0; i<lw; i++) {
      int posX;
      int posY;
      do {
        //println("\n\ngeneriere Animal");
        posX = (int)random(0, screenSize);
        posY = (int)random(0, screenSize);
      } while (!this.getTile(posX, posY).isLand());

      bewohner.add(new Animal(posX, posY, fB, currentID));
      currentID++;
    }
  }

  // entfernt Tote
  public void todUndGeburt() {
    ArrayList<Animal> bewohnerCopy = new ArrayList<Animal>(bewohner);
    for (Animal lw1 : bewohnerCopy) {
      for (Animal lw2 : bewohnerCopy) {
        if (!lw1.equals(lw2) && lw1.collision(lw2)) {
          this.gebaeren(lw1, lw2);
        }
      }
    }
  }

  public float entfernungAnimal(Animal lw1, Animal lw2) {
    return lw1.getPosition().dist(lw2.getPosition());
  }

  public void gebaeren(Animal lw1, Animal lw2) {
    if (
      (lw1.NN.getGeburtwille()>lw1.reproduktionsschwellwert && lw2.NN.getGeburtwille()>lw2.reproduktionsschwellwert)
      &&
      (lw1.getEnergy() >= Animal.geburtsEnergy && lw2.getEnergy() >= Animal.geburtsEnergy) // Beide LW muessen genug Energy haben
      &&
      (lw1.isGeburtsbereit() && lw2.isGeburtsbereit()) // Beide LW muessen geburtsbereit sein
      )
    {
      // benötigte GeburtsEnergy wird abgezogen
      lw1.addEnergy(-Animal.geburtsEnergy);
      lw2.addEnergy(-Animal.geburtsEnergy);

      // Dummy-Vectoren
      PVector posLw1 = new PVector(lw1.getPosition().x, lw1.getPosition().y);
      PVector posLw2 = new PVector(lw2.getPosition().x, lw2.getPosition().y);
      geburten++;
      println("geburt" + geburten);
      // Neues Animal mit gemischten Connections entsteht
      this.addAnimal(
        new Animal((int)(posLw1.x + cos(PVector.angleBetween(posLw1, posLw2))*(lw1.getDiameter()/2)), 
        (int)(posLw1.y + sin(PVector.angleBetween(posLw1, posLw2))*(lw1.getDiameter()/2)), 
        lw1.NN.getConnections1(), 
        lw1.NN.getConnections2(), 
        lw1.NN.getConnections3(), 
        lw1.NN.getConnections4(), 
        lw1.NN.getConnections5(), 
        lw1.NN.getConnections6(), 
        lw1.NN.getConnections7(), 
        lw2.NN.getConnections1(), 
        lw2.NN.getConnections2(), 
        lw2.NN.getConnections3(), 
        lw2.NN.getConnections4(), 
        lw2.NN.getConnections5(), 
        lw2.NN.getConnections6(), 
        lw2.NN.getConnections7(), 
        lw1.getFellfarbe(), 
        lw2.getFellfarbe(), 
        max(lw1.getGeneration(), lw2.getGeneration()), 
        lw1.getfeedingRate(), 
        lw1.getmaxVelocity(), 
        lw1.getReproduktionswTypeezeit(), 
        lw1.getAngriffswert(), 

        lw2.getfeedingRate(), 
        lw2.getmaxVelocity(), 
        lw2.getReproduktionswTypeezeit(), 
        lw2.getAngriffswert(), 

        currentID, 

        chooseRandom(lw1.praeferenzfeedingRate, lw2.praeferenzfeedingRate), 
        chooseRandom(lw1.praeferenzmaxVelocity, lw2.praeferenzmaxVelocity), 
        chooseRandom(lw1.praeferenzAngriffswert, lw2.praeferenzAngriffswert), 
        chooseRandom(lw1.praeferenzReproduktionswTypeezeit, lw2.praeferenzReproduktionswTypeezeit), 

        chooseRandom(lw1.feedingRatenAnteil, lw2.feedingRatenAnteil), 
        chooseRandom(lw1.maxGeschwAnteil, lw2.maxGeschwAnteil), 
        chooseRandom(lw1.angriffsAnteil, lw2.angriffsAnteil), 
        chooseRandom(lw1.repwTypeeAnteil, lw2.repwTypeeAnteil)

        ));
      currentID++;
      lw1.setLetzteGeburt((float)lw1.getAlter());
      lw2.setLetzteGeburt((float)lw2.getAlter());

      geburtenProJahr++;
    }
  }

  // update Methode wird immer in draw (Mainloop) gerufen
  public void update() {
    translate(xOveralOffset+xOffset, yOveralOffset+yOffset);
    scale(scaling);
    background(0, 128, 255);
    WorldX = (0-xOveralOffset-xOffset)/scaling;
    WorldY = (0-yOveralOffset-yOffset)/scaling;
    spacing = 20/scaling;
    int bewohnerZahl = bewohner.size();
    if (bewohnerZahl < lwZahl) {
      for (int i=0; i<lwZahl-bewohnerZahl; i++) {
        int posX;
        int posY;
        do {
          //println("\n\nfehlende Animal werden hizugefügt");
          posX = (int)random(0, screenSize);
          posY = (int)random(0, screenSize);
        } while (!this.getTile(posX, posY).isLand());

        bewohner.add(new Animal(posX, posY, fB, currentID));
        currentID++;
      }
    }

    gesamtAlter = 0;
    gesamtFitness = 0;

    for (int i = bewohner.size()-1; i>=0; i--) {
      Animal lw = bewohner.get(i);
      lw.input();
      lw.NN.update();
      lw.leben();
      lw.altern();
      lw.bewegen(lw.NN.getvelocity(lw), lw.NN.getRotation());
      lw.fressen(lw.NN.getFresswille());
      lw.erinnern(lw.NN.getMemory());
      //lw.fellfarbeAendern(lw.NN.getFellRot(), lw.NN.getFellGruen(), lw.NN.getFellBlau());
      for (int j = 0; j < lw.SensorZahl; j++) {
        lw.rotateSensor(lw.NN.getRotationSensor(j)+  lw.NN.getRotation(), j);
      }
      lw.angriff(lw.NN.getAngriffswille()); // hilft, Bevoelkerung nicht zu gross zu halten

      gesamtAlter += lw.getAlter();
      gesamtFitness += lw.calculateFitnessStandard(); // funktioniert nur bei Standardfitness
      if (!lw.getStatus()) {
        bewohner.remove(bewohner.indexOf(lw));
        todeProJahr++;
      }
    }

    todUndGeburt();

    if (frameCount > 1) {
     Tileerinfluence();
    } else {
      for (Tile f : land) {
        f.influenceByWater();
      }
    }


    jahr += zeitProFrame;
    float neuesJahr = (float)(jahr * multiplikator);
    jahr = (double)floor(neuesJahr) / multiplikator;
    if (save) {
      if ((jahr*100)%1 == 0) {
        double aeltestesLwAlter = 0;
        int aeltestesLwID = 0; // 0 ist Dummywert
        for (Animal lw : bewohner) {
          if (lw.getAlter() > aeltestesLwAlter) {
            aeltestesLwAlter = lw.getAlter();
            aeltestesLwID = lw.getID();
          }
        }
        fitness.addValues((float)jahr, (float)gesamtFitness/bewohner.size());
        aeltestes.addValues((float)jahr, (float)aeltestesLwAlter);
        altersschnitt.addValues((float)jahr, (float)gesamtAlter/bewohner.size());
        output1.print("(" + jahr + "," + aeltestesLwAlter + "," + aeltestesLwID + ");");
        output1.flush();
        output2.print("(" + jahr + "," + gesamtAlter/bewohner.size() + ");");
        output2.flush();
        output3.print("(" + jahr + "," + gesamtFitness/bewohner.size() + ");");
        output3.flush();
        output5.print("(" + jahr + "," + bewohner.size() + ");");
        output5.flush();
      }
      if (jahr%1==0) {
        output4.print("(" + jahr + "," + todeProJahr + "," + geburtenProJahr + ");");
        output4.flush();
        geburtenProJahr = 0;
        todeProJahr = 0;
      }
    }

    showWorld();
    showAnimal();
    showInterface();
    if (graph == "fitness")fitness.show();
    if (graph == "aeltestes")aeltestes.show();
    if (graph == "schnitt")altersschnitt.show();
  }
  // Animal hinzufügen
  public void addAnimal(Animal lw) {
    bewohner.add(lw);
  }

  // Interface
  public void showInterface() {

    String jahre = "Jahre: " + jahr;
    fill(50, 200);
    rect(WorldX, WorldY, 200/scaling, 150/scaling);

    fill(255);
    textSize(17/scaling);
    textAlign(LEFT);
    text(jahre, WorldX + spacing, WorldY + spacing);

    text("Bewohner: " + bewohner.size(), WorldX + spacing, WorldY + spacing*2);

    bFitness.show();
    bAltersschnitt.show();
    bAeltestes.show();
    keiner.show();
  }

  // zeichnet die World
  public void showWorld() {
    for (int x=0; x<worldSize; x++) {
      for (Tile a : World[x]) {
        a.drawTile();
      }
    }
  }
  public void showAnimal() {
    stroke(1);
    strokeWeight(0.2);
    for (Animal lw : bewohner) {
      lw.drawAnimal();
    }
    noStroke();
  }
  // zeichnet ein Array aus Animal (meistens am Anfang genutzt) // ka ob mans noch braucht, ich lass es einfach mal drinnen
  public void showAnimal(Animal[] lwArray) {
    stroke(1);
    strokeWeight(0.2);
    for (Animal lw : lwArray) {
      lw.drawAnimal();
    }
    noStroke();
  }

  // zeichnet ein einziges Animal (eig. unnötig, aber um die Form zu wahren sollte man diese Methode nutzen)
  public void showAnimal(Animal lw) {
    stroke(1);
    strokeWeight(0.2);
    lw.drawAnimal();
    noStroke();
  }

  public void Tileerinfluence() {
    for (Tile f : land) {
      f.influenceNeighbors();
    }
    for (Tile f : land) {
      f.grow();
    }
  }

  //// Getter
  public Animal[] getAnimal() {
    return bewohner.toArray(new Animal[bewohner.size()]);
  }

  public int getworldSize() {
    return worldSize;
  }

  public Tile getTile(int x, int y) { // funktioniert nur bei schönen Zahle, muss noch besser werden (1000, 100, etc)
    float xTile = (x - (x % fB)) / fB;
    float yTile = (y - (y % fB)) / fB;
    if (xTile >= worldSize) {
      xTile = 0;
    }
    if (yTile >= worldSize) {
      yTile = 0;
    }
    //println("x: " + x + " xTile: " + xTile + "         y: " + y + " yTile: " + yTile);
    return World[(int)xTile][(int)yTile];
  }

  public Tile getTileInArray(int x, int y) {
    try {
      if (x != -1 && x != worldSize && y != -1 && y != worldSize) { // um die ArrayIndexOutOfBoundsException zu umgehen, die normalerweise auftreten würde // try-catch Block ist trotzdem zur sicherheit da
        return World[x][y];
      } else return null;
    } 
    catch(Exception e) {
      e.printStackTrace();
      return null;
    }
  }

  public Animal getTier(int x, int y) {
    for (Animal lw : bewohner) {
      if (sqrt(sq(lw.position.x- x) + sq(lw.position.y- y)) < lw.diameter/2) {
        return lw;
      }
    }
    return null;
  }
  float chooseRandom(float v1, float v2) {
    if (random(1) > 0.5) {
      return v1;
    } else return v2;
  }

  public double getJahr() {
    return jahr;
  }
  public double getZeitProFrame() {
    return zeitProFrame;
  }
  public int getZeitMultiplikator() {
    return multiplikator;
  }
  public float getTileWidth() {
    return fB;
  }
  public float getDurchschnittsFitness() { // funktioniert nur bei Standardfitness
    return gesamtFitness/bewohner.size();
  }
}