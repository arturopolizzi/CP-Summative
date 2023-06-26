//method of generating a waveform of the entire sound file adapted from
//this post on the Processing forum, thanks to user jonatan.van.hove for the inspiration
//https://forum.processing.org/one/topic/how-to-generate-a-simple-waveform-of-an-entire-sound-file.html

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
//for audio engine

import java.util.Arrays; //for waveform visual

//import all req'd libraries

Minim minim;
FilePlayer filePlayer;
AudioOutput out;
GranulateSteady chopper;
Delay delay;
//initiate all components of audio engine

float[][] spectra; //for waveform

String song = "£loop2.mp3";  //loop I created myself some years ago

//initiate params

int initLoopSize;
int loopStart;
int loopEnd = loopStart + initLoopSize; //these start and end points only used in setup()
float currentLoopStart;
float prevLoopStart;
//for looping

float LFOAmp;
float LFORate;
//for start point offset LFO

float grainSize = 0;
float spaceSize = 0;
float fadeSize = 0;
//for granulator

float delayAmp = 0.5;
float delayTime = 0.4;
//for delay/echo plugin

float volume;

//now to initiate all control parameters

import controlP5.*;
ControlP5 cp5;

Knob loopStartKnob;
Knob loopSizeKnob;

Knob LFOAmpKnob;
Knob LFORateKnob;

Knob grainSizeKnob;
Knob grainSpacingKnob;
Knob grainFadeKnob;

Knob delayAmpKnob;
Knob delayTimeKnob;

Knob volumeKnob;

//for all knob positioning to be relative regardless of where they are
int firstKnobX = 17;
int knobY = 120;

void setup() {
  size(640,180); 
  
  minim = new Minim(this);
  
  analyzeUsingAudioSample(); // analyse audio to create waveform
  
  filePlayer = new FilePlayer( minim.loadFileStream(song) );
  filePlayer.setLoopPoints(loopStart , loopEnd);
  filePlayer.loop();
  //init audio and loop it
  
  chopper = new GranulateSteady(grainSize,spaceSize,fadeSize);
  delay = new Delay(delayTime, delayAmp,true,true);
  out = minim.getLineOut();
  //audio engine init
  
  filePlayer.patch(chopper).patch(delay).patch(out);
  //audio engine routing
  
  //control surface init
  cp5 = new ControlP5(this);
  loopSizeKnob = cp5.addKnob("size")
    .setRange(30,filePlayer.length())
    .setValue(800)
    .setPosition(firstKnobX+50,knobY);
  
  loopStartKnob = cp5.addKnob("start point")
    .setRange(0,filePlayer.length())
    .setPosition(firstKnobX,knobY);
   
  LFOAmpKnob = cp5.addKnob("amp")
    .setRange(0,4000)
    .setPosition(firstKnobX+310,knobY);
  LFORateKnob = cp5.addKnob("rate")
    .setRange(1,10)
    .setValue(3)
    .setPosition(firstKnobX+360,knobY);
  
  grainSizeKnob = cp5.addKnob("grain")
    .setRange(0.001,1)
    .setValue(0.03)
    .setPosition(firstKnobX+130,knobY);
  grainSpacingKnob = cp5.addKnob("spacing")
    .setRange(0.001,1)
    .setValue(0.07)
    .setPosition(firstKnobX+180,knobY);
  grainFadeKnob = cp5.addKnob("fade")
    .setRange(0.001,0.05)
    .setPosition(firstKnobX+230,knobY);
    
  delayAmpKnob = cp5.addKnob(" amp")
    .setRange(0,1).setValue(0.4)
    .setPosition(firstKnobX+440,knobY);
  delayTimeKnob = cp5.addKnob("time")
    .setRange(0,1)
    .setValue(0.4)
    .setPosition(firstKnobX+490,knobY);
    
  volumeKnob = cp5.addKnob("volume")
  .setRange(-80,6)
  .setValue(0)
  .setPosition(firstKnobX+570,knobY);;
}

void analyzeUsingAudioSample() //taken from a Processing forum post as prev mentioned, see link above
{
   AudioSample jingle = minim.loadSample(song, 2048);
   
  // get the left channel of the audio as a float array
  // getChannel is defined in the interface BuffereAudio, 
  // which also defines two constants to use as an argument
  // BufferedAudio.LEFT and BufferedAudio.RIGHT
  float[] leftChannel = jingle.getChannel(AudioSample.LEFT);
  
  // then we create an array we'll copy sample data into for the FFT object
  // this should be as large as you want your FFT to be. generally speaking, 1024 is probably fine.
  int fftSize = 1024;
  float[] fftSamples = new float[fftSize];
  FFT fft = new FFT( fftSize, jingle.sampleRate() );
  
  // now we'll analyze the samples in chunks
  int totalChunks = (leftChannel.length / fftSize) + 1;
  
  // allocate a 2-dimentional array that will hold all of the spectrum data for all of the chunks.
  // the second dimension if fftSize/2 because the spectrum size is always half the number of samples analyzed.
  spectra = new float[totalChunks][fftSize/2];
  
  for(int chunkIdx = 0; chunkIdx < totalChunks; ++chunkIdx)
  {
    int chunkStartIndex = chunkIdx * fftSize;
   
    // the chunk size will always be fftSize, except for the 
    // last chunk, which will be however many samples are left in source
    int chunkSize = min( leftChannel.length - chunkStartIndex, fftSize );
   
    // copy first chunk into our analysis array
    arraycopy( leftChannel, // source of the copy
               chunkStartIndex, // index to start in the source
               fftSamples, // destination of the copy
               0, // index to copy to
               chunkSize // how many samples to copy
              );
      
    // if the chunk was smaller than the fftSize, we need to pad the analysis buffer with zeroes        
    if ( chunkSize < fftSize )
    {
      // we use a system call for this
      Arrays.fill( fftSamples, chunkSize, fftSamples.length - 1, 0.0 );
    }
    
    // now analyze this buffer
    fft.forward( fftSamples );
   
    // and copy the resulting spectrum into our spectra array
    for(int i = 0; i < 512; ++i)
    {
      spectra[chunkIdx][i] = fft.getBand(i);
    }
  }
  
  jingle.close(); 
}

void draw() {
  background(0);
  
  float scaleMod = (float(width) / float(spectra.length)); //ensure waveform fits screen
  
  for(int s = 0; s < spectra.length; s++) //draw w/f
  {
    strokeWeight(1);
    stroke(255);
    int i =0;
    float total = 0; 
    for(i = 0; i < spectra[s].length-1; i++)
    {
        total += spectra[s][i];
    }
    total = total / 10;
    line(s*scaleMod,total/4+height/4,s*scaleMod,-total/4+height/4);
  }
  
  strokeWeight(0); //draw GUI separators (rect() used instead of line() so firstKnobX can be used more easily)
  fill(255);
  
  rect(firstKnobX+110,100,1,70);
  rect(firstKnobX+290,100,1,70);
  rect(firstKnobX+420,100,1,70);
  rect(firstKnobX+550,100,1,70);
  rect(0,(height/2)+3,width,1);
  
  //GUI labels
  textSize(12);
  text("LOOP",firstKnobX+30,110);
  text("GRANULATE",firstKnobX+170,110);
  text("OFFSET",firstKnobX+335,110);
  text("DELAY",firstKnobX+470,110);
  text("VOLUME",firstKnobX+567,110);
  
  //playhead in red, following movement of loop and loop controls
  
  stroke(255,0,0);
  strokeWeight(3);
  float position = map(filePlayer.position(), 0, filePlayer.length(), 0, width);
  line(position, 0, position, height/2);
  
  //now reading values from controls to put into the sound engine
  
  volume = cp5.getController("volume").getValue(); //beginning from end of chain
  
  out.setGain(volume);
  
  delayAmp = cp5.getController(" amp").getValue();
  delay.setDelAmp( delayAmp );
  delayTime = cp5.getController("time").getValue();
  delay.setDelTime( delayTime );
  
  grainSize = cp5.getController("grain").getValue();
  spaceSize = cp5.getController("spacing").getValue();
  fadeSize = cp5.getController("fade").getValue();
  chopper.setAllTimeParameters(grainSize,spaceSize,fadeSize );
  
  //now the loop start point LFO, the most tricky part
  
  currentLoopStart = cp5.getController("start point").getValue();
  
  LFOAmp = cp5.getController("amp").getValue();
  LFORate = int(cp5.getController("rate").getValue());
  
  float LFOPhase = (LFORate * frameCount) % 360 ; //using modulo for ease
  float loopStartOffset = LFOAmp*sin(radians(LFOPhase)); //convert to rad and generate offset amnt for each loop shift
  currentLoopStart = currentLoopStart +loopStartOffset; //change by loop shift amnt
  if (prevLoopStart < currentLoopStart) { //fixing filePlayer's tendency to let a loop play until a loop point is reached
    filePlayer.cue(int(currentLoopStart)); 
  }
  
  if (currentLoopStart < 0 ) { //fixing what happens if the loop or LFO reach the outer bounds of the audio file
    currentLoopStart = 1;
  }
  int loopSize = int(cp5.getController("size").getValue());
  if (loopSize > filePlayer.length() - int(currentLoopStart)) {
    loopSize = filePlayer.length() - int(currentLoopStart);
  }
  
    if (currentLoopStart > filePlayer.length() - loopSize) {
    currentLoopStart = filePlayer.length() - loopSize;
  }
  
  //finally, calculating loop end point from size and start point, and keying those in for the next loop
  
  loopEnd = int(currentLoopStart) + loopSize;
  filePlayer.setLoopPoints(int(currentLoopStart) , int(loopEnd));
  prevLoopStart = currentLoopStart; //creating a memory of the last loop start point
  
  if (keyPressed == true) { //randomising parameters with R key
    if (key == 'r' || key == 'R') {
      filePlayer.pause();
      float newVal1 = random(0.05,0.1);
      cp5.getController("grain").setValue(newVal1);
      
      float newVal2 = random(0,0.1);
      cp5.getController("spacing").setValue(newVal2);
      
      float newVal3 = random(0,0.9);
      cp5.getController(" amp").setValue(newVal3);
      
      float newVal4 = random(0,0.9);
      cp5.getController("time").setValue(newVal4);
      
      filePlayer.loop();
    }
  }
  
}
