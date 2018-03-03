public class NeuralNetwork {

  Matrix inputSchicht;
  Matrix w1;
  Matrix hiddenSchicht1;
  Matrix w2;
  Matrix hiddenSchicht2;
  Matrix w3;
  Matrix hiddenSchicht3;
  Matrix w4;
  Matrix hiddenSchicht4;
  Matrix w5;
  Matrix hiddenSchicht5;
  Matrix w6;
  Matrix hiddenSchicht6;
  Matrix w7;
  Matrix outputSchicht;


  private int iSLaenge = 16; // Grund in NN_Planung.txt ersichtlich
  private int oSLaenge = 8; // Grund in NN_Planung.txt ersichtlich


  NeuralNetwork(int hS) { // hiddenSchicht1
    // Input Neuronen werden erstellt

    inputSchicht = new Matrix(iSLaenge, 1);
    w1 = new Matrix(hS, iSLaenge);
    w1.setRandom(-1/sqrt(iSLaenge), 1/sqrt(iSLaenge));

    hiddenSchicht1 = new Matrix(hS, 1);
    // Hidden Neuronen (1 Schicht) werden erstellt
    w2 = new Matrix(hS, hS);
    w2.setRandom(-1/sqrt(hS), 1/sqrt(hS));

    hiddenSchicht2 = new Matrix(hS, 1);
    // Hidden Neuronen (1 Schicht) werden erstellt
    w3 = new Matrix(hS, hS);
    w3.setRandom(-1/sqrt(hS), 1/sqrt(hS));

    hiddenSchicht3 = new Matrix(hS, 1);
    // Hidden Neuronen (1 Schicht) werden erstellt
    w4 = new Matrix(hS, hS);
    w4.setRandom(-1/sqrt(hS), 1/sqrt(hS));

    hiddenSchicht4 = new Matrix(hS, 1);
    // Hidden Neuronen (1 Schicht) werden erstellt
    w5 = new Matrix(hS, hS);
    w5.setRandom(-1/sqrt(hS), 1/sqrt(hS));

    hiddenSchicht5 = new Matrix(hS, 1);
    // Hidden Neuronen (1 Schicht) werden erstellt
    w6 = new Matrix(hS, hS);
    w6.setRandom(-1/sqrt(hS), 1/sqrt(hS));

    hiddenSchicht6 = new Matrix(hS, 1);
    // Hidden Neuronen (1 Schicht) werden erstellt
    w7 = new Matrix(oSLaenge, hS);
    w7.setRandom(-1/sqrt(hS), 1/sqrt(hS));

    outputSchicht = new Matrix(oSLaenge, 1);
  }


  NeuralNetwork(int hS, Matrix c1, Matrix c2, Matrix c3, Matrix c4, Matrix c5, Matrix c6, Matrix c7) { // hiddenSchicht1
    // Input Neuronen werden erstellt

    inputSchicht = new Matrix(iSLaenge, 1);
    w1 = new Matrix(hS, iSLaenge);
    w1.set(c1.m);

    hiddenSchicht1 = new Matrix(hS, 1);
    // Hidden Neuronen (1 Schicht) werden erstellt
    w2 = new Matrix(hS, hS);
    w2.set(c2.m);

    hiddenSchicht2 = new Matrix(hS, 1);
    // Hidden Neuronen (1 Schicht) werden erstellt
    w3 = new Matrix(hS, hS);
    w3.set(c3.m);

    hiddenSchicht3 = new Matrix(hS, 1);
    // Hidden Neuronen (1 Schicht) werden erstellt
    w4 = new Matrix(hS, hS);
    w4.set(c4.m);

    hiddenSchicht4 = new Matrix(hS, 1);
    // Hidden Neuronen (1 Schicht) werden erstellt
    w5 = new Matrix(hS, hS);
    w5.set(c5.m);

    hiddenSchicht5 = new Matrix(hS, 1);
    // Hidden Neuronen (1 Schicht) werden erstellt
    w6 = new Matrix(hS, hS);
    w6.set(c6.m);

    hiddenSchicht6 = new Matrix(hS, 1);
    // Hidden Neuronen (1 Schicht) werden erstellt
    w7 = new Matrix(oSLaenge,hS);
    w7.set(c7.m);

    outputSchicht = new Matrix(oSLaenge, 1);
  }


  public void update() {
    hiddenSchicht1.mult(inputSchicht, w1);
    hiddenSchicht1.sigmoid();
    hiddenSchicht2.mult(hiddenSchicht1, w2);
    hiddenSchicht2.sigmoid();
    hiddenSchicht3.mult(hiddenSchicht2, w3);
    hiddenSchicht3.sigmoid();
    hiddenSchicht4.mult(hiddenSchicht3, w4);
    hiddenSchicht4.sigmoid();
    hiddenSchicht5.mult(hiddenSchicht4, w5);
    hiddenSchicht5.sigmoid();
    hiddenSchicht6.mult(hiddenSchicht5, w6);
    hiddenSchicht6.sigmoid();
    outputSchicht.mult(hiddenSchicht6, w7);  
    outputSchicht.sigmoid();
  }

  //// getter
  // InputNeuronen, setzt voraus dass so viele Neuronen generiert wurden, wie es hier Werte gibt
  public void setInputNvelocity(float v) {
    inputSchicht.set(0, 0, v);
  }
  public void setInputNEnergy(float v) {
    inputSchicht.set(1, 0, v);
  }
  public void setInputNTileType(float v) {
    inputSchicht.set(2, 0, v);
  }
  public void setInputNMemory(float v) {
    inputSchicht.set(3, 0, v);
  }
  public void setInputNBias(float v) {
    inputSchicht.set(4, 0, v);
  }
  public void setInputNHeading(float v) {
    inputSchicht.set(5, 0, v);
  }
  ////Sensor

  public void setInputNSensorHeading(float v, int i) {
    inputSchicht.set(6 + (i*5), 0, v);
  }
  public void setInputNSensorEnemyEnergy(float v, int i) {
    inputSchicht.set(7+ (i*5), 0, v);
  }
  public void setInputNSensorTileEnergy(float v, int i) {
    inputSchicht.set(8+ (i*5), 0, v);
  }
  public void setInputNSensorTileType(float v, int i) {
    inputSchicht.set(9 + (i*5), 0, v);
  }
  public void setInputNSensorGenDiff(float v, int i) {
    inputSchicht.set(10 + (i*5), 0, v);
  }

  // OutputNeuronen
  public float getvelocity(Animal lw) {
    return outputSchicht.get(0, 0) * lw.getmaxVelocity();
  }
  public float getRotation() {
    float rotation; // muss noch sehen, wie die Rotation wirklich laeuft
    if (outputSchicht.get(1, 0) < 0.475) {
      rotation = map(sq(outputSchicht.get(1, 0)), 0, 0.225625, -Animal.maxRotationAngle/2, 0);
    } else if (outputSchicht.get(1, 0) > 0.525) {
      rotation = map(sq(outputSchicht.get(1, 0)), 0.275625, 1, 0, Animal.maxRotationAngle/2);
    } else rotation = 0;
    return rotation;
  }
  public float getMemory() {
    return outputSchicht.get(2, 0);
  }



  public float getFresswille() {
    return outputSchicht.get(3, 0);
  }
  public float getGeburtwille() {
    return outputSchicht.get(4, 0);
  }

  public float getAngriffswille() {
    return outputSchicht.get(5, 0);
  }

  // Sensor

  public float getRotationSensor(int i) {
    return map(outputSchicht.get(6+i, 0), 0, 1, -Animal.maxRotationAngleSensor/2, Animal.maxRotationAngleSensor/2);
  }

  // andere getter
  public Matrix getConnections1() {
    return w1;
  }
  public Matrix getConnections2() {
    return w2;
  }
  public Matrix getConnections3() {
    return w3;
  }
  public Matrix getConnections4() {
    return w4;
  }
  public Matrix getConnections5() {
    return w5;
  }
  public Matrix getConnections6() {
    return w6;
  }
  public Matrix getConnections7() {
    return w7;
  }
}