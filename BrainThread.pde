class BrainThread extends Thread
{
  //int [][] twoInarow = new int [][];
  //int [][] twoInarowOp = new int [][];
  int turnsDeeper;
  int x, y;
  int A, B;
  int gloBa, gloBb; //Global a and b
  int [] boxestoWin = new int[10];
  int originalTwoinaRow;
  int originalTwoinaRowOpp;
  int [] originalTwoinaRowOppB = new int [5]; //Change
  int [] originalTwoinaRowB = new int [5];
  boolean running;
  boolean twoEmpty;
  //Make the actual move in here as well
  //Not even passing any data, just using it globally :)
  float [][] movePref = new float [3][3];
  float [][] movePref2 = new float [3][3];
  float [] BigSquarePref = new float [10];
  float [] OppBigSquarePref= new float [10];
  int smallChangedTemp;     //All these temp values are for
  int bigChangedTemp;       //simulation, where we dont actually
  int stateChangedtoTemp;   //play the move, but pretend we do
  int tempTurn=0;
  int bigSquarenowTemp;
  int [] bigstateTemp = new int [10];
  int [] lastSquare = new int [5]; //Holds the big prior to the one first played
  biggerSquares [] big = new biggerSquares [10]; //Array of a big square object
  //bigstateTemp = bigstate;  
  bigBoxRating bbr = new bigBoxRating(BigSquarePref, OppBigSquarePref); 
  winPatterning winPat;
  bigObj [] small = new bigObj[10];
  BrainThread()
  {
    tempTurn = 2;
    //Here
  }
  void run() {
    for (int i=0;i<3;i++) {
      for (int j=0;j<3;j++) {
        movePref[i][j] = 5;
      }
    }
    for (int i=0; i<10; i++) {
      small[i] = new bigObj();
    }
    bigSquarenowTemp = bigSquarenow;
    lastSquare[0] = bigSquarenow;
    big[1] = big1;
    big[2] = big2;
    big[3] = big3;
    big[4] = big4;
    big[5] = big5;
    big[6] = big6;
    big[7] = big7;
    big[8] = big8;
    big[9] = big9;
    if (bigSquarenow != 0) {
      for (int i=0; i <3; i++) {
        for (int j=0; j<3; j++) {
          small[i*3+j+1].setl(i, j);
          small[i*3+j+1].state = big[bigSquarenow].boxes[i][j].state;
        }
      }
    }
    if (big[bigSquarenow].boxes[1][0].state == 0) {
      twoEmpty = true;
    } 
    else {
      twoEmpty = false;
    }
    //super.start();
    //println("A"); 
    ComputerMainBrain(); //Main function here
  }
  //X represents the states that the box should be
  //for you to be satisfied
  boolean possibleMove(int state)
  {
    if (state==0) return true;
    else return false;
  }
  void makeMove() {
    float a=-.01; //So that if it must be played, a zero move
    int x=0;      //will be played...
    int y=0;
    float p;
    for (int i=0; i<3; i++) {
      for (int j=0; j<3; j++) {
        //println(i+1+j*3+": "+movePref[i][j]);
        if (movePref[i][j] > a) {
          //finds the highest move pref and plays it
          a = movePref[i][j];
          x = i;
          y = j;
        }
        if (movePref[i][j] == a) {
          p = random(0, 4);
          if (p>=3) {
            x = i;
            y = j;
          }
        }
      }
    }
    bigObject(lastSquare[0]).boxes[x][y].state = 2;
    thinking = false;
    smallestSquares smally = (smallestSquares) smalls.get(big[lastSquare[0]].arrayNumtosmallSquare(x, y)-1);
    smally.boxTaker();
  }

  boolean giveFreebee(int depth) {
    //If no boxes have been won be looser?
    //Might want to rework this, im not sure
    for (int i=1; i<10; i++) {
      if (BigSquarePref[lastSquare[depth]] < OppBigSquarePref[i]) {
        if (big[i].numberofTwoinaRows(big[i].twoInarowBlank) != 0) {
          return false;
        }
      }
    }
    return true;
  }
  void rateMoveRecursiveOpp(int a, int b, int depth) {
    //Depth starts at 0
    //println(big[1].state);
    findTwoinaRows(bigSquarenowTemp);
    originalTwoinaRowB[depth] = big[bigSquarenowTemp].numberofTwoinaRows(big[bigSquarenowTemp].twoInarowBlank);
    originalTwoinaRowOppB[depth] = big[bigSquarenowTemp].numberofTwoinaRows(big[bigSquarenowTemp].twoInarowBlank);
    if (!possibleMove(big[bigSquarenowTemp].boxes[x][y].state))
    {
      movePref2[a][b] = -1; //3D Arrays huh?, nah...
    } 
    else {
      //Now were making the attempted move...
      lastSquare[depth] = bigSquarenowTemp;
      bigSquarenowTemp = littletoBig(big[bigSquarenowTemp].arrayNumtosmallSquare(a, b));
      big[bigSquarenowTemp].boxes[a][b].state = 1;
      if (big[lastSquare[depth]].winCheckXY(a, b) == 1) {
        //Dont know bout here yet
      }
      int twoInaRowsNow;
      int twoInaRowsNowOpp;
      findTwoinaRows(lastSquare[tempTurn]);
      twoInaRowsNow = big[lastSquare[tempTurn]].numberofTwoinaRows(big[lastSquare[0]].twoInarowBlank);
      findTwoinaRowsOpp(lastSquare[tempTurn]);
      twoInaRowsNowOpp = big[lastSquare[tempTurn]].numberofTwoinaRows(big[lastSquare[tempTurn]].twoInarowBlankOpp);
      if (twoInaRowsNow == originalTwoinaRowB[depth]-1 && twoInaRowsNow==0) {
        if (BigSquarePref[lastSquare[depth]] > BigSquarePref[lastSquare[0]]) {
          movePref[x][y] -= BigSquarePref[lastSquare[depth]]*.4;
        }
      }
      if (twoInaRowsNowOpp != originalTwoinaRowB[depth] && originalTwoinaRowB[depth]==0) {
        //They got a two in a row so,
        //ARBITRARY NUMBER
        if (OppBigSquarePref[lastSquare[depth]] >= 6) movePref[x][y] -= OppBigSquarePref[lastSquare[depth]]*.3; 
        if (BigSquarePref[lastSquare[depth]] > BigSquarePref[lastSquare[0]]) {
          movePref[x][y] -= BigSquarePref[lastSquare[0]]*.3;
        }
      }
      big[bigSquarenowTemp].boxes[a][b].state = 0;
    }
  }
  void rateMove(int a, int b) {
    x = a;
    y = b;
    //println("Move "+ (a+1+3*b));
    //Rates the move given based only patterns when run
    winPat = new winPatterning(big[bigSquarenowTemp], twoEmpty, small, lastSquare[0]);
    bbr.boxRating(big);
    //First rate the big boxes
    findTwoinaRows(lastSquare[0]);
    findTwoinaRowsOpp(lastSquare[0]);
    //We must compare if we started with two in a rows
    //and if we end with any, thus:
    originalTwoinaRow = big[lastSquare[0]].numberofTwoinaRows(big[lastSquare[0]].twoInarowBlank);
    originalTwoinaRowOpp = big[lastSquare[0]].numberofTwoinaRows(big[lastSquare[0]].twoInarowBlank);
    //println(originalTwoinaRow);
    biggerSquares bigTemp;
    //Well lets explain this huh? First we take the x,y and find
    //the smallersquare value(1-81), then we find what bigSquare it points to (not a pointer...)
    //then we fins the bigobject that correlates to 
    bigstateTemp = bigstate;
    //impossible moves
    //if(big[bigSquarenowTemp].boxes[x][y].state!=0) println(big[bigSquarenowTemp].boxes[x][y].state);
    if (!possibleMove(big[lastSquare[0]].boxes[x][y].state)) {
      movePref[x][y] = -1;
      //println(x+" "+y+" Not Possible");
    } 
    //Start of the real code for rating
    else {
      //println(x+" "+y+" Possible");
      //Once we know its possible, we will make that move in our
      //     "head"    //
      winPat.run(a, b, BigSquarePref, small);
      big[bigSquarenowTemp].boxes[x][y].state = tempTurn%2;
      bigSquarenowTemp = littletoBig(big[lastSquare[0]].arrayNumtosmallSquare(x, y));
      big[bigSquarenowTemp].stateFinder();
      if (big[bigSquarenowTemp].state!=0) bigSquarenowTemp = lastSquare[0]; 
      //if we send them to a full box they know what to
      //do...
      smallChangedTemp = big[lastSquare[0]].arrayNumtosmallSquare(x, y);
      //Find bigChangedtemp here-The box that small is in...
      bigChangedTemp = bigFinder(big[lastSquare[0]].arrayNumtosmallSquare(x, y));
      stateChangedtoTemp = big[lastSquare[0]].boxes[x][y].state; 
      //bigstateTemp[lastSquare[0]] = big[lastSquare].winCheck(); //sees if the move win has won a box
      for (int i=1; i<10; i++) {
        big[i].stateFinder();
      }
      //and then we check to
      //see if the opponenet can win in that box
      //START OF THE CODE, the rest is bs!
      if (checkOppWinnable(big[bigSquarenowTemp]) == 1)
      {
        //println("Opponent can win if sent here");
        //In here means the opponent can win if we send them here, so check if 
        //we care if they win, do we want the freebie etc...
        checkBoardWinnable(); //Doesnt return anything, changes boxestoWin
        //if we send them here they will win 
        if (boxestoWin[bigSquarenowTemp]==1) movePref[x][y] = 0; // negative is impossible
        //boxes to win is an array, the index is its square, the value means
        //who needs it to win
      }
      if (big[lastSquare[0]].winCheckXY(x, y) == 2) {
        //println("Box is won");
        //Check to see if we win first, so
        if (boardWon(bigstateTemp)==2) movePref[x][y] = 10; //maybe even just make move
        //from here
        if (giveFreebee(0)) {
          //println("Giving Freebee");
          //Might want to make the difference of bigSquarePrefs...
          movePref[x][y] += BigSquarePref[lastSquare[0]] * .65;
        }
        //So we can make something like a recursive call, or we can...
        //In here we decide whether to win the box or not 
        //if()
      }
      else {
        //println("Move testing");
        //now lets add this movepref to move our global movepref
        //println(x+1+3*y+" "+winPat.MovePref[x+1+3*y]);
        println(x+1+y*3+": "+winPat.MovePref[x+1+y*3]);
        movePref[x][y] += winPat.MovePref[x+1+3*y]; //Every time this function is run, a new
        //winpat is made which resets all the variables
        //Theres a new one for each move
        moveTester(); //If we dont win the box check this stuff
      }
    }
    //println(movePref[a][b]);
  }
  //Finds out if we bock the enemy, get 
  //two in a row, etc...
  void moveTester() {
    int twoInaRowsNow;
    int twoInaRowsNowOpp;
    findTwoinaRows(lastSquare[0]); //big[lastSquare[tempTurn]]
    twoInaRowsNow = big[lastSquare[0]].numberofTwoinaRows(big[lastSquare[0]].twoInarowBlank); //lastSquare[tempTurn]
    //println(twoInaRowsNow);
    //first lets see if we get two in a row
    //Dont need to do anything...Except send them somewhere bad?
    //this is worth more than just getting more of two in a row
    movePref[x][y] -= OppBigSquarePref[bigSquarenowTemp]*.35;
    //This code is temporary, will be replaced by recursion ^^
    if (twoInaRowsNow == originalTwoinaRow+1) {
      //println("Got 1 two in a row");
      //means we got one two in a row 
      if (originalTwoinaRow == 0) { 
        movePref[x][y] += BigSquarePref[lastSquare[tempTurn]]*.4;
        //this is worth more than just getting more of two in a row
      } 
      else {
        movePref[x][y] += BigSquarePref[lastSquare[tempTurn]]*.3;
      }
    }
    if (twoInaRowsNow == originalTwoinaRow+2) {
      if (originalTwoinaRow == 0) {
        movePref[x][y] += BigSquarePref[lastSquare[tempTurn]]*.5;
        //this is worth more than just getting more of two in a row
      } 
      //means we got two of two in a row with the
      //last move
    }
    findTwoinaRowsOpp(lastSquare[0]);
    twoInaRowsNowOpp = big[lastSquare[0]].numberofTwoinaRows(big[lastSquare[0]].twoInarowBlankOpp);
    //Next lets check if we blocked our opponent
    if (originalTwoinaRowOpp == 0) {
      //cant block our opponent since they have one
    }
    else if (originalTwoinaRowOpp >= 1) {
      if (twoInaRowsNowOpp == 0) {
        //println("Blocking Opponent");
        //we blocked them, now check opp box pref
        if (OppBigSquarePref[lastSquare[tempTurn]] > 5) {
          movePref[x][y]+= OppBigSquarePref[lastSquare[tempTurn]]*.4; //Change this value for more
          //accuracy
        } //no need to else, just leave it be
      }
    }
    //Now we call rate move recursively, checking
    //how much they like that box, if they can win
    //etc...
    tempTurn++;
    for (int i = 0; i<3; i++) {
      for (int j = 0; j<3; j++) {
        // rateMoveRecursiveOpp(i, j, tempTurn); //We have a seperate
      } //Rate move for tree depth!=0
    }
  }
  //Run inside a for loop, will find all the possible boxes that
  //will win the box, in those values, make sure there state is == 0,
  //else set them to negative. Use a fxn to find the x y coordinate...
  void findTwoinaRowsOpp(int bignum) {
    if (big[bignum].state != 0) {
      big[bignum].twoInarowBlankOpp[0] = -1;
      big[bignum].twoInarowBlankOpp[1] = -1;
      big[bignum].twoInarowBlankOpp[2] = -1;
      //The array value finds up to three two in a rows...
    }
    if (big[bignum].state == 0)
    {
      int i=0;
      //These ifs find out if you can win in one move...
      if (big[bignum].boxes[0][0].state == big[bignum].boxes[1][1].state &&
        big[bignum].boxes[2][2].state == 0 && big[bignum].boxes[0][0].state==1) { 
        big[bignum].twoInarowBlankOpp[i] = 2.2; 
        i++;
      }
      if (big[bignum].boxes[0][0].state == big[bignum].boxes[2][2].state &&
        big[bignum].boxes[1][1].state == 0 && big[bignum].boxes[0][0].state==1) {
        big[bignum].twoInarowBlankOpp[i] = 1.1; 
        i++;
      }
      if (big[bignum].boxes[1][1].state == big[bignum].boxes[2][2].state &&
        big[bignum].boxes[0][0].state == 0 && big[bignum].boxes[1][1].state==1) {
        big[bignum].twoInarowBlankOpp[i] = 0.0; 
        i++;
      }
      // // //
      if (big[bignum].boxes[2][0].state == big[bignum].boxes[1][1].state &&
        big[bignum].boxes[0][2].state == 0 && big[bignum].boxes[2][0].state==1) {
        big[bignum].twoInarowBlankOpp[i] = 0.2; 
        i++;
      } 
      if (big[bignum].boxes[2][0].state == big[bignum].boxes[0][2].state &&
        big[bignum].boxes[1][1].state == 0 && big[bignum].boxes[2][0].state==1) {
        big[bignum].twoInarowBlankOpp[i] = 1.1; 
        i++;
      }
      if (big[bignum].boxes[1][1].state == big[bignum].boxes[0][2].state &&
        big[bignum].boxes[2][0].state == 0 && big[bignum].boxes[1][1].state==1) {
        big[bignum].twoInarowBlankOpp[i] = 2.0; 
        i++;
      }
      //This for loop just checks if the box can be won
      //In one move for vertical and horizontal cases
      for (int k = 0; k<3; k++) {
        if (big[bignum].boxes[0][k].state == big[bignum].boxes[1][k].state &&
          big[bignum].boxes[2][k].state == 0 && big[bignum].boxes[0][k].state==1) { 
          big[bignum].twoInarowBlankOpp[i] = 2+.1*k; 
          i++;
        }
        if (big[bignum].boxes[k][0].state == big[bignum].boxes[k][1].state &&
          big[bignum].boxes[k][2].state == 0 && big[bignum].boxes[k][0].state==1) {
          big[bignum].twoInarowBlankOpp[i] = 1*k+.2; 
          i++;
        }
        if (big[bignum].boxes[0][k].state == big[bignum].boxes[2][k].state &&
          big[bignum].boxes[1][k].state == 0 && big[bignum].boxes[0][k].state==1) {
          big[bignum].twoInarowBlankOpp[i] = 1+.1*k; 
          i++;
        }
        if (big[bignum].boxes[k][0].state == big[bignum].boxes[k][2].state &&
          big[bignum].boxes[k][1].state == 0 && big[bignum].boxes[k][0].state==1) {
          big[bignum].twoInarowBlankOpp[i] = 1*k+.1; 
          i++;
        }
        if (big[bignum].boxes[1][k].state == big[bignum].boxes[2][k].state &&
          big[bignum].boxes[0][k].state == 0 && big[bignum].boxes[2][k].state==1) {
          big[bignum].twoInarowBlankOpp[i] = 0 +.1*k; 
          i++;
        }
        if (big[bignum].boxes[k][1].state == big[bignum].boxes[k][2].state &&
          big[bignum].boxes[k][0].state == 0 && big[bignum].boxes[k][1].state==1) {
          big[bignum].twoInarowBlankOpp[i] = 1*k+0.0; 
          i++;
        }
      }
    }
  }
  void findTwoinaRows(int Bignum) {
    if (big[Bignum].state != 0) {
      big[Bignum].twoInarowBlank[0] = -1;
      big[Bignum].twoInarowBlank[1] = -1;
      big[Bignum].twoInarowBlank[2] = -1;
      //The array value finds up to three two in a rows...
    }
    if (big[Bignum].state == 0)
    {
      int i=0;
      //These ifs find out if you can win in one move...
      if (big[Bignum].boxes[0][0].state == big[Bignum].boxes[1][1].state &&
        big[Bignum].boxes[2][2].state == 0 && big[Bignum].boxes[0][0].state==2) { 
        big[Bignum].twoInarowBlank[i] = 2.2; //This value represents 2, 2
        i++;
      }
      if (big[Bignum].boxes[0][0].state == big[Bignum].boxes[2][2].state &&
        big[Bignum].boxes[1][1].state == 0&& big[Bignum].boxes[0][0].state==2) {
        big[Bignum].twoInarowBlank[i] = 1.1; 
        i++;
      }
      if (big[Bignum].boxes[1][1].state == big[Bignum].boxes[2][2].state &&
        big[Bignum].boxes[0][0].state == 0 && big[Bignum].boxes[1][1].state==2) {
        big[Bignum].twoInarowBlank[i] = 0.0; 
        i++;
      }
      // // //
      if (big[Bignum].boxes[2][0].state == big[Bignum].boxes[1][1].state &&
        big[Bignum].boxes[0][2].state == 0 && big[Bignum].boxes[2][0].state==2) {
        big[Bignum].twoInarowBlank[i] = 0.2; 
        i++;
      } 
      if (big[Bignum].boxes[2][0].state == big[Bignum].boxes[0][2].state &&
        big[Bignum].boxes[1][1].state == 0 && big[Bignum].boxes[2][0].state==2) {
        big[Bignum].twoInarowBlank[i] = 1.1; 
        i++;
      }
      if (big[Bignum].boxes[1][1].state == big[Bignum].boxes[0][2].state &&
        big[Bignum].boxes[2][0].state == 0 && big[Bignum].boxes[1][1].state==2) {
        big[Bignum].twoInarowBlank[i] = 2.0; 
        i++;
      }
      //This for loop just checks if the box can be won
      //In one move for vertical and horizontal cases
      for (int k = 0; k<3; k++) {
        if (big[Bignum].boxes[0][k].state == big[Bignum].boxes[1][k].state &&
          big[Bignum].boxes[2][k].state == 0 && big[Bignum].boxes[0][k].state==2) { 
          big[Bignum].twoInarowBlank[i] = 2+.1*k; 
          i++;
        }
        if (big[Bignum].boxes[k][0].state == big[Bignum].boxes[k][1].state &&
          big[Bignum].boxes[k][2].state == 0 && big[Bignum].boxes[k][0].state==2) {
          big[Bignum].twoInarowBlank[i] = 1*k+.2; 
          i++;
        }
        if (big[Bignum].boxes[0][k].state == big[Bignum].boxes[2][k].state &&
          big[Bignum].boxes[1][k].state == 0 && big[Bignum].boxes[0][k].state==2) {
          big[Bignum].twoInarowBlank[i] = 1+.1*k; 
          i++;
        }
        if (big[Bignum].boxes[k][0].state == big[Bignum].boxes[k][2].state &&
          big[Bignum].boxes[k][1].state == 0 && big[Bignum].boxes[k][0].state==2) {
          big[Bignum].twoInarowBlank[i] = 1*k+.1; 
          i++;
        }
        if (big[Bignum].boxes[1][k].state == big[Bignum].boxes[2][k].state &&
          big[Bignum].boxes[0][k].state == 0 && big[Bignum].boxes[2][k].state==2) {
          big[Bignum].twoInarowBlank[i] = 0 +.1*k; 
          i++;
        }
        if (big[Bignum].boxes[k][1].state == big[Bignum].boxes[k][2].state &&
          big[Bignum].boxes[k][0].state == 0 && big[Bignum].boxes[k][1].state==2) {
          big[Bignum].twoInarowBlank[i] = 1*k+0.0; 
          i++;
        }
      }
      for (int q=0; q<3; q++) {
        if (big[Bignum].twoInarowBlank[q] != -1) {
          //println(q+": "+big[Bignum].twoInarowBlank[q]);
        }
      }
    }
  }
  //finds the state the first two in a row,
  //should make it parse for more than one 
  //two in a row
  int checkOppWinnable(biggerSquares big1)
  {
    //if the box we are sending them to hasnt been won
    //can they win?
    if (bigstate[littletoBig(smallChangedTemp)] != 0) {
      return checkOppWinnable(big[lastSquare[tempTurn]]);
    }
    if (bigstate[littletoBig(smallChangedTemp)] == 0)
    {
      //These ifs find out if you can win in one move...
      if (big1.boxes[0][0].state == big1.boxes[1][1].state &&
        big1.boxes[2][2].state == 0) return big1.boxes[0][0].state;
      if (big1.boxes[0][0].state == big1.boxes[2][2].state &&
        big1.boxes[1][1].state == 0) return big1.boxes[0][0].state;
      if (big1.boxes[1][1].state == big1.boxes[2][2].state &&
        big1.boxes[0][0].state == 0) return big1.boxes[2][2].state;
      // // //
      if (big1.boxes[2][0].state == big1.boxes[1][1].state &&
        big1.boxes[0][2].state == 0) return big1.boxes[2][0].state;
      if (big1.boxes[2][0].state == big1.boxes[0][2].state &&
        big1.boxes[1][1].state == 0) return big1.boxes[0][2].state;
      if (big1.boxes[1][1].state == big1.boxes[0][2].state &&
        big1.boxes[2][0].state == 0) return big1.boxes[0][2].state;
      //This for loop just checks if the box can be won
      //In one move for vertical and horizontal cases
      for (int k = 0; k<3; k++) {
        if (big1.boxes[0][k].state == big1.boxes[1][k].state &&
          big1.boxes[2][k].state == 0) return big1.boxes[1][k].state;
        if (big1.boxes[k][0].state == big1.boxes[k][1].state &&
          big1.boxes[k][2].state == 0) return big1.boxes[k][1].state;
        if (big1.boxes[0][k].state == big1.boxes[2][k].state &&
          big1.boxes[1][k].state == 0) return big1.boxes[0][k].state;
        if (big1.boxes[k][0].state == big1.boxes[k][2].state &&
          big1.boxes[k][1].state == 0) return big1.boxes[k][2].state;
        if (big1.boxes[1][k].state == big1.boxes[2][k].state &&
          big1.boxes[0][k].state == 0) return big1.boxes[1][k].state;
        if (big1.boxes[k][1].state == big1.boxes[k][2].state &&
          big1.boxes[k][0].state == 0) return big1.boxes[k][1].state;
      }
      return 0; //Means that it can't be won, but is still
      //Playable
    }
    return -1; //Means that the box it sends you to
    //is dud and they stay in same box
  }
  void checkBoardWinnable()
  {
    //updates the array bigwinable
    for (int i=1; i<10; i+=3) //Horizontal cases of winable
    { 
      if (bigstate[i] == bigstate[i+1] && bigstate[i+2]==0) boxestoWin[i+2] = bigstate[i+2];
      if (bigstate[i] == bigstate[i+2] && bigstate[i+1]==0) boxestoWin[i+1] = bigstate[i+1];
      if (bigstate[i+1] == bigstate[i+2] && bigstate[i]==0) boxestoWin[i] = bigstate[i];
    }
    for (int i=1; i<4;i++)
    {
      if (bigstate[i] == bigstate[i+3] && bigstate[i+6]==0) boxestoWin[i+6] = bigstate[i+6];
      if (bigstate[i] == bigstate[i+6] && bigstate[i+3]==0) boxestoWin[i+3] = bigstate[i+3];
      if (bigstate[i+6] == bigstate[i+3] && bigstate[i]==0) boxestoWin[i] = bigstate[i];
    }
    if (bigstate[1] == bigstate[4] && bigstate[9] == 0) boxestoWin[9] = bigstate[9];
    if (bigstate[1] == bigstate[9] && bigstate[4] == 0) boxestoWin[4] = bigstate[4];
    if (bigstate[9] == bigstate[4] && bigstate[1] == 0) boxestoWin[1] = bigstate[1];
    //Flip diagonals
    if (bigstate[3] == bigstate[5] && bigstate[7] == 0) boxestoWin[7] = bigstate[7];
    if (bigstate[7] == bigstate[3] && bigstate[5] == 0) boxestoWin[5] = bigstate[5];
    if (bigstate[7] == bigstate[5] && bigstate[3] == 0) boxestoWin[3] = bigstate[3];
  }


  void ComputerMainBrain() 
  {
    //add
    //println("A");
    if (difficulty == 2 || difficulty == 3) {
      //Add easy in here too, change a value for 
      //the random factor
      while (thinking == true) {
        if (bigSquarenow != 0) {
          for (int i=0; i<3; i++)
          {
            for (int j=0; j<3; j++)
            {
              //DUHHH RESET SHIT
              tempTurn = 0;
              rateMove(i, j);
            }
          }
          makeMove();
        } 
        else {
          bbr.boxRating(big);
          //Freebee code here...
        }
      }
    }
    if (difficulty == 1) {
      while (thinking == true) {
        while (bigSquarenowTemp == 0) {
          bigSquarenowTemp = floor(random(1, 9));
          big[bigSquarenowTemp].stateFinder();
          if (big[bigSquarenowTemp].state!=0) bigSquarenowTemp = 0;
        }
        A = floor(random(3));
        B = floor(random(3));
        if (possibleMove(big[bigSquarenowTemp].boxes[A][B].state) &&
          possibleMove(big[bigSquarenowTemp].boxes[A][B].state)) 
        {
          //Keep this code, its elligible for something or other, and
          //also contains how to make the move
          //println(big[bigSquarenowTemp].arrayNumtosmallSquare(A, B));
          thinking = false;
          smallestSquares smally = (smallestSquares) smalls.get(big[bigSquarenowTemp].arrayNumtosmallSquare(A, B)-1);
          //smally.computerReturn = true;
          // println("Small: "+smally.smallsquare);
          smally.boxTaker();
        }
      }
    }
  }
}

