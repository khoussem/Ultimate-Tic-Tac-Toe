import java.util.ArrayList;
//Recursive solutions are us
class BrainThread2 extends Thread {
  Board board = new Board();
  boolean running = false;
  boolean moved = false;
  final int TURN = 2;
  int [][] movePrefs;
  int [][] bigBoxRatings;
  int bestX, bestY;
  int existedCount = 0;
  int notExistedCount = 0;
  boolean last = false;
  boolean lastWasWon = false;
  //Might want to change this based upon the speed of our algorithm, maybe lower levels
  //of difficulty use smaller depthlimit
  int DEPTHLIMIT = 6; //Limit on depth of recursion
  /*  Constructors to be passed 
   *  Board's current position  
   *
   *
   */
  BrainThread2(Board bored, int BSN) { 
    DEPTHLIMIT = difficulty + 3;
    board = bored; //Witty
    running = true;
    moved = false;
    movePrefs = new int[3][3];
    bigBoxRatings = new int[3][3];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        movePrefs[i][j] = 0;
      }
    }
    bestX = 0;
    bestY = 0;
    //However, to explain, bored is a Board object that is updated 
    //in the main function, and is passed to BrainThread2 when BT2 is called
    //   maxCall(board, 0, 0, bigSquarenow, 0);
  } 
  public boolean running() {
    return running;
  }
  public void run() {
    int startBSN = bigSquarenow;
    int depth = 0; //Our starting call for the depth of the recursion
    //Run our tree search in here
    //maxCall
    // if (bigSquarenow == 0) getRandomBox();
    /*for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
      rateMove(i, j);
      }
      }*/
    recursor(0, 0);
    if (startBSN != 0) bigSquarenow = startBSN;
    gameMakeMove(bestX, bestY);
    running = false;
  }
  PVector getBestMove() {
    int max = 0;
    ArrayList<PVector> moves = new ArrayList<PVector>();
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        //println("DEBUG: i: " + i + " j: " + j + " pref: " + movePrefs[i][j]);
        if (movePrefs[i][j] > max) {
          max = movePrefs[i][j];
          moves = new ArrayList<PVector>();
          moves.add(new PVector(i, j));
        } 
        else if (movePrefs[i][j] == max) {
          moves.add(new PVector(i, j));
        }
      }
    }
    return moves.get(floor(random(0, moves.size())));
  }
  int recursor(int depth, int rating) {
    String tabs = "";
    for (int i = 0; i < depth; i++) tabs += "\t";
    int bestmove = 0;
    if (bigSquarenow == 0) {
      //If board is won return the rating
      if(board.gameFinished() != 0) return rating; 
      // println(tabs + "Depth: " + depth);
      // println(tabs + "Big square now: " + bigSquarenow);
      if (depth % 2 == 0) {
        bestmove = -1000000000; //The retval... 
      }
      else {
        bestmove = 1000000000;
      }
      //DEPTHLIMIT++;
      int bestBig = 0;
      int myBestX = 0;
      int myBestY = 0;
      //if(depth == 1) println("here we'are " + depth);
      for (int tempBig = 1; tempBig < 10; tempBig++) {
        if (board.big[tempBig - 1].state != 0) continue;
        for(int i = 1; i < 10; i++) {
          if(depth == 0) println("STATES: " + i + " " + bigstate[i]);
        }
        if (depth == 0) println("Tempbig: " + tempBig);
        bigSquarenow = tempBig;
        //println("Temp big: " + tempBig);
        //println("DEPTH!SADG: " + depth);
        int tempRating = rateTheBig(depth, rating);
        //if(tempRating == rating) println("Too deep: returning...");
        if (depth == 0) println("Rating of the big: " + tempRating);
        //println(
        if (depth % 2 == 0) {
          if (tempRating > bestmove) {
            bestmove = tempRating;
            bestBig = tempBig;
            myBestX = bestX;
            myBestY = bestY;
          }
        } 
        else {
          if (tempRating < bestmove) {
            bestmove = tempRating;
            bestBig = tempBig;
            myBestX = bestX;
            myBestY = bestY;
          }
        }
      }
      if (depth == 0) {
        bestX = myBestX;
        bestY = myBestY;
        //println("Best x, y: " + bestX + ", " + bestY);
        //println("Best box... " + bestBig);
      }
      //if(depth == 1) println("Best big: " + bestBig);
      bigSquarenow = bestBig;
      //DEPTHLIMIT--;
      //if(depth == 1) println("Best move: " + bestmove);
    } 
    else bestmove = rateTheBig(depth, rating);
    //For now don't recurse...
    //println(tabs + "Best move: " + bestMove);
    //println(tabs + "BestX " + bestX + " bestY " + bestY);
    return bestmove;
  }
  int rateTheBig(int depth, int rating) { 
    int depthInc = 0;
    if (lastWasWon && depth == DEPTHLIMIT) {
      depthInc++;
      //println(lastWasWon);
      lastWasWon = false;
    }
    DEPTHLIMIT += depthInc;
    String tabs = "";
    for (int i = 0; i < depth; i++) tabs += '\t';
    //if(bigstate[bigSquarenow] != 0) println(tabs + "invalid place" + bigSquarenow);
    int bestMove = 0;
    if (depth % 2 == 0) {
      bestMove = -1000000000; //The retval...
    }
    else {
      bestMove = 1000000000;
    }
    if (depth >= DEPTHLIMIT) {
      return rating;
    }
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        int Bsn = bigSquarenow; //Store for later reproduction
        //println("BigSqNow: "  + bigSquarenow);
        int afterMoveRating = 0;
        if (!board.possibleMove(i, j, bigSquarenow)) {
          //Need not adjust retval for this case, just continue
          //println(tabs + "i: " + i + " j: " + j + "Impossible move");
          continue;
        }
        makeMove(new PVector(i, j), turn); //Make the temp move on the board
        newBigBoxRating n = new newBigBoxRating(board, 1); //Init the position rating
        afterMoveRating = n.ratePosition(); //The rating after a move... If worse than 
        boolean keepGoing = false;
        //If depth % 2 == 0 then
        //we just made a move for the computer
        if (depth % 2 == 0) {
          //Therefore if the rating of the position we got
          //Is worse than the rating of the 
          if (afterMoveRating > bestMove) {
            //This is gotten better for computer 
            keepGoing = true;
          } 
          else {
            //Otherwise our position declined...
            keepGoing = false;
          }
        } 
        else {
          if (afterMoveRating < bestMove) keepGoing = true; 
          else keepGoing = false;
        }
        if (bigSquarenow == 0) lastWasWon = true;
        int r = afterMoveRating; //Make this bestMove
        if(boardWasWon) {
          keepGoing = false;
        }
        if(depth <= 2) keepGoing = true;
        if (keepGoing) r = recursor(depth + 1, afterMoveRating);
                //          if(keepGoing) println(tabs + "Returning from recursion");
        //          println(tabs + "Rating of i: " + i + " j: " + j + " is " + r);
        // println("Returning from recursion with depth: " + depth);
        //println("My i is: " + i + " my j is: " + j);
        bigSquarenow = Bsn;
        unMakeMove(new PVector(i, j), Bsn);
        bigSquarenow = Bsn;
        if (depth % 2 == 0) {
          if ( r > bestMove) {
            bestMove = r;
            if (depth == 0) {
              bestX = i;
              bestY = j;
            }
          }
        } 
        else if (r < bestMove) {
          if (depth == 0) {
            bestX = i;
            bestY = j;
          }
          bestMove = r;
        }
        //This should never happen
        //if(r == 1000000000) println("CURR BIG LOL: " + bigSquarenow);
        //if(r == -1000000000) println("NEG CURR BIG LOL: " + bigSquarenow);

      }
    }
    DEPTHLIMIT -= depthInc;
    boardWasWon = false;
    if(depth == 0) { 
      println("Best move: " + bestMove);
      println("Best x, y: " + bestX + ", " + bestY);
    }
    return bestMove;
  }
  void rateMove(int a, int b) {
    if (!board.possibleMove(a, b, bigSquarenow)) {
      //println("DEBUG: bigSq: " + bigSqCurr + " not possible: " + (a + 3 * b));
      movePrefs[a][b] = -4;
      return;
    }
    int nextBox = 3 * b + a;
    if (board.big[bigSquarenow - 1].canBeWon(a, b, 2)) {
      //This move wins this box
      movePrefs[a][b] += 30; //For now though lets just increment
      nextBox = 0;
    } 
    else {
      if (board.big[bigSquarenow - 1].canBeWon(a, b, 1)) movePrefs[a][b] += 5; //Should multiply times opponents want of curr box
    }
    //Now lets subtract based upon what they can do in the next box
    /*
       int max = 0;
       if(nextBox == 0) {
       for(int i = 1; i < 10; i++) {
       int v = subtractNextBoxVal(i, 1);
       if(v > max) max = v;
       }
       } else max = subtractNextBoxVal(nextBox, 1);
       movePrefs[a][b] -= max; */
  }
  void getRandomBox() {
    ArrayList<Integer> possibles = new ArrayList<Integer>();
    for (int i = 0; i < 9; i++) {
      if (board.big[i].state == 0) possibles.add(new Integer(i + 1));
    }
    bigSquarenow = possibles.get(floor(random(0, possibles.size())));
  }
  void makeMove(PVector p, int t) {
    int temp = bigSquarenow;
    bigChanged = bigSquarenow;
    smallChanged = getSmallChanged((int) p.x, (int) p.y);
    ((smallestSquares) smalls.get(smallChanged - 1)).boxTaker();
    if (bigstate[bigSquarenow] != 0) {
      bigSquarenow = temp;
    }
    if(bigstate[temp] != 0) {
      bigSquarenow = 0;
    }
  }
  void unMakeMove(PVector p, int bigNow) {
    bigChanged = bigNow;
    smallChanged = getSmallChanged((int) p.x, (int) p.y);
    ((smallestSquares) smalls.get(smallChanged - 1)).unTake();
    changeMade = false;
    turn = Utils.getOtherTurn(turn);
    if (bigstate[bigNow] != 0) bigstate[bigNow] = 0;
  }
  void gameMakeMove(int x, int y) {
    //println("Box: " + bigSquarenow);
    //println("X: " + x + " Y: " + y);
    //newBigBoxRating n = new newBigBoxRating(board, 2);
    //println("Pre-move rating: " + n.ratePosition());
    //stateChangedTo = 2;
    bigChanged = bigSquarenow;
    smallChanged = getSmallChanged(x, y);
    ((smallestSquares) smalls.get(smallChanged - 1)).boxTaker();
    moved = true;
    thinking = false;
  }
  void gameMakeMove(PVector p) {
    //stateChangedTo = 2;
    bigChanged = bigSquarenow;
    smallChanged = getSmallChanged((int) p.x, (int) p.y);
    thinking = false;
    ((smallestSquares) smalls.get(smallChanged - 1)).boxTaker();
    moved = true;
  }
  int quotient(int n, int d) {
    int ret = 0;
    while (d <= n) {
      n -= d;
      ret++;
    } 
    return ret;
  }
  int getSmallChanged(int a, int b) {
    int ret = 1;
    ret += (3 * ((bigChanged + 2) % 3)) + a;
    ret += (quotient(bigChanged - 1, 3)) * 27 + b * 9;
    return ret;
  }
  PVector getRandomMove() {
    boardbigSquares now = board.big[bigSquarenow-1];
    int r = 0;
    while (true) {
      r = floor(random(0, 9));
      if ( now.isValid(r) ) break;
    }
    return new PVector(Utils.getX(r), Utils.getY(r));
  }
}
