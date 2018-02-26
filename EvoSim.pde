PrintWriter output1;
PrintWriter output2;
PrintWriter output3;
PrintWriter output4;
PrintWriter output5;

int b =1;
// fenstergroesse muss seperat geändert werden, sollte immer gleich sein & einen schönen Wert haben, z.B. 100, 500,...
final int fensterGroesse = 1000;
private int weltGroesse;
private float skalierungsfaktor;
private float xOffset = 0.0;
private float yOffset = 0.0;
private float xOffsetGesamt = 0.0;
private float yOffsetGesamt = 0.0;
private float xPressed, yPressed;
private boolean locked = false;
int fileNumber;

boolean save;

int currentID = 0;

public Welt map;

void setup() {
  size(1000, 1000);
  map = new Welt(200, 200);
  noStroke();
  skalierungsfaktor = 1;
  frameRate(50);

  save = true;

  if (save) {
    if (!fileExists(sketchPath("saveDataIndex.dat"))) {
      fileNumber = 1;
      byte[] b = {1};
      saveBytes("saveDataIndex.dat", b);
    } else {
      fileNumber = bytesToInt(loadBytes("saveDataIndex.dat")) + 1;
      saveBytes("saveDataIndex.dat", intToBytes(fileNumber));
    }

    output1 = createWriter("./data/ältestesLw/ältestesLw"+fileNumber+".txt");
    output2 = createWriter("./data/durchschnittsLw/durchschnittsLw"+fileNumber+".txt");
    output3 = createWriter("./data/durchschnittsFitnessLw/durchschnittsFitnessLw"+fileNumber+".txt");
    output4 = createWriter("./data/todeUndGeburtenLw/todeUndGeburtenLw"+fileNumber+".txt");
    output5 = createWriter("./data/population/population"+fileNumber+".txt");
  }



  map.showWelt();
  map.showLebewesen(map.getLebewesen());
}

void draw() {
  //try {
    for (int i=0; i<b; i++) {
      map.update();
    }
  //}
  //catch(Exception e) {
  //  e.printStackTrace();
  //}
}

// Eventhandler
void mouseWheel(MouseEvent event) {
  float e = event.getCount();

  skalierungsfaktor -= e / 10;
  if (skalierungsfaktor<=0) {
    skalierungsfaktor = e/10;
  }
  float rMouseX = (mouseX-(xOffsetGesamt))/skalierungsfaktor;
  float rMouseY = (mouseY-(yOffsetGesamt))/skalierungsfaktor;

  xOffsetGesamt += rMouseX * e/10;
  yOffsetGesamt += rMouseY * e/10;
}
void mouseDragged() {
  if (locked) {
    xOffset = (mouseX - xPressed);
    yOffset = (mouseY - yPressed);
    xOffsetGesamt += xOffset;
    yOffsetGesamt += yOffset;
    xPressed = mouseX;
    yPressed = mouseY;
    cursor(MOVE);
  }
}
void keyPressed() {
  if (key=='w') {
    b  = 100;
  }
  if (key=='s') {
    b  = 1;
  }
  if (key ==' ') {
    skalierungsfaktor = 1;
    xOffsetGesamt = 0;
    yOffsetGesamt = 0;
  }
}
void mousePressed() {
  locked = true;
  xPressed = mouseX;
  yPressed = mouseY;
  if (map.keiner.isPressed())map.graph = "keiner";
  if (map.bAeltestes.isPressed())map.graph = "aeltestes";
  if (map.bAltersschnitt.isPressed())map.graph = "schnitt";
  if (map.bFitness.isPressed())map.graph = "fitness";
}
void mouseReleased() {
  locked = false;
  cursor(ARROW);
}

byte[] intToBytes(int x) {
  int bLength = floor(x/255);
  byte[] returnValue = new byte[bLength+1];
  for (int y = 0; y < bLength; y++) {
    returnValue[y] = byte(255);
  }
  returnValue[bLength] = byte(x%255);
  return returnValue;
}

int bytesToInt(byte[] b) {
  int returnValue = 0;
  for (byte by : b) {
    returnValue += int(by);
  }
  return returnValue;
}

boolean fileExists(String path) {
  File file=new File(sketchPath(path));
  boolean exists = file.exists();
  if (exists) {
    return true;
  } else {
    return false;
  }
}

////////////////////////////      TODO       /////////////////////
/*
- wachsen optimieren
 - moegliche Fehler koennen beim Kopieren der Connections auftreten (falsche Referenzen, etc...)
 - Farben werden nach einiger Zeit grau
 - Fitness noch nicht vollstaendig implementiert --> muss noch Auswirkung auf die Paarung haben
 - möglichst effizienten Stammbaum erstellen
 - vllt durchschnittliche Lebensdauer der Vorfahren in die Fitnessfunktion --> erstmal Stammbaum
 */