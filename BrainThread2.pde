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
        } else if (movePrefs[i][j] == max) {
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
      // println(tabs + "Depth: " + depth);
      // println(tabs + "Big square now: " + bigSquarenow);
      if (depth % 2 == 0) bestmove = -1000000; //The retval... else bestmove = 1000000000;
      //DEPTHLIMIT++;
      int bestBig = 0;
      int myBestX = 0;
      int myBestY = 0;
      //if(depth == 1) println("here we'are " + depth);
      for (int tempBig = 1; tempBig < 10; tempBig++) {
        if (bigstate[tempBig] != 0) continue;
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
        } else {
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
        println("Best x, y: " + bestX + ", " + bestY);
        println("Best box... " + bestBig);
      }
      //if(depth == 1) println("Best big: " + bestBig);
      bigSquarenow = bestBig;
      //DEPTHLIMIT--;
      //if(depth == 1) println("Best move: " + bestmove);
    } else bestmove = rateTheBig(depth, rating);
    //For now don't recurse...
    //println(tabs + "Best move: " + bestMove);
    //println(tabs + "BestX " + bestX + " bestY " + bestY);
    return bestmove;
  }
  int rateTheBig(int depth, int rating) {
    int depthInc = 0;
    if (bigSquarenow == 0) println("WTF");
    if (lastWasWon && depth == DEPTHLIMIT) {
      depthInc++;
      //println(lastWasWon);
      lastWasWon = false;
    }
    DEPTHLIMIT += depthInc;
    String tabs = "";
    for (int i = 0; i < depth; i++) tabs += '\t';
    int bestMove = 0;
    if (depth % 2 == 0) bestMove = -1000000; //The retval... else bestMove = 1000000000;
    if (depth >= DEPTHLIMIT) {
      return rating;
    }
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        //println("BigSqNow: "  + bigSquarenow);
        if (!board.possibleMove(i, j, bigSquarenow)) {
          //Need not adjust retval for this case, just continue
          //println(tabs + "i: " + i + " j: " + j + "Impossible move");
          continue;
        }
        int Bsn = bigSquarenow; //Store for later reproduction
        makeMove(new PVector(i, j), turn); //Make the temp move on the board
        newBigBoxRating n = new newBigBoxRating(board, 1); //Init the position rating
        int afterMoveRating = n.ratePosition(); //The rating after a move... If worse than 
        boolean keepGoing = false;
        //If depth % 2 == 0 then
        //we just made a move for the computer
        if (depth % 2 == 0) {
          //Therefore if the rating of the position we got
          //Is worse than the rating of the 
          if (afterMoveRating > bestMove) {
            //This is gotten better for computer 
            keepGoing = true;
          } else {
            //Otherwise our position declined...
            keepGoing = false;
          }
        } else {
          if (afterMoveRating < bestMove) keepGoing = true; else keepGoing = false;
        }
        if (bigSquarenow == 0) lastWasWon = true;
        int r = afterMoveRating; //Make this bestMove
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
        } else if (r < bestMove) {
          if (depth == 0) {
            bestX = i;
            bestY = j;
          }
          bestMove = r;
        }
      }
    }
    DEPTHLIMIT -= depthInc;
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
    } else {
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
    bigChanged = bigSquarenow;
    smallChanged = getSmallChanged((int) p.x, (int) p.y);
    ((smallestSquares) smalls.get(smallChanged - 1)).boxTaker();
    if(bigstate[bigSquarenow] != 0) bigSquarenow = bigChanged;
  }
  void unMakeMove(PVector p, int bigNow) {
    if (bigstate[bigSquarenow] != 0) bigstate[bigSquarenow] = 0;
    bigChanged = bigNow;
    smallChanged = getSmallChanged((int) p.x, (int) p.y);
    ((smallestSquares) smalls.get(smallChanged - 1)).unTake();
    changeMade = false;
    turn = Utils.getOtherTurn(turn);
  }
  void gameMakeMove(int x, int y) {
    println("Box: " + bigSquarenow);
    println("X: " + x + " Y: " + y);
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
    ((smallestSquares) smalls.get(smallChanged - 1)).boxTaker();
    moved = true;
    thinking = false;
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
  /* Functions declared below
   * possibleMove(move, &board): finds if move is possible
   * gameDone(&board) could make board.done boolean: says if board is finished
   * makeMove(takes move and board (not pass by reference) and makes the move
   * positionJudge(&board) judges board at final position.
   */
  //Max is the search for computers main brain
  int maxCall(Board board, int _alpha, int _beta, int squareNow, int depth) {
    //Base case/break code
    int moveReturn = 0;
    board.turn = 2;
    if (depth > DEPTHLIMIT || board.gameDone()) return board.positionJudge(squareNow); //Heuristic approximation of board
    int bestMove = 0; //Will hold our best move
    //Code to deal with freebee case
    if (squareNow == 0) {
      for (int i=1; i<10; i++) {
        //Here we just recall minCall for each possible squareNow, without changing the board
        int moveHold = maxCall(board, _alpha, _beta, i, depth + 1); //Increment depth so that we 
        if (moveHold > bestMove) {                                  //Compensate for broader search
          //Here we just are doing the same thing as below
          bestMove = moveHold;
          _alpha = bestMove;
        }
        if (_beta > _alpha) {
          //And here of course is the pruning
          return bestMove;
        }
      }
    }
    //The above code will take you here in the next recursion
    //If it is not a freebee than ignore above code else {
    //Loop through each possible move
    for (int i = 1; i < 10; i++) { 
      //First make sure its possible, if not just move on to next case
      if (board.onePossibleMove(i, squareNow)) {
        board.makeMove(i, squareNow);
        int moveHolder = minCall(board, _alpha, _beta, board.nextSquare, depth + 1); //This holds the value of the current move, minmove returns a value
        board.turn = 2; //Keep track of the turn for min versus max
        board.unmakeMove(i, squareNow);
        //If this move is better, than we replace the other one
        if (moveHolder > bestMove) {
          moveReturn = i;
          bestMove = moveHolder;
          _alpha = bestMove; //Then we make alpha to be our best move
        }
        if (_beta > _alpha) {
          //If our opponents best move 
          if (depth == 0) {
            return moveReturn;
          }
          return bestMove;
        }
      }
    }
    if (depth == 0) {
      return moveReturn;
    }
    return bestMove;
  }
  //min is the search for the opponent of the computer
  int minCall(Board board, int _alpha, int _beta, int squareNow, int depth) {
    //Base case/break code
    board.turn = 1;
    if (depth > DEPTHLIMIT || board.gameDone()) return board.positionJudge(squareNow); //Heuristic approximation of board
    int bestMove = 0; //Will hold our best move
    //Code to deal with freebee case
    if (squareNow == 0) {
      for (int i=1; i<10; i++) {
        //Here we just recall minCall for each possible squareNow, without changing the board
        int moveHold = minCall(board, _alpha, _beta, i, depth + 1); //Increment depth so that we 
        if (moveHold > bestMove) {                                  //Compensate for broader search
          //Here we just are doing the same thing as below
          bestMove = moveHold;
          _beta = bestMove;
        }
        if (_alpha > _beta) {
          //And here of course is the pruning
          return bestMove;
        }
      }
    }
    //The above code will take you here in the next recursion
    //If it is not a freebee than ignore above code else {
    //Loop through each possible move
    for (int i = 1; i < 10; i++) {
      //First make sure its possible, if not just move on to next case
      if (board.onePossibleMove(i, squareNow)) {
        board.makeMove(i, squareNow);
        int moveHolder = maxCall(board, _alpha, _beta, board.nextSquare, depth + 1); //This holds the value of the current move, maxmove returns a value
        board.turn = 1;
        board.unmakeMove(i, squareNow);
        //If this move is better, than we replace the other one
        if (moveHolder > bestMove) {
          bestMove = moveHolder;
          _beta = bestMove; //Then we make beta to be our best move
        }
        if (_alpha > _beta) {
          //If our opponent has an opportunity to play a better move,
          //they will never go down this path
          return bestMove;
        }
      }
    }
    return bestMove; //Will return 0 in a situation of a tie with no moves
  }
}

