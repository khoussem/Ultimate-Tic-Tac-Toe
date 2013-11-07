public class bigBoxPatterns {
  Board board;
  ArrayList<PVector> twoInARows;
  int bNum = 0;
  int turn = 0;
  public bigBoxPatterns(Board bored, int sNum, int state) {
    board = bored;
    bNum = sNum;
    turn = state;
  }
  void findTwos() {
    for(int i = 0; i < 3; i++) {
      for(int j = 0; j < 3; j++) {
        if(board.big[bNum].canBeWon(i, j, turn)) twoInARows.add(new PVector(i, j));
      }
    }
  }
  

}
