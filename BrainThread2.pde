//Recursive solutions are us
class BrainThread2 extends Thread {
  Board board = new Board();
  boolean running = false;
  int smallChanged; //THIS IS FOR MOVING THE BOARD....
  int bigChanged;
  int stateChangedTo;
  final int TURN = 2;
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
    bigSqCurr = BSN;
    running = true;
    //However, to explain, bored is a Board object that is updated 
    //in the main function, and is passed to BrainThread2 when BT2 is called
    //   maxCall(board, 0, 0, bigSquarenow, 0);
  } 
  public boolean running() {
    return running;
  }
  public void run() {
    println("Start");
    int depth = 0; //Our starting call for the depth of the recursion
    //Run our tree search in here
    //maxCall
    //Lets check if this box can be won
    if(bigSqCurr == 0) pickABig();
    PVector c = board.big[bigSqCurr - 1].canBeWon(TURN);
    if (c != null) {
      gameMakeMove(c);
      println("Non-rando");
    } else gameMakeMove(getRandomMove());
    running = false;
  }
  void makeMove(PVector p) {
    println("Move, x: " + p.x + " y: " + p.y);
    board.big[bigSqCurr].makeMove((int)p.x, (int) (3  * p.y));
  }
  void gameMakeMove(PVector p) {
    stateChangedTo = 2;
    bigChanged = bigSqCurr;
    smallChanged = getSmallChanged((int) p.x, (int) p.y);
    println(smallChanged);
    ((smallestSquares) smalls.get(smallChanged - 1)).boxTaker();

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
    println("A: " + a);
    println("B: " + b);
    println("Big: " + bigChanged);
   int ret = 1;
   ret += (3 * ((bigChanged + 2) % 3)) + a;
   println("X: " + ret);
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
  void pickABig() {
    int i = 0;
    for(i = 0; i < 9; i++) {
        if(board.big[i].state == 0) break;
    }
    bigSqCurr = i + 1;
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
      if (board.possibleMove(i, squareNow)) {
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
      if (board.possibleMove(i, squareNow)) {
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

