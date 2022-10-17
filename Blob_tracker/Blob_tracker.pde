import processing.video.*;

// Variable for capture device
Capture video;

// A variable for the color we are searching for.
color trackColor, targetColor; 
float color_threshold = 50;
float distance_threshold = 25;

ArrayList<Blob> blobs = new ArrayList<Blob>();

void setup() {
  size(1280, 960);
  video = new Capture(this, width, height);
  video.start();
  // Start off tracking for red
  trackColor = color(255, 255, 255);
  targetColor = color(0,255,0);
}

void captureEvent(Capture video) {
  // Read image from the camera
  video.read();
}

void draw() {
  video.loadPixels();
  image(video, 0, 0);
  
  blobs.clear();

  
  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      int loc = x + y * video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      // Using euclidean distance to compare colors
      float d = distSq(r1, g1, b1, r2, g2, b2); // We are using the dist( ) function to compare the current color with the color we are tracking.

      // If current color is more similar to tracked color than
      // closest color, save current location and current difference
      if (d < color_threshold) {
        
        boolean found = false;
        for(Blob b : blobs) {
          if( b.isNear(x,y) ) {
            b.add(x,y);
            found = true;
            break;
          }
        }

        if(!found) {
          Blob b = new Blob(x, y);
          blobs.add(b);
        }
        
        fill(targetColor);
        strokeWeight(0.0);
        stroke(0);
        ellipse(x, y, 1, 1);
      }
    }
  }

  // We only consider the color found if its color distance is less than 10. 
  // This threshold of 10 is arbitrary and you can adjust this number depending on how accurate you require the tracking to be.
  if (count > 5) { 
    avgX = avgX/count;
    avgY = avgY/count;
    
    // Draw a circle at the tracked pixel
    fill(targetColor);
    strokeWeight(2.0);
    stroke(255);
    ellipse(avgX, avgY, 10, 10);
  }
}

void mousePressed() {
  // Save color where the mouse is clicked in trackColor variable
  int loc = mouseX + mouseY*video.width;
  trackColor = video.pixels[loc];
}

float distSq(float x1, float y1, float x2, float y2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
  return d;
}

float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) + (z2-z1)*(z2-z1);
  return d;
}
