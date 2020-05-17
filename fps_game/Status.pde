class Status {
  int hp;
  int score;
  
  Status(){
    hp = 100;
    score=0;
  }
  
  void showStatus(){
    pushMatrix();
      float x = modelX(0,0,0);
      float y = modelY(0,0,0);
      float z = modelZ(0,0,0);
      translate(x,y,z);
      textSize(25);
      text("HP is"+" "+str(hp),0,0);
      text("Score is"+" "+str(score),0,30);
    popMatrix();
  }
}
