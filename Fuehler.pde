class Fuehler{
  
  private PVector position;
  
  private int abstand = 10;
  private Lebewesen tier;
  private Feld momentanFeld;
  
  Fuehler(Lebewesen t){
    tier = t;
    position.set(t.position.x + abstand*cos(random(0,2*3.1415926535)),t.position.y + abstand*sin(random(0,2*3.1415926536)));
    momentanFeld = map.getFeld((int)position.x,(int)position.y);
  }
  //updated und malt den Fühler
  void drawFuehler(){
    position.x = tier.position.x + abstand*cos(position.heading());
    position.y = tier.position.y + abstand*sin(position.heading());
    momentanFeld = map.getFeld((int)position.x,(int)position.y);
    line(position.x,position.y,tier.position.x,tier.position.y);
    ellipse(position.x,position.y,tier.durchmesser/2,tier.durchmesser/2);
  }
  //getter
  //gibt die Energie vom feld des Fühlers
  int fuehlerEnergie(){
    return (int)momentanFeld.getEnergie();
  }
  
  //gibt,wenn Gegner vorhanden, dessen Energie aus
  Integer fuehlerGegnerEnergie(){
    Lebewesen a = map.getTier((int)position.x,(int)position.y);
    if(a != null){
      return (Integer)((int)a.energie);
    }
    else return null;
  }

}