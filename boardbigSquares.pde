class boardbigSquares{
 int state = 0;
 int Num;
 boardSquares [][] boxes = new boardSquares[3][3];
  boardbigSquares(int num) {
   Num = num; 
   for(int i = 0; i < 3; i++) {
    for(int j = 0; j < 3; j++) {
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
  void makeMove(int i, int turn) {
   boxes[findX(i)][findY(i)].state = turn;
   state = winCheck();
   //All next square controls are held here for convience
   if(state != 0) {
     //If this box has been won...
     //super.bigStates[Num] = state; //Update the big squares states array
     //super.nextSquare = 0; //Means that the next square is freebee
   }
   else {
    //If it wasnt won
    /*if(super.bigStates[i] != 0) {
      //If the box being sent to is full
    super.nextSquare = Num; //Then we go back to this box
    } else {
    super.nextSquare = i; //Else we go to the normal box where we are sent
    }*/
   }
  }
  void unmakeMove(int i) {
  /*  boxes[findX(i)][findY(i)].state = 0;
    if(state != 0) {
    state = 0;
    super.bigStates[Num] = 0;
    }*/
  }
 boolean possibleMove(int i) {
  if(boxes[findX(i)][findY(i)].state == 0) return true;
  else return false;
 } 
 int findX(int i) {
  if(i == 3 || i == 6 || i == 9) {
   return 2; 
  }
  if(i == 2 || i == 5 || i == 8) {
   return 1; 
  }
  else return 0;
 }
 int findY(int i) {
  if(i < 4) {
  return 0;
  } 
  if(i < 7) {
   return 1; 
  }
  else return 2;
 }
}
