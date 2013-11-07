class boardbigSquares {
  int state = 0;
  int Num;
  boardSquares [][] boxes = new boardSquares[3][3];
  int [][] states;
  boardbigSquares(int num) {
    Num = num; 
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        boxes[i][j] = new boardSquares();
      }
    }
  }
  int winCheck()
  {
    if (boxes[0][0].state == boxes[1][0].state && boxes[1][0].state ==
      boxes[2][0].state && boxes[0][0].state!=0)
    {
      return boxes[0][0].state;
      //horizontal case 1
    } else if (boxes[0][1].state == boxes[1][1].state && boxes[1][1].state ==
      boxes[2][1].state&& boxes[0][1].state!=0)
    {
      return boxes[0][1].state;
      //horizontal case 2
    } else if (boxes[0][2].state == boxes[1][2].state && boxes[1][2].state ==
      boxes[2][2].state && boxes[0][2].state!=0)
    {
      return boxes[0][2].state;
      //horizontal case 3
    } else if (boxes[0][0].state == boxes[0][1].state && boxes[0][1].state ==
      boxes[0][2].state && boxes[0][0].state!=0)
    {
      return boxes[0][2].state;
      //vertical case 1
    } else if (boxes[1][0].state == boxes[1][1].state && boxes[1][1].state ==
      boxes[1][2].state && boxes[1][0].state!=0)
    {
      return boxes[1][0].state;
      //vertical case 2
    } else if (boxes[2][0].state == boxes[2][1].state && boxes[2][1].state ==
      boxes[2][2].state && boxes[2][0].state!=0)
    {
      return boxes[2][2].state;
      //vertical case 3
    } else if (boxes[0][0].state == boxes[1][1].state && boxes[1][1].state ==
      boxes[2][2].state && boxes[0][0].state!=0)
    {
      return boxes[0][0].state;
      //vertical case 1
    } else if (boxes[0][2].state == boxes[1][1].state && boxes[1][1].state ==
      boxes[2][0].state && boxes[0][2].state!=0)
    {
      return boxes[2][0].state;
      //vertical case 1
    } else {
      return 0;
    }
  }
  void makeMove(int a, int b, int turn) {
    boxes[a][b].state = turn;
    state = winCheck();
    //All next square controls are held here for convience
    if (state != 0) {
      //If this box has been won...
      //super.bigStates[Num] = state; //Update the big squares states array
      //super.nextSquare = 0; //Means that the next square is freebee
    } else {
      //If it wasnt won
      /*if(super.bigStates[i] != 0) {
       //If the box being sent to is full
       super.nextSquare = Num; //Then we go back to this box
       } else {
       super.nextSquare = i; //Else we go to the normal box where we are sent
       }*/
    }
  }
  void unmakeMove(int a, int b) {
    /*  boxes[findX(i)][findY(i)].state = 0;
     if(state != 0) {
     state = 0;
     super.bigStates[Num] = 0;
     }*/
     boxes[a][b].state = 0;
  }
  boolean possibleMove(int x, int y) {
    return boxes[x][y].state == 0;
  }
  boolean possibleMove(int i) {
    if (boxes[Utils.getX(i)][Utils.getY(i)].state == 0) return true; else return false;
  } 
  void initStates() {
   states = new int[7][7];
    for (int j = 0; j < 7; j++) {
      for (int i = 0; i < 7; i++) {
        states[i][j] = 0;
      }
    }
    for (int i = 2; i < 5; i++) {
      for (int j = 2; j < 5; j++) {
        states[i][j] = boxes[i-2][j-2].state;
      }
    }

  }
  int winCheckXY(int x, int y) {
    initStates();
    x = x + 2;
    y = y + 2;
    //horizontal middle
    if (states[x-1][y] != 0 && states[x+1][y] == states[x-1][y]) return states[x-1][y];
    //horizontal right
    if (states[x-1][y] != 0 && states[x-1][y] == states[x-2][y]) return states[x-1][y];
    //horizontal left
    if (states[x+1][y] != 0 && states[x+1][y] == states[x+2][y]) return states[x+1][y];
    //vertical middle
    if (states[x][y+1] != 0 && states[x][y+1] == states[x][y-1]) return states[x][y+1];
    //vertical top
    if (states[x][y+1] != 0 && states[x][y+1] == states[x][y+2]) return states[x][y+1];
    //vertical bottom
    if (states[x][y-1] != 0 && states[x][y-1] == states[x][y-2]) return states[x][y-1];
    //Left diag middle
    if (states[x-1][y-1] != 0 && states[x-1][y-1] == states[x+1][y+1]) return states[x+1][y+1];
    //Left diag right
    if (states[x-1][y-1] != 0 && states[x-1][y-1] == states[x-2][y-2]) return states[x-1][y-1];
    //Left diag left
    if (states[x+1][y+1] != 0 && states[x+1][y+1] == states[x+2][y+2]) return states[x+1][y+1];
    //Reight diag middle
    if (states[x+1][y-1] != 0 && states[x-1][y+1] == states[x+1][y-1]) return states[x+1][y-1];
    //Right diag left
    if (states[x+1][y-1] != 0 && states[x+1][y-1] == states[x+2][y-2]) return states[x+1][y-1];
    //Right diag right
    if (states[x-1][y+1] != 0 && states[x-1][y+1] == states[x-2][y-2]) return states[x-1][y+1];
    return 0;
  }
  public PVector canBeWon(int s) {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if(!possibleMove(i, j)) continue;
        if (winCheckXY(i, j) == s) return new PVector(i, j);
      }
    }
    return null;
  }
  public boolean canBeWon(int x, int y, int state) {
      return possibleMove(x, y) && (winCheckXY(x, y) == state);
  }
  int quotient(int n, int d) {
    int ret = 0;
    while (n > d) {
      n -= d;
      ret++;
    }
    return ret;
  }
  boolean isValid(int square) {
    int x = square % 3;
    int y = quotient(square, 3);
    if (boxes[x][y].isEmpty()) return true;
    return false;
  }
}

