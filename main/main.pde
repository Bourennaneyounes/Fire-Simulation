import java.util.Random;

float rGlobal = 100;
float searchRadius = 100;
int N = 800;

PVector points[] = new PVector[N];
MetricTree metricTree = new MetricTree(); 

ArrayList<Particle> particles = new ArrayList<Particle>();

Box box = new Box(0,0,100,50,50,200); 
float angleX = PI/2, angleY, angleZ;
float camDistance = 300;


void setup() {
  size(600, 600, P3D);
  
  for(int i=0;i<N;i++){
    Particle b = new Particle(random(0,50), random(0,50), random(150,200), 2,1.0);
    particles.add(b);
    
    points[i] = new PVector(particles.get(i).position.x, particles.get(i).position.y, particles.get(i).position.z);
    metricTree.insert(i, rGlobal);
  }


}

void draw() {
  background(0);
  lights();
  
 updateCamera();
  rotateScene();
  
  
//drawGrid();
  
  for (Particle particle : particles) {
    particle.update();
    particle.checkBoundaryCollision(box);
    particle.display();
    
  }

   
for (Particle particle : particles) {
  IntList neighbors = new IntList();
  metricTree.search(particle.position, searchRadius, neighbors);
 
  for (int i = 0; i < neighbors.size(); i++) {
    int neighborId = neighbors.get(i);
    particle.checkCollision(particles.get(neighborId));  
  }
}

  box.display();

   float blurAmount = map(width/3, 0, width, 0, 5); // Adjust the blur amount based on mouse position
  filter(BLUR, blurAmount);
}
//void drawGrid() {
//  stroke(150);
//  for (float i = -500; i <= 500; i += 50) {
//    line(i, -500, 0, i, 500, 0);
//    line(-500, i, 0, 500, i, 0); 
//  }
//}
void rotateScene() {
  rotateX(angleX);
  rotateY(angleY);
  rotateZ(angleZ); 
}

void updateCamera() {
  float cameraX = sin(radians(angleZ)) * cos(radians(angleY)) * camDistance;
  float cameraY = -sin(radians(angleZ)) * sin(radians(angleX)) * camDistance;
  float cameraZ = cos(radians(angleZ)) * cos(radians(angleY)) * camDistance;
  
  camera(cameraX, cameraY, cameraZ, 0, 0, 0, 0, 1, 0);
}

void mouseDragged() {
  float sensitivity = 0.5;
  angleZ += radians((pmouseX - mouseX) * sensitivity); 
  angleX -= radians((mouseY - pmouseY) * sensitivity); 
}

void mouseWheel(MouseEvent event) {
  float delta = event.getCount();
  camDistance += delta * 70; 
 
}

void keyPressed() {
  if (keyCode == UP) {
    for (Particle particle : particles) {
      particle.temperature+= 50;
    }
  }

  if (keyCode == DOWN) {
    for (Particle particle : particles) {
      particle.temperature-= 50;
    }
  }
}
