class Matrix {
  int rows;
  int cols;
  float[][] m;

  Matrix(int r, int c) {
    rows = r;
    cols = c;
    m = new float[r][c];
  }

  Matrix mult(Matrix m2) {
    Matrix returnMatrix = new Matrix(rows,m2.cols);
    for (int x = 0; x < rows; x++) {
      for (int y = 0;y < m2.cols ; y++) {
        returnMatrix.set(x,y,mult(getRow(x),m2.getCol(y)));
      }
    }
    return returnMatrix;
  }
  float mult(float[] i1, float[] i2) {
    float result = 0;
    for (int x = 0; x < i1.length; x++) {
      result += i1[x] * i2[x];
    }
    return result;
  }

  float get(int r, int c) {
    return m[r][c];
  }
  void set(int r, int c, float v) {
    m[r][c] = v;
  }
  void set(float[][] v) {
    m = v;
  } 
  float[] getRow(int r) {
    return m[r];
  }
  float[] getCol(int c) {
    float[] result = new float[rows];
    for (int x=0; x<rows; x++) {
      result[x] = m[x][c];
    }
    return result;
  }
}