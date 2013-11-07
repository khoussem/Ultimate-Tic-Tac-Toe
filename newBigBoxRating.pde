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
  int [] bigLikeliness;
  public newBigBoxRating(Board bored, int s) {
    board = bored;
    turn = s;
    likeliness = new int[9];
    bigLikeliness = new int[9];
  }
  int rateMe(int bigSqNum) {
    initLikelyhoods();
    initLikelyhoodsBig();
    return 1;
  }
  //This initializes a list of the eight different 
  //Winning combination vectors, that are than used 
  //To represent either winning patterns in the small
  //boards, or for the whole game
  ArrayList<winPattern> initPatterns() {
    ArrayList<winPattern> win = new ArrayList<winPattern>();
    for (int i = 0; i < 8; i++) win.add(new winPattern());
    //Diags
    win.get(0).initMyself(new PVector(0, 0), new PVector(1, 1), new PVector(2, 2));
    win.get(1).initMyself(new PVector(0, 2), new PVector(1, 1), new PVector(2, 0));
    //Horizontals
    win.get(2).initMyself(new PVector(0, 0), new PVector(1, 0), new PVector(2, 0));
    win.get(3).initMyself(new PVector(0, 1), new PVector(1, 1), new PVector(2, 1));
    win.get(4).initMyself(new PVector(0, 2), new PVector(1, 2), new PVector(2, 2));
    //Verticals
    win.get(5).initMyself(new PVector(0, 0), new PVector(0, 1), new PVector(0, 2));
    win.get(6).initMyself(new PVector(1, 0), new PVector(1, 1), new PVector(1, 2));
    win.get(7).initMyself(new PVector(2, 0), new PVector(2, 1), new PVector(2, 2));
    return win;
  }
  //Inits the states for a win vectors of smaller board
  void addStates(ArrayList<winPattern> win, boardbigSquares b) {
    for (int i = 0; i < win.size(); i++) win.get(i).initStates(b);
  }
  //Calculates the likely hood that any big box will be one by the player (aka turn)
  int bigLikelyhood(int big, int turn) {
    if(board.big[big].state == turn) return 150; //If box is already won
    if(board.big[big].state == Utils.getOtherTurn(turn)) return 0; //If it can't be won
    ArrayList<winPattern> win = initPatterns(); //Get the list of win vectors
    addStates(win, board.big[big]); //Add the states to each square represented...
    //And then find the likely hood that the box will be won by player (aka turn)...
    //This is done by finding how many possible winning combinations of:
    //one in a rows, and blank threes there are represented by numOnes and numZeros
    //and combining it with how many two in a row wins there are (to prevent from
    //reusing winning squares with look at each square and see if it is the missing
    //part of a two in a row
    for (int i = 0; i < win.size(); i++) win.get(i).initLikelyhood(turn); 
    int numOnes = 0;
    int numZeros = 0;
    for (int i = 0; i < win.size(); i++) { 
      if (win.get(i).likelyhood == 1) numOnes++; //Likelyhood is how many squares
      //In the win pattern are owned by us 
      //Its -1 if the opponent has a square in that winPattern
      if(win.get(i).likelyhood == 0) numZeros++;
    }
    int numTwos = 0; //Calculated slightly differently to prevent overlap
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board.big[big].canBeWon(i, j, turn)) numTwos++;
      }
    }
    //Lets see how can we use these two values to find out the likelyhood...
    //We will add arbitrary values and then maybe (machine learning or just
    //aaron's approximation to adjust values to be apt)
    float likely = 0;
    //Add significant amount if it can be won in one turn (theres a two in a row)
    if (numTwos == 1) likely += 20;
    else if (numTwos >= 2) likely += 25 + numTwos - 2;
    likely += 1.5 * numOnes; //For every pattern thats missing two add 1.5
    likely += .5 * numZeros; //So it starts at 4
    //If we can win eventually (thats what numZeros represents)
    return ceil(likely); //Round up, floats are a pain
  }
  //Fill in the likeliness array for a smaller square
  public void initLikelyhoods() {
    for (int i = 0; i < 9; i++) likeliness[i] = bigLikelyhood(i, turn);
  }
  //Print out the likeliness of a smaller square
  public void printLikelyhood() {
    for (int i = 0; i < 9; i++) println("DEBUG: box: " + i + " like: " + likeliness[i]);
  }
  //The below functions are for whole board analysis
  winPattern [] initPatternBigs(int num, ArrayList<winPattern> p) {
    //We have a list of win vectors, now based upon what square we \
    //are we fill in the values accordingly. Hardcoded because it will be
    //faster to run and wasn't that difficult to do (although aesthitically its ugly)
    winPattern [] wins = new winPattern[4]; //temporary storage
    switch(num) {
      //Next to case is the x,y coordinate of the box represented...
      case 0: //0, 0
        wins[0] = p.get(0);
        wins[1] = p.get(2);
        wins[2] = p.get(5);
        break;
      case 1: //1, 0
        wins[0] = p.get(2);
        wins[1] = p.get(6);
        break;
      case 2: //2, 0
        wins[0] = p.get(1);
        wins[1] = p.get(2);
        wins[2] = p.get(7);
        break;
      case 3: //0, 1
        wins[0] = p.get(3);
        wins[1] = p.get(5);
        break;
      case 4: //1, 1
        wins[0] = p.get(0);
        wins[1] = p.get(1);
        wins[2] = p.get(3);
        wins[3] = p.get(6);
        break;
     case 5: //2, 1
        wins[0] = p.get(3);
        wins[1] = p.get(7);
        break;
     case 6: //0, 2
        wins[0] = p.get(1);
        wins[1] = p.get(4);
        wins[2] = p.get(5);
        break;
     case 7: //1, 2
        wins[0] = p.get(4);
        wins[1] = p.get(6); 
        break;
     case 8: //2, 2
        wins[0] = p.get(0);
        wins[1] = p.get(4);
        wins[2] = p.get(7);
        break;
     default:
        break;
    }
    return wins;
  }
  //Returns each boxes inidvidualized win patterns
  //Done from each boxes perspective instead of from the 
  //vectors perspective for speed. And makes box analysis easier
  winPattern [][] findBigPatterns() {
    winPattern [][] bigWins = new winPattern[9][4]; //Init the return array
    ArrayList<winPattern> winVectors = new ArrayList<winPattern>(); //Only init
    //this list once and then pass it to initPatternsBigs each time to save time
    winVectors = initPatterns();
    for(int i = 0; i < winVectors.size(); i++) winVectors.get(i).initStates(board);
    //Now calculate the game winning patterns that this big is valid for
    for(int i = 0; i < 9; i++) {
      bigWins[i] = initPatternBigs(i, winVectors); 
    }
    return bigWins;
  }
  //Using the win patterns of each big, find the likelihood
  //of it being part of a winning pattern and then rate it
  //as such
  void initLikelyhoodsBig() {
    
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
    void initStates(Board bo) {
      state[0] = bo.big[(int)(a.x + 3 * a.y)].state;
      state[1] = bo.big[(int)(b.x + 3 * b.y)].state;
      state[2] = bo.big[(int)(c.x + 3 * c.y)].state;
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

