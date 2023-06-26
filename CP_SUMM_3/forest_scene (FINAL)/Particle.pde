//the class for each leaf

class Particle { //initiate parameters
  float x;
  float y;
  
  PVector pos;
  PVector vel;
  PVector acc;
  PVector wind;
  color pColor;
  float angle;
  float rotationVel;
  
  float size = 5;
  int timer = 0;
  int threshold = 1000; //for particles to disappear after some time
  
  Particle(float x,float y) { //given init. pos. from draw() loop
    pos = new PVector (x,y); //initiate vectors for position, velocity and acceleration
    vel = new PVector(random(-0.5, 0.5), random(1, 1.5));
    acc = new PVector(0,0.005);
    pColor = color(random(20, 30), random(20, 60), random(20, 30)); // random dark green/brown colour
    angle = PI/3;
    rotationVel = random(-0.3, 0.3);
  }
  
  void run() { //both functions contained in here for ease
    update();
    display();
  }
  
  void update() {
    if (pos.y < height - size) { //if bottom of screen not reached,
    
      pos.add(vel); //move the leaves
      vel.add(acc); //with acceleration
      
      float windAmp = 1; //creating oscillating wind
      float windFreq = 0.03*noise(0.0003*frameCount); //slow moving noise osc
      float windOffset = sin(frameCount/2 * windFreq/2) * windAmp; //fed into sinusoidal osc
      //therefore the result is a left-right sine wave motion with random rate
      wind = new PVector(windOffset, 0);
      
      pos.add(wind); //add to motion
      angle = map(wind.x, -windAmp, windAmp, -PI / 4, PI / 4);
      angle += rotationVel; // different leaves rotate at different weights
    
    } else { //if leaves at bottom of screen
      vel = new PVector(0,0);  //stop
      countUp(); //begin to count towards removal from canvas
    }
    
    if (timer >= threshold) { //remove from canvas after a time
    pos.y += 30;
    }
    
  }
  
  void countUp() { 
    timer++;
  }
  
  void display() { //the shape and characteristics of a leaf
    pushMatrix();
      translate(pos.x, pos.y);
      rotate(-angle-PI/6);
      stroke(pColor);
      fill(pColor);
      strokeWeight(size);
      ellipse(0, 0, 2, 8);
      noStroke();
      rect(-1,-10,1,5);
    popMatrix();
  }
  
}
