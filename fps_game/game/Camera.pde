class fpCamera{
  PVector cpos;
  PVector cvel;
  PVector cacc;
  
  float topspeed = 7;
  
  fpCamera(){
    //cpos = new PVector(width/2, height/2, (height/2) / tan(PI*30 / 180));
    cpos = new PVector(width/2, height/2, (height/2) / tan(PI*30 / 180));
    cvel = new PVector(0,0,0);
  }
  
  void camTrans(){
    pushMatrix();
    //원점 이동
      translate(cpos.x, cpos.y, cpos.z);
      //좌우 회전
      rotateY(-(float)(mouseX-640)/width*2*PI);
      println(mouseX,width);
      // 카메라가 볼 곳 설정
      translate(0,0,-200);
      float x = modelX(0,0,0);
      float y = modelY(0,0,0);
      float z = modelZ(0,0,0);
    popMatrix();
    //카메라 설정
    y = map(mouseY, 0, height, -200, 1200);
    println(x,y,z);
    camera(cpos.x,cpos.y,cpos.z,x,y,z,0,1,0);
    //키 눌렸을 때(움직일 때)
    if(keyPressed){
      if(key=='w'||key=='s'){
        PVector target = new PVector(x,cpos.y,z);
        cacc = PVector.sub(target,cpos);
        if(key=='w')cacc.setMag(5);
        else if(key=='s') cacc.setMag(-5);
        cvel.add(cacc);
        cvel.limit(topspeed);
        cpos.add(cvel);
      }
    }
  }
}
