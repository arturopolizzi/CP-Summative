//general method taken from Dan Schiffman's very helpful example on the processing website
//https://processing.org/examples/simpleparticlesystem.html

//initiate particle system
ParticleSys particleSys;
//initiate image
PImage bg;

void setup() {
  size(400,400);
  
  particleSys = new ParticleSys(); //instantiate par. sys.
  
  bg = loadImage("for1.png"); //load background image
}

void draw() {
  background(0); //refresh screen each frame
  
  image(bg, 0, 0); //draw bg
  
  if (frameCount % 1 == 0) { // Generate a particle every second
    float x = random(width*-3,width*3); //wider than canvas to accom. for wind
    float y = 0; //always at top of screen
    particleSys.addParticle(x, y); //generate particles at pos. specified
  }
  
  particleSys.run(); //run particle system update and display functions in one go
  
}
