class Box {
  float boxX, boxY, boxZ; 
  float boxSizeX, boxSizeY, boxSizeZ; 

  Box(float x, float y, float z, float sizeX, float sizeY, float sizeZ) {
    boxX = x;
    boxY = y;
    boxZ = z;
    boxSizeX = sizeX;
    boxSizeY = sizeY;
    boxSizeZ = sizeZ;
  }

  void display() {
    noFill(); 
    stroke(0); 
    strokeWeight(1); 
    translate(boxX, boxY, boxZ);
    box(boxSizeX, boxSizeY, boxSizeZ);
  }
}
