class winPatterning
{
  //For this we are saying 
  ///////////
  //1  2  3//
  //4  5  6//
  //7  8  9//
  ///////////
  //These are patterns for the smaller box that we pass it'
  boolean firstTime; //used in finding two in a rows
  float [] bigSquarePref = new float [10];
  biggerSquares big;
  bigObj smalls = new bigObj();
  bigObj [] small = new bigObj [10];
  boolean [][] twoTrue = new boolean [3][3];
  boolean twoEmpty;
  int bigNow;
  int smallnum;
  //We add this value to the global movePref
  float [] MovePref = new float [10]; //Will start at 0...that is the value btw, index starts at 1
  int patterns[][] = new int [10][5]; //holds which patterns the box uses...0 means none
  int patternsThem[][] = new int [10][4];
  int [] numberofPatterns = new int[10]; //the index is the boxnum
  int [] numberofPatternsThem = new int [10];
  int [] winPatternsthem = new int[10];
  int [] winPatternsme = new int[10]; //what does its pointer hold versus its actual data?
  // winPatternsme-1 is horizontal, 4 is horizontal, 7 is horizontal, 2 is down, 3 is down,
  //5 is first collumn down, 6 is left to right diagonal (going up), 9 is right to left.
  winPatterning(biggerSquares Big, boolean twoE, bigObj [] Small, int BigNow) 
  {
    bigNow = BigNow;
    twoEmpty = twoE;
    small = Small;
    //Creating our faux smaller squares
    /*for (int i=0;i<10;i++) {
     small[i] = new bigObj();
     }
     //and giving them their x and y's
     for (int i=0; i <3; i++) {
     for (int j=0; j<3; j++) {
     small[i*3+j+1].setl(i, j);
     }
     }*/
    //
    big = Big;
  }
  //Keep in mind this rates the smallest squares...
  void rater(float [] MovePref, biggerSquares big, int a, int b) {
    int i = a+1+3*b; // transfers from xy notation to 1-9 notation
    //That allows for this function to be use with both
    //me and opponent
    int j = 0;
    switch(numberofPatterns[a+1+3*b]) {
      //First we switched based on how many patterns
    case 0:
      //0 is obvious, cant win with this square...
      MovePref[a+1+3*b] -= .4 * bigSquarePref[bigNow];
      break;
    case 1:
      while (j==0) {
        if (patterns[i][j] != 0) {
          //Then we switch for each individual pattern the box has
          //so we will run for as many patterns it has...
          switch(winPatternsme[patterns[i][j]]) {
          case 0:
            MovePref[a+1+3*b] -= .4 * bigSquarePref[bigNow];
            break;
          case 1:
            MovePref[a+1+3*b] += .05 * bigSquarePref[bigNow];
            break;
          case 2:
            MovePref[a+1+3*b] += .1 * bigSquarePref[bigNow];
            break;
          case 6:
            MovePref[a+1+3*b] += .3 * bigSquarePref[bigNow];
            //This means two in a row, duh...
            break;
          }
        }
        j++;
      }
      break;
    case 2:
      while (j<2) {
        if (patterns[i][j] != 0) {
          if (winPatternsme[patterns[i][j]] == 0) {
            MovePref[a+1+3*b] -= .2 * bigSquarePref[bigNow];
          }
          else if (winPatternsme[patterns[i][j]] == 1) {
            MovePref[a+1+3*b] += .05 * bigSquarePref[bigNow];
          }
          else if (winPatternsme[patterns[i][j]] == 2) {
            MovePref[a+1+3*b] += .1 * bigSquarePref[bigNow];
          }
          else if (winPatternsme[patterns[i][j]] == 6) {
            //We only want to change this once if there's a two in a row
            //because it doesnt matter if we have two two in a rows to one
            //square
            if (firstTime) MovePref[a+1+3*b] += .3 * bigSquarePref[bigNow];
            firstTime = false;
          }
        }
        j++;
      }
      break;
    case 3:
      while (j<3) {
        if (patterns[i][j] != 0) {
          switch(winPatternsme[patterns[i][j]]) {
          case 0:
            MovePref[a+1+3*b] -= .133 * bigSquarePref[bigNow];
            break;
          case 1:
            MovePref[a+1+3*b] += .05 * bigSquarePref[bigNow];
            break;
          case 2:
            MovePref[a+1+3*b] += .1 * bigSquarePref[bigNow];    
            break;
          case 6:
            if (firstTime) MovePref[a+1+3*b] += .3 * bigSquarePref[bigNow];
            firstTime = false;
            break;
          }
        }
        j++;
      }
      break;
    case 4:
      while (j<4) {
        if (patterns[i][j] != 0) {
          switch(winPatternsme[patterns[i][j]]) {
          case 0: //In fact, 0 should never happen as it will just go down
            //in numberofpatterns...ahhhhh
            MovePref[a+1+3*b] -= .1 * bigSquarePref[bigNow];
            break;
          case 1:
            MovePref[a+1+3*b] += .05 * bigSquarePref[bigNow];
            break;
          case 2:
            MovePref[a+1+3*b] += .1 * bigSquarePref[bigNow];
            break;
          case 6:
            if (firstTime) MovePref[a+1+3*b] += .3 * bigSquarePref[bigNow];
            firstTime = false;
            break;
          }
        }
        j++;
      }
      break;
    }
  }
  //Use a and b to represent x and y
  void run(int a, int b, float [] BigSquarePref, bigObj [] small) {
    bigSquarePref = BigSquarePref;
    //bigObjCreator(); //makes the objects bigObj
    findTwoinaRows(big);
    //first we find the possible ways the box can be won from each square
    //Then we find how likely that is and base how much we want it
    //on that...The same as for the biggersquares...
    for (int i=1;i<10;i++) {
      winPatterns(small, i, 2);
    }
    for (int i=1;i<10;i++) {
      smallNumtoPatterns(i, patterns);
    }
    //Creates patterns[i][j]
    patternsToboxReview(winPatternsme, numberofPatterns);
    for (int i=0; i<3; i++) {
      for (int p=0; p<3; p++) {
        if (big.winCheckXY(i, p) == 2) twoTrue[i][p] = true;
      }
    }
    rater(MovePref, big, a, b);
  }
  //implement only once in the run
  int xytoNum(int x, int y) {
    //Simply switching notations
    return (x+1)+(y*3);
  }
  int smalltoX(int smallnum) {
    if (smallnum == 3 || smallnum==6
      || smallnum==9) return 2;
    if (smallnum == 2 || smallnum==5
      || smallnum==8) return 1;
    else return 0;
  }
  int smalltoY(int smallnum) {
    if (smallnum == 7 || smallnum==8
      || smallnum==9) return 2;
    if (smallnum == 4 || smallnum==5
      || smallnum==6) return 1;
    else return 0;
  }

  void patternsToboxReview(int [] winPatternsme, int [] numberofPatterns) {
    if (winPatternsme[5] >= 1) {
      numberofPatterns[1]++;
      numberofPatterns[4]++;
      numberofPatterns[7]++;
    } 
    else {
      numberofPatterns[1]--;
      numberofPatterns[4]--;
      numberofPatterns[7]--;
    }
    if (winPatternsme[2] >= 1) {
      numberofPatterns[2]++;
      numberofPatterns[5]++;
      numberofPatterns[8]++;
    } 
    else {
      numberofPatterns[2]--;
      numberofPatterns[5]--;
      numberofPatterns[8]--;
    }
    if (winPatternsme[3] >= 1) {
      numberofPatterns[3]++;
      numberofPatterns[6]++;
      numberofPatterns[9]++;
    } 
    else {
      numberofPatterns[3]--;
      numberofPatterns[6]--;
      numberofPatterns[9]--;
    }
    //horizontals are done
    if (winPatternsme[1] >= 1) {
      numberofPatterns[1]++;
      numberofPatterns[2]++;
      numberofPatterns[3]++;
    } 
    else {
      numberofPatterns[1]--;
      numberofPatterns[2]--;
      numberofPatterns[3]--;
    }
    if (winPatternsme[4] >= 1) {
      numberofPatterns[4]++;
      numberofPatterns[5]++;
      numberofPatterns[6]++;
    } 
    else {
      numberofPatterns[4]--;
      numberofPatterns[5]--;
      numberofPatterns[6]--;
    }
    if (winPatternsme[7] >= 1) {
      numberofPatterns[7]++;
      numberofPatterns[8]++;
      numberofPatterns[9]++;
    } 
    else {
      numberofPatterns[7]--;
      numberofPatterns[8]--;
      numberofPatterns[9]--;
    }
    //verticals are done
    if (winPatternsme[9] >= 1) {
      numberofPatterns[1]++;
      numberofPatterns[5]++;
      numberofPatterns[9]++;
    } 
    else {
      numberofPatterns[1]--;
      numberofPatterns[5]--;
      numberofPatterns[9]--;
    }
    if (winPatternsme[6] >= 1) {
      numberofPatterns[3]++;
      numberofPatterns[5]++;
      numberofPatterns[7]++;
    } 
    else {
      numberofPatterns[3]--;
      numberofPatterns[5]--;
      numberofPatterns[7]--;
    }
    //diagonals are done
  }
  //Functions for switching back...
  void smallNumtoPatterns(int smallnum, int [][] patterns) {
    //Creates the patterns here, value will be changed to -1 
    //if not possible anymore
    switch (smallnum) {
    case 1:  
      patterns[1][0] = 1;
      patterns[1][1] = 5;
      patterns[1][2] = 9;
      patterns[1][3] = 0;
    case 2:  
      patterns[2][0] = 2;
      patterns[2][1] = 1;
      patterns[2][2] = 0;
      patterns[2][3] = 0;
    case 3:  
      patterns[3][0] = 3;
      patterns[3][1] = 1;
      patterns[3][2] = 6;
      patterns[3][3] = 0;
    case 4:  
      patterns[4][0] = 5;
      patterns[4][1] = 4;
      patterns[4][2] = 0;
      patterns[4][3] = 0;
    case 5:  
      patterns[5][0] = 2;
      patterns[5][1] = 4;
      patterns[5][2] = 9;
      patterns[5][3] = 6;
    case 6:  
      patterns[6][0] = 3;
      patterns[6][1] = 4;
      patterns[6][2] = 0;
      patterns[6][3] = 0;
    case 7:  
      patterns[7][0] = 5;
      patterns[7][1] = 7;
      patterns[7][2] = 6;
      patterns[7][3] = 0;
    case 8:  
      patterns[8][0] = 2;
      patterns[8][1] = 7;
      patterns[8][2] = 0;
      patterns[8][3] = 0;
    default: 
      patterns[9][0] = 3;
      patterns[9][1] = 7;
      patterns[9][2] = 9;
      patterns[9][3] = 0;
    }
  }
  //Here its actually represented as smallSq
  //But i dont feel like changing it each time
  //copy and pasted code...
  void winPatterns(bigObj [] big, int bigSq, int x) {
    int y;
    if (x == 1)  y = 2; //Y is the other state...
    else y = 1;
    //Diagonal checking~ ~ ~
    if (bigSq == 1) {
      int bigHolder = 9;
      if (big[bigSq].state == x) {
        if ((big[bigSq+4].state == x && big[bigSq+8].state == 0) || 
          (big[bigSq+4].state == 0 && big[bigSq+8].state == x)) {
          winPatternsme[bigHolder] = 6;
          //six means one box away from victory...
        }
        else if (big[bigSq+4].state == 0 && big[bigSq+8].state == 0) {
          winPatternsme[bigHolder] = 2;
          //two means you have one box
        }
        else if (big[bigSq+4].state == y || big[bigSq+8].state == y) {
          winPatternsme[bigHolder] = 0;
          //zero means one of the other boxes is owned
          //by the enemt
        }
      } 
      else if (big[bigSq].state == y) {
        if ((big[bigSq+4].state == y && big[bigSq+8].state == 0) || 
          (big[bigSq+4].state == 0 && big[bigSq+8].state == y)) {
          winPatternsthem[bigHolder] = 6;
        }
        else if (big[bigSq+4].state == 0 && big[bigSq+8].state == 0) {
          winPatternsthem[bigHolder] = 2;
        }
        else if (big[bigSq+4].state == x || big[bigSq+8].state == x) {
          winPatternsthem[bigHolder] = 0;
        }
      }
      else if (big[bigSq+4].state == 0 && big[bigSq+8].state == 0) {
        winPatternsme[bigHolder] = 1;
        winPatternsthem[bigHolder] = 1;
      }
    }
    //next
    if (bigSq == 5) {
      int bigHolder = 9;
      if (big[bigSq].state == x) {
        if ((big[bigSq+4].state == x && big[bigSq-4].state == 0) || 
          (big[bigSq+4].state == 0 && big[bigSq-4].state == x)) {
          winPatternsme[bigHolder] = 6;
        }
        else if (big[bigSq+4].state == 0 && big[bigSq-4].state == 0) {
          winPatternsme[bigHolder] = 2;
        }
        else if (big[bigSq+4].state == y || big[bigSq-4].state == y) {
          winPatternsme[bigHolder] = 0;
        }
      } 
      else if (big[bigSq].state == y) {
        if ((big[bigSq+4].state == y && big[bigSq-4].state == 0) || 
          (big[bigSq+4].state == 0 && big[bigSq-4].state == y)) {
          winPatternsthem[bigHolder] = 6;
        }
        else if (big[bigSq+4].state == 0 && big[bigSq-4].state == 0) {
          winPatternsthem[bigHolder] = 2;
        }
        else if (big[bigSq+4].state == x || big[bigSq-4].state == x) {
          winPatternsthem[bigHolder] = 0;
        }
      } 
      else if (big[bigSq+4].state == 0 && big[bigSq-4].state == 0) {
        winPatternsthem[bigHolder] = 1;
        winPatternsme[bigHolder] = 1;
      }
    }
    //next
    if (bigSq == 9) {
      int bigHolder = 9;
      if (big[bigSq].state == x) {
        if ((big[bigSq-8].state == x && big[bigSq-4].state == 0) || 
          (big[bigSq-8].state == 0 && big[bigSq-4].state == x)) {
          winPatternsme[bigHolder] = 6;
        }
        else if (big[bigSq-8].state == 0 && big[bigSq-4].state == 0) {
          winPatternsme[bigHolder] = 2;
        }
        else if (big[bigSq-8].state == y || big[bigSq-4].state == y) {
          winPatternsme[bigHolder] = 0;
        }
      } 
      else if (big[bigSq].state == y) {
        if ((big[bigSq-8].state == y && big[bigSq-4].state == 0) || 
          (big[bigSq-8].state == 0 && big[bigSq-4].state == y)) {
          winPatternsthem[bigHolder] = 6;
        }
        else if (big[bigSq-8].state == 0 && big[bigSq-4].state == 0) {
          winPatternsthem[bigHolder] = 2;
        }
        else if (big[bigSq-8].state == x || big[bigSq-4].state == x) {
          winPatternsthem[bigHolder] = 0;
        }
      }
      else if (big[bigSq-8].state == 0 && big[bigSq-4].state == 0) {
        winPatternsme[bigHolder] = 1;
        winPatternsthem[bigHolder] = 1;
      }
    } 
    // next
    if (bigSq == 3) {
      int bigHolder = 6;
      if (big[bigSq].state == x) {
        if ((big[bigSq+4].state == x && big[bigSq+2].state == 0) || 
          (big[bigSq+4].state == 0 && big[bigSq+2].state == x)) {
          winPatternsme[bigHolder] = 6;
        }
        else if (big[bigSq+4].state == 0 && big[bigSq+2].state == 0) {
          winPatternsme[bigHolder] = 2;
        }
        else if (big[bigSq+4].state == y || big[bigSq+2].state == y) {
          winPatternsme[bigHolder] = 0;
        }
      } 
      else if (big[bigSq].state == y) {
        if ((big[bigSq+4].state == y && big[bigSq+2].state == 0) || 
          (big[bigSq+4].state == 0 && big[bigSq+2].state == y)) {
          winPatternsthem[bigHolder] = 6;
        }
        else if (big[bigSq+4].state == 0 && big[bigSq+2].state == 0) {
          winPatternsthem[bigHolder] = 2;
        }
        else if (big[bigSq+4].state == x || big[bigSq+2].state == x) {
          winPatternsthem[bigHolder] = 0;
        }
      }
      else if (big[bigSq+4].state == 0 && big[bigSq+2].state == 0) {
        winPatternsme[bigHolder] = 1;
        winPatternsthem[bigHolder] = 1;
      }
    }
    //next
    //This is good
    if (bigSq == 5) {
      int bigHolder = 6;
      if (big[bigSq].state == x) {
        if ((big[bigSq+2].state == x && big[bigSq-2].state == 0) || 
          (big[bigSq+2].state == 0 && big[bigSq-2].state == x)) {
          winPatternsme[bigHolder] = 6;
        }
        else if (big[bigSq+2].state == 0 && big[bigSq-2].state == 0) {
          winPatternsme[bigHolder] = 2;
        }
        else if (big[bigSq+2].state == y || big[bigSq-2].state == y) {
          winPatternsme[bigHolder] = 0;
        }
      } 
      else if (big[bigSq].state == y) {
        if ((big[bigSq+2].state == y && big[bigSq-2].state == 0) || 
          (big[bigSq+2].state == 0 && big[bigSq-2].state == y)) {
          winPatternsthem[bigHolder] = 6;
        }
        else if (big[bigSq+2].state == 0 && big[bigSq-2].state == 0) {
          winPatternsthem[bigHolder] = 2;
        }
        else if (big[bigSq+2].state == x || big[bigSq-2].state == x) {
          winPatternsthem[bigHolder] = 0;
        }
      } 
      else if (big[bigSq-2].state == 0 && big[bigSq+2].state == 0) {
        winPatternsthem[bigHolder] = 1;
        winPatternsme[bigHolder] = 1;
      }
    }
    //next
    if (bigSq == 7) {
      int bigHolder = 6;
      if (big[bigSq].state == x) {
        if ((big[bigSq-2].state == x && big[bigSq-4].state == 0) || 
          (big[bigSq-2].state == 0 && big[bigSq-4].state == x)) {
          winPatternsme[bigHolder] = 6;
        }
        else if (big[bigSq-2].state == 0 && big[bigSq-4].state == 0) {
          winPatternsme[bigHolder] = 2;
        }
        else if (big[bigSq-2].state == y || big[bigSq-4].state == y) {
          winPatternsme[bigHolder] = 0;
        }
      } 
      else if (big[bigSq].state == y) {
        if ((big[bigSq-2].state == y && big[bigSq-4].state == 0) || 
          (big[bigSq-2].state == 0 && big[bigSq-4].state == y)) {
          winPatternsthem[bigHolder] = 6;
        }
        else if (big[bigSq-2].state == 0 && big[bigSq-4].state == 0) {
          winPatternsthem[bigHolder] = 2;
        }
        else if (big[bigSq-2].state == x || big[bigSq-4].state == x) {
          winPatternsthem[bigHolder] = 0;
        }
      }
      else if (big[bigSq-2].state == 0 && big[bigSq-4].state == 0) {
        winPatternsme[bigHolder] = 1;
        winPatternsthem[bigHolder] = 1;
      }
    }
    //verticals
    if (bigSq == 1 || bigSq == 2 || bigSq == 3) {
      int bigHolder;
      if (bigSq == 1) bigHolder = 5;
      else bigHolder = bigSq;
      if (big[bigSq].state == x) {
        if ((big[bigSq+3].state == x && big[bigSq+6].state == 0) || 
          (big[bigSq+3].state == 0 && big[bigSq+6].state == x)) {
          winPatternsme[bigHolder] = 6;
        }
        else if (big[bigSq+3].state == 0 && big[bigSq+6].state == 0) {
          winPatternsme[bigHolder] = 2;
        }
        else if (big[bigSq+3].state == y || big[bigSq+6].state == y) {
          winPatternsme[bigHolder] = 0;
        }
      }
      else if (big[bigSq].state == y) {
        if ((big[bigSq+3].state == y && big[bigSq+6].state == 0) || 
          (big[bigSq+3].state == 0 && big[bigSq+6].state == y)) {
          winPatternsthem[bigHolder] = 6;
        }
        else if (big[bigSq+3].state == 0 && big[bigSq+6].state == 0) {
          winPatternsthem[bigHolder] = 2;
        }
        else if (big[bigSq+3].state == x || big[bigSq+6].state == x) {
          winPatternsthem[bigHolder] = 0;
        }
      }
      else if (big[bigSq+3].state == 0 && big[bigSq+6].state == 0) {
        winPatternsme[bigHolder] = 1;
        winPatternsthem[bigHolder] = 1;
      }
    }
    //Next 3 vertical
    if (bigSq == 4 || bigSq == 5 || bigSq == 6) {
      int bigHolder;
      if (bigSq == 4) bigHolder = 5;
      else bigHolder = bigSq-3;
      if (big[bigSq].state == x) {
        if ((big[bigSq+3].state == x && big[bigSq-3].state == 0) || 
          (big[bigSq+3].state == 0 && big[bigSq-3].state == x)) {
          winPatternsme[bigHolder] = 6;
        }
        else if (big[bigSq+3].state == 0 && big[bigSq-3].state == 0) {
          winPatternsme[bigHolder] = 2;
        }
        else if (big[bigSq+3].state == y || big[bigSq-3].state == y) {
          winPatternsme[bigHolder] = 0;
        }
      }
      else if (big[bigSq].state == y) {
        if ((big[bigSq+3].state == y && big[bigSq-3].state == 0) || 
          (big[bigSq+3].state == 0 && big[bigSq-3].state == y)) {
          winPatternsthem[bigHolder] = 6;
        }
        else if (big[bigSq+3].state == 0 && big[bigSq-3].state == 0) {
          winPatternsthem[bigHolder] = 2;
        }
        else if (big[bigSq+3].state == x || big[bigSq-3].state == x) {
          winPatternsthem[bigHolder] = 0;
        }
      }
      else if (big[bigSq+3].state == 0 && big[bigSq-3].state == 0) {
        winPatternsthem[bigHolder] = 1;
        winPatternsme[bigHolder] = 1;
      }
    }
    if (bigSq == 7 || bigSq == 8 || bigSq == 9) {
      int bigHolder;
      if (bigSq == 7) bigHolder = 5;
      //if(bigSq == 8) bigHolder = 2;
      else bigHolder = bigSq-6;
      if (big[bigSq].state == x) {
        if ((big[bigSq-6].state == x && big[bigSq-3].state == 0) || 
          (big[bigSq-6].state == 0 && big[bigSq-3].state == x)) {
          winPatternsme[bigHolder] = 6;
        }
        else if (big[bigSq-6].state == 0 && big[bigSq-3].state == 0) {
          winPatternsme[bigHolder] = 2;
        }
        else if (big[bigSq-6].state == y || big[bigSq-3].state == y) {
          winPatternsme[bigHolder] = 0;
        }
      }
      else if (big[bigSq].state == y) {
        if ((big[bigSq-6].state == y && big[bigSq-3].state == 0) || 
          (big[bigSq-6].state == 0 && big[bigSq-3].state == y)) {
          winPatternsthem[bigHolder] = 6;
        }
        else if (big[bigSq-6].state == 0 && big[bigSq-3].state == 0) {
          winPatternsthem[bigHolder] = 2;
        }
        else if (big[bigSq-6].state == x || big[bigSq-3].state == x) {
          winPatternsthem[bigHolder] = 0;
        }
      }
      else if (big[bigSq-6].state == 0 && big[bigSq-3].state == 0) {
        winPatternsthem[bigHolder] = 1;
        winPatternsme[bigHolder] = 1;
      }
    }
    //Horizontals
    if (bigSq==1||bigSq==4||bigSq==7) {
      //Is this box owned...
      if (big[bigSq].state == x) {
        if ((big[bigSq+1].state == x && big[bigSq+2].state==0) ||
          (big[bigSq+1].state==0 && big[bigSq+2].state == x)) {
          winPatternsme[bigSq] = 6; //Just need one box to win
        } 
        else if (big[bigSq+1].state == 0 && big[bigSq+2].state == 0) {
          winPatternsme[bigSq] = 2; //Need two boxes to win
        } 
        else if (big[bigSq+1].state == y || big[bigSq+2].state == y) {
          winPatternsme[bigSq] = 0; //Can't be won
        }
      } 
      else if (big[bigSq].state == y) {
        if ((big[bigSq+1].state == y && big[bigSq+2].state==0) ||
          (big[bigSq+1].state==0 && big[bigSq+2].state == y)) {
          winPatternsthem[bigSq] = 6; //Just need one box to win
        } 
        else if (big[bigSq+1].state == 0 && big[bigSq+2].state == 0) {
          winPatternsthem[bigSq] = 2; //Need two boxes to win
        } 
        else if (big[bigSq+1].state == y || big[bigSq+2].state == y) {
          winPatternsthem[bigSq] = 0; //Can't be won
        }
      } 
      else if ( big[bigSq+1].state == 0 && big[bigSq+2].state==0) {
        winPatternsme[bigSq] = 1;
        winPatternsthem[bigSq] = 1;
      }
    }
    //Next 3 for horizontal
    if (bigSq==2||bigSq==5||bigSq==8) {
      //Is this box owned...
      if (big[bigSq].state == x) {
        if ((big[bigSq+1].state == x && big[bigSq-1].state==0) ||
          (big[bigSq+1].state==0 && big[bigSq-1].state == x)) {
          winPatternsme[bigSq-1] = 6; //Just need one box to win
        } 
        else if (big[bigSq+1].state == 0 && big[bigSq-1].state == 0) {
          winPatternsme[bigSq-1] = 2; //Need two boxes to win
        } 
        else if (big[bigSq+1].state == y || big[bigSq-1].state == y) {
          winPatternsme[bigSq-1] = 0; //Can't be won
        }
      } 
      else if (big[bigSq].state == y) {
        if ((big[bigSq+1].state == y && big[bigSq-1].state==0) ||
          (big[bigSq+1].state==0 && big[bigSq-1].state == y)) {
          winPatternsthem[bigSq-1] = 6; //Just need one box to win
        } 
        else if (big[bigSq+1].state == 0 && big[bigSq-1].state == 0) {
          winPatternsthem[bigSq-1] = 2; //Need two boxes to win
        } 
        else if (big[bigSq+1].state == y || big[bigSq-1].state == y) {
          winPatternsthem[bigSq-1] = 0; //Can't be won
        }
      }
      else if ( big[bigSq+1].state == 0 && big[bigSq-1].state==0) {
        winPatternsme[bigSq-1] = 1;
        winPatternsthem[bigSq-1] = 1;
      }
    }
    //Final 3 for horizontal 
    if (bigSq==3||bigSq==6||bigSq==9) {
      //Is this box owned...
      if (big[bigSq].state == x) {
        if ((big[bigSq-1].state == x && big[bigSq-2].state==0) ||
          (big[bigSq-1].state==0 && big[bigSq-2].state == x)) {
          winPatternsme[bigSq-2] = 6; //Just need one box to win
        } 
        else if (big[bigSq-1].state == 0 && big[bigSq-2].state == 0) {
          winPatternsme[bigSq-2] = 2; //Need two boxes to win
        } 
        else if (big[bigSq-1].state == y || big[bigSq-2].state == y) {
          winPatternsme[bigSq-2] = 0; //Can't be won
        }
      } 
      else if (big[bigSq].state == y) {
        if ((big[bigSq-1].state == y && big[bigSq-2].state==0) ||
          (big[bigSq-1].state==0 && big[bigSq-2].state == y)) {
          winPatternsthem[bigSq-2] = 6; //Just need one box to win
        } 
        else if (big[bigSq-1].state == 0 && big[bigSq-2].state == 0) {
          winPatternsthem[bigSq-2] = 2; //Need two boxes to win
        } 
        else if (big[bigSq-1].state == y || big[bigSq-2].state == y) {
          winPatternsthem[bigSq-2] = 0; //Can't be won
        }
      } 
      else if ( big[bigSq-1].state == 0 && big[bigSq-2].state==0) {
        winPatternsme[bigSq-2] = 1;
        winPatternsthem[bigSq-2] = 1;
      }
    }
  }
  void findTwoinaRows(biggerSquares big1) {
    //Check to make sure the two
    //in a row still exists
    for (int i=0; i<5; i++) {
      if (big1.twoInarowBlank[i]>=0) {
        if (big1.boxes[floor(big1.twoInarowBlank[i])] //White space
        [floor((big1.twoInarowBlank[i]- floor(big1.twoInarowBlank[i]))*10)].state != 0)
        {
          big1.twoInarowBlank[i] = -1;
        }
      }
    }
    if (big1.state != 0) {
      big1.twoInarowBlank[0] = -1;
      big1.twoInarowBlank[1] = -1;
      big1.twoInarowBlank[2] = -1;
      //The array value finds up to three two in a rows...
    }
    if (big1.state == 0)
    {
      int i=0;
      //These ifs find out if you can win in one move...
      if (big1.boxes[0][0].state == big1.boxes[1][1].state &&
        big1.boxes[2][2].state == 0 && big1.boxes[0][0].state==2) { 
        big1.twoInarowBlank[i] = 2.2; 
        i++;
      }
      if (big1.boxes[0][0].state == big1.boxes[2][2].state &&
        big1.boxes[1][1].state == 0&& big1.boxes[0][0].state==2) {
        big1.twoInarowBlank[i] = 1.1; 
        i++;
      }
      if (big1.boxes[1][1].state == big1.boxes[2][2].state &&
        big1.boxes[0][0].state == 0 && big1.boxes[1][1].state==2) {
        big1.twoInarowBlank[i] = 0.0; 
        i++;
      }
      // // //
      if (big1.boxes[2][0].state == big1.boxes[1][1].state &&
        big1.boxes[0][2].state == 0 && big1.boxes[2][0].state==2) {
        big1.twoInarowBlank[i] = 0.2; 
        i++;
      } 
      if (big1.boxes[2][0].state == big1.boxes[0][2].state &&
        big1.boxes[1][1].state == 0 && big1.boxes[2][0].state==2) {
        big1.twoInarowBlank[i] = 1.1; 
        i++;
      }
      if (big1.boxes[1][1].state == big1.boxes[0][2].state &&
        big1.boxes[2][0].state == 0 && big1.boxes[1][1].state==2) {
        big1.twoInarowBlank[i] = 2.0; 
        i++;
      }
      //This for loop just checks if the box can be won
      //In one move for vertical and horizontal cases
      for (int k = 0; k<3; k++) {
        if (big1.boxes[0][k].state == big1.boxes[1][k].state &&
          big1.boxes[2][k].state == 0 && big1.boxes[0][k].state==2) { 
          big1.twoInarowBlank[i] = 2+.1*k; 
          i++;
        }
        if (big1.boxes[k][0].state == big1.boxes[k][1].state &&
          big1.boxes[k][2].state == 0 && big1.boxes[k][0].state==2) {
          big1.twoInarowBlank[i] = 1*k+.2; 
          i++;
        }
        if (big1.boxes[0][k].state == big1.boxes[2][k].state &&
          big1.boxes[1][k].state == 0 && big1.boxes[0][k].state==2) {
          big1.twoInarowBlank[i] = 1+.1*k; 
          i++;
        }
        if (big1.boxes[k][0].state == big1.boxes[k][2].state &&
          big1.boxes[k][1].state == 0 && big1.boxes[k][0].state==2) {
          big1.twoInarowBlank[i] = 1*k+.1; 
          i++;
        }
        if (big1.boxes[1][k].state == big1.boxes[2][k].state &&
          big1.boxes[0][k].state == 0 && big1.boxes[2][k].state==2) {
          big1.twoInarowBlank[i] = 0 +.1*k; 
          i++;
        }
        if (big1.boxes[k][1].state == big1.boxes[k][2].state &&
          big1.boxes[k][0].state == 0 && big1.boxes[k][1].state==2) {
          big1.twoInarowBlank[i] = 1*k+0.0; 
          i++;
        }
      }
    }
  }
}

