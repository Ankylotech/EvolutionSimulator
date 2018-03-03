class Tile {


  final public static float maxOverallEnergy = 20;
  private float posX, posY;
  private float nHeight; //noise-Height
  private float regenerationRate;
  private float energyValue = 0;
  private float maxEnergyValue;
  private float TileWidth;
  private float maxregenerationRate = maxOverallEnergy/140;
  private float[] influence;
  private boolean influenceable;

  private int arrayPosX;
  private int arrayPosY;



  private int sealevel = 50;

 Tile(float x, float y, float h, float fB, int aX, int aY) {
    posX = x;
    posY = y;
    nHeight = h;
    TileWidth = fB;
    arrayPosX = aX;
    arrayPosY = aY;
    influence = new float[4];

    if (this.isLand()) {
      maxEnergyValue = maxOverallEnergy;
      influenceable = true;
    } else {
      maxregenerationRate = 0;
      maxEnergyValue = 0;
      influenceable = false;
    }
  }

  public void grow() { 
    if (influenceable) {
      float rest = maxregenerationRate - regenerationRate;
      influence = sort(influence);
      for (int i = 3; i >= 0; i--) { 
        if (influence[i] > random(0.5, 0.9)) {
          regenerationRate += influence[i] * rest;
        }
        rest = maxregenerationRate - regenerationRate;
      }
    }

    regenerationRate *= sealevel+20/nHeight;
    if (regenerationRate>maxregenerationRate)regenerationRate = maxregenerationRate;

    energyValue += regenerationRate;
    if (energyValue > maxEnergyValue)energyValue = maxEnergyValue;
  }

  public boolean isLand() {
    if (nHeight>sealevel) {
      return true;
    } else return false;
  }
  public int isLandInt() {
    if (nHeight>sealevel) {
      return 1;
    } else return 0;
  }

  public void drawTile() {
    if (nHeight>sealevel) {
      fill(map(energyValue, 0, maxEnergyValue, 255, 80), map(energyValue, 0, maxEnergyValue, 210, 140), 20); //muss noch geändert werden
    } else fill(0, 0, map(nHeight, 0, 45, 0, 140));
    rect(posX, posY,TileWidth,TileWidth);
  }

  public void setEnergy(int x) {
    energyValue = x;
  }

  // getter(bisher)
  public float getEnergy() {
    return energyValue;
  }

  public float getMaxEnergy() {
    return maxEnergyValue;
  }

  public float getinfluence() {
    return energyValue/maxOverallEnergy;
  }
  public void influenceByWater() {
    boolean water = false;
    if (arrayPosX > 0 && !water) water = !map.getTileInArray(arrayPosX-1, arrayPosY).isLand();
    if (arrayPosY > 0 && !water) water = !map.getTileInArray(arrayPosX, arrayPosY-1).isLand();
    if (arrayPosX < worldSize -1 && !water) water = !map.getTileInArray(arrayPosX+1, arrayPosY).isLand();
    if (arrayPosY < worldSize -1 && !water) water = !map.getTileInArray(arrayPosX, arrayPosY+1).isLand();
    if (water) {
      regenerationRate = maxregenerationRate;
      influenceable = false;
    }
  }

  public void influenceNeighbors() {
    if (arrayPosX > 0) {
     Tile f = map.getTileInArray(arrayPosX-1, arrayPosY);
      if (f.influenceable) {
        f.influence[0] = getinfluence();
      }
    };
    if (arrayPosY > 0) {
     Tile f = map.getTileInArray(arrayPosX, arrayPosY-1);
      if (f.influenceable) {
        f.influence[1] = getinfluence();
      }
    };
    if (arrayPosX < worldSize -1) {
     Tile f = map.getTileInArray(arrayPosX+1, arrayPosY);
      if (f.influenceable) {
        f.influence[2] = getinfluence();
      }
    };
    if (arrayPosY < worldSize -1) {
     Tile f = map.getTileInArray(arrayPosX, arrayPosY+1);
      if (f.influenceable) {
        f.influence[3] = getinfluence();
      }
    };
  }
}