PImage mapImage;
PImage markerImage;
PImage nomarkerImage;
Table dataTable;
Table locationTable;
Table nameTable;
TableRow row;
int rowCount;

float dataMin = MAX_FLOAT;
float dataMax = MIN_FLOAT;

int markMode = 0;
float num;

Data[] dataArr;
scrollBar sc;

void setup() {
  size(640, 500);
  markerImage = loadImage("marker.png");
  nomarkerImage = loadImage("nomarker.png");
  mapImage = loadImage("map.png");
  locationTable = loadTable("locations.tsv", "header");
  nameTable = loadTable("names.tsv", "header");
  dataTable = loadTable("value.tsv", "header");
  rowCount = locationTable.getRowCount();

  for (int row = 0; row < rowCount; row++) {
    float value = dataTable.getFloat(row, 1);
    if (value > dataMax) dataMax = value;
    if (value < dataMin) dataMin = value;
  }
  num = dataMin;
  dataArr = new Data[rowCount];
   for (int i = 0; i < rowCount; i++) {
    String abbrev = dataTable.getRow(i).getString("abbrev");
    float value = dataTable.getRow(i).getFloat("value");
    row = locationTable.findRow(abbrev, "abbrev");
    float x = row.getFloat("x");
    float y = row.getFloat("y");
    row = nameTable.findRow(abbrev, "abbrev");
    String name = row.getString("name");
    dataArr[i] = new Data(name,x,y,value);
   }
  sc = new scrollBar();
  noStroke();
}

void draw() {
  background(255);
  image(mapImage, 0, 0);
  sc.display();
  drawButton();
  for (int i = 0; i < rowCount; i++) dataArr[i].drawData(markMode);
}

void mouseClicked(){
  if(markMode!=2){
    for(int i=0; i<rowCount; i++){
      boolean clicked = dataArr[i].clicked();
      if(clicked) break;
    }
  }
  buttonPressed();
}

void drawButton(){
  rectMode(CENTER);
  if(markMode==1){
    fill(150);
    rect(600,350,64,64);
  }
  if(markMode==2){
    fill(150);
    rect(600,280,64,64);
  }
  imageMode(CENTER);
  image(markerImage, 600,350);
  image(markerImage, 600,280);
  image(nomarkerImage,600,280,50,50);
  imageMode(CORNER);
}

void buttonPressed(){
  if(568<mouseX && mouseX<632 && 318<mouseY && mouseY<382 && mouseButton==LEFT){
    if(markMode!=1) markMode=1;
    else markMode=0;
  }
  if(575<mouseX && mouseX<625 && 255<mouseY && mouseY<305 && mouseButton==LEFT){
    if(markMode!=2) markMode = 2;
    else markMode = 0;
  }
}

class scrollBar{
  int sw = 200;
  int sh = 10;
  int sx = 350;
  int sy = 450;
  int spos = 350;
  boolean on;
  boolean locked;
  
  scrollBar(){
    on = false;
    locked = false;
  }
  
  boolean isOn(){
    if(sx<mouseX && mouseX<sx+sw && sy<mouseY && mouseY<sy+sh) return true;
    return false;
  }
  
  void update(){
    if(isOn()) on = true;
    else on = false;
    if(mousePressed && on) locked = true;
    if(!mousePressed) locked = false;
    
    if(locked) spos = constrain(mouseX, 350, 550);
  }
  
  void calNum(){
    num = map(spos, 350, 550, dataMin-1, dataMax+1);
    float tmpnum = num*10;
    num = round(tmpnum)/10.0;
  }
  
  void display(){
    update();
    rectMode(CORNER);
    fill(0,200,200);
    rect(sx,sy,sw,sh);
    fill(0);
    rect(spos,sy,sh,sh);
    calNum();
    textAlign(CORNER);
    text("Value="+" "+num,565,460);
  }
}

class Data{
  boolean pressed=false;
  String name;
  float x,y,value;
  float radius;
  
  Data(String na, float xx, float yy, float v){
    name = na;
    x = xx;
    y = yy;
    value = v;
    if (value >= 0) radius = map(value, 0, dataMax, 1.5, 15);
    else radius = map(value, 0, dataMin, 1.5, 15);
  }
  
  boolean clicked(){
    float d = dist(x,y,mouseX,mouseY);
    if(d<radius+2 && mouseButton == LEFT){
      if(markMode==1){
        if(pressed) pressed = !pressed;
      }
      else pressed = !pressed;
      return true;
    }  
    return false;
  }
  
  void drawMarker(){
    if(pressed){
      imageMode(CENTER);
      image(markerImage,x,y,2*radius,2*radius);
      imageMode(CORNER);
    }
  }
  void drawData(int mode){
    if((mode==0 || (mode==1 && pressed) || (mode==2 && !pressed)) && value>=num){
      if (value >= 0) fill(#333366);
      else fill(#ec5166);
      ellipseMode(RADIUS);
      ellipse(x, y, radius, radius);

      float d = dist(x, y, mouseX, mouseY);
      if (d < radius + 2 || pressed) {
        textAlign(CENTER);
        text(name + " " + value, x, y-radius-2);
      }
      drawMarker();
    }
  }
}
