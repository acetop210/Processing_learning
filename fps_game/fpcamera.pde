
class fpCamera{
  PVector cpos;
  PVector cvel;
  PVector cacc;
  
  ArrayList barr = new ArrayList();
  ArrayList earr = new ArrayList();
  ArrayList ebarr = new ArrayList();
  float topspeed = 7;
  int enemynum;
  long framecnt;
  long bframecnt;
  long hitframe;
  
  fpCamera(){
    //cpos = new PVector(width/2, height/2, (height/2) / tan(PI*30 / 180));
    cpos = new PVector(width/2, height/2-100, (height/2) / tan(PI*30 / 180));
    cvel = new PVector(0,0,0);
    framecnt=0;
    bframecnt=0;
  }
  
  void makeEnemy(){
    enemynum=5+level;
    for(int i=0; i<enemynum; i++){
      Enemy enemy = new Enemy(random(0,1200),0,random(0,1200));
      earr.add(enemy);
    }
  }
  
  void enemyact(){
    for(int i=0; i<earr.size(); i++){
      Enemy e =(Enemy) earr.get(i);
      if(e.enemyframe%int(random(60,180-level*3))==55){
        bullet bul = new bullet(e.pos.x,e.pos.y,e.pos.z,cpos.x,cpos.y,cpos.z);
        ebarr.add(bul);
      }
      e.edraw();
    }
  }
  
  void bulletact(){
    for(int i=0; i<barr.size(); i++){
      bullet bul =(bullet) barr.get(i);
      bul.bdraw(true);
    }
    
    for(int i=0; i<ebarr.size(); i++){
      bullet bul =(bullet) ebarr.get(i);
      bul.bdraw(false);
    }
  }
  
  void Reload(){
    if(keyPressed&&key=='r'&&bulletcnt==0){
      warncnt=90;
      warnstr="Reloading...";
      reloading=true;
    }
  }
  
  void warn(){
    if(warncnt>0){
      if(warncnt%30==0){
        reloadsound = minim.loadFile("reload.wav");
        reloadsound.play();
      }
      pushMatrix();
      noLights();
      resetMatrix();
      fill(255);
      camera();
      noStroke();
      int alpha = (warncnt-1)%60*255/60;
      fill(230,10,10,alpha);
      rectMode(CENTER);
      rect(width/2,height/2-200,500,100);
      textAlign(CENTER,CENTER);
      fill(255,255,255,alpha);
      textSize(60);
      text(warnstr,width/2,height/2-200);
      textAlign(LEFT,LEFT);
      popMatrix();
      warncnt--;
      stroke(0);
    }
    if(warncnt==0 && reloading){
      bulletcnt=rebullcnt;
      reloading = false;
    }
  }
  
  boolean collide(bullet b, Enemy e){
    float dis = sqrt(pow(b.pos.x-e.pos.x,2)+pow(b.pos.y-e.pos.y,2)+pow(b.pos.z-e.pos.z,2));
    if(dis<e.size+6) return true;
    return false;
  }
  
  void bulletcollision(){
    for(int i=0; i<barr.size(); i++){
      bullet bul = (bullet) barr.get(i);
      for(int j=0; j<earr.size(); j++){
        Enemy enemy = (Enemy) earr.get(j);
        if(collide(bul, enemy)){
          if(barr.size()>i) barr.remove(i);
          if(earr.size()>j)earr.remove(j);
          score+=10;
          hitsound = minim.loadFile("hit.wav");
          hitsound.play();
        }
      }
    }
    for(int i=0; i<ebarr.size(); i++){
      bullet b = (bullet) ebarr.get(i);
      float dis = sqrt(pow(b.pos.x-cpos.x,2)+pow(b.pos.y-cpos.y,2)+pow(b.pos.z-cpos.z,2));
      if(dis<30){
        if(ebarr.size()>i) ebarr.remove(i);
        hp-=10;
        hit = true;
        hitframe=framecnt;
      }
    }
  }
  
  void drawpointer(){
    hint(DISABLE_DEPTH_TEST);
    pushMatrix();
    noLights();
    resetMatrix();
    camera();
    stroke(255);
    noFill();
    ellipse(width/2,height/2,30,30);
    int x,y;
    if(shooting){
      x=20;
      y=10;
      shooting=false;
    }
    else{
      x=50;
      y=35;
    }
    line(width/2,height/2+x,width/2,height/2+y);
    line(width/2,height/2-x,width/2,height/2-y);
    line(width/2+x,height/2,width/2+y,height/2);
    line(width/2-x,height/2,width/2-y,height/2);
    stroke(0);
    popMatrix();
    hint(ENABLE_DEPTH_TEST);
  }
    
boolean chOut(){
    if(cpos.x<0||cpos.x>2550||cpos.z<0||cpos.z>2550) return true;
    return false;
  }
  
  void camTrans(){
    if(score==enemynum*10){
      scene=2;
      clear=true;
      return;
    }
    if(chOut()) scene=2;
    framecnt++;
    Reload();
    warn();
    if(hit&&framecnt-hitframe>20) hit=false;
    pushMatrix();
      translate(cpos.x,cpos.y,cpos.z);
      rotateY(-(float)(mouseX-640)/width*8*PI);
      float x = 0;
      float y = map(mouseY,0,height,-700,700);
      float z = -200;
      float mx = modelX(x,y,z);
      float my = modelY(x,y,z);
      float mz = modelZ(x,y,z);
    popMatrix();
    
   // drawpointer();
    camera(cpos.x,cpos.y,cpos.z,mx,my,mz,0,1,0);
    
    enemyact();
    bulletact();
    bulletcollision();
    
    if(keyPressed){
      if(key=='w'||key=='s'){
        PVector target = new PVector(mx,cpos.y,mz);
        cacc = PVector.sub(target,cpos);
        if(key=='w')cacc.setMag(5);
        else if(key=='s') cacc.setMag(-5);
        cvel.add(cacc);
        cvel.limit(topspeed);
        cpos.add(cvel);
      }
    }
   if(mousePressed){
     if(mouseButton==LEFT&&bulletcnt!=0&&(framecnt-bframecnt>10)){
       bframecnt = framecnt;
       bulletcnt--;
       bullet bul = new bullet(cpos.x,cpos.y,cpos.z,mx,my,mz);
       barr.add(bul);
       shooting = true;
       shotsound = minim.loadFile("gunshot.wav");
       shotsound.play();
    }
   }
  }
  
  void reset(){
    hp=100;
    score=0;
    clear = false;
    hit = false;
    reloading=false;
    warncnt=0;
    bulletcnt=rebullcnt;
    for(int i=barr.size()-1; i>=0; i--) barr.remove(i);
    for(int i=earr.size()-1; i>=0; i--) earr.remove(i);
    for(int i=ebarr.size()-1; i>=0; i--) ebarr.remove(i);
    cpos = new PVector(width/2, height/2-100, (height/2) / tan(PI*30 / 180));
    cvel = new PVector(0,0,0);
    scene=0;
    framecnt=0;
    bframecnt=0;
  }
}
