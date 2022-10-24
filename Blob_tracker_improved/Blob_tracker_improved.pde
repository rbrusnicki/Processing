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
float Ax=0.0, Ay=-3*k, Az=0.0, Bx=0.0, By=k, Bz=-2*k, Cx=0.0, Cy=2*k, Cz=0.0;
float[][] A = {{0, 0, 0, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}};
float[][] A2 = {{0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0}};
float[][] b = {{0}, {0}, {0}, {1}};
float[][] b2 = {{0}, {0}, {0}, {0}, {0}, {0}};
float[][] M1 = {{0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}};
float[][] M2 = {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}};
float[][] b1 = {{0}, {0}, {0}, {0}, {0}, {0}, {0}, {0}, {0}, {0}};

ArrayList<Blob> blobs = new ArrayList<Blob>();

void setup() {
  size(1280, 960);  //divide by 1700 to get in m at 1,00m distance
  video = new Capture(this, width, height);
  video.start();
  // Start off tracking for red
  trackColor = color(255, 255, 255);
  targetColor = color(0, 255, 0);
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
        for (Blob b : blobs) {
          if ( b.isNear(x, y) ) {
            b.add(x, y);
            found = true;
            break;
          }
        }

        if (!found) {
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
  stroke(color(0, 0, 0));
  fill(color(50, 50, 50));
  ellipse(640, 120, 20, 20);
  ellipse(640, 600, 20, 20);
  ellipse(640, 720, 20, 20);
  textSize(16);
  // Tracks leds
  for (Blob b : blobs) {
    b.show();
    // Draw a circle at the tracked pixel
    fill(targetColor);
    strokeWeight(2.0);
    stroke(targetColor);
    ellipse(b.avgx, b.avgy, 10, 10);

    text((b.avgx- 640)/1700, b.maxx+10, b.miny);
    text((b.avgy- 480)/1700, b.maxx+10, b.miny+16);
  }

  // Draw measurements
  if ( blobs.size() == 3 ) {
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

    //For debbuging
    //Apx = -0.0688;
    //Apy = -0.3560;
    //Bpx = -0.0389;
    //Bpy = -0.0131;
    //Cpx =  0.0169;
    //Cpy =  0.0874;
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

  Matrix Ainverse = inverse4by4( Matrix.array(A) );
  Matrix q = Matrix.Multiply(Ainverse, Matrix.array(b) );

  float norm = q.array[0][0]*q.array[0][0]+q.array[1][0]*q.array[1][0];
  norm = norm + q.array[2][0]*q.array[2][0]+q.array[3][0]*q.array[3][0];
  norm = 1/sqrt(norm);
  q = MultiplyF(q, norm);

 
  //Matrix.print(b);
  //text(q.array[0][0], 100, 200);
  //text(q.array[1][0], 100, 210);
  //text(q.array[2][0], 100, 220);
  //text(q.array[3][0], 100, 230);

  for (int i = 0; i < 4; i++ ) {
    b2[0][0] = q.array[1][0]*q.array[1][0];
    b2[1][0] = q.array[1][0]*q.array[2][0];
    b2[2][0] = q.array[1][0]*q.array[3][0];
    b2[3][0] = q.array[2][0]*q.array[2][0];
    b2[4][0] = q.array[2][0]*q.array[3][0];
    b2[5][0] = q.array[3][0]*q.array[3][0];

    //  Matrix matb2 = Matrix.array(b2);

    Matrix b4 = Matrix.Multiply( Matrix.array(A2), Matrix.array(b2) );
    Matrix matb = Matrix.subtract( Matrix.array(b), b4 );

    q = Matrix.Multiply(Ainverse, matb );

    norm = q.array[0][0]*q.array[0][0]+q.array[1][0]*q.array[1][0];
    norm = norm + q.array[2][0]*q.array[2][0]+q.array[3][0]*q.array[3][0];
    norm = 1/sqrt(norm);
    q = MultiplyF(q, norm);
    
  }

  text("QUATERNION",  10,  64);
  text(q.array[0][0], 10,  84);
  text(q.array[1][0], 10, 100);
  text(q.array[2][0], 10, 116);
  text(q.array[3][0], 10, 132);

  //Solução para posição
  float[] aux0 = {Ax + Apx*Az, 2*Az - 2*Apx*Ax, 2*Ay, -2*Apx*Ay, - Ax - Apx*Az, 2*Apx*Ay, 2*Ay, Apx*Az - Ax, 2*Az + 2*Apx*Ax, Ax - Apx*Az};
  float[] aux1 = {Ay + Apy*Az, -2*Apy*Ax, -2*Ax, 2*Az - 2*Apy*Ay, Ay - Apy*Az, 2*Az + 2*Apy*Ay, 2*Ax, Apy*Az - Ay, 2*Apy*Ax, - Ay - Apy*Az};
  float[] aux2 = {Bx + Bpx*Bz, 2*Bz - 2*Bpx*Bx, 2*By, -2*Bpx*By, - Bx - Bpx*Bz, 2*Bpx*By, 2*By, Bpx*Bz - Bx, 2*Bz + 2*Bpx*Bx, Bx - Bpx*Bz};
  float[] aux3 = {By + Bpy*Bz, -2*Bpy*Bx, -2*Bx, 2*Bz - 2*Bpy*By, By - Bpy*Bz, 2*Bz + 2*Bpy*By, 2*Bx, Bpy*Bz - By, 2*Bpy*Bx, - By - Bpy*Bz};
  float[] aux4 = {Cx + Cpx*Cz, 2*Cz - 2*Cpx*Cx, 2*Cy, -2*Cpx*Cy, - Cx - Cpx*Cz, 2*Cpx*Cy, 2*Cy, Cpx*Cz - Cx, 2*Cz + 2*Cpx*Cx, Cx - Cpx*Cz};
  float[] aux5 = {Cy + Cpy*Cz, -2*Cpy*Cx, -2*Cx, 2*Cz - 2*Cpy*Cy, Cy - Cpy*Cz, 2*Cz + 2*Cpy*Cy, 2*Cx, Cpy*Cz - Cy, 2*Cpy*Cx, - Cy - Cpy*Cz};

  float[][] M1 = {aux0, aux1, aux2, aux3, aux4, aux5};
  //Matrix.print(Matrix.array(M1));

  float[][] M2 = {{1, 0, Apx}, {0, 1, Apy}, {1, 0, Bpx}, {0, 1, Bpy}, {1, 0, Cpx}, {0, 1, Cpy}};
  float[][] M2t = {{1, 0, 1, 0, 1, 0}, {0, 1, 0, 1, 0, 1}, {Apx, Apy, Bpx, Bpy, Cpx, Cpy}};
  //Matrix.print(Matrix.array(M2));

  b1[0][0] = q.array[0][0]*q.array[0][0];
  b1[1][0] = q.array[0][0]*q.array[1][0];
  b1[2][0] = q.array[0][0]*q.array[2][0];
  b1[3][0] = q.array[0][0]*q.array[3][0];
  b1[4][0] = q.array[1][0]*q.array[1][0];
  b1[5][0] = q.array[1][0]*q.array[2][0];
  b1[6][0] = q.array[1][0]*q.array[3][0];
  b1[7][0] = q.array[2][0]*q.array[2][0];
  b1[8][0] = q.array[2][0]*q.array[3][0];
  b1[9][0] = q.array[3][0]*q.array[3][0];
  //Matrix.print(Matrix.array(b1));

  Matrix AUX1 = Matrix.Multiply( Matrix.array(M2t), Matrix.array(M2));
  Matrix AUX2 = Matrix.Multiply( Matrix.array(M2t), Matrix.Multiply(Matrix.array(M1), Matrix.array(b1)));
  //Matrix.print(AUX2);

  Matrix AUX3 = inverse3by3(AUX1);
  //Matrix.print(AUX3);

  Matrix pos = Matrix.Multiply(AUX3, AUX2);

  text("POSIÇÃO [m]"   , 10, 180);
  text(-pos.array[0][0], 10, 200);
  text(-pos.array[1][0], 10, 216);
  text(-pos.array[2][0], 10, 232);


  Matrix r = quat2angleXYZ(q);
  text("ANGULOS DE EULER [°]",  10, 280); 
  text( r.array[0][0] * 180/PI, 10, 300);
  text( r.array[1][0] * 180/PI, 10, 316);
  text( r.array[2][0] * 180/PI, 10, 332);
  
  
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

Matrix Transpose(Matrix a, int l, int c) {
  float[][] arr = new float[c][l];
  for (int i = 0; i < c; i++) {
    for (int j = 0; j < l; j++) {

      arr[i][j] = a.array[j][i];
    }
  }
  return Matrix.array(arr);
}

float det3by3(Matrix a) {
  float det = a.array[0][0]*a.array[1][1]*a.array[2][2] + a.array[0][1]*a.array[1][2]*a.array[2][0] + a.array[0][2]*a.array[1][0]*a.array[2][1];
  det = det - a.array[0][2]*a.array[1][1]*a.array[2][0] - a.array[0][1]*a.array[1][0]*a.array[2][2] - a.array[0][0]*a.array[1][2]*a.array[2][1];
  return det;
}

Matrix inverse3by3(Matrix a) {
  float[][] adj = new float[3][3];

  float det = det3by3(a);

  if (det == 0) {
    throw new IllegalArgumentException("Null determinant of 3x3 Matrix");
  }

  adj[0][0] = +(a.array[1][1]*a.array[2][2] - a.array[1][2]*a.array[2][1]) / det;
  adj[1][0] = -(a.array[1][0]*a.array[2][2] - a.array[1][2]*a.array[2][0]) / det;
  adj[2][0] = +(a.array[1][0]*a.array[2][1] - a.array[1][1]*a.array[2][0]) / det;

  adj[0][1] = -(a.array[0][1]*a.array[2][2] - a.array[0][2]*a.array[2][1]) / det;
  adj[1][1] = +(a.array[0][0]*a.array[2][2] - a.array[0][2]*a.array[2][0]) / det;
  adj[2][1] = -(a.array[0][0]*a.array[2][1] - a.array[0][1]*a.array[2][0]) / det;

  adj[0][2] = +(a.array[0][1]*a.array[1][2] - a.array[0][2]*a.array[1][1]) / det;
  adj[1][2] = -(a.array[0][0]*a.array[1][2] - a.array[0][2]*a.array[1][0]) / det;
  adj[2][2] = +(a.array[0][0]*a.array[1][1] - a.array[0][1]*a.array[1][0]) / det;

  return Matrix.array(adj);
}

float det4by4(Matrix a) {

  float [][] M1 = { {a.array[1][1], a.array[1][2], a.array[1][3]}, {a.array[2][1], a.array[2][2], a.array[2][3]}, {a.array[3][1], a.array[3][2], a.array[3][3]} };
  float [][] M2 = { {a.array[1][0], a.array[1][2], a.array[1][3]}, {a.array[2][0], a.array[2][2], a.array[2][3]}, {a.array[3][0], a.array[3][2], a.array[3][3]} };
  float [][] M3 = { {a.array[1][0], a.array[1][1], a.array[1][3]}, {a.array[2][0], a.array[2][1], a.array[2][3]}, {a.array[3][0], a.array[3][1], a.array[3][3]} };
  float [][] M4 = { {a.array[1][0], a.array[1][1], a.array[1][2]}, {a.array[2][0], a.array[2][1], a.array[2][2]}, {a.array[3][0], a.array[3][1], a.array[3][2]} };


  float det = a.array[0][0] * det3by3(Matrix.array(M1));
  det = det - a.array[0][1] * det3by3(Matrix.array(M2));
  det = det + a.array[0][2] * det3by3(Matrix.array(M3));
  det = det - a.array[0][3] * det3by3(Matrix.array(M4));
  

  if (det == 0) {
    throw new IllegalArgumentException("Null determinant of 4x4 Matrix");
  }
  return det;
}

Matrix inverse4by4(Matrix a) {
  float[][] adj = new float[4][4];
  float det = det4by4(a);
  
  float [][] M11 = {{a.array[1][1],a.array[1][2],a.array[1][3]}, {a.array[2][1],a.array[2][2],a.array[2][3]}, {a.array[3][1],a.array[3][2],a.array[3][3]}};
  float [][] M12 = {{a.array[1][0],a.array[1][2],a.array[1][3]}, {a.array[2][0],a.array[2][2],a.array[2][3]}, {a.array[3][0],a.array[3][2],a.array[3][3]}};
  float [][] M13 = {{a.array[1][0],a.array[1][1],a.array[1][3]}, {a.array[2][0],a.array[2][1],a.array[2][3]}, {a.array[3][0],a.array[3][1],a.array[3][3]}};
  float [][] M14 = {{a.array[1][0],a.array[1][1],a.array[1][2]}, {a.array[2][0],a.array[2][1],a.array[2][2]}, {a.array[3][0],a.array[3][1],a.array[3][2]}};
  float [][] M21 = {{a.array[0][1],a.array[0][2],a.array[0][3]}, {a.array[2][1],a.array[2][2],a.array[2][3]}, {a.array[3][1],a.array[3][2],a.array[3][3]}};
  float [][] M22 = {{a.array[0][0],a.array[0][2],a.array[0][3]}, {a.array[2][0],a.array[2][2],a.array[2][3]}, {a.array[3][0],a.array[3][2],a.array[3][3]}};
  float [][] M23 = {{a.array[0][0],a.array[0][1],a.array[0][3]}, {a.array[2][0],a.array[2][1],a.array[2][3]}, {a.array[3][0],a.array[3][1],a.array[3][3]}};
  float [][] M24 = {{a.array[0][0],a.array[0][1],a.array[0][2]}, {a.array[2][0],a.array[2][1],a.array[2][2]}, {a.array[3][0],a.array[3][1],a.array[3][2]}};
  float [][] M31 = {{a.array[0][1],a.array[0][2],a.array[0][3]}, {a.array[1][1],a.array[1][2],a.array[1][3]}, {a.array[3][1],a.array[3][2],a.array[3][3]}};
  float [][] M32 = {{a.array[0][0],a.array[0][2],a.array[0][3]}, {a.array[1][0],a.array[1][2],a.array[1][3]}, {a.array[3][0],a.array[3][2],a.array[3][3]}};
  float [][] M33 = {{a.array[0][0],a.array[0][1],a.array[0][3]}, {a.array[1][0],a.array[1][1],a.array[1][3]}, {a.array[3][0],a.array[3][1],a.array[3][3]}};
  float [][] M34 = {{a.array[0][0],a.array[0][1],a.array[0][2]}, {a.array[1][0],a.array[1][1],a.array[1][2]}, {a.array[3][0],a.array[3][1],a.array[3][2]}};
  float [][] M41 = {{a.array[0][1],a.array[0][2],a.array[0][3]}, {a.array[1][1],a.array[1][2],a.array[1][3]}, {a.array[2][1],a.array[2][2],a.array[2][3]}};
  float [][] M42 = {{a.array[0][0],a.array[0][2],a.array[0][3]}, {a.array[1][0],a.array[1][2],a.array[1][3]}, {a.array[2][0],a.array[2][2],a.array[2][3]}};
  float [][] M43 = {{a.array[0][0],a.array[0][1],a.array[0][3]}, {a.array[1][0],a.array[1][1],a.array[1][3]}, {a.array[2][0],a.array[2][1],a.array[2][3]}};
  float [][] M44 = {{a.array[0][0],a.array[0][1],a.array[0][2]}, {a.array[1][0],a.array[1][1],a.array[1][2]}, {a.array[2][0],a.array[2][1],a.array[2][2]}};
  
  
  adj[0][0] = +( det3by3(Matrix.array(M11)) ) / det;
  adj[1][0] = -( det3by3(Matrix.array(M12)) ) / det;
  adj[2][0] = +( det3by3(Matrix.array(M13)) ) / det;
  adj[3][0] = -( det3by3(Matrix.array(M14)) ) / det;

  adj[0][1] = -( det3by3(Matrix.array(M21)) ) / det;
  adj[1][1] = +( det3by3(Matrix.array(M22)) ) / det;
  adj[2][1] = -( det3by3(Matrix.array(M23)) ) / det;
  adj[3][1] = +( det3by3(Matrix.array(M24)) ) / det;

  adj[0][2] = +( det3by3(Matrix.array(M31)) ) / det;
  adj[1][2] = -( det3by3(Matrix.array(M32)) ) / det;
  adj[2][2] = +( det3by3(Matrix.array(M33)) ) / det;
  adj[3][2] = -( det3by3(Matrix.array(M34)) ) / det;

  adj[0][3] = -( det3by3(Matrix.array(M41)) ) / det;
  adj[1][3] = +( det3by3(Matrix.array(M42)) ) / det;
  adj[2][3] = -( det3by3(Matrix.array(M43)) ) / det;
  adj[3][3] = +( det3by3(Matrix.array(M44)) ) / det;

  return Matrix.array(adj);
}

Matrix quat2angleXYZ(Matrix q) {
  float  r11 = -2*(q.array[2][0]*q.array[3][0] - q.array[0][0]*q.array[1][0]);
  float  r12 =  q.array[0][0]*q.array[0][0] - q.array[1][0]*q.array[1][0] - q.array[2][0]*q.array[2][0] + q.array[3][0]*q.array[3][0];
  float  r21 = 2*(q.array[1][0]*q.array[3][0] + q.array[0][0]*q.array[2][0]);
  float  r31 = -2*(q.array[1][0]*q.array[2][0] - q.array[0][0]*q.array[3][0]);
  float  r32 = q.array[0][0]*q.array[0][0] + q.array[1][0]*q.array[1][0] - q.array[2][0]*q.array[2][0] - q.array[3][0]*q.array[3][0];
  Matrix  r = threeaxisrot(r11, r12, r21, r31, r32);
  return r;
}

Matrix threeaxisrot(float r11, float r12, float r21, float r31, float r32) {
  // Find angles for rotations about X, Y, and Z axes
  float r11a = 0.0;
  float r12a = 1.0;

  float [][] r = {{0.0}, {0.0}, {0.0}};

  r[0][0] = atan2( r11, r12 );

  if (r21 > 1) {
    r21 = 1;
  }
  else { 
    if (r21 < -1) {
          r21 = -1;
    }
  }
  r[1][0] = asin( r21 );
  r[2][0] = atan2( r31, r32 );

  if (abs(r21) == 1.0) {
    r[0][0] = atan2(r11a, r12a);
    r[2][0] = 0.0;
  }

  return Matrix.array(r);
}
