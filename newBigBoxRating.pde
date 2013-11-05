 /* To analyze a box we need to:
  * Find out how many winning patterns its a part of
  * And combine that number with the likely hood of that
  * pattern being won. So we need to give each box a likelyhood
  * of being won. Keep in mind we dont care about the next bigSq
  * So first
  */
public class newBigBoxRating {
  Board board;
  int [][] numPatterns;
  int state;
  int otherState;
  newBigBoxRating(Board bored, int s) {
    board = bored;
    state = s;
    otherState = (s % 2) + 1;
    numPatterns = new int[3][3];
    numPatterns[0][0] = 3;
    numPatterns[0][2] = 3;
    numPatterns[2][0] = 3;
    numPatterns[2][2] = 3;
    numPatterns[1][2] = 2;
    numPatterns[2][1] = 2;
    numPatterns[0][1] = 2;
    numPatterns[1][0] = 2;
    numPatterns[1][1] = 4;
  }
  int rateMe(int bigSqNum) {
    return 1;
  }
  void findBigPatterns() {
    int i;
    for(i = 0; i < 3; i++) {
     // if(board.big[i][0].state == otherState) break; 
    } 
    if(i != 4) {
      //numPatterns[
    }
  }
    private class winPattern {
     // int 
    }
}
