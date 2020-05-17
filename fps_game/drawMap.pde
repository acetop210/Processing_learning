
void setup(){
  size(1200,900,P3D);
  noStroke();
}

void draw(){
  background(0);
  lights();

  pushMatrix();
  fill(0,255,0);
  translate(width/2,height/2,-100);
  rotateX(mouseY*0.01);
  rotateY(mouseX*0.01);
  box(200,100,200);
  popMatrix();
}
