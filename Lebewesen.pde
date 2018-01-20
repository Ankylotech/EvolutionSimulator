
public class Lebewesen{
  
  public final static int maxRotationswinkelBewegung = 30; /////////////////////////////// Version mit veraenderter Mutation
  public final static int maxRotationswinkelFuehler = 10;
  
  private PVector geschwindigkeit;
  private PVector position;
  
  private float mutationsrate = 0.5;
  private float durchmesser = 10; // muss an Welt skaliert werden
  private float fressrate;//GEN
  private float maxGeschwindigkeit; //GEN
  private float energie = 300.0;
  private float maxEnergie = 1400;
  private color fellFarbe = color((int)random(0,256), (int)random(0,256), (int)random(0,256));
  private float verbrauchBewegung = maxEnergie/200;
  private float wasserreibung = 0.1;
  private float energieverbrauch = maxEnergie/400;
  private boolean lebend = true;
  private float geburtsenergie; //GEN
  private float reproduktionsWartezeit; // GEN
  private float angriffswert; //GEN
  
  private double alter = 0;
  
  private Fuehler fuehler1;
  private Fuehler fuehler2;
  
  private NeuralNetwork NN;
  private float memory = 1; 
  
  // sollte bei 1. Generation verwendet werden
  Lebewesen(int x, int y){
    
    fressrate = 20;
    maxGeschwindigkeit = 3;
    geburtsenergie = 200;
    reproduktionsWartezeit = 0.2;
    angriffswert = 20;
    
    NN = new NeuralNetwork(17);
    
    geschwindigkeit = new PVector(maxGeschwindigkeit,maxGeschwindigkeit);
    geschwindigkeit.limit(maxGeschwindigkeit);
    
    position = new PVector(x,y);
    
    fuehler1 = new Fuehler(this);
    fuehler2 = new Fuehler(this);
    
  }
  
  // 2. Konstruktor, damit die Gewichte übergeben werden können
  Lebewesen(int x, int y, Connection[][] c1, Connection[][] c2,float f,float mG,float gE,float r,float a){
    
    energie = geburtsenergie;
    c1 = mutieren(c1);
    c2 = mutieren(c2);
    
    fressrate = mutieren(f);
    maxGeschwindigkeit = mutieren(mG);
    geburtsenergie = mutieren(gE);
    reproduktionsWartezeit = mutieren(r);
    angriffswert = mutieren(a);
 
    
    NN = new NeuralNetwork(14, c1, c2);
    
    geschwindigkeit = new PVector(maxGeschwindigkeit,maxGeschwindigkeit);
    geschwindigkeit.limit(maxGeschwindigkeit);
    
    position = new PVector(x,y);
    
    fuehler1 = new Fuehler(this);
    fuehler2 = new Fuehler(this);
  }
  
  public void drawLebewesen(){
    fill(fellFarbe);
    fuehler1.drawFuehler();
    fuehler2.drawFuehler();
    ellipse(position.x, position.y, durchmesser, durchmesser);
  }
  
  // NeuralNetwork input
  public void input(){
    // Geschwindigkeit
    NN.getInputNGeschwindigkeit().setWert(map(geschwindigkeit.mag(), 0, maxGeschwindigkeit, -1, 1));
    // Fellfarbe

    // eigene Energie
    NN.getInputNEnergie().setWert(map(energie, 0, maxEnergie, -1, 1));
    // Feldart
    //println("\n\ngetInputNFeldArt");
    NN.getInputNFeldart().setWert(map(map.getFeld((int)position.x, (int)position.y).isLandInt(), 0, 1, -1, 1));
    // Memory
    NN.getInputNMemory().setWert(map(memory, 0, 1, -1, 1));
    // Bias // immer 1
    NN.getInputNBias().setWert(1);
    // Richtung
    NN.getInputNRichtung().setWert(map(degrees(geschwindigkeit.heading()), -180, 180, -1, 1));
    
    NN.getInputNFeldHoehe().setWert(map(map.getFeld((int)position.x, (int)position.y).nHoehe,0,100,-1,1));
    
    //// Fuehler 1
    // Richtung Fuehler 
    NN.getInputNFuehlerRichtung1().setWert(map(fuehler1.getRichtung(), -180, 180, -1, 1));//                                                                  Hier könnte es Probleme mit map geben
    // Gegnerenergie
    //float[] gegnerEnergie1 = fuehler1.getFuehlerGegnerEnergie();
    NN.getInputNFuehlerGegnerEnergie1().setWert(map(fuehler1.getFuehlerGegnerEnergie(), 0, maxEnergie, -1, 1));// maxEnergie muss geändert werden, falls die maximale Energie von Tier zu Tier variieren kann
    // Feldenergie
    //float[] feldEnergie1 = fuehler1.getFuehlerFeldEnergie();
    NN.getInputNFuehlerFeldEnergie1().setWert(map(fuehler1.getFuehlerFeldEnergie(), 0, Feld.maxEnergiewertAllgemein, -1, 1));
    // Feldart
    NN.getInputNFuehlerFeldArt1().setWert(map(fuehler1.getFuehlerFeldArt(), 0, 1, -1, 1));
    
    NN.getInputNFuehlerFeldHoehe1().setWert(map(fuehler1.getFuehlerFeldHoehe(),0,100,-1,1));
    
    //// Fuehler 2
    // Richtung Fuehler
    NN.getInputNFuehlerRichtung2().setWert(map(fuehler2.getRichtung(), -180, 180, -1, 1)); //                                                                  Hier könnte es Probleme mit map geben
    // Gegnerenergie
    //float[] gegnerEnergie2 = fuehler2.getFuehlerGegnerEnergie();
    NN.getInputNFuehlerGegnerEnergie2().setWert(map(fuehler2.getFuehlerGegnerEnergie(), 0, maxEnergie, -1, 1)); // maxEnergie muss geändert werden, falls die maximale Energie von Tier zu Tier variieren kann
    // Feldenergie
    //float[] feldEnergie2 = fuehler2.getFuehlerFeldEnergie();
    NN.getInputNFuehlerFeldEnergie2().setWert(map(fuehler2.getFuehlerFeldEnergie(), 0, Feld.maxEnergiewertAllgemein, -1, 1));
    // Feldart
    NN.getInputNFuehlerFeldArt2().setWert(map(fuehler2.getFuehlerFeldArt(), 0, 1, -1, 1));
    
    NN.getInputNFuehlerFeldHoehe2().setWert(map(fuehler2.getFuehlerFeldHoehe(),0,100,-1,1));
  }
  
  // Bewewgung
  public void bewegen(float v, float angle){ // Rotationswinkel in Grad
    if (energie-(verbrauchBewegung*maxGeschwindigkeit/3)>=0 && v<maxGeschwindigkeit && v>=0){
      energie-=(verbrauchBewegung*maxGeschwindigkeit/3);
      float a = angle;
      if(a <0){
        a = 360 - a;
      }
      
      geschwindigkeit.rotate(radians(a));
      geschwindigkeit.setMag(v);
      
      // im Wasser bewegen sich die Lebewesen langsamer
      //println("\n\nbewegen");
      if(!map.getFeld((int)position.x,(int)position.y).isLand()){
        position.add(geschwindigkeit.mult(1-wasserreibung));
      } else {
        position.add(geschwindigkeit);
      }

      // Lebewesen werden auf die gegenüberliegende Seite teleportiert, wenn sie außerhalb der Map sind
      if (position.x > fensterGroesse){ // wenn zu weit rechts        
        position.set(position.x-fensterGroesse, position.y);
      }
      if (position.x < 0){ // wenn zu weit links       
        position.set(fensterGroesse+position.x, position.y); // + position.x, weil es immer ein negativer Wert ist
      }
      if (position.y > fensterGroesse){ // wenn zu weit unten
        position.set(position.x, position.y-fensterGroesse);
      }
      if (position.y < 0){ // wenn zu weit oben
        position.set(position.x, fensterGroesse+position.y); // + position.y, weil es immer ein negativer Wert ist
      }
    }
  }
  // Angriff auf Gegner
  public void angriff(float wille){
    if(wille > 0.5){
      addEnergie(-(energieverbrauch*angriffswert/20));
      
      // Opfer nur DIREKT vor dem Lebewesen (d.h. in Geschwindigkeitsrichtung) kann angegriffen werden
      PVector opferPosition = new PVector(cos(geschwindigkeit.heading())*durchmesser+position.x, position.y-sin(geschwindigkeit.heading())*durchmesser);
      
      Lebewesen opfer = map.getTier((int)(opferPosition.x),(int)(opferPosition.y));
      
      if(!(opfer == null)){
        if(opfer.getEnergie() >= angriffswert){
          opfer.addEnergie(-angriffswert);
          this.addEnergie(angriffswert);
        } else {
          this.addEnergie(opfer.getEnergie());
          opfer.setEnergie(0);
        }
        if (energie>maxEnergie){ // Lebewesen-Energie ist über dem Maximum
          energie = maxEnergie;
        }
      }
    }
  }
  
  // Grundverbrauch
  public void leben(){
    energie -= energieverbrauch*(alter/2);
  }
  
  // Fressen
  public void fressen(float wille){
    if(wille > 0.5){
      energie -= energieverbrauch*(alter/2);
      //println("\n\nfressen");
      Feld feld = map.getFeld((int)position.x,(int)position.y);
      float neueFeldEnergie = feld.getEnergie() - fressrate;
      
      if (neueFeldEnergie>=0){ // Feld hat genug Energie
        energie += fressrate;
        feld.setEnergie((int)neueFeldEnergie);
      } else { // Feld hat zu wenig Energie
        energie += feld.getEnergie();
        feld.setEnergie(0);
      }
      
      if (energie>maxEnergie){ // Lebewesen-Energie ist über dem Maximum
        feld.setEnergie((int)(feld.getEnergie()+(energie-maxEnergie)));
        energie = maxEnergie;
      }
    }
  }
  
  // Gebaeren
  public void gebaeren(float wille){
    if(wille > 0.5 && energie >= geburtsenergie && ((float)alter % reproduktionsWartezeit == 0)){ // Bedingung ist so seltsam, weil das Alter ungenau ist
      energie -= geburtsenergie;
      map.addLebewesen(new Lebewesen((int)position.x, (int)position.y, NN.getConnections1(), NN.getConnections2(),fressrate,maxGeschwindigkeit,geburtsenergie,reproduktionsWartezeit,angriffswert));
    }
    
  }
  
  // Fuehler 1 rotieren
  public void fuehlerRotieren1(float angle){
    fuehler1.fuehlerRotieren(angle);
  }
  
  // Fuehler 2 rotieren
  public void fuehlerRotieren2(float angle){
    fuehler2.fuehlerRotieren(angle);
  }
  
  // mutiert Gewichte
  public Connection[][] mutieren(Connection[][] cArr){
    for(int x=0; x<cArr.length; x++){
      for(Connection c : cArr[x]){
        float chance = random(0,1);
        if(chance>0.3){
          float multiplizierer = random(-mutationsrate,mutationsrate);
          c.setWeight(c.getWeight()+c.getWeight() * multiplizierer);
        }
      }
    }
    return cArr;
  }
  public float mutieren(float x){
    float a = x;
    float chance = random(0,1);
    if (chance>0.5){
      a += random(-mutationsrate,mutationsrate)*x/4;
    }
    return a;     
}
  
  public void altern(){
    alter += map.getZeitProFrame();
    float neuesAlter = (float)(alter * map.getZeitMultiplikator());
    alter = (double)floor(neuesAlter) / (double)map.getZeitMultiplikator();
  }
  
  public void erinnern(float m){
    memory = m;
  }
  
  public void fellfarbeAendern(float r, float g, float b){
    fellFarbe = color(r,g,b);
  }
  
  public void addEnergie(float e){
    energie += e;
  }
  
  public void setEnergie(float e){
    energie = e;
  }
  
  // getter 
  public boolean getStatus(){
    if(energie<0){
      lebend = false;
    }
    return lebend;
  }
  public float getMaxGeschwindigkeit(){
    return maxGeschwindigkeit;
  }
  public float getEnergie(){
    return energie;
  }
  public float getMaxEnergie(){
    return maxEnergie;
  }
  public PVector getPosition(){
    return position;
  }
}