public static class Utils {
  public static int quotient(int n, int d) {
    int ret = 0;
    while(n > d) {
      n -= d;
      ret++;
    }
    return ret;
  }
  public static int getX(int s) {
    return s % 3;
  }
  public static int getY(int s) {
    return quotient(s, 3);
  }
  public static int getI(int x, int y) {
    return y * 3 + x;
  }
  public static int getOtherTurn(int turn) {
    return (turn % 2) + 1;
  }
  public static int getMyBoxNumber(int smallSquare) {
    int x = (smallSquare - 1) % 9;
    x = x % 3;
    println("X: " + x);
    int y = quotient(smallSquare, 9);
    y = y % 3;
    println("Y: " + y);
    return x + 3 * y;
  }
}
