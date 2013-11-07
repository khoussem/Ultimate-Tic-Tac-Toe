import java.util.ArrayList;
//Recursive solutions are us
class BrainThread2 extends Thread {
  Board board = new Board();
  boolean running = false;
  boolean moved = false;
  final int TURN = 2;
  int [][] movePrefs;
  int [][] bigBoxRatings;
  //Might want to change this based upon the speed of our algorithm, maybe lower levels
  //of difficulty use smaller depthlimit
  final int DEPTHLIMIT = 10; //Limit on depth of recursion
  /*  Constructors to be passed 
   *  Board's current position  
   *
   *
   */
  int bigSqCurr;
  BrainThread2(Board bored, int BSN) { 
    board = bored; //Witty
    bigSqCurr = BSN; //This is stored 1-10
    running = true;
    moved = false;
    movePrefs = new int[3][3];
    bigBoxRatings = new int[3][3];
    for(int i = 0; i < 3; i++) {
        for(int j = 0; j < 3; j++) {
            movePrefs[i][j] = 50;
        }
    }
    //However, to explain, bored is a Board object that is updated 
    //in the main function, and is passed to BrainThread2 when BT2 is called
    //   maxCall(board, 0, 0, bigSquarenow, 0);
  } 
  public boolean running() {
    return running;
  }
  public void run() {
    int depth = 0; //Our starting call for the depth of the recursion
    //Run our tree search in here
    //maxCall
    //Lets check if this box can be won
    if(bigSqCurr == 0) getRandomBox();
    for(int i = 0; i < 3; i++) {
        for(int j = 0; j < 3; j++) {
            rateMove(i, j);
        }
    }
    gameMakeMove(getBestMove());
    newBigBoxRating n = new newBigBoxRating(board, 1);
    n.initLikelyhoods();
    n.printLikelyhood();
    running = false;
  }
  PVector getBestMove() {
      int max = 0;
      ArrayList<PVector> moves = new ArrayList<PVector>();
      for(int i = 0; i < 3; i++) {
          for(int j = 0; j < 3; j++) {
            println("DEBUG: i: " + i + " j: " + j + " pref: " + movePrefs[i][j]);
            if(movePrefs[i][j] > max) {
                max = movePrefs[i][j];
                moves = new ArrayList<PVector>();
                moves.add(new PVector(i, j));
            } else if(movePrefs[i][j] == max) {
                moves.add(new PVector(i, j));
            }
          }
      }
      return moves.get(floor(random(0, moves.size())));
  }
  int recursor(int depth) {
    for(int i = 0; i < 3; i++) {
      for(int j = 0; j < 3; j++) {
        
      }
    }
    return 0;
  }
  int rateBox(int a, int b, int Turn) {
    return 1;
  }
  void rateMove(int a, int b) {
    if(!board.possibleMove(a, b, bigSqCurr)) {
      //println("DEBUG: bigSq: " + bigSqCurr + " not possible: " + (a + 3 * b));
     movePrefs[a][b] = -4;
     return; 
    }
    int nextBox = 3 * b + a;
    if(board.big[bigSqCurr - 1].canBeWon(a, b, 2)) {
        //This move wins this box
        movePrefs[a][b] += 30; //For now though lets just increment
        nextBox = 0;
    } else {
        if(board.big[bigSqCurr - 1].canBeWon(a, b, 1)) movePrefs[a][b] += 5; //Should multiply times opponents want of curr box
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
  int subtractNextBoxVal(int box, int turn) {
    int ret = 0;
    if(board.big[box - 1].canBeWon(turn) != null) {
        ret += 27; //We want to multiply by box value
    } else {
        //If they can get 2 in a row...
        //And other shit..
    }
    return ret;
  }
  void getRandomBox() {
    ArrayList<Integer> possibles = new ArrayList<Integer>();
    for(int i = 0; i < 9; i++) {
      if(board.big[i].state == 0) possibles.add(new Integer(i + 1));
    }
    bigSqCurr = possibles.get(floor(random(0, possibles.size())));
  }
  void makeMove(PVector p, int t) {
    board.big[bigSqCurr].makeMove((int)p.x, (int) (p.y), t);
  }
  void unMakeMove(PVector p) {
    board.big[bigSqCurr].unmakeMove((int) p.x, (int) (p.y));
  }
  void gameMakeMove(PVector p) {
    //stateChangedTo = 2;
    bigChanged = bigSqCurr;
    smallChanged = getSmallChanged((int) p.x, (int) p.y);
    ((smallestSquares) smalls.get(smallChanged - 1)).boxTaker();
    moved = true;
    thinking = false;
  }
  int quotient(int n, int d) {
   int ret = 0;
   while(d <= n) {
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
    boardbigSquares now = board.big[bigSqCurr-1];
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

