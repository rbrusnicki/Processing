import processing.video.*;

// Variable for capture device
Capture video;

// A variable for the color we are searching for.
color trackColor, targetColor; 
float color_threshold = 350;
float distance_threshold = 10;

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
  //pushMatrix();
  //translate( video.width, 0 );
  //scale( -1, 1 );
  //image( video, 0, 0 );
  //popMatrix();
  
  blobs.clear();

  
  // Begin loop to walk through every pixel
  
  for (int y = 0; y < video.height; y++ ) {
    for (int x = 0; x < video.width; x++ ) {
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
      if (d < color_threshold*color_threshold ) {
        
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
        
        //fill(targetColor);
        //strokeWeight(0.0);
        //stroke(0);
        //ellipse(x, y, 1, 1);
      }
    }
  }
  
  // Calibration distance ~= 0.70m
  stroke(color(0,0,0));
  fill(color(50, 50, 50));
  ellipse(640, 192, 20, 20);
  ellipse(640, 576, 20, 20);
  ellipse(640, 768, 20, 20);

  // Tracks leds
  for (Blob b : blobs) {
    b.show(); 
      // Draw a circle at the tracked pixel
    fill(targetColor);
    strokeWeight(2.0);
    stroke(targetColor);
    ellipse(b.avgx, b.avgy, 10, 10);
    text(b.avgx, b.maxx+10, b.miny);
    text(b.avgy, b.maxx+10, b.miny+10);
  }
  
  // Draw measurements
  if( blobs.size() == 3 ){
    Blob top = blobs.get(0);
    Blob middle = blobs.get(1);
    Blob bottom = blobs.get(2);
    stroke(255);
    line(top.avgx, top.avgy, middle.avgx, middle.avgy);
    line(middle.avgx, middle.avgy, bottom.avgx, bottom.avgy);
    stroke(55);
    line(top.avgx, top.avgy, bottom.avgx, bottom.avgy);
     
    float baricenterX = (top.avgx + middle.avgx + bottom.avgx)/3;
    float baricenterY = (top.avgy + middle.avgy + bottom.avgy)/3;
    stroke(color(255,0,0));
    fill(color(255,0,0));
    ellipse(baricenterX, baricenterY, 5, 5);
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
