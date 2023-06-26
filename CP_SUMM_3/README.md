# Late Autumn in the Black Forest
### Small Project 3: "Forest Scene"

This Processing sketch depicts a forest scene, with leaves falling and moving with the wind.

## How to Use

Press play to start the sketch. There are no controls, so let the it run and watch as the leaves fall to the ground.

## Design Choices

I chose the background image as I like how stark it is: the lack of colour and the use of negative space really interested me and gave the sketch a dark, moody feel. I tried to emulate this in the design of the leaves, making their colours a range of muted green/browns to reflect the lighting and the idea of autumn leading into dark, deadly winter. 

I wanted the leaves to vary in direction, velocity and rotation, but to feel like they were moving together overall. So many factors go into the real movement of leaves, affecting them together and individually, and I wanted to keep this balance of order and chaos in mind as I simulated their movement.

## Notes on Process

First, I created a particle system in which small squares were dropped from random positions across the top of the screen and made to stop once reaching the bottom. This helped me begin to think about the physics of falling leaves without getting bogged down with design choices too early in the process. I used Daniel Schiffman's example of a simple particle system on the Processing website as a starting point. The link can be found in the code notes.

Once I had set up my particle class (which defines and manages the properties of a single leaf) and the particlesystem class (which manages the leaves overall), I began to play with forces affecting the particles. First I randomised the speed of their descent, doing the same with direction to create the impression of different leaves being held up in the air in slightly different ways. I also made sure the leaves disappear from the screen once on the ground for a certain length of time.

I then began to think about wind and how its direction changes slowly over time. I created a force that affected the x position of all the leaves in a slow, sinusoidally oscillating manner, but found this too regular. I used a noise oscillator to make the speed of the sinusoidal oscillator random, meaning that the leaves solidly move from left to right, but change direction at non-regular intervals.

Once I had built the wind, I began to draw the leaves themselves using simple vector graphics. I included a rotation parameter to increase the slight variations in movement across leaves. I made the input for rotation the strength of the wind while randomising the magnitude of rotation for each leaf, meaning that the wind changes the direction of each leaf to varying degrees.


