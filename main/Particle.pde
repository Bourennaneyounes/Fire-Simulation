class Particle  {
  PVector position;
  PVector velocity;
  PVector addedPos = new PVector(0, 0, 0);
  PVector addedVel = new PVector(0, 0, 0);

  float gravity = -9.80; 
  float buoyancy = 0.05; 
  float turbulence = 0.3; 

  color temperatureColor;
  float temperature; 
  float radius, m;

  Particle(float x, float y, float z, float r_, float initialTemperature) {
    position = new PVector(x, y, z);
    velocity = new PVector(0, 0, 0);
    radius = r_;
    m = radius * 0.1;
    temperature = initialTemperature; 
    temperatureColor = mapTemperatureToColor(initialTemperature);
  }

  void update() {
    position.add(addedPos);
    velocity.add(addedVel);
    
    PVector gravityForce = new PVector(0, 0, gravity * m);
    addedVel.add(gravityForce);

    float buoyantForceMagnitude = buoyancy * temperature;
    PVector buoyantForce = new PVector(0, 0, buoyantForceMagnitude);
    addedVel.add(buoyantForce);

    PVector turbulenceForce = new PVector(random(-turbulence, turbulence), random(-turbulence, turbulence), 0);
    addedVel.add(turbulenceForce);

  
    float bottomThreshold = box.boxZ + box.boxSizeZ/2 - radius;
    if (position.z > bottomThreshold - 50 ) { 
      PVector eruptionForce = new PVector(0, 0, -2); 
      addedVel.add(eruptionForce);
    }
    
        
    float leftThreshold = 20;
    float rightThreshold = 30;
        
    if (position.x>leftThreshold && position.x<rightThreshold) {
   
      PVector eruptionForce = new PVector(0, 0, +1); 
      addedVel.add(eruptionForce);
    }
    
    position.add(addedPos);
    velocity.add(addedVel);
    
    position.add(velocity);
    
    addedPos = new PVector(0, 0, 0);
    addedVel = new PVector(0, 0, 0);
    
    temperatureColor = mapTemperatureToColor(temperature);
    radius = map(temperature, 0, 100, 0, 4); 
    
  }

  void checkBoundaryCollision(Box box) {
    
  if (position.x > box.boxX + box.boxSizeX - radius) {
    position.x = box.boxX + box.boxSizeX - radius;
    velocity.x *= -1;
  } else if (position.x < box.boxX + radius) {
    position.x = box.boxX + radius;
    velocity.x *= -1;
  }

 
  if (position.y > box.boxY + box.boxSizeY - radius) {
    position.y = box.boxY + box.boxSizeY - radius;
    velocity.y *= -1;
  } else if (position.y < box.boxY + radius) {
    position.y = box.boxY + radius;
    velocity.y *= -1;
  }

  
  if (position.z > box.boxZ + box.boxSizeZ - radius) {
    position.z = box.boxZ + box.boxSizeZ - radius;
    velocity.z *= -1;
  } else if (position.z < box.boxZ + radius) {
    position.z = box.boxZ + radius;
    velocity.z *= -0;
    temperature += 10; 
  }
  
  if(position.z < box.boxZ + box.boxSizeZ - radius && position.z > box.boxZ + radius){
  temperature -= 3;
  }
  }

 void checkCollision(Particle other) {
  PVector distanceVect = PVector.sub(other.position, position);
  float distanceVectMag = distanceVect.mag();
  float minDistance = radius + other.radius;

  if (distanceVectMag < minDistance) {
    float distanceCorrection = (minDistance - distanceVectMag) / 2.0;
    PVector d = distanceVect.copy();
    PVector correctionVector = d.normalize().mult(distanceCorrection);
    other.position.add(correctionVector);
    position.sub(correctionVector);
    

    float temperatureDifference = other.temperature - temperature;
    float temperatureTransfer = temperatureDifference * 0.01; 

    
    other.temperature -= temperatureTransfer;
    temperature += temperatureTransfer;

    other.temperature = constrain(other.temperature, 0, 100);
    temperature = constrain(temperature, 0, 100);
   
  }
}

  void display() {
    pushMatrix();
  fill(temperatureColor);
  translate(position.x - 25, position.y - 25, position.z - 100);
    rotateX(frameCount * 0.01);
    rotateY(frameCount * 0.01);
    rotateZ(frameCount * 0.01); 
    noStroke();
  sphere(radius);
  popMatrix();
}

 
color mapTemperatureToColor(float temp) {
  float t = constrain(temp, 0, 100); 

  float r, g, b;

  if (t < 25) {
    r = map(t, 0, 25, 0, 255);
    g = 0;
    b = 0;
  } else if (t < 50) {
    r = map(t, 25, 50, 255, 255);
    g = map(t, 25, 50, 0, 165);
    b = 0;
  } else if (t < 75) {
    r = map(t, 50, 75, 255, 255);
    g = map(t, 50, 75, 165, 255);
    b = 0;
  } else {
    r = map(t, 75, 100, 255, 255);
    g = map(t, 75, 100, 255, 255);
    b = map(t, 75, 100, 0, 255);
  }

  return color(r, g, b);
}


}
