class smallestSquares
{
  float x, y;
  float width, height;
  int state;
  int largersquare;
  int smallsquare;
  boolean computerReturn;
  //should be placed in a two d array thats nine by nine
  smallestSquares(int smallSquare, int LargerSquare, int State, float xpos, float ypos)
  {
    //State = 0 is null, State = 1 is X, State = 2 is O
    //Xpos, Ypos is a point at the top right of box
    largersquare = LargerSquare;
    smallsquare = smallSquare;
    x = xpos;
    y = ypos;  
    state = State;
    //Change the height and width to fit screen
    width = 40;
    height = 40;
  }
  void move()
  {
    //The next to functions are used for converting from little square
    //to the next big square

      //Will be replaced with image...
    //the rect is now below!
    //the fill is a test, white is O, black is X
    fill(255);
    //if the box hasnt been played in
    //it can be changed
    if (!pauser) {
      if (mouseX > x && mouseX < x + width &&
        mouseY > y && mouseY < y + height)
      {
        //println(smallsquare);
        if (bigSquarenow == largersquare || bigSquarenow==0)
        {
          //bigSquarenow ==0 means a free move in any box
          if (mousePressed && state==0 && bigstate[largersquare]==0)
          {
            boxTaker();
          }
        }
      }
    } 
    else if (computerReturn == true) {
      computerReturn = false;
      boxTaker();
    }
  }
  void boxTaker() {
    //using both state and turn
    //as integers from 1-2 is useful
    changeMade = true;
    state = turn;
    smallChanged = smallsquare;
    //Find bigChanged here because winChecker needs it
    bigChanged = bigFinder(smallsquare);
    stateChangedto = state; 
    //Above just says where the next move must be
    //Call Winstate in here because we need the bigstate
    winCheckerCombined();
    //Function that tests the state of big squares
    //Here is a test case to see if either the square you are
    //moving to, or the move you just played has filled a box
    //then the other player gets a freebee  
    if (bigstate[littletoBig(smallsquare)]!=0) bigSquarenow = //SPACE
    largersquare;
    else if (bigstate[bigFinder(smallsquare)]!=0) bigSquarenow = 0;
    else bigSquarenow = littletoBig(smallsquare);
    //This makes it so you move in the same square if
    //The move sends you to a filled one
    //Flips the turn
    if (turn == 1) turn = 2;
    else turn = 1;
    //simply cool if else!
  }
  void unTake() {
    state = 0;
    if(bigstate[littletoBig(smallsquare)] != 0) bigstate[littletoBig(smallsquare)] = 0;
  }
  void build() {
    move();
    rect(x, y, width, height);
    imageMode(CENTER);
    if (state == 1) image(Ex, x+width/2, y+height/2, width, height);
    else if (state == 2) image(Oh, x+width/2, y+height/2, width, height);
  }
  boolean isEmpty() {
    return state == 0;
  }
}

