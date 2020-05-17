class bullet{
  float power;
  PVector tar;
  PVector pos;
  PVector speed;
  
  bullet(float cx, float cy, float cz, float x, float y, float z){
    power=1;
    pos = new PVector(cx,cy,cz);
    tar = new PVector(x,y,z);
    speed = PVector.sub(tar,pos);
    speed.setMag(50+level);
  }
  
  void move(){
    pos.add(speed);
  }
  
  void bdraw(boolean me){
    move();
    noStroke();
    if(me) fill(255,0,0);
    else fill(0,255,0);
    translate(pos.x,pos.y,pos.z);
    sphere(3);
    stroke(0);
    translate(-pos.x,-pos.y,-pos.z);
  }
}
