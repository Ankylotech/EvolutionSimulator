class Button {
  float X;
  float Y;
  float W;
  float H;
  float posX;
  float posY;
  float bWidth;
  float bHeight;
  String name;

  Button(float x, float y, float w, float h, String n) {   
    X = x;
    Y = y;
    W= w;
    H = h;
    name = n;
  }

  void show() {

    posX = map.WorldX + X/scaling;
    posY = map.WorldY + Y/scaling;

    bWidth = (W)/scaling;
    bHeight = (H)/scaling;

    stroke(0);
    fill(0, 100);
    rect(posX, posY, bWidth, bHeight);
    fill(255);
    textSize(10/scaling);
    text(name, posX, posY+bHeight/2);
    noStroke();
  }

  boolean isPressed() {

    posX = map.WorldX + X/scaling;
    posY = map.WorldY + Y/scaling;

    float rMouseX = (mouseX-(xOveralOffset))/scaling;
    float rMouseY = (mouseY-(yOveralOffset))/scaling;

    bWidth = (W)/scaling;
    bHeight = (H)/scaling;

    if (rMouseX>posX && rMouseX<posX+bWidth && rMouseY > posY && rMouseY < posY+bHeight) {
      return true;
    } else return false;
  }
}