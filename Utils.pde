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
}
