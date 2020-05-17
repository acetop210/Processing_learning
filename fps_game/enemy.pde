class Enemy{
  PVector pos;
  PVector speed;
  PVector tar;
  PVector orpos;
  float size;
  color col;
  long enemyframe=0;
  
  Enemy(float x, float y, float z){
    //float rx=random(0,1250);
    //float ry=random(0,height*2/3);
    //float rz=random(0,1250);
    pos = new PVector(x,y,z);
    orpos = new PVector(x,y,z);
    tar = new PVector(0,0,0);
    size = random(25-level, 100);
    col = color(int(random(0,255)),int(random(0,255)),int(random(0,255)));
  }
  
  void move(){
    if(enemyframe%60==0){
      float x = random(-30,30);
      float y = 0;
      float z = random(-30,30);
      tar = new PVector(x,y,z);
    }
    speed = tar;
    speed.setMag(3);
    speed.limit(8+level*0.3);
    if(pos.x+speed.x>orpos.x+200 || pos.x+speed.x<orpos.x-200) speed.x=-speed.x;
    if(pos.z+speed.z>orpos.z+200 || pos.z+speed.z<orpos.x-200) speed.z=-speed.z;
    pos.add(speed);
  }
  
  void edraw(){
    enemyframe++;
    move();
    fill(col);
    translate(pos.x,pos.y,pos.z);
    sphere(size);
    translate(-pos.x,-pos.y,-pos.z);
  }
}
