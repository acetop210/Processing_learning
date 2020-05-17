PImage pencil;
PImage eraser;
PImage plus;
PImage minus;
PImage save;
PImage ellipse;
PImage rect;
PImage line;
PImage circle;
PImage paint;
PImage result;
PImage saveimg;
int framecnt=0;
int bframecnt=0;
int icwidth = 60;
int icheight = 60;
int icIv = 85;
int pWeight = 1;
int eWeight = 1;
color pColor = color(0,0,0); 
int R=0;
int G=0;
int B=0;
int sx;
int sy;
int type=0;
int cf = 100;
int paltype=0;
int gtype=0;
int presscnt=0;
int ellnum=0;
int recnum=0;
int cirnum=0;
boolean coloring=false;
boolean saving = false;
boolean nameIp = false;
String saveName="";
String fileName="";
color[] colarr = {color(0,0,0), color(84,0,0),color(128,0,0), color(255,0,0),color(248, 143, 37),color(255, 212, 0),color(111, 191, 0),
color(0, 167, 55),color(0, 143, 191),color(0, 0, 191),color(94, 0, 191),color(230, 0, 115),color(255,255,255),color(192,192,192),
color(191, 134, 134),color(255, 178, 178),color(255, 217, 178),color(255, 244, 127),color(210, 255, 76),color(109, 218, 145),
color(115, 210, 230),color(96, 135, 191),color(173, 143, 204),color(230, 172, 201)};
color[] px = new color[1499+899*1500+1];

Button pbtn;
Button ebtn;
Button sbtn;
Button colbtn;
wButton plusbtn;
wButton minusbtn;
wButton ellbtn;
wButton recbtn;
wButton libtn;
Pallet[] pals;
ellClass[] ellCs;

void setup() {

  size(1500, 900);

  background(200, 240, 240);

  fill(255);

  noStroke();

  rect(25, 125, 1150, 750);//sketchbook
  
  pencil = loadImage("pencil.png");
  eraser = loadImage("eraser.png");
  plus = loadImage("plus.png");
  minus = loadImage("minus.png");
  save = loadImage("save.png");
  ellipse = loadImage("ellipse.png");
  rect = loadImage("rect.png");
  circle = loadImage("circle.png");
  line = loadImage("line.png");
  paint = loadImage("paint.png");
  
  
  pbtn = new Button(25, 25, pencil);
  ebtn = new Button(25+icIv, 25, eraser);
  sbtn = new Button(940+icIv, 25, save);
  colbtn = new Button(1200, 200+icIv, paint);
  
  plusbtn = new wButton(25+icIv*5-8,40,plus);
  minusbtn = new wButton(25+icIv*2,40,minus);
  ellbtn = new wButton(1200, 125, ellipse);
  recbtn = new wButton(1240, 125, rect);
  libtn = new wButton(1240,165,line);
  
  pals = new Pallet[24];
  for(int i=0; i<24; i++){
    Pallet pal;
    if(i<12){ 
      pal = new Pallet(500+40*i, 25, colarr[i]);
    }
    else{
      pal = new Pallet(500+40*(i-12), 66, colarr[i]);
    }
    pals[i] = pal;
  }
  
  ellCs = new ellClass[1000000];
}


void draw(){
  framecnt++;
  if(key == 'x' && keyPressed){
    fill(255);
    noStroke();
    rect(25, 125, 1150, 750);
  }
  if(pbtn.isClicked()){
    type=1;
    gtype=0;
  }
  if(ebtn.isClicked()){
    type=2;
    gtype=0;
  }
  if(colbtn.isClicked()) coloring = true;
  pencilF();
  eraserF();
  colF();
  palF();
  plusbtn.display();
  minusbtn.display();
  pmF();
  viewStroke();
  if(colbtn.isClicked()) coloring = true;
  geoShow();
  geoDraw();
  sbtn.display(180);
  if(sbtn.isClicked() || key=='s'){
    saving=true;
    nameIp=true;
  }
  if(saving){
    sbtn.display(100);
    saveF();
    fileName="Input file name";
  }
}

///Button class
class Button{
  int bx;
  int by;
  int bwidth = 70;
  int bheight = 70;
  PImage bimg;
  
  Button(int x, int y, PImage img){
    bx = x;
    by = y;
    bimg = img;
  }
  
  void display(int f){
    fill(f);
    rect(bx, by, bwidth, bheight);
    image(bimg, bx+5, by+5, icwidth, icheight);  
  }
  
  boolean isClicked(){
    if(mouseX>bx && mouseX<bx+bwidth && mouseY>by && mouseY<by+bheight && mousePressed) return true;
    return false;
  }
}


//wButton class
class wButton{
  int wbx;
  int wby;
  int wbwidth = 35;
  int wbheight = 35;
  PImage wbimg;
  
  wButton(int x, int y, PImage img){
    wbx=x;
    wby=y;
    wbimg=img;
  }
  
  void display(){
    fill(255);
    strokeWeight(2);
    rect(wbx,wby,wbwidth,wbheight);
    image(wbimg, wbx+2.5, wby+2.5, 30, 30);
  }
  
  boolean isClicked(){
    if(mouseX>wbx && mouseX<wbx+wbwidth && mouseY>wby && mouseY<wby+wbheight && mousePressed) return true;
    return false;
  }
  
}


//Pallet class
class Pallet{
  color palcol;
  int palx;
  int paly;
  int palwidth;
  int palheight;
  
  Pallet(int x, int y, color col){
    palx=x;
    paly=y;
    palcol=col;
  }
  
  void display(boolean selected){
    if(selected){
      fill(180);
      pColor = palcol;
    }
    else fill(225);
    strokeWeight(2);
    rect(palx,paly,35,35);
    fill(palcol);
    rect(palx+2.5,paly+2.5,30,30);
    strokeWeight(0);
  }
  
  boolean isSelected(){
    if(palx<mouseX && mouseX<palx+35 && paly<mouseY && mouseY<paly+35 && mousePressed) return true;
    return false;
  }
}


//shpae class
class ellClass{
  int cornerx;
  int cornery;
  float ellwidth;
  float ellheight;
  float ellwidth2;
  float ellheight2;
  boolean ellcolor;
  boolean clicked = false;
  color stcol;
  int stweight;
  boolean keyPr;
  char keyy;
  
  ellClass(int x, int y, float w, float h, color c, int st, boolean keyP, char keyyy){
    cornerx=x;
    cornery=y;
    ellwidth=w;
    ellheight=h;
    stcol = c;
    stweight = st;
    keyPr = keyP;
    keyy = keyyy;
  }
  
  void isClicked(){
    if(keyPr && keyy=='c'){
     ellwidth2 =  (ellwidth)/abs(ellwidth+0.1)*sqrt(pow(ellwidth,2)+pow(ellheight,2));
     ellheight2 = (ellheight)/abs(ellheight+0.1)*sqrt(pow(ellwidth,2)+pow(ellheight,2));
    }
    else{
      ellwidth2 = ellwidth;
      ellheight2 = ellheight;
    }
    if(ellwidth2>0 && ellheight2>0 && mouseX>cornerx && mouseX<(cornerx+ellwidth2)*0.95 && mouseY>cornery && mouseY<(cornery+ellheight2)*0.95 && mousePressed) clicked=true;
    if(ellwidth2<0 && ellheight2>0 && mouseX<cornerx && mouseX>(cornerx+ellwidth2)*0.95 && mouseY>cornery && mouseY<(cornery+ellheight2)*0.95 && mousePressed) clicked=true;
    if(ellwidth2<0 && ellheight2<0 && mouseX<cornerx && mouseX>(cornerx+ellwidth2)*0.95 && mouseY<cornery && mouseY>(cornery+ellheight2)*0.95 && mousePressed) clicked=true;
    if(ellwidth2>0 && ellheight2<0 && mouseX>cornerx && mouseX<(cornerx+ellwidth2)*0.95 && mouseY<cornery && mouseY>(cornery+ellheight2)*0.95 && mousePressed) clicked=true;
  }
  
  void display(int sh){
    isClicked();
    if(clicked && ellcolor) fill(pColor);
    else clicked=false;
    ellipseMode(CORNER);
    rectMode(CORNER);
    strokeWeight(stweight);
    stroke(stcol);
    if(sh==1)ellipse(cornerx,cornery,ellwidth2,ellheight2);
    else rect(cornerx,cornery,ellwidth2,ellheight2);
    fill(0);
  }
}


boolean backgroundCh(){
  if(mouseX>30 && mouseY>130 && pmouseX>30 && pmouseY>130 && mouseX<1170 && pmouseX<1170 && mouseY<870 && pmouseY<870) return true;
  return false;
}


//func pencilF
void pencilF(){
  if(type==1){
    cf=100;
    cursor(pencil,2,27);
    if(key == 'r') pColor+=color(5,0,0);
    if(key == 'g') pColor+=color(0,5,0);
    if(key == 'b') pColor+=color(0,0,5);
    if(mousePressed && backgroundCh()){
      strokeWeight(pWeight);
      stroke(pColor);
      line(mouseX,mouseY,pmouseX,pmouseY);
    }
  }
  else cf=180;
  stroke(0);
  strokeWeight(0);
  pbtn.display(cf);
}


//func eraserF
void eraserF(){
  if(type==2){
    cf=100;
    cursor(eraser,2,27);
    if(mousePressed && backgroundCh()){
      strokeWeight(eWeight);
      stroke(255);
      line(mouseX,mouseY,pmouseX,pmouseY);
    }
  }
  else cf=180;
  stroke(0);
  strokeWeight(0);
  ebtn.display(cf);
}


//func colF
void colF(){
  if(coloring && gtype!=0){
    cf=100;
    cursor(paint,2,27);
  }
  else{
    coloring = false;
    cf=180;
  }
  colbtn.display(cf);
}

//func pmF
void pmF(){
  if(type==1 || gtype!=0){
    if(plusbtn.isClicked() && pWeight<30) pWeight+=1;
    if(minusbtn.isClicked() && pWeight>1) pWeight-=1;
  }
  if(type==2){
    if(plusbtn.isClicked() && eWeight<30) eWeight+=1;
    if(minusbtn.isClicked() && eWeight>1) eWeight-=1;
  }
}


//func viewStroke
void viewStroke(){
  fill(200, 240, 240);
  noStroke();
  rect(235, 25, 205, 60);
  if(type==1 || gtype!=0){
    stroke(pColor);
    strokeWeight(pWeight);
  }
  if(type==2){
    stroke(255);
    strokeWeight(eWeight);
  }
  noFill();
  bezier(270, 55, 290, 25, 340, 85, 390, 55);
  stroke(0);
  strokeWeight(0);
}


//func Pallet
void palF(){
  for(int i=0; i<24; i++){
    if(pals[i].isSelected()) paltype=i;
  }
  for(int i=0; i<24; i++){
    pals[i].display(paltype==i);
  }
}

void namekey(){
  if(saving && keyPressed && (framecnt-bframecnt)>8){
    bframecnt=framecnt;
    if(key == ENTER && saveName!=""){
      nameIp=false;
      bframecnt=0;
    }
    else if('A'<=key && key<='z'){
      saveName += key;
    }
  }
}
//func save
void saveF(){
  if(nameIp){
    textSize(30);
    text(fileName,940+2*icIv,25);
    namekey();
    text(saveName,940+2*icIv,60);
  }
  else{
    save("result/"+saveName+".png");
    result = loadImage("result/"+saveName+".png");
    saveimg = result.get(25,125,1150,750);
    saveimg.save("result/"+saveName+".png");
    saving=false;
    saveName="";
    strokeWeight(0);
    fill(200, 240, 240);
    rect(940+2*icIv,1,500,75);
    fill(0);
  }
}

void geoShow(){
  ellbtn.display();
  recbtn.display();
  libtn.display();
}

void geoDraw(){
  if(ellbtn.isClicked()){
    if(coloring) coloring=false;
    gtype=1;
  }
  else if(recbtn.isClicked()){
    if(coloring) coloring=false;
    gtype=2;
  }
  else if(libtn.isClicked()){
    if(coloring) coloring=false;
    gtype=3;
  }
  if(gtype==0) return;
  type=0;
  if(coloring == false)cursor(CROSS);
  if(gtype==1) drawEll();
  if(gtype==2) drawRec();
  if(gtype==3) drawLine();
}


void drawEll(){
  if(mousePressed && mouseButton==LEFT && backgroundCh()){
   if(presscnt==0){
     sx=mouseX;
     sy=mouseY;
     presscnt++;
   } 
   pixUpdate();
   if(coloring == false) ellCs[++ellnum] = new ellClass(sx,sy,mouseX-sx,mouseY-sy,pColor,pWeight, keyPressed, key);
   else ellCs[ellnum].ellcolor = true;
   ellCs[ellnum].display(1);
  }
  else{
    copyPixel();
    presscnt=0;
  }
  strokeWeight(0);
  stroke(0);
}

void drawRec(){
  if(mousePressed && mouseButton==LEFT && backgroundCh()){
   if(presscnt==0){
     sx=mouseX;
     sy=mouseY;
     presscnt++;
   } 
   pixUpdate();
   if(coloring == false) ellCs[++ellnum] = new ellClass(sx,sy,mouseX-sx,mouseY-sy,pColor,pWeight, keyPressed, key);
   else ellCs[ellnum].ellcolor = true;
   ellCs[ellnum].display(2);
  }
  else{
    copyPixel();
    presscnt=0;
  }
  strokeWeight(0);
  stroke(0);
}


void drawLine(){
  if(mousePressed && mouseButton==LEFT && backgroundCh()){
   if(presscnt==0){
     sx=mouseX;
     sy=mouseY;
     presscnt++;
   } 
   pixUpdate();
   strokeWeight(pWeight);
   stroke(pColor);
   line(sx,sy,mouseX,mouseY);
  }
  else{
    copyPixel();
    presscnt=0;
  }
  strokeWeight(0);
  stroke(0);
}

void copyPixel(){
  loadPixels();
  for(int i=0; i<pixels.length; i++){
    px[i] = pixels[i];
  }
  updatePixels();
}

void pixUpdate(){
  loadPixels();
  for(int i=0; i<pixels.length; i++){
    pixels[i]=px[i];
  }
  updatePixels();
}
