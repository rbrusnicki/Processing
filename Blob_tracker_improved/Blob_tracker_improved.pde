import pallav.Matrix.*;

import processing.video.*;
//import pallav.Matrix.*;

// Variable for capture device
Capture video;

// A variable for the color we are searching for.
color trackColor, targetColor; 
float color_threshold = 350;
float distance_threshold = 10;
float Apx, Apy, Bpx, Bpy, Cpx, Cpy;
float k = 0.1 * sqrt(5)/5 * 1.0;
float Ax=0.0, Ay=-4*k, Az=0.0, Bx=0.0, By=0.0, Bz=-2*k, Cx=0.0, Cy=k, Cz=0.0;
float[][] A = {{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}};
float[][] A2 = {{0,0,0,0,0,0},{0,0,0,0,0,0},{0,0,0,0,0,0},{0,0,0,0,0,0}};
float[][] b = {{0},{0},{0},{1}};
float[][] b2 = {{0},{0},{0},{0},{0},{0}};


ArrayList<Blob> blobs = new ArrayList<Blob>();

void setup() {
  size(1280, 960);  //divide by 1700 to get in m at 1,00m distance
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
  ellipse(640, 120, 20, 20);
  ellipse(640, 600, 20, 20);
  ellipse(640, 720, 20, 20);

  // Tracks leds
  for (Blob b : blobs) {
    b.show(); 
      // Draw a circle at the tracked pixel
    fill(targetColor);
    strokeWeight(2.0);
    stroke(targetColor);
    ellipse(b.avgx, b.avgy, 10, 10);
    
    text((b.avgx- 640)/1700, b.maxx+10, b.miny);
    text((b.avgy- 480)/1700, b.maxx+10, b.miny+10);
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
    
    Apx = (   top.avgx - 640)/1700;
    Apy = (   top.avgy - 480)/1700;
    Bpx = (middle.avgx - 640)/1700;
    Bpy = (middle.avgy - 480)/1700;
    Cpx = (bottom.avgx - 640)/1700;
    Cpy = (bottom.avgy - 480)/1700;
    
  }
  
  A[0][0] =     (Ay - By + Apy*Az - Bpy*Bz)/(Apy - Bpy) - (Ax - Bx + Apx*Az - Bpx*Bz)/(Apx - Bpx);
  A[0][1] = - (2*Apy*Ax - 2*Bpy*Bx)/(Apy - Bpy) - (2*Az - 2*Bz - 2*Apx*Ax + 2*Bpx*Bx)/(Apx - Bpx);
  A[0][2] =                               - (2*Ax - 2*Bx)/(Apy - Bpy) - (2*Ay - 2*By)/(Apx - Bpx);
  A[0][3] =   (2*Apx*Ay - 2*Bpx*By)/(Apx - Bpx) + (2*Az - 2*Bz - 2*Apy*Ay + 2*Bpy*By)/(Apy - Bpy);
  A[1][0] =                 (Ax - Cx + Apx*Az - Cpx*Cz)/(Apx - Cpx) - (Ax - Bx + Apx*Az - Bpx*Bz)/(Apx - Bpx);
  A[1][1] = (2*Az - 2*Cz - 2*Apx*Ax + 2*Cpx*Cx)/(Apx - Cpx) - (2*Az - 2*Bz - 2*Apx*Ax + 2*Bpx*Bx)/(Apx - Bpx);
  A[1][2] =                                             (2*Ay - 2*Cy)/(Apx - Cpx) - (2*Ay - 2*By)/(Apx - Bpx);
  A[1][3] =                             (2*Apx*Ay - 2*Bpx*By)/(Apx - Bpx) - (2*Apx*Ay - 2*Cpx*Cy)/(Apx - Cpx);
  A[2][0] =     (Ay - Cy + Apy*Az - Cpy*Cz)/(Apy - Cpy) - (Ax - Cx + Apx*Az - Cpx*Cz)/(Apx - Cpx);
  A[2][1] = - (2*Apy*Ax - 2*Cpy*Cx)/(Apy - Cpy) - (2*Az - 2*Cz - 2*Apx*Ax + 2*Cpx*Cx)/(Apx - Cpx);
  A[2][2] =                               - (2*Ax - 2*Cx)/(Apy - Cpy) - (2*Ay - 2*Cy)/(Apx - Cpx);
  A[2][3] =   (2*Apx*Ay - 2*Cpx*Cy)/(Apx - Cpx) + (2*Az - 2*Cz - 2*Apy*Ay + 2*Cpy*Cy)/(Apy - Cpy);
  A[3][0] = 1;
  A[3][1] = 0;
  A[3][2] = 0;
  A[3][3] = 0;
  
  A2[0][0] =   (Ax - Bx + Apx*Az - Bpx*Bz)/(Apx - Bpx) + (Ay - By - Apy*Az + Bpy*Bz)/(Apy - Bpy);
  A2[0][1] = (2*Az - 2*Bz + 2*Apy*Ay - 2*Bpy*By)/(Apy - Bpy) - (2*Apx*Ay - 2*Bpx*By)/(Apx - Bpx);
  A2[0][2] =                               (2*Ax - 2*Bx)/(Apy - Bpy) - (2*Ay - 2*By)/(Apx - Bpx);
  A2[0][3] =   (Ax - Bx - Apx*Az + Bpx*Bz)/(Apx - Bpx) - (Ay - By - Apy*Az + Bpy*Bz)/(Apy - Bpy);
  A2[0][4] = (2*Apy*Ax - 2*Bpy*Bx)/(Apy - Bpy) - (2*Az - 2*Bz + 2*Apx*Ax - 2*Bpx*Bx)/(Apx - Bpx);
  A2[0][5] = - (Ax - Bx - Apx*Az + Bpx*Bz)/(Apx - Bpx) - (Ay - By + Apy*Az - Bpy*Bz)/(Apy - Bpy);
  A2[1][0] =                 (Ax - Bx + Apx*Az - Bpx*Bz)/(Apx - Bpx) - (Ax - Cx + Apx*Az - Cpx*Cz)/(Apx - Cpx);
  A2[1][1] =                             (2*Apx*Ay - 2*Cpx*Cy)/(Apx - Cpx) - (2*Apx*Ay - 2*Bpx*By)/(Apx - Bpx);
  A2[1][2] =                                             (2*Ay - 2*Cy)/(Apx - Cpx) - (2*Ay - 2*By)/(Apx - Bpx);
  A2[1][3] =                 (Ax - Bx - Apx*Az + Bpx*Bz)/(Apx - Bpx) - (Ax - Cx - Apx*Az + Cpx*Cz)/(Apx - Cpx);
  A2[1][4] = (2*Az - 2*Cz + 2*Apx*Ax - 2*Cpx*Cx)/(Apx - Cpx) - (2*Az - 2*Bz + 2*Apx*Ax - 2*Bpx*Bx)/(Apx - Bpx);
  A2[1][5] =                 (Ax - Cx - Apx*Az + Cpx*Cz)/(Apx - Cpx) - (Ax - Bx - Apx*Az + Bpx*Bz)/(Apx - Bpx);
  A2[2][0] =   (Ax - Cx + Apx*Az - Cpx*Cz)/(Apx - Cpx) + (Ay - Cy - Apy*Az + Cpy*Cz)/(Apy - Cpy);
  A2[2][1] = (2*Az - 2*Cz + 2*Apy*Ay - 2*Cpy*Cy)/(Apy - Cpy) - (2*Apx*Ay - 2*Cpx*Cy)/(Apx - Cpx);
  A2[2][2] =                               (2*Ax - 2*Cx)/(Apy - Cpy) - (2*Ay - 2*Cy)/(Apx - Cpx);
  A2[2][3] =   (Ax - Cx - Apx*Az + Cpx*Cz)/(Apx - Cpx) - (Ay - Cy - Apy*Az + Cpy*Cz)/(Apy - Cpy);
  A2[2][4] = (2*Apy*Ax - 2*Cpy*Cx)/(Apy - Cpy) - (2*Az - 2*Cz + 2*Apx*Ax - 2*Cpx*Cx)/(Apx - Cpx);
  A2[2][5] = - (Ax - Cx - Apx*Az + Cpx*Cz)/(Apx - Cpx) - (Ay - Cy + Apy*Az - Cpy*Cz)/(Apy - Cpy);
  A2[3][0] = 1;
  A2[3][1] = 0;
  A2[3][2] = 0;
  A2[3][3] = 1;
  A2[3][4] = 0;
  A2[3][5] = 1;
   

  //Matrix matb = Matrix.array(b);

  Matrix Ainverse = Matrix.inverse( Matrix.array(A) );
  Matrix q = Matrix.Multiply(Ainverse, Matrix.array(b) );
 
  float norm = q.array[0][0]*q.array[0][0]+q.array[1][0]*q.array[1][0];
  norm = norm + q.array[2][0]*q.array[2][0]+q.array[3][0]*q.array[3][0];
  norm = 1/sqrt(norm);
  q = MultiplyF(q, norm);
  
  //Matrix.print(q);
  //Matrix.print(b);
  //text(q.array[0][0], 100, 200);
  //text(q.array[1][0], 100, 210);
  //text(q.array[2][0], 100, 220);
  //text(q.array[3][0], 100, 230);
  
  b2[0][0] = q.array[1][0]*q.array[1][0];
  b2[1][0] = q.array[1][0]*q.array[2][0];
  b2[2][0] = q.array[1][0]*q.array[3][0];
  b2[3][0] = q.array[2][0]*q.array[2][0];
  b2[4][0] = q.array[2][0]*q.array[3][0];
  b2[5][0] = q.array[3][0]*q.array[3][0];
  
//  Matrix matb2 = Matrix.array(b2);
  
  Matrix b4 = Matrix.Multiply( Matrix.array(A2) , Matrix.array(b2) );
  Matrix matb = Matrix.subtract( Matrix.array(b) , b4 );
  
  q = Matrix.Multiply(Ainverse, matb );
  
  norm = q.array[0][0]*q.array[0][0]+q.array[1][0]*q.array[1][0];
  norm = norm + q.array[2][0]*q.array[2][0]+q.array[3][0]*q.array[3][0];
  norm = 1/sqrt(norm);
  q = MultiplyF(q, norm);
  
  text(q.array[0][0], 100, 200);
  text(q.array[1][0], 100, 210);
  text(q.array[2][0], 100, 220);
  text(q.array[3][0], 100, 230);
  
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

Matrix MultiplyF(Matrix a, float b) {
  float[][] ar = a.array;

  for (int j = 0; j < ar.length; j++) {
    for (int i = 0; i < ar[0].length; i++) {
      ar[j][i] = ar[j][i] * b;
    }
  }
  return Matrix.array(ar);
}
