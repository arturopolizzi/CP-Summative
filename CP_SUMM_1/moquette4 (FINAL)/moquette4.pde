//begin by defining the unit lengths of the stripes,
int[] lengths = { 1,1,1,1,2,2,2,4,4,6,8 }; //skew for smaller values
//,then the specific sequence of lengths needed to make the pattern
int[] lengthIndexSequence = new int[15];
//then initialising an empty array for the symmetrical pattern sequence
int[] mirroredLengthIndexSequence = new int[44];

//same for the colours of the stripes
color [] colors = {0,1,1,1,2,2,2};
color [] colorScheme = new color[4]; //empty list of colours

//in this case there are a series of possible colour schemes:
color[] routemaster = { color(34,139,34), color(255,0,0), color(0,0,0), color(255,255,0) };
color[] bakerloo = { color(177,80,13), color(153, 102, 51), color(0,0,20), color(209, 164, 58) };
color[] central = { color(0, 100, 153), color(204,51,51), color(20,20,20), color(255,255,255)  };
color[] circle = { color(255, 164, 5), color(255, 205, 0), color(92, 64, 51), color(255,0,0) };
color[] district = { color(129, 199, 161), color(0, 102, 51), color(0, 133, 62), color(0, 120, 42) };
color[] hammersmith_city = { color(220, 90, 105), color(204,153,153), color(166, 62, 79), color(192, 103, 117) };

//specific sequence of colour values needed to make the pattern
int[] colorIndexSequence = new int[15];
//empty array for the symmetrical colour pattern sequence
int[] mirroredColorIndexSequence = new int[44]; 
//create the length of the fundamental sequence
int numberOfParts = lengthIndexSequence.length;
//create length of mirrored sequence
int numberOfMirroredParts = (lengthIndexSequence.length*2)-1;

//create the basic properties of the vertical stripes
int numberColumns = int(random(4,7));
int columnWidth = int(random(1,2));

//create a series of fundamental lengths
int maxX = 600; //canvas always 600 wide
float maxY = 0; //length of entire mirrored sequence
int maxYScaled = 600; //canvas always 600 high 
float y = 0; //incremented thru to get the y position of each rectangle
float scale; //multiply maxY by this number to get maxYScaled (600)

int i; //base iterator
int j; //for nested iterators

//function that prepare the mirrored sequences for final use in draw()
void preload() {
  for (i = 0; i<numberOfParts; i++) { //first copy the original sequences over
    int lenRand = int(random(0,lengths.length));
    lengthIndexSequence[i] = lengths[lenRand];
    mirroredLengthIndexSequence[i] = lengthIndexSequence[i];
    int prevColor = 0;
    if (i>0) {
      prevColor = mirroredColorIndexSequence[i-1];
    }
    int colorRand = int(random(0, colors.length));
    while (colors[colorRand] == prevColor) {
      colorRand = int(random(0, colors.length));
    }
    colorIndexSequence[i] = colors[colorRand];
    mirroredColorIndexSequence[i] = colorIndexSequence[i];
  }
  j = numberOfParts-1; //exclude the last item as it is not to be duplicated
  for (i = numberOfParts-1; i > 0; i--) { //then duplicate the sequence in reverse
    mirroredLengthIndexSequence[j] = lengthIndexSequence[i];
    mirroredColorIndexSequence[j] = colorIndexSequence[i];
    j += 1;
  }

  //make the last mirrored item the first original item
  mirroredLengthIndexSequence[j] = lengthIndexSequence[0];
  mirroredColorIndexSequence[j] = colorIndexSequence[0];

  //derive maxY for the entire sequence
  for (i=0; i<numberOfMirroredParts; i++) {
  int lengthIndex = mirroredLengthIndexSequence[i];
  maxY += lengths[lengthIndex];
  }
  
  scale = maxYScaled / maxY; //derive the scale
  //j -= 1;

}

void setup() {
 preload(); //prepare variables
 windowResize(maxX, maxYScaled); //windowResize for dynamic sizing;
 colorScheme = routemaster; //set default color scheme
 
 for (i = 0; i<numberOfParts; i++) { //duplicate the sequence in reverse
  mirroredLengthIndexSequence[j] = mirroredLengthIndexSequence[i];
  mirroredColorIndexSequence[j] = mirroredColorIndexSequence[i];
  j += 1;
  }
}

void draw() {
  y = 0;
  background(255);
  noStroke();
  for (i = 0; i < numberOfMirroredParts*1.5; i++) {
    //use the index sequence to access the correct length and colours
    int colorIndex = mirroredColorIndexSequence[i];
    int lengthIndex = mirroredLengthIndexSequence[i];
    
    fill(colorScheme[colorIndex]);
    //scale multiplier used to make rects fit and ultimately total 600 pixels in height
    
    pushMatrix(); // make alternate colums offset
    for (j = 0; j < numberColumns+1; j++) {
    rect(maxX*j/(numberColumns-1), y, (maxX/(numberColumns-1)), scale*lengths[lengthIndex]);
    translate(0, ((2 * (j % 2)) - 1)*2*(scale));

  }
    popMatrix();
    y += scale*lengths[lengthIndex];
  }

  fill(colorScheme[3]); //set stripe colour
  float columnWidthScaled = columnWidth * scale; //derive the scaled width
  float columnXPosIncrement = ((maxX-columnWidthScaled)/ (numberColumns-1)); //derive the distance between columns
  for (i = 0; i < numberColumns; i++) { //draw vertical rectangles using new properties
    float columnXPos = i * columnXPosIncrement;
    rect(columnXPos, 0, columnWidthScaled, maxYScaled);
  }
}

void keyPressed() { //change colour scheme with pressing of buttons
  if (key == '1') {
    colorScheme = routemaster;
  } else if (key == '2') {
    colorScheme = bakerloo;
  } else if (key == '3') {
    colorScheme = central;
  } else if (key == '4') {
    colorScheme = circle;
  } else if (key == '5') {
    colorScheme = district;
  } else if (key == '6') {
    colorScheme = hammersmith_city;
  }
}
