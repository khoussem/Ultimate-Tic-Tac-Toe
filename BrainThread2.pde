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
    //We start of our recursion here: 
    //this fills out bestX & bestY, and bestBox for freebees
    recursor(0, 0);
    if (startBSN != 0) bigSquarenow = startBSN; //Not sure if neccesary
    gameMakeMove(bestX, bestY); //Make the best move
    running = false;
  }
  //Caller function for the recursion to deal with freebie case
  int recursor(int depth, int rating) {
    String tabs = "";
    for (int i = 0; i < depth; i++) tabs += "\t";
    int bestmove = 0;
    //If we have a freebee, otherwise do a normal call
    if (bigSquarenow == 0) {
      //If board is won return the rating
      //Can only be won if the last box was taken... therefore its in here
      if(board.gameFinished() != 0) return rating; 
      // println(tabs + "Depth: " + depth);
      // println(tabs + "Big square now: " + bigSquarenow);
      if (depth % 2 == 0) {
        bestmove = -1000000000; //The retval... 
      }
      else {
        bestmove = 1000000000;
      }
      int bestBig = 0; //These three are only used if depth = 0
      int myBestX = 0;
      int myBestY = 0;
      //Loop through each possible big
      for (int tempBig = 1; tempBig < 10; tempBig++) {
        if (board.big[tempBig - 1].state != 0) continue; //Doesn't work if we use bigstate[tempBig]...
        //Can't figure out why, but anyways this works
        bigSquarenow = tempBig; //Make each possible big our current big
        int tempRating = rateTheBig(depth, rating); //And run our recursion on it...
        //if (depth == 0) println("Rating of the big: " + tempRating);
    
        //Now we store the value in bestmove to find the best big to play in
        //For min/max we see what our depth is (even or odd)
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
        //This is the move we cant to make, so set our bestX and bestY
        bestX = myBestX;
        bestY = myBestY;
      }
      bigSquarenow = bestBig;
    } 
    //If its not a freebie simply call rateTheBig and return what we get
    else bestmove = rateTheBig(depth, rating);
    //println(tabs + "Best move: " + bestMove);
    //println(tabs + "BestX " + bestX + " bestY " + bestY);
    return bestmove;
  }
  //This rates a position recursively
  //Called by recursor
  int rateTheBig(int depth, int rating) { 
    //If the last box was won (aka we have a freebee)
    //this can significantly affect the value of thep position rating so go deeper
    int depthInc = 0;
    if (lastWasWon && depth == DEPTHLIMIT) {
      depthInc++;
    }
    lastWasWon = false; //only used above so now we reset it
    DEPTHLIMIT += depthInc;
    //tabs is for debugging attractiveness
    //String tabs = "";
    //for (int i = 0; i < depth; i++) tabs += '\t';

    //Init bestMove so that any position will originally beat it
    int bestMove = 0;
    if (depth % 2 == 0) {
      bestMove = -1000000000; //We want to maximize so start at min
    }
    else {
      bestMove = 1000000000; //We want to minimize so start at max
    }
    //If we're too far just return...
    if (depth >= DEPTHLIMIT) {
      return rating;
    }
    //Now loop through each possible move
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        int Bsn = bigSquarenow; //Store for later reproduction
        //this is the positional rating of the position after the move is made
        int afterMoveRating = 0;
        //If move is illegal...
        if (!board.possibleMove(i, j, bigSquarenow)) {
          //Need not adjust retval for this case, just continue to next move
          continue;
        }
        //Otherwise lets make the move
        makeMove(new PVector(i, j), turn); 
        newBigBoxRating n = new newBigBoxRating(board, 1); //Init the position rating
        afterMoveRating = n.ratePosition(); //The rating after a move...  
        boolean keepGoing = false; //For pruning... 
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
        if (bigSquarenow == 0) lastWasWon = true; //lastWasWon is used for deepening search
        int r = afterMoveRating; //Make this bestMove

        if(depth <= 2) keepGoing = true; //To find non-optimal starting moves that end up
        //With great positions (akin to a sacrifice in chess)
        //If we should keep search then let us
        if (keepGoing) r = recursor(depth + 1, afterMoveRating);
        //Now reset the bigSquareNow
        bigSquarenow = Bsn;
        unMakeMove(new PVector(i, j), Bsn); //And unmake the move
        bigSquarenow = Bsn;
        //Appropriately set the bestMove
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
    if(depth == 0) { 
      println("Best move: " + bestMove);
      println("Best x, y: " + bestX + ", " + bestY);
    }
    return bestMove;
  }
  //Temporary make move
  void makeMove(PVector p, int t) {
    int temp = bigSquarenow; //Store the bsn
    bigChanged = bigSquarenow; //Set bigchanged, smallchanged
    smallChanged = getSmallChanged((int) p.x, (int) p.y);
    ((smallestSquares) smalls.get(smallChanged - 1)).boxTaker(); //this sets the smalls state
    //smalls are held in board too...
    //If we are sent to a taken box then we go back to original (this may be unnecessary and 
    //dealt with in boxTaker()
    if (bigstate[bigSquarenow] != 0) {
      bigSquarenow = temp;
    }
    //If we won the box make it be a freebie (also potentially unnecessary)
    if(bigstate[temp] != 0) {
      bigSquarenow = 0;
    }
  }
  void unMakeMove(PVector p, int bigNow) {
    bigChanged = bigNow;
    smallChanged = getSmallChanged((int) p.x, (int) p.y);
    ((smallestSquares) smalls.get(smallChanged - 1)).unTake(); //Deal with board.big.state in here
                                                               //And the small boxes state
    changeMade = false;
    turn = Utils.getOtherTurn(turn); 
    //Reset bigstate
    if (bigstate[bigNow] != 0) bigstate[bigNow] = 0;
  }
  void gameMakeMove(int x, int y) {
    //Basically the same as makeMove but we also set thinking to false and moved to true
    bigChanged = bigSquarenow;
    smallChanged = getSmallChanged(x, y);
    ((smallestSquares) smalls.get(smallChanged - 1)).boxTaker();
    moved = true;
    thinking = false;
  }
  //Vector form of the above
  void gameMakeMove(PVector p) {
    //stateChangedTo = 2;
    bigChanged = bigSquarenow;
    smallChanged = getSmallChanged((int) p.x, (int) p.y);
    thinking = false;
    ((smallestSquares) smalls.get(smallChanged - 1)).boxTaker();
    moved = true;
  }
  //Two helper functions...
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
}
