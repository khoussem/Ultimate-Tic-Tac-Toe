/*
*Things to add:
*Combining likelyness of winning a big box with likeliness of winning the whole game
*Turn bigboxratings into a position judgement
*Take into account squarenow at the end
*/
class bigBoxRating
{
  //The already having one in a box part of rating will be dealt
  //with in the recursive call :: 
  int jy = 0;
  int patterns[][] = new int [10][5]; //holds which patterns the box uses...0 means none
  int patternsThem[][] = new int [10][4];
  float [] BigSquarePref = new float [10];
  float [] OppBigSquarePref = new float [10];
  int [] numberofPatterns = new int[10]; //the index is the boxnum
  int [] numberofPatternsThem = new int [10];
  int [] winPatternsthem = new int[10];
  int [] winPatternsme = new int[10]; //what does its pointer hold versus its actual data?
  // winPatternsme-1 is horizontal, 4 is horizontal, 7 is horizontal, 2 is down, 3 is down,
  //5 is first collumn down, 6 is left to right diagonal (going up), 9 is right to left.
  biggerSquares [] big = new biggerSquares[10];
  bigBoxRating(float [] bigSquarepref, float [] bigSquarePrefOp) {
    BigSquarePref = bigSquarepref;
    OppBigSquarePref = bigSquarePrefOp;
    for (int i=0; i<10; i++) {
      patterns[i][4] = 0;
    }
  }
  boolean tieChecker() {
    //also need to check to make sure squares can be won...
    for (int i=1; i<10; i++) {
      if (winPatternsme[i] != 0) return false;
      if (winPatternsthem[i] !=0) return false;
    }
    return true;
  }
  void boxNumtoPatterns(int bignum, int [][] patterns) {
    switch (bignum) {
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
  void boxRating(biggerSquares [] Big) {
    big = Big;
    for (int i=1; i<10; i++) {
      big[i].stateFinder();
      //(i+": "+big[i].state);
      findTwoinaRows(big[i]);
      numberofPatterns[i] = 0;
      BigSquarePref[i] = 5.0;
      OppBigSquarePref[i] = 5.0;
      //println("Number "+i+" :"+big[i].numberofTwoinaRows(big[i].twoInarowBlank));
      //if(big[i].twoInarowBlank[1]!=-1) println("Number "+i+" :"+big[i].numberofTwoinaRows(big[i].twoInarowBlank[1]));
    }
    for (int i=1;i<10;i++) {
      winPatterns(i, 2);
      boxNumtoPatterns(i, patterns);
    }
    patternsToboxReview(winPatternsme, numberofPatterns);
    rater(BigSquarePref, winPatternsme, 2);
    for (int i=1;i<10;i++) {
      winPatterns(i, 1);
      boxNumtoPatterns(i, patternsThem);
    }
    patternsToboxReview(winPatternsthem, numberofPatternsThem);
    rater(OppBigSquarePref, winPatternsthem, 1);
  }

  void rater(float [] bigBoxPref, int [] winPatternsme, int opp) {
    float [] twoRows;
    //That allows for this function to be use with both
    //me and opponent
    for (int i=1;i<10;i++) {
      if (big[i].state == 0) {
        if (opp == 2)twoRows = big[i].twoInarowBlank;
        else twoRows = big[i].twoInarowBlankOpp;
        int j = 0; 
        switch (numberofPatterns[i]) {
        case 0: 
          bigBoxPref[i] -= 3;
          break; 
        case 1:
          while (j==0) {
            if (patterns[i][j] != 0) {
              switch(winPatternsme[patterns[i][j]]) {
              case 0: 
                bigBoxPref[i] -= 3;
                break;
              case 1:
                if (big[i].numberofTwoinaRows(twoRows) == 0) bigBoxPref[i] -= .25;
                else if (big[i].numberofTwoinaRows(twoRows) == 1) bigBoxPref[i] += .25;
                else if (big[i].numberofTwoinaRows(twoRows) == 2) bigBoxPref[i] += .5;
                else if (big[i].numberofTwoinaRows(twoRows) == 3) bigBoxPref[i] += .55;
                break; 
              case 2:
                if (big[i].numberofTwoinaRows(twoRows) == 0) bigBoxPref[i] += .25;
                else if (big[i].numberofTwoinaRows(twoRows) == 1) bigBoxPref[i] += .75;
                else if (big[i].numberofTwoinaRows(twoRows) == 2) bigBoxPref[i] += 1;
                else if (big[i].numberofTwoinaRows(twoRows) == 3) bigBoxPref[i] += 1.05;
                break; 
              case 6:
                if (big[i].numberofTwoinaRows(twoRows) == 0) bigBoxPref[i] += 4;
                if (big[i].numberofTwoinaRows(twoRows) == 1) bigBoxPref[i] += 5;
                if (big[i].numberofTwoinaRows(twoRows) == 2) bigBoxPref[i] += 5.5;
                if (big[i].numberofTwoinaRows(twoRows) == 3) bigBoxPref[i] += 5.5;
                break;
              }
            }
            j++;
            if (j == 4) break;
          }
          break;
        case 2:    
          while (j<2) {
            if (patterns[i][j] != 0) {
              switch(winPatternsme[patterns[i][j]]) {
              case 0: 
                if (j == 0) {
                  if (winPatternsme[patterns[i][1]]==0) {
                    bigBoxPref[i] -= 3;
                  } //don't change the pref unless
                  //both are zero, otherwise it justs acts as a 
                  //numpatterns1
                }
                break; 
              case 1:
                if (big[i].numberofTwoinaRows(twoRows) == 0) bigBoxPref[i] -= 0;
                if (big[i].numberofTwoinaRows(twoRows) == 1) bigBoxPref[i] += .5;
                if (big[i].numberofTwoinaRows(twoRows) == 2) bigBoxPref[i] += .75;
                if (big[i].numberofTwoinaRows(twoRows) == 3) bigBoxPref[i] += .8;
                break; 
              case 2:
                if (big[i].numberofTwoinaRows(twoRows) == 0) bigBoxPref[i] += .25;
                if (big[i].numberofTwoinaRows(twoRows) == 1) bigBoxPref[i] += 1;
                if (big[i].numberofTwoinaRows(twoRows) == 2) bigBoxPref[i] += 1.25;
                if (big[i].numberofTwoinaRows(twoRows) == 3) bigBoxPref[i] += 1.3;
                break; 
              case 6: 
                if (big[i].numberofTwoinaRows(twoRows) == 0) bigBoxPref[i] += 4.5;
                if (big[i].numberofTwoinaRows(twoRows) == 1) bigBoxPref[i] += 5;
                if (big[i].numberofTwoinaRows(twoRows) == 2) bigBoxPref[i] += 5.5;
                if (big[i].numberofTwoinaRows(twoRows) == 3) bigBoxPref[i] += 5.5;
                break;
              }
              j++;
            }
            if (j == 4) break;
          }
          break;
        case 3: 
          while (j<3) {
            if (patterns[i][j] != 0) {
              switch(winPatternsme[patterns[i][j]]) {
              case 0: 
                if (j == 0) {
                  if (winPatternsme[patterns[i][1]]==0&&winPatternsme[patterns[i][2]]==0) {
                    bigBoxPref[i] -= 3;
                  } //don't change the pref unless
                  //both are zero, otherwise it justs acts as a 
                  //numpatterns1
                }
                break; 
              case 1:
                if (big[i].numberofTwoinaRows(twoRows) == 0) bigBoxPref[i] += .2;
                if (big[i].numberofTwoinaRows(twoRows) == 1) bigBoxPref[i] += .7;
                if (big[i].numberofTwoinaRows(twoRows) == 2) bigBoxPref[i] += .95;
                if (big[i].numberofTwoinaRows(twoRows) == 3) bigBoxPref[i] += .95;
                break;
              case 2:
                if (big[i].numberofTwoinaRows(twoRows) == 0) bigBoxPref[i] += .45;
                if (big[i].numberofTwoinaRows(twoRows) == 1) bigBoxPref[i] += 1.25;
                if (big[i].numberofTwoinaRows(twoRows) == 2) bigBoxPref[i] += 1.5;
                if (big[i].numberofTwoinaRows(twoRows) == 3) bigBoxPref[i] += 1.55;
                break; 
              case 6: 
                if (big[i].numberofTwoinaRows(twoRows) == 0) bigBoxPref[i] += 4.5;
                if (big[i].numberofTwoinaRows(twoRows) == 1) bigBoxPref[i] += 5;
                if (big[i].numberofTwoinaRows(twoRows) == 2) bigBoxPref[i] += 5.5;
                if (big[i].numberofTwoinaRows(twoRows) == 3) bigBoxPref[i] += 5.5;
                break;
              }
              j++;
            }
            if (j == 4) break;
          }
          break;
        case 4:
          while (j<4) {
            if (patterns[i][j] != 0) {
              switch(winPatternsme[patterns[i][j]]) {
              case 0: 
                if (j == 0) {
                  if (winPatternsme[patterns[i][1]]==0&&winPatternsme[patterns[i][2]]==0
                    &&winPatternsme[patterns[i][3]]==0) {
                    bigBoxPref[i] -= 3;
                  } //don't change the pref unless
                  //both are zero, otherwise it justs acts as a 
                  //numpatterns1
                } 
                break;
              case 1:
                if (big[i].numberofTwoinaRows(twoRows) == 0) bigBoxPref[i] += .35;
                if (big[i].numberofTwoinaRows(twoRows) == 1) bigBoxPref[i] += 1.35;
                if (big[i].numberofTwoinaRows(twoRows) == 2) bigBoxPref[i] += 1.65;
                if (big[i].numberofTwoinaRows(twoRows) == 3) bigBoxPref[i] += 1.7;
                break;
              case 2: 
                if (big[i].numberofTwoinaRows(twoRows) == 0) bigBoxPref[i] += .5;
                if (big[i].numberofTwoinaRows(twoRows) == 1) bigBoxPref[i] += 1.5;
                if (big[i].numberofTwoinaRows(twoRows) == 2) bigBoxPref[i] += 1.75;
                if (big[i].numberofTwoinaRows(twoRows) == 3) bigBoxPref[i] += 1.8;
                break;
              case 6: 
                if (big[i].numberofTwoinaRows(twoRows) == 0) bigBoxPref[i] += 4.5;
                if (big[i].numberofTwoinaRows(twoRows) == 1) bigBoxPref[i] += 5;
                if (big[i].numberofTwoinaRows(twoRows) == 2) bigBoxPref[i] += 5.5;
                if (big[i].numberofTwoinaRows(twoRows) == 3) bigBoxPref[i] += 5.5;
                break;
              }
            } 
            j++;
            //break;
          }
        }
      } 
      else bigBoxPref[i] = -1;
    }
  }
  //finds the number of patterns
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
  //Same code as in brain thread, but i need it here too
  //dont be fooled here big1 is passed to this, so it works for all
  //squares
  void findTwoinaRowsOpp(biggerSquares big1) {
    if (big1.state != 0) {
      big1.twoInarowBlankOpp[0] = -1;
      big1.twoInarowBlankOpp[1] = -1;
      big1.twoInarowBlankOpp[2] = -1;
      //The array value finds up to three two in a rows...
    }
    if (big1.state == 0)
    {
      int i=0;
      //These ifs find out if you can win in one move...
      if (big1.boxes[0][0].state == big1.boxes[1][1].state &&
        big1.boxes[2][2].state == 0 && big1.boxes[0][0].state==1) { 
        big1.twoInarowBlankOpp[i] = 2.2; 
        i++;
      }
      if (big1.boxes[0][0].state == big1.boxes[2][2].state &&
        big1.boxes[1][1].state == 0&& big1.boxes[0][0].state==1) {
        big1.twoInarowBlankOpp[i] = 1.1; 
        i++;
      }
      if (big1.boxes[1][1].state == big1.boxes[2][2].state &&
        big1.boxes[0][0].state == 0 && big1.boxes[1][1].state==1) {
        big1.twoInarowBlankOpp[i] = 0.0; 
        i++;
      }
      // // //
      if (big1.boxes[2][0].state == big1.boxes[1][1].state &&
        big1.boxes[0][2].state == 0 && big1.boxes[2][0].state==1) {
        big1.twoInarowBlankOpp[i] = 0.2; 
        i++;
      } 
      if (big1.boxes[2][0].state == big1.boxes[0][2].state &&
        big1.boxes[1][1].state == 0 && big1.boxes[2][0].state==1) {
        big1.twoInarowBlankOpp[i] = 1.1; 
        i++;
      }
      if (big1.boxes[1][1].state == big1.boxes[0][2].state &&
        big1.boxes[2][0].state == 0 && big1.boxes[1][1].state==1) {
        big1.twoInarowBlankOpp[i] = 2.0; 
        i++;
      }
      //This for loop just checks if the box can be won
      //In one move for vertical and horizontal cases
      for (int k = 0; k<3; k++) {
        if (big1.boxes[0][k].state == big1.boxes[1][k].state &&
          big1.boxes[2][k].state == 0 && big1.boxes[0][k].state==1) { 
          big1.twoInarowBlankOpp[i] = 2+.1*k; 
          i++;
        }
        if (big1.boxes[k][0].state == big1.boxes[k][1].state &&
          big1.boxes[k][2].state == 0 && big1.boxes[k][0].state==1) {
          big1.twoInarowBlankOpp[i] = 1*k+.2; 
          i++;
        }
        if (big1.boxes[0][k].state == big1.boxes[2][k].state &&
          big1.boxes[1][k].state == 0 && big1.boxes[0][k].state==1) {
          big1.twoInarowBlankOpp[i] = 1+.1*k; 
          i++;
        }
        if (big1.boxes[k][0].state == big1.boxes[k][2].state &&
          big1.boxes[k][1].state == 0 && big1.boxes[k][0].state==1) {
          big1.twoInarowBlankOpp[i] = 1*k+.1; 
          i++;
        }
        if (big1.boxes[1][k].state == big1.boxes[2][k].state &&
          big1.boxes[0][k].state == 0 && big1.boxes[2][k].state==1) {
          big1.twoInarowBlankOpp[i] = 0 +.1*k; 
          i++;
        }
        if (big1.boxes[k][1].state == big1.boxes[k][2].state &&
          big1.boxes[k][0].state == 0 && big1.boxes[k][1].state==1) {
          big1.twoInarowBlankOpp[i] = 1*k+0.0; 
          i++;
        }
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
  //Okay
  //UGLY FUNCTION HERE ;; ; ;; ; ;; 
  void winPatterns(int bigSq, int x) {
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
}

