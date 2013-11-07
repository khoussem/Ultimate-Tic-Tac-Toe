/* To analyze a box we need to:
 * Find out how many winning patterns its a part of
 * And combine that number with the likely hood of that
 * pattern being won. So we need to give each box a likelyhood
 * of being won. Keep in mind we dont care about the next bigSq
 * So first
 */
public class newBigBoxRating {
  Board board;
  int turn;
  int [] likeliness;
  public newBigBoxRating(Board bored, int s) {
    board = bored;
    turn = s;
    likeliness = new int[9];
  }
  int rateMe(int bigSqNum) {
    return 1;
  }
  ArrayList<winPattern> initPatterns() {
    ArrayList<winPattern> win = new ArrayList<winPattern>();
    for (int i = 0; i < 8; i++) win.add(new winPattern());
    win.get(0).initMyself(new PVector(0, 0), new PVector(1, 1), new PVector(2, 2));
    win.get(1).initMyself(new PVector(0, 2), new PVector(1, 1), new PVector(2, 0));
    win.get(2).initMyself(new PVector(0, 0), new PVector(1, 0), new PVector(2, 0));
    win.get(3).initMyself(new PVector(0, 1), new PVector(1, 1), new PVector(2, 1));
    win.get(4).initMyself(new PVector(0, 2), new PVector(1, 2), new PVector(2, 2));
    win.get(5).initMyself(new PVector(0, 0), new PVector(0, 1), new PVector(0, 2));
    win.get(6).initMyself(new PVector(1, 0), new PVector(1, 1), new PVector(1, 2));
    win.get(7).initMyself(new PVector(2, 0), new PVector(2, 1), new PVector(2, 2));
    return win;
  }
  void addStates(ArrayList<winPattern> win, boardbigSquares b) {
    for (int i = 0; i < win.size(); i++) win.get(i).initStates(b);
  }
  int bigLikelyhood(int big, int turn) {
    ArrayList<winPattern> win = initPatterns();
    addStates(win, board.big[big]);
    for (int i = 0; i < win.size(); i++) win.get(i).initLikelyhood(turn);
    int numOnes = 0;
    int numZeros = 0;
    for (int i = 0; i < win.size(); i++) { 
      if (win.get(i).likelyhood == 1) numOnes++;
      if(win.get(i).likelyhood == 0) numZeros++;
    }
    println("DEBUG: Ones: " + numOnes);
    int numTwos = 0;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board.big[big].canBeWon(i, j, turn)) numTwos++;
      }
    }
    //Lets see how can we use these two values to find out the likelyhood...
    float likely = 0;
    if (numTwos == 1) likely += 20; 
    else if (numTwos >= 2) likely += 25 + numTwos - 2;
    likely += 1.5 * numOnes;
    likely += .5 * numZeros; //So it starts at 4
    return floor(likely);
  }
  public void initLikelyhoods() {
    for (int i = 0; i < 9; i++) likeliness[i] = bigLikelyhood(i, turn);
  }
  public void printLikelyhood() {
    for (int i = 0; i < 9; i++) println("DEBUG: box: " + i + " like: " + likeliness[i]);
  }
  void findBigPatterns() {
  }
  private class winPattern {
    PVector a;
    PVector b;
    PVector c;
    int [] state;
    int likelyhood;
    public winPattern() {
      state = new int[3];
      likelyhood = 0;
    }
    void initMyself(int i, int j, int k) {
      a = new PVector(Utils.getX(i), Utils.getY(i));
      b = new PVector(Utils.getX(j), Utils.getY(j));
      c = new PVector(Utils.getX(k), Utils.getY(k));
    }
    void initMyself(PVector A, PVector B, PVector C) {
      a = A;
      b = B;
      c = C;
    }
    void initStates(boardbigSquares box) {
      state[0] = box.boxes[(int) a.x][(int) a.y].state;
      state[1] = box.boxes[(int) b.x][(int) b.y].state;
      state[2] = box.boxes[(int) c.x][(int) c.y].state;
    }
    void initLikelyhood(int t) {
      int other = Utils.getOtherTurn(t);
      if (state[0] == other || state[1] == other || state[2] == other) {
        likelyhood = -1;
        return;
      }
      for (int i = 0; i < 3; i++) if (state[i] == t) likelyhood++;
    }
  }
}

