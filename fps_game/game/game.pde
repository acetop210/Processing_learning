
fpCamera mainCamera;

void setup(){
  size(1280,600,P3D);
  mainCamera = new fpCamera();
}

void draw(){
  background(0);
  mainCamera.camTrans();
  drawenv();
}

void drawenv(){
  float ground = height*2/3;
  int boxnum = 25;
  fill(198,101,35);
  //천장
  for(int z=0; z<boxnum; z++)
    for(int x=0; x<boxnum; x++)
      block(x*50,0,z*50,50);  
  //바닥
  for(int z=0; z<boxnum; z++)
    for(int x=0; x<boxnum; x++)
      block(x*50,ground,z*50,50);
  
  piller(0,ground-50,0,50,5);
}
