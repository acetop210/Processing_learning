void block(float x, float y, float z, float s){
  pushMatrix();
    translate(x,y,z);
    box(s);
  popMatrix();
}

void piller(float x, float y, float z, float s, float k){
  for(int i=0; i<k; i++) block(x,y-50*i,z,s);
}
