class Feld{
  
  private float posX, posY;
  private float nHoehe; //noise-Hoehe
  private float regenerationsrate;
  private float energiewert;
  private float maxEnergiewert;
  private int feldBreite;
  
  final public static float maxEnergiewertAllgemein = 120;
  
  private int meeresspiegel = 45;

  Feld(int x , int y, float h, int fB){
    posX = x;
    posY = y;
    nHoehe = h;
    feldBreite = fB;
    
    if(this.isLand()){
      regenerationsrate = 10000/((nHoehe*nHoehe)*10);
      energiewert = 0;
      maxEnergiewert = maxEnergiewertAllgemein;
    } else {
      regenerationsrate = 0;
      energiewert = 0;
      maxEnergiewert = 0;
    }
  }
  
  public void regenerieren(){
    energiewert += regenerationsrate;
    if (energiewert > maxEnergiewert){
      energiewert = maxEnergiewert;
    }
  }
  
  public boolean isLand(){
    if (nHoehe>meeresspiegel){
      return true;
    } else return false;
  }
  
  public int isLandInt(){
    if (nHoehe>meeresspiegel){
      return 1;
    } else return 0;
  }
  
  public void drawFeld(){
    if(nHoehe>meeresspiegel){
      fill(map(energiewert, 0, maxEnergiewert, 255, 80)  - map(nHoehe, 45, 100, 90, 0), map(energiewert, 0, maxEnergiewert, 210, 140) - map(nHoehe, 45, 100, -45, 45), 20 - map(nHoehe, 45, 100, 0, 20)); //muss noch geändert werden
    } else fill(0, 0, map(nHoehe, 0, 45, 0, 140));
    rect(posX, posY, feldBreite, feldBreite);
  }
  
  public void setEnergie(int x){
    energiewert = x;
  }
  
  // getter(bisher)
  public float getEnergie(){
    return energiewert;
  }
  
  public float getMaxEnergie(){
    return maxEnergiewert;
  }

}