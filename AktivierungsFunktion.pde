public static class AktivierungsFunktion{  
  //range 0,1
  static float sigmoid(float x){
    return 1/(1+exp(-x));
  }
  
  //range -1,1
  static float tanh(float x){
    return (exp(x)-exp(-x))/(exp(x)+exp(-x));
  }
}