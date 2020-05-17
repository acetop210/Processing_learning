import ddf.minim.*;

fpCamera mainCamera;
PImage red;
PImage playimg;
PImage zoom;
PImage playimg2;
int rebullcnt;
int scene=0;
int hp=100;
int score=0;
int bulletcnt;
int warncnt;
int level;
long framecnt=0;
String warnstr;
boolean clear = false;
boolean reloading = false;
boolean hit = false;
boolean shooting = false;

Minim minim;
AudioPlayer basesound;
AudioPlayer shotsound;
AudioPlayer hitsound;
AudioPlayer reloadsound;

void setup(){
  size(1280,600,P3D);
  mainCamera = new fpCamera();
  red = loadImage("red.png");
  playimg = loadImage("play.jpg");
  zoom = loadImage("aim.png");
  playimg2 = loadImage("play2.png");
  
  minim = new Minim(this);
  basesound = minim.loadFile("backgroundaudio.mp3");
  basesound.play();
}

void draw(){
  framecnt++;
  background(0);
  drawsomething();
}

void drawsomething(){
  if(framecnt%(160*60)==0){
    basesound.close();
    basesound = minim.loadFile("backgroundaudio.mp3");
    basesound.play();
  }
  if(scene==0) drawStart();
  if(scene==1) drawPlay();
  if(scene==2) drawOver();
}

void drawEnv(){
  float ground = height*2/3;
  int boxnum = 50;
  fill(198,101,35); 
  //바닥
  for(int z=0; z<boxnum; z++)
    for(int x=0; x<boxnum; x++)
      block(x*50,ground,z*50,50);
}

void drawPlay(){
  if(hp==0){
    scene=2;
    return;
  }
  if(hit)background(playimg2);
  else background(playimg);
  fill(255);
  textSize(24);
  camera();
  text("HP: "+hp,10,32);
  text("SCORE: " + mainCamera.enemynum*10 +"/"+score, width - 200, 32);
  text("Bullet: "+bulletcnt, width-160, 100);
  mainCamera.camTrans();
  drawEnv();
  mainCamera.drawpointer();
}

void drawStart(){
  background(0);
  fill(255);
  camera();
  textSize(30);
  text("Select level 0~9 to start",width/2-160, height/2,-100);
  if(keyPressed && '0'<=key && key<='9'){
    scene=1;
    level=int(key)-48;
    mainCamera.makeEnemy();
    rebullcnt=10+level;
    bulletcnt=rebullcnt;
  }
}

void drawOver(){
  if(clear) background(0,250,0);
  else background(250,0,0);
  fill(255);
  camera();
  textSize(30);
  if(clear) text("Clear!!!",width/2-70, height/2-100,-100);
  text("Press space to restart",width/2-150, height/2,-100);
  text("Press x to exit",width/2-100, height/2+100,-100);
  if(keyPressed && key==' ') mainCamera.reset();
  if(keyPressed && key =='x') exit();
}
