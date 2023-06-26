# Granular Looper
### Small Project 2: Sound-and-Visuals Synthesizer

This Processing sketch is a granular sampler: it takes existing audio as its input, looping it and playing different small portions (grains) in a non-linear way. This creates a glitch effect, forming new melodies and textures from the sampled audio.

## How to Use

Press play to start. Click and drag on any of the knobs to change the parameters described. Press R to randomise some parameters.

## Intention

I wanted to work with manipulating audio as it is a good way to get interesting, textural results quickly. I love using granular synthesis in my practice as a sound designer, and wanted to take a peek behind the curtain and create a custom tool for my own use.

Rather than a sampler triggered by a keyboard, I wanted a looping drone-like instrument where the sound being produced is constant and slowly shifting. The length and position of the loop can be controlled and also sinusoidally offset over time using an LFO. With the granulator, I included controls for grain size, their spacing, and how much each grain would fade in and out when triggered. I also added an echo/delay to make the sound output denser. 

## Notes on Process

I began by consulting with Tom and speaking about the architecture of the sound engine. I built each component separately before combining them so that I could easily debug them. The audio engine is built using the Minim library. 

Once combined, I implemented the user controls using P5Control and created the GUI, with the audio file represented as a waveform at the top, a playhead showing which section of the audio is being played, and all the parameter knobs at the bottom, separated and labelled. The code for creating the waveform of the entire file is taken from a Processing forum post, linked in the code notes.

## Improvements

The sketch is satisfactory as a first version of what I had originally planned. I had trouble with the LFO and making sure it didn't set the playhead position every frame, but this only works part of the time. I also wanted a multiple-grain system, perhaps also made pitchable by using the sampler() method to load the audio file, but wasn't able to implement these successfully in time. Although I improved the project so that over time it was much less prone to breaking, there are still some unwanted bugs which create interesting, though undesired, results.
