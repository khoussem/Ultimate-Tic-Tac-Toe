class Board {
  int turn = 0; //1 is min, 2 is max!!
  int nextSquare = 0;
  boardbigSquares [] big = new boardbigSquares[9];
  int [] bigStates = new int [10];
  int squareNow;
 Board() {
  for(int i=0; i < 9; i++) {
   big[i] = new boardbigSquares(i+1); 
  }
 }
 int positionJudge(int squareNow) {
  //HEURISTICAL INCLINATIONS ONLY PLEASE
  if(gameDone()) {
    //If the board has been won 
   if(gameFinished() == 1) {
     //If our opponent won then we return BAD
     return 0;
   } else {
     //If we won the board
    // return maxScore();
   } 
  } else {
    //Here what we want to do is first judge the bigboxs, using bigbox rating,
    //Then, combining the current square, along with whose turn it is (and the big box rating of said square)
    //We will judge the position, and return a value between 0 and maxScore
    
  }
  return floor(random(0, 10));
  //Default fail case
 // return 0;
 }
 void makeMove(int i, int squareNow) {
  big[squareNow-1].makeMove(i, turn);
 }
 void unmakeMove(int i, int squareNow) {
 big[squareNow-1].unmakeMove(i); 
 }
 boolean possibleMove(int i, int squareNow) {
   return big[squareNow-1].possibleMove(i);
 }
 boolean gameDone() {
  if(gameFinished() > 0) return true;
  else return false; 
 }
 int gameFinished() { 
 //Returns who won
 //Horizontal cases
 if(bigStates[1] == bigStates[2] && bigStates[2]==bigStates[3]) {
  return bigStates[1]; 
 }
 if(bigStates[6] == bigStates[4] && bigStates[4]==bigStates[5]) {
  return bigStates[4];
 }
 if(bigStates[8] == bigStates[7] && bigStates[7]==bigStates[9]) {
  return bigStates[7]; 
 }
 //Vertical
 if(bigStates[1] == bigStates[4] && bigStates[4]==bigStates[7]) {
  return bigStates[1]; 
 }
 if(bigStates[2] == bigStates[5] && bigStates[5]==bigStates[8]) {
  return bigStates[2];
 }
 if(bigStates[3] == bigStates[6] && bigStates[6]==bigStates[9]) {
  return bigStates[3]; 
 }
 //Diagonal
 if(bigStates[1] == bigStates[5] && bigStates[5]==bigStates[9]) {
  return bigStates[1]; 
 }
 if(bigStates[3] == bigStates[5] && bigStates[5]==bigStates[7]) {
  return bigStates[3];
 }
 return 0;
 } 
}
