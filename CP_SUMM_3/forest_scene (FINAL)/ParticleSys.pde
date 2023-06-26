//class for entire group of leaves
class ParticleSys {
  ArrayList<Particle> pars;
  
  ParticleSys() {
    pars = new ArrayList<Particle>();
  }
  
  void addParticle(float x, float y) {
    pars.add(new Particle(x, y)); //create each new lead
  }
  
  void run() { //go through, display and update each particle in particle array
  for (int i = pars.size() - 1; i >= 0; i--) {
    Particle par = pars.get(i);
    par.run();
    }
  }
  
  
}
