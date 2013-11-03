class biggerSquares
{
  float [] twoInarowBlankOpp = new float [5];
  float [] twoInarowBlank = new float [5];
  int state;
  int number;
  float x, y;
  float width = 133;
  float height = 133;
  boolean hasbeenWon = false;
  smallestSquares [][] boxes = new smallestSquares [3][3];
  biggerSquares(boolean Won, int Number, smallestSquares [][] Boxes, float X, float Y)
  {
    state = 0;
    hasbeenWon = Won;
    for (int i=0;i<3;i++)
    {
      for (int j=0;j<3;j++) 
      {
        boxes[i][j] = Boxes[i][j];
      }
    }
    twoInarowBlank[0] = -1;
    twoInarowBlank[1] = -1;
    twoInarowBlank[2] = -1;
    number = Number;
    x = X;
    y = Y;
  }
  int numberofTwoinaRows(float [] twoinarowBlank) {
    int i=0;
    if (twoInarowBlank[0] >= 0) i++;
    if (twoInarowBlank[1] >= 0) i++;
    if (twoInarowBlank[2] >= 0) i++;
    return i;
  }
  //These two functions are for twoinrowBlank...
  int findX(float x) {
    return floor(x);
  }
  int findY(float y) {
    return floor((y - floor(y))*10);
  }
  //
  //
  //Tests all the cases for a win
  int winCheckXY(int x, int y) {
    if (x == 1) {
      if (boxes[x-1][y].state == boxes[x+1][y].state) return boxes[x+1][y].state;
      if (y == 1) {
        if (boxes[x-1][y-1].state == boxes[x+1][y+1].state) return boxes[x+1][y+1].state;
      }
    }
    if (x == 2) {
      if (boxes[x-2][y].state == boxes[x-1][y].state) return boxes[x-2][y].state;
      if (y == 0) {
        if (boxes[x-2][y+2].state == boxes[x-1][y+1].state) return boxes[x-1][y+1].state;
      }
      if (y == 2) {
        if (boxes[x-2][y-2].state == boxes[x-1][y-1].state) return boxes[x-1][y-1].state;
      }
    }
    if (x == 0) {
      if (boxes[x+2][y].state == boxes[x+1][y].state) return boxes[x+2][y].state;
      if (y == 0) {
        if (boxes[x+1][y+1].state == boxes[x+2][y+2].state) return boxes[x+1][y+1].state;
      }
      if (y == 2) {
        if (boxes[x+1][y-1].state == boxes[x+2][y-2].state) return boxes[x+1][y-1].state;
      }
    }
    if (y == 1) {
      if (boxes[x][y-1].state == boxes[x][y+1].state) return boxes[x][y-1].state;
    }
    if (y == 2) {
      if (boxes[x][y-2].state == boxes[x][y-1].state) return boxes[x][y-1].state;
    }
    if (y == 0) {
      if (boxes[x][y+1].state == boxes[x][y+2].state) return boxes[x][y+1].state;
    }
    return 0;
  }
  void stateFinder() {
    state = winCheck();
  }
  int winCheck()
  {
    if (boxes[0][0].state == boxes[1][0].state && boxes[1][0].state ==
      boxes[2][0].state && boxes[0][0].state!=0)
    {
      return boxes[0][0].state;
      //horizontal case 1
    }
    else if (boxes[0][1].state == boxes[1][1].state && boxes[1][1].state ==
      boxes[2][1].state&& boxes[0][1].state!=0)
    {
      return boxes[0][1].state;
      //horizontal case 2
    }
    else if (boxes[0][2].state == boxes[1][2].state && boxes[1][2].state ==
      boxes[2][2].state && boxes[0][2].state!=0)
    {
      return boxes[0][2].state;
      //horizontal case 3
    }
    else if (boxes[0][0].state == boxes[0][1].state && boxes[0][1].state ==
      boxes[0][2].state && boxes[0][0].state!=0)
    {
      return boxes[0][2].state;
      //vertical case 1
    }
    else if (boxes[1][0].state == boxes[1][1].state && boxes[1][1].state ==
      boxes[1][2].state && boxes[1][0].state!=0)
    {
      return boxes[1][0].state;
      //vertical case 2
    }
    else if (boxes[2][0].state == boxes[2][1].state && boxes[2][1].state ==
      boxes[2][2].state && boxes[2][0].state!=0)
    {
      return boxes[2][2].state;
      //vertical case 3
    }
    else if (boxes[0][0].state == boxes[1][1].state && boxes[1][1].state ==
      boxes[2][2].state && boxes[0][0].state!=0)
    {
      return boxes[0][0].state;
      //vertical case 1
    }
    else if (boxes[0][2].state == boxes[1][1].state && boxes[1][1].state ==
      boxes[2][0].state && boxes[0][2].state!=0)
    {
      return boxes[2][0].state;
      //vertical case 1
    }
    else {
      return 0;
    }
  }

  int arrayNumtosmallSquare(int x, int y)
  {
    if (number == 1 ) return x+1 + y*9;
    if (number == 2 ) return x+4 + y*9;
    if (number == 3 ) return x+7 + y*9;
    if (number == 4 ) return x+1 + (y+3)*9;
    if (number == 5 ) return x+4 + (y+3)*9;
    if (number == 6 ) return x+7 + (y+3)*9;
    if (number == 7 ) return x+1 + (y+6)*9;
    if (number == 8 ) return x+4 + (y+6)*9;
    else return x+7 + (y+6)*9;
  }
  void boxisWon(int state)
  {
    if (state!=0)
    {
      fill(255);
      rect(x, y, width, height);
      if (state == 1) image(Ex, x+width/2, y+height/2, width, height);
      else if (state == 2) image(Oh, x+width/2, y+height/2, width, height);
    }
  }

}

