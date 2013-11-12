//Computer doesn't work at the moment
//But mano-e-mano does!
///////////
// 1 2 3 //IMPORTANT!
// 4 5 6 //THIS IS THE ORDERING FOR BOXES
// 7 8 9 //ANY KIND OF BOX! except inside the actual box
/////////// where its (in xy)
// 00 10 20 //
// 01 11 21 //
// 02 12 22 //
//////////////
float [] bbp = new float [10];
float [] bbo = new float [10];
//biggerSquares [] biggie = new biggerSquares[10];
//bigBoxRating bbr;
Board board;
boolean tester;
boolean mouseRelease;
boolean highLight=true;
int highLightNum = 5;
int brainViewNum = 7;
boolean brainView = true;
ArrayList smalls;
PImage Ex;
PImage Oh;
//aaron sucks elephant penis
//Smalls is an length 81 array of each small square
//Each biggerSquares is an object of a single larger
//box, going left to right
int difficulty = 4; //4 means no computer atm
//BrainThread thread1; //thread the shred
BrainThread2 thread2;
boolean thinking = false;
boolean spacePressed; //True if space is being pressed..., for reset
boolean menu = true; //Menu state
boolean Rules = false;
boolean pauser = false;
boolean options = false; //option screen state
boolean computer = false;
boolean rulesImageScreen = false;
int RulesScreencount;
biggerSquares big1;
biggerSquares big2;
biggerSquares big3;
biggerSquares big4;
biggerSquares big5;
biggerSquares big6;
biggerSquares big7;
biggerSquares big8;
biggerSquares big9;
boolean changeMade; //memory saver so winUpdater is only called
//after a change
int smallChanged=0; //holds the value of the small changed
int bigChanged=0; //An important variable, that tells the main
//what box has been changed so it can be updated with new values
//for its littleSquare states
int stateChangedto; //Holds the state of the variable change
int gameState; //if != 0, game is won
int [] bigstate = new int [10]; //Array containing the state of each big square
int turn=1; //1 = X, 2 = O
int bigSquarenow=0; //1-9, deciding where the next move must be
String [] rules;
String [] moveExplain;
void keyPressed()
{
  if (key ==  ' ') spacePressed = true;
}
void keyReleased()
{
  if (key == ' ') spacePressed = false;
  if (key == 't' ) {
    //findTwoinaRows(bigObject(bigSquarenow));
    for (int i = 1; i < 10; i++) {
      println("State: " + i);
      println(bigstate[i]);
    }
  }
  if (key == 'p') {
    newBigBoxRating n = new newBigBoxRating(board, 2);
    int rating = n.ratePosition();
    println("Negative is X, Positive is O");
    println("Positional rating: " + rating);
  }
}
void mouseReleased()
{
  mouseRelease = true;
  if (pauser) pauser = false;
}
void mouseMoved() {
  mouseRelease = false;
}
void setup()
{ 
  size(400, 400);
  //SIZE SIZE SIZE
  rules = loadStrings("rules.txt");
  moveExplain = loadStrings("moveExplain.txt");
  Oh = loadImage("Oh.gif");
  Ex = loadImage("Ex.png");
  board = new Board();
  smallestSquares [][] big_1;
  smallestSquares [][] big_2;
  smallestSquares [][] big_3;
  smallestSquares [][] big_4;
  smallestSquares [][] big_5;
  smallestSquares [][] big_6;
  smallestSquares [][] big_7;
  smallestSquares [][] big_8;
  smallestSquares [][] big_9;
  big_1 = new smallestSquares[3][3];
  big_2 = new smallestSquares[3][3];
  big_3 = new smallestSquares[3][3];
  big_4 = new smallestSquares[3][3];
  big_5 = new smallestSquares[3][3];
  big_6 = new smallestSquares[3][3];
  big_7 = new smallestSquares[3][3];
  big_8 = new smallestSquares[3][3];
  big_9 = new smallestSquares[3][3];
  //Each has 9 elements obviously, however
  //in this array we go,
  // 00 10 20
  // 01 11 21
  // 02 12 22 
  //Lets make our thread for the computer brain
  //thread1 = new BrainThread();
  //thread2 = new BrainThread2();
  //bbr = new bigBoxRating(bbp, bbo);
  smalls = new ArrayList();
  for (int i=0; i<9; i++)
  {
    for (int j=0; j<9; j++)
    {
      smalls.add(//whitespacing
      new smallestSquares(9*i + (j+1), bigFinder(9*i+j+1), 0, j*(40+5), i*(40+5)));
    } //Just creating the arraylist of small boxes
  } //
  //This
  //For loop is all for alloting
  //the smaller squares into
  //a smaller 3 by 3 array
  //for each seperate big square
  for (int i=0;i<9;i++)
  {
    for (int j=0;j<9;j++)
    {
      if (i==0 && j<3) big_1[j][i] = (smallestSquares) smalls.get(j);
      if (i==1 && j<3) big_1[j][i] = (smallestSquares) smalls.get(j+9);
      if (i==2 && j<3) big_1[j][i] = (smallestSquares) smalls.get(j+18);
      //2
      if (i==0 && j>=4 && j<=6) big_2[j-4][i] = (smallestSquares) smalls.get(j-1);
      if (i==1 && j>=4 && j<=6) big_2[j-4][i] = (smallestSquares) smalls.get(j+8);
      if (i==2 && j>=4 && j<=6) big_2[j-4][i] = (smallestSquares) smalls.get(j+17);
      //3
      if (i==0 && j>=6 && j<=8) big_3[j-6][i] = (smallestSquares) smalls.get(j);
      if (i==1 && j>=6 && j<=8) big_3[j-6][i] = (smallestSquares) smalls.get(j+9);
      if (i==2 && j>=6 && j<=8) big_3[j-6][i] = (smallestSquares) smalls.get(j+18);
      //4
      if (i==3 && j<3) big_4[j][i-3] = (smallestSquares) smalls.get(j+27);
      if (i==4 && j<3) big_4[j][i-3] = (smallestSquares) smalls.get(j+36);
      if (i==5 && j<3) big_4[j][i-3] = (smallestSquares) smalls.get(j+45);
      //5
      if (i==3 && j>=4 && j<=6) big_5[j-4][i-3] = (smallestSquares) smalls.get(j+26);
      if (i==4 && j>=4 && j<=6) big_5[j-4][i-3] = (smallestSquares) smalls.get(j+35);
      if (i==5 && j>=4 && j<=6) big_5[j-4][i-3] = (smallestSquares) smalls.get(j+44);
      //6
      if (i==3 && j>=6 && j<=8) big_6[j-6][i-3] = (smallestSquares) smalls.get(j+27);
      if (i==4 && j>=6 && j<=8) big_6[j-6][i-3] = (smallestSquares) smalls.get(j+36);
      if (i==5 && j>=6 && j<=8) big_6[j-6][i-3] = (smallestSquares) smalls.get(j+45);
      //7
      if (i==6 && j>=0 && j<=2) big_7[j][i-6] = (smallestSquares) smalls.get(j+54);
      if (i==7 && j>=0 && j<=2) big_7[j][i-6] = (smallestSquares) smalls.get(j+63);
      if (i==8 && j>=0 && j<=2) big_7[j][i-6] = (smallestSquares) smalls.get(j+72);
      //81
      if (i==6 && j>=4 && j<=6) big_8[j-4][i-6] = (smallestSquares) smalls.get(j+53);
      if (i==7 && j>=4 && j<=6) big_8[j-4][i-6] = (smallestSquares) smalls.get(j+62);
      if (i==8 && j>=4 && j<=6) big_8[j-4][i-6] = (smallestSquares) smalls.get(j+71);
      //9
      if (i==6 && j>=6 && j<=8) big_9[j-6][i-6] = (smallestSquares) smalls.get(j+54);
      if (i==7 && j>=6 && j<=8) big_9[j-6][i-6] = (smallestSquares) smalls.get(j+63);
      if (i==8 && j>=6 && j<=8) big_9[j-6][i-6] = (smallestSquares) smalls.get(j+72);
    }
  }
  //Then we declare a new object and
  //pass it the array of smallersquares
  //big_1 is the array that is contained
  //by big1
  //list of constructors is
  //small square tag
  //big square tag
  //state
  //x
  //y
  big1 = new biggerSquares(false, 1, big_1, 0, 0);
  big2 = new biggerSquares(false, 2, big_2, 133, 0);
  big3 = new biggerSquares(false, 3, big_3, 266, 0);
  big4 = new biggerSquares(false, 4, big_4, 0, 133);
  big5 = new biggerSquares(false, 5, big_5, 133, 133);
  big6 = new biggerSquares(false, 6, big_6, 266, 133);
  big7 = new biggerSquares(false, 7, big_7, 0, 266);
  big8 = new biggerSquares(false, 8, big_8, 133, 266);
  big9 = new biggerSquares(false, 9, big_9, 266, 266);
}
//Finds the first value of the 2D array
//taking in a number input
int findMy2dArrayValueX(int n)
{
  if (n%9 == 0) return 2;
  if ((n - (quotientForme(n, 9) -1) * 9)/8 == 1) return 1;
  if ((n - (quotientForme(n, 9) -1) * 9)/7 == 1) return 0;
  if ((n - (quotientForme(n, 9) -1) * 9)/6 == 1) return 2;
  if ((n - (quotientForme(n, 9) -1) * 9)/5 == 1) return 1;
  if ((n - (quotientForme(n, 9) -1) * 9)/4 == 1) return 0;
  if ((n - (quotientForme(n, 9) -1) * 9)/3 == 1) return 2;
  if ((n - (quotientForme(n, 9) -1) * 9)/2 == 1) return 1;
  return 0;
}
//finds the vertical value
int findMy2dArrayValueY(int n)
{
  //J is a temp variable
  int J = quotientForme(n, 9);
  if (J==6 || J ==9 || J ==3) return 2;
  if (J==5 || J ==8 || J ==2) return 1;
  return 0;
}
//ALL FUNCTIONS FOR CONVERSION
//BETWEEN SMALL AND BIG SQUARES
int quotientForme(float num, float divisor)
{
  //this quotient finds the quotient, but if there is no remainder
  //it goes in as the quotient-1;
  if (num/divisor == floor(num/divisor)) return floor(num/divisor); else return floor(num/divisor)+1;
}
void boardBuild()
{
  if (boardWon(bigstate) == 1) gameState = 1; else if (boardWon(bigstate) == 2) gameState = 2;
  if (gameState==0)
  {
    //This is little detail shit
    for (int i=1; i<9; i++)
    {
      //fill in rectangles height wise
      if (i==3 || i ==6) fill(0); else fill(200);
      rect(i*45-5, 0, 5, height);
    }
    for (int i=1; i<9; i++)
    {
      //fill in rectangles
      if (i==3 || i ==6) fill(0); else fill(200);
      rect(0, i*45-5, width, 5);
    }
    //minor error fixing
    fill(0);
    rect(130, 0, 5, height); //
    rect(265, 0, 5, height); //
    //fixing overlap here
    //this is the box win cases
    //Builds the bigBoxes, must be here for optimal viewing :)
  }
  bigBoxStateChecker();

  if (gameState!=0) { //This is for victory
    fill(255);
    rect(0, 0, width, height);
    if (gameState == 1) image(Ex, width/2, height/2, width, height); else if (gameState == 2) image(Oh, width/2, height/2, width, height);
    textAlign(CENTER);
    fill(0);
    text("Press Space to Play Again", width/2, height/2);
    if (spacePressed) resetBoard();
  }
}
//this switches from little to big
//takes input little square
//returns big square that
//it corresponds to
//NOT, its big square
int littletoBig(float num)
{
  //first case is for rows i%3 = 1;
  if (quotientForme(num, 9.0)%3==1) return  floor((num-1)%3)+1;
  //second case is for rows i%3 = 2
  if (quotientForme(num, 9.0)%3==2) return floor((num-1)%3)+4;
  //final case is for i%3 = 0
  if (quotientForme(num, 9.0)%3==0) return floor((num-1)%3)+7; else return 100;
  //the quotient for me is right bove, and the return
  //is pretty understandable
}
int bigFinder(int num)
{
  //a function for finding the biggersquare
  //the pattern for finding it is kinda weird
  //takes little num, num and returns
  //bigger square
  if (num>=1 && num<= 3 ||
    num>=10 && num<= 12 ||
    num>=19 && num<= 21) return 1;
  if (num>=4 && num<= 6 ||
    num>=13 && num<=15 ||
    num>=22 && num<=24) return 2;
  if (num<=27) return 3;
  if (num>=28 && num<=30 ||
    num>=37 && num<=39 ||
    num>=46 && num<=48) return 4;
  if (num>=31 && num<=33 ||
    num>=40 && num<=42 ||
    num>=49 && num<=51) return 5;
  if (num<=54) return 6;
  if (num>=55 && num<=57 ||
    num>=64 && num<=66 ||
    num>=73 && num<=75) return 7;
  if (num>=58 && num<=60 ||
    num>=67 && num<=69 ||
    num>=76 && num<=78) return 8; else return 9;
}
//END OF THESE FUNCTIONS
//winupdater is called everytime a change is made
//This resets the variable in the array of big(x)
//called .state, and is called every time
//the mouse is clicked, bigChanged and smallChanged
//are jsut the last small square, and its bigger square
//and change made is a to let winUpdater know when to run
void winUpdater()
{
  if (changeMade) {
    //bigSquaresArrayer();
    //bbr.boxRating(biggie);
    for (int i=0; i<9; i++) {
      // println(i+": "+bbr.BigSquarePref[i]);
    }
  }
  changeMade = false;
  switch(bigChanged) {
  case 9:
    if (bigstate[9]==0) big9.boxes[findMy2dArrayValueX(smallChanged)] //new line for space saving
    [findMy2dArrayValueY(smallChanged)].state = stateChangedto;
    break;
  case 8:
    if (bigstate[8]==0) big8.boxes[findMy2dArrayValueX(smallChanged)] //new line for space saving
    [findMy2dArrayValueY(smallChanged)].state = stateChangedto;
    break;
  case 7:
    if (bigstate[7]==0) big7.boxes[findMy2dArrayValueX(smallChanged)] //new line for space saving
    [findMy2dArrayValueY(smallChanged)].state = stateChangedto;
    break;
  case 6:
    if (bigstate[6]==0) big6.boxes[findMy2dArrayValueX(smallChanged)] //new line for space saving
    [findMy2dArrayValueY(smallChanged)].state = stateChangedto;
    break;
  case 5:
    if (bigstate[5]==0) big5.boxes[findMy2dArrayValueX(smallChanged)] //new line for space saving
    [findMy2dArrayValueY(smallChanged)].state = stateChangedto;
    break;
  case 4:
    if (bigstate[4]==0) big4.boxes[findMy2dArrayValueX(smallChanged)] //new line for space saving
    [findMy2dArrayValueY(smallChanged)].state = stateChangedto;
    break;
  case 3:
    if (bigstate[3]==0) big3.boxes[findMy2dArrayValueX(smallChanged)] //new line for space saving
    [findMy2dArrayValueY(smallChanged)].state = stateChangedto;
    break;
  case 2:
    if (bigstate[2]==0) big2.boxes[findMy2dArrayValueX(smallChanged)] //new line for space saving
    [findMy2dArrayValueY(smallChanged)].state = stateChangedto;
    break;
  case 1:
    if (bigstate[1]==0) big1.boxes[findMy2dArrayValueX(smallChanged)] //new line for space saving
    [findMy2dArrayValueY(smallChanged)].state = stateChangedto;
    break;
    //Each case passes the arrayx value and arrayy value of the smallsquare-
    //smallchanged. I just made a switch, but maybe i could do a string
    //and append type deal to make it stringByAppendingString("big"+bigChanged)
  }
}
void winCheckerCombined()
{
  if (changeMade==true)
  {
    winUpdater();
  }
  //If a change was made it will run winupdater ^ ^ ^
  //Then if the winCheck of a box is not 0, we assign the
  //big boxes state to be the winCheck, which is an
  //int from 1 to 2
  if (big1.winCheck()!=0) bigstate[1] = big1.winCheck();
  if (big2.winCheck()!=0) bigstate[2] = big2.winCheck();
  if (big3.winCheck()!=0) bigstate[3] = big3.winCheck();
  if (big4.winCheck()!=0) bigstate[4] = big4.winCheck();
  if (big5.winCheck()!=0) bigstate[5] = big5.winCheck();
  if (big6.winCheck()!=0) bigstate[6] = big6.winCheck();
  if (big7.winCheck()!=0) bigstate[7] = big7.winCheck();
  if (big8.winCheck()!=0) bigstate[8] = big8.winCheck();
  if (big9.winCheck()!=0) bigstate[9] = big9.winCheck();
  boardUpdater();
}
void bigBoxStateChecker()
{
  //here- - -  -
  if (bigstate[1]!=0) big1.boxisWon(bigstate[1]);
  if (bigstate[2]!=0) big2.boxisWon(bigstate[2]);
  if (bigstate[3]!=0) big3.boxisWon(bigstate[3]);
  if (bigstate[4]!=0) big4.boxisWon(bigstate[4]);
  if (bigstate[5]!=0) big5.boxisWon(bigstate[5]);
  if (bigstate[6]!=0) big6.boxisWon(bigstate[6]);
  if (bigstate[7]!=0) big7.boxisWon(bigstate[7]);
  if (bigstate[8]!=0) big8.boxisWon(bigstate[8]);
  if (bigstate[9]!=0) big9.boxisWon(bigstate[9]);
}
void buildSmallSquares()
{
  //Just building each individual small square
  //and running its .build() function
  for (int i=0; i<81; i++)
  {
    smallestSquares smally = (smallestSquares) smalls.get(i);
    smally.build();
  }
}
int boardWon(int [] bigstate)
{
  if (bigstate[1] == bigstate[2] && bigstate[2] == bigstate[3]
    && bigstate[3] !=0) return bigstate[3];
  if (bigstate[1] == bigstate[4] && bigstate[4] == bigstate[7]
    && bigstate[7] !=0) return bigstate[7];
  if (bigstate[1] == bigstate[5] && bigstate[5] == bigstate[9]
    && bigstate[9] !=0) return bigstate[9];
  if (bigstate[4] == bigstate[5] && bigstate[5] == bigstate[6]
    && bigstate[6] !=0) return bigstate[6];
  if (bigstate[7] == bigstate[8] && bigstate[8] == bigstate[9]
    && bigstate[9] !=0) return bigstate[9];
  if (bigstate[2] == bigstate[5] && bigstate[5] == bigstate[8]
    && bigstate[8]!=0) return bigstate[8];
  if (bigstate[3] == bigstate[6] && bigstate[6] == bigstate[9]
    && bigstate[9] !=0) return bigstate[9];
  if (bigstate[3] == bigstate[5] && bigstate[5] == bigstate[7]
    && bigstate[7] !=0) return bigstate[7];  
  return 0;
}
void currBoxCheck()
{
  //checks to make sure the box that should be played
  //in isnt filled
  if (bigstate[bigSquarenow]!=0) bigSquarenow = 0;
}
biggerSquares bigObject(int biggerSquare)
{
  if (biggerSquare == 1) return big1; 
  if (biggerSquare == 2) return big2;
  if (biggerSquare == 3) return big3;
  if (biggerSquare == 4) return big4;
  if (biggerSquare == 5) return big5;
  if (biggerSquare == 6) return big6;
  if (biggerSquare == 7) return big7;
  if (biggerSquare == 8) return big8; else return big9;
}
void boardUpdater() {
  for (int i = 0; i < 9; i++) {
    for (int  k = 0; k < 3; k++) {
      for (int l = 0; l < 3; l++) {
        board.big[i].boxes[k][l].state = bigObject(i+1).boxes[k][l].state;
      }
    }
    board.big[i].state = bigstate[i+1];
  }
}
/*void bigSquaresArrayer() {
 biggie[1] = big1;
 biggie[2] = big2;
 biggie[3] = big3;
 biggie[4] = big4;
 biggie[5] = big5;
 biggie[6] = big6; 
 biggie[7] = big7;
 biggie[8] = big8;
 biggie[9] = big9;
 }*/
//reset board function
void resetBoard()
{
  gameState = 0;
  turn = 1;
  bigSquarenow = 0;
  stateChangedto = 0;
  bigChanged = 0;
  smallChanged = 0;
  for (int i=1; i<10; i++)
  {
    bigstate[i] = 0;
  }
  setup(); //Sneaky...sneaky...
}
boolean button(float x, float y, float width, float height, String t, int switcher)
{
  fill(255, 100, 100);
  stroke(0);
  rectMode(CENTER);
  rect(x, y, width, height);
  fill(0);
  textSize(16);
  text(t, x, y+5);
  fill(255, 100, 100);
  rectMode(CORNER);
  if (mouseX > x - width/2 && mouseX < x + width/2 &&
    mouseY > y - height/2 && mouseY < y + height/2) { 
    fill(255, 0, 0);  
    if (mousePressed) return true;
  } 
  if (switcher == difficulty) {
    fill(255, 0, 0);
  }
  if (switcher == highLightNum) {
    fill(255, 0, 0);
  }
  if(switcher == brainViewNum) {
    fill(255, 0, 0); 
  }
  rectMode(CENTER);
  rect(x, y, width, height);
  fill(0);
  textSize(16);
  text(t, x, y+5);
  rectMode(CORNER);
  return false;
}
void startScreen()
{
  background(200);
  textAlign(CENTER);
  textSize(26);
  fill(0);
  text("Ultimate Tic-Tac-Toe", width/2, 75);
  textSize(12);
  text("Created by Poppa Coppa", width/2, 100);
  //Start Button
  if (button(width/2, 150, 60, 25, "Start", 0)) { 
    if (!pauser) { 
      menu = false;
      pauser = true;
    }
  }
  if (button(width/2, 200, 60, 25, "Options", 0)) { 
    if (!pauser) {
      pauser = true;
      options = true;
    }
  }
  if (button(width/2, 250, 60, 25, "Rules", 0)) { 
    if (!pauser) {
      pauser = true;
      Rules = true;
    }
  }
}
void rulesIScreen() { //image displayer
  background(200);
  if (button(width/2, 350, 60, 25, "Back", 0)) { 
    Rules = true;
    pauser = true;
    rulesImageScreen = false;
  }
  if (button(width*1/4, 315, 60, 25, "Left", 0)) { 
    if (!pauser) {
      RulesScreencount--;
      pauser = true;
    }
  }
  if (button(width*3/4, 315, 60, 25, "Right", 0)) { 
    if (!pauser) {
      RulesScreencount++;
      pauser = true;
    }
  }
  if (RulesScreencount < 0) RulesScreencount = 0;
  if (RulesScreencount > 6) RulesScreencount = 6;
  fill(0);
  text(RulesScreencount+"/6", width/2, 330); 
  if (RulesScreencount == 1 || RulesScreencount ==0) {
    pushMatrix();
    translate(70, 15);
    for (int i=1; i<9; i++)
    {
      //fill in rectangles height wise
      if (i==3 || i ==6) fill(0); else fill(200);
      rect(i*30-5, 0, 5, 260);
    }
    for (int i=1; i<9; i++)
    {
      //fill in rectangles
      if (i==3 || i ==6) fill(0); else fill(200);
      rect(0, i*30-5, 260, 5);
    }
    //minor error fixing
    fill(0);
    //rect(130, 0, 5, 300); //
    rect(-5, -5, 270, 5);
    rect(-5, 0, 5, 265);
    rect(260, 0, 5, 260); //
    rect(0, 260, 265, 5);
    if (RulesScreencount == 1) image(Ex, 1, 181, 25, 25);
    popMatrix();
  }
  if (RulesScreencount == 2) {
    pushMatrix();
    translate(70, 15);
    for (int i=1; i<9; i++)
    {
      //fill in rectangles height wise
      if (i==3 || i ==6) fill(0); else fill(200);
      rect(i*30-5, 0, 5, 260);
    }
    for (int i=1; i<9; i++)
    {
      //fill in rectangles
      if (i==3 || i ==6) fill(0); else fill(200);
      rect(0, i*30-5, 260, 5);
    }
    //minor error fixing
    fill(0);
    //rect(130, 0, 5, 300); //
    rect(-5, -5, 270, 5);
    rect(-5, 0, 5, 265);
    rect(260, 0, 5, 260); //
    rect(0, 260, 265, 5);
    image(Ex, 1, 181, 25, 25);
    fill(0, 255, 0);
    stroke(0, 255, 0);
    rect(-5, -5, 95, 5);
    rect(-5, 0, 5, 85);
    rect(-5, 85, 95, 5);
    rect(85, 0, 5, 85);
    popMatrix();
  }
  if (RulesScreencount == 3) {
    pushMatrix();
    translate(70, 15);
    for (int i=1; i<9; i++)
    {
      //fill in rectangles height wise
      if (i==3 || i ==6) fill(0); else fill(200);
      rect(i*30-5, 0, 5, 260);
    }
    for (int i=1; i<9; i++)
    {
      //fill in rectangles
      if (i==3 || i ==6) fill(0); else fill(200);
      rect(0, i*30-5, 260, 5);
    }
    //minor error fixing
    fill(0);
    //rect(130, 0, 5, 300); //
    rect(-5, -5, 270, 5);
    rect(-5, 0, 5, 265);
    rect(260, 0, 5, 260); //
    rect(0, 260, 265, 5);
    image(Ex, 1, 181, 25, 25);
    fill(0, 255, 0);
    stroke(0, 255, 0);
    rect(-5, -5, 95, 5);
    rect(-5, 0, 5, 85);
    rect(-5, 85, 95, 5);
    rect(85, 0, 5, 85);
    image(Oh, 58, -2, 30, 30);
    popMatrix();
  }
  if (RulesScreencount == 4) {
    pushMatrix();
    translate(70, 15);
    for (int i=1; i<9; i++)
    {
      //fill in rectangles height wise
      if (i==3 || i ==6) fill(0); else fill(200);
      rect(i*30-5, 0, 5, 260);
    }
    for (int i=1; i<9; i++)
    {
      //fill in rectangles
      if (i==3 || i ==6) fill(0); else fill(200);
      rect(0, i*30-5, 260, 5);
    }
    //minor error fixing
    fill(0);
    //rect(130, 0, 5, 300); //
    rect(-5, -5, 270, 5);
    rect(-5, 0, 5, 265);
    rect(260, 0, 5, 260); //
    rect(0, 260, 265, 5);
    image(Ex, 1, 181, 25, 25);
    fill(0, 255, 0);
    stroke(0, 255, 0);
    rect(175, -5, 90, 5);
    rect(175, 0, 5, 90);
    rect(175, 85, 90, 5);
    rect(260, 0, 5, 85);
    image(Oh, 58, -2, 30, 30);
    popMatrix();
  }
  if (RulesScreencount == 5) {
    pushMatrix();
    translate(70, 15);
    for (int i=1; i<9; i++)
    {
      //fill in rectangles height wise
      if (i==3 || i ==6) fill(0); else fill(200);
      rect(i*30-5, 0, 5, 260);
    }
    for (int i=1; i<9; i++)
    {
      //fill in rectangles
      if (i==3 || i ==6) fill(0); else fill(200);
      rect(0, i*30-5, 260, 5);
    }
    //minor error fixing
    fill(0);
    //rect(130, 0, 5, 300); //
    rect(-5, -5, 270, 5);
    rect(-5, 0, 5, 265);
    rect(260, 0, 5, 260); //
    rect(0, 260, 265, 5);
    image(Ex, 1, 181, 25, 25);
    fill(0, 255, 0);
    stroke(0, 255, 0);
    rect(175, -5, 90, 5);
    rect(175, 0, 5, 90);
    rect(175, 85, 90, 5);
    rect(260, 0, 5, 85);
    image(Oh, 58, -2, 30, 30);
    image(Ex, 210, 30, 25, 25);
    popMatrix();
  }
  if (RulesScreencount==6) {
    for (int i=0; i<moveExplain.length; i++) {
      fill(0);
      textSize(12);
      text(moveExplain[i], width/2, 50+15*i);
    }
  }
}
void ruleScreen() {
  background(200); 
  textAlign(CENTER);
  textSize(26);
  fill(0);
  text("Rules", width/2, 100); //Start of rules txt
  //Lets read a rules txt file and display for 
  //fun!
  textSize(12);
  try {
    for (int i=0; i<rules.length;i++) {
      textSize(12);
      if (i == 5) {
        if (mouseX>width*1/4 && mouseX<width*3/4 &&
          mouseY>215 && mouseY<230) {
          fill(255, 0, 0);
          if (mousePressed) {
            Rules = false; 
            rulesImageScreen = true;
          }
        } else textSize(12);
      } else fill(0);
      text(rules[i], width/2, 150+15*i);
    }
  } 
  catch(Exception E) {
    text("Rules Unavailable", width/2, 150);
  }
  if (button(width/2, 350, 60, 25, "Back", 0)) {
    if (!pauser) { 
      Rules = false;
      pauser = true;
    }
  }
}
void optionScreen()
{
  background(200); 
  textAlign(CENTER);
  textSize(26);
  fill(0);
  text("Options", width/2, 100);
  //Start Button
  if (button(width/2, 150, 60, 25, "Back", 0)) { 
    options = false;
    pauser = true;
  }
  text("Computer:", width/2-150, 200+5);
  if (button(width/2-65, 200, 65, 25, "Easy", 1)) {
    //NEWYORK!
    computer = true;
    difficulty = 1;
  }
  if (button(width/2, 200, 65, 25, "Medium", 2)) {
    //NEWYORK
    if (!pauser) {
      computer = true;
      difficulty = 2;
    }
  }
  if (button(width/2+65, 200, 65, 25, "Hard", 3)) {
    //NEWYORK!
    computer = true;
    difficulty = 3;
  }
  if (button(width/2+130, 200, 65, 25, "Off", 4)) {
    //NEWYORK!
    computer = false;
    difficulty = 4;
  }
  text("Hightlights:", width/2-145, 250+5);
  if (button(width/2-40, 250, 65, 25, "On", 5)) {
    highLight = true;
    highLightNum = 5;
  }
  if (button(width/2+40, 250, 65, 25, "Off", 6)) {
    highLight = false;
    highLightNum = 6;
  }
  text("Brain view:", width/2-145, 300+5);
  if (button(width/2-40, 300, 65, 25, "On", 7)) {
    brainViewNum = 7;
    brainView = true;
  }
  if (button(width/2+40, 300, 65, 25, "Off", 8)) {
    brainViewNum = 8;
    brainView = false;
  }
}
void drawHighlight() {
  int x = 0;
  int y = 0;
  int width = 0;
  int height = 0;
  if (bigSquarenow != 0) {
    if (bigSquarenow <= 3) {
      y = -5;
      height = 138;
    } else if (bigSquarenow <= 6) {
      y = 133;
      height = 133;
    } else if (bigSquarenow <=9 ) {
      y = 268;
      height = 133;
    }
    if (bigSquarenow%3 == 1) {
      x = -5;
      width = 138;
    } else if (bigSquarenow%3 == 2) {
      x = 133;
      width = 133;
    } else {
      x = 268;
      width = 133;
    }
    stroke(255, 0, 0);
    noFill();
    strokeWeight(5);
    rect(x, y, width, height);
    stroke(0);
    strokeWeight(1);
  }
}
void draw()
{
  if (!menu)
  {
    //START OF TIC TAC TOE CODE
    if (turn == 2 && computer) {
      thinking = true; //Need this so .start() is only called once
      //
      if (thread2 == null) {
        println("Starting...");
        //thread1.run();
        thread2 = new BrainThread2(board, bigSquarenow);
        thread2.start();
      } else {
        if (!thread2.running()) {
          thread2 = null;
          thinking = false;
        }
      }
    } else { //if (!thinking) {
      stroke(0);
      //Function that builds board
      //if(!thinking) 
      if(brainView || !thinking) buildSmallSquares();
      if (!thinking) boardBuild();
      //Inside boardBuild is the winstate checkers
      //This functions checks for the availibiity
      //of the current box
      if (!thinking) currBoxCheck();
      if (highLight && !thinking) drawHighlight();
      //END OF TIC TAC TOE CODE
    }
  } //START OF MENU CODE 
  else if (options) {
    optionScreen();
  } else if (Rules) {
    ruleScreen();
  } else if (rulesImageScreen) {
    rulesIScreen();
  } else startScreen();
}
/*void findTwoinaRows(biggerSquares big1) {
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
 println("RAN");
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
 }*/
