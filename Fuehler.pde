class Sensor {

  private float distance;

  private PVector position;
  private PVector heading;

  private Animal lw;

  Sensor(Animal l) {
    lw = l;
    distance = lw.getDiameter()*1.25;
    heading = new PVector(distance, 0);
    position = new PVector(0, 0);
  }

  //updated und malt den Fühler
  public void drawSensor() {
    distance = lw.getDiameter()* 1.25;
    // Fühlerposition wird erstellt
    position.set(lw.position.x, lw.position.y); //                               lw.position.copy() wurder manchmal null, keine Ahnung wieso
    heading.setMag(lw.getDiameter() + lw.Energy/200);
    position.add(heading);

    // Sensor werden auf die gegenüberliegende Seite teleportiert, wenn sie außerhalb der Map sind
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

    // Falls Sensor auf anderer Seite der Map sind, werden die Linien nicht mehr gemalt
    if (!(position.dist(lw.getPosition()) > distance)) {
      line(position.x, position.y, lw.position.x, lw.position.y);
    }

    ellipse(position.x, position.y, lw.getDiameter()/4, lw.getDiameter()/4);
  }

  public void rotateSensor(float angle) {
    heading.rotate(radians(angle));
  }

  ////getter

  //gibt die Energy vomTile des Fühlers
  public float getSensorTileEnergy() {
    Tile Tile = map.getTile((int)position.x, (int)position.y);
    return Tile.getEnergy();
  }

  //gibt,wenn Enemy vorhanden, dessen Energy aus // muss effizienter gemacht werden
  public float getSensorEnemyEnergy() { /////////////   aus irgend einem Grund kann position null werden
    Animal lw = map.getTier((int)position.x, (int)position.y);
    if (lw != null) {
      return lw.getEnergy();
    } else {
      return 0;
    }
  }
  public float getSensorGeneticDifference() { /////////////   aus irgend einem Grund kann position null werden
    Animal lw2 = map.getTier((int)position.x, (int)position.y);
    if (lw2 != null) {
      return lw.calculateGeneticDifference(lw2);
    } else {
      return 0;
    }
  }

  public float getHeading() {
    return degrees(heading.heading());
  }
  public float getSensorTileType() {
    return map.getTile((int)position.x, (int)position.y).isLandInt();
  }
}