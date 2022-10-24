class Blob {
  float minx;
  float maxx;
  float miny;
  float maxy;
  float avgx;
  float avgy;
  
  ArrayList<PVector> points;

  Blob(float x, float y){
    minx = x;
    miny = y;
    maxx = x;
    maxy = y;
    avgx = x;
    avgy = y;
    points = new ArrayList<PVector>();
    points.add(new PVector(x,y));
  }

  boolean isNear(float x, float y) {
    //float cx = (minx + maxx)/2;
    //float cy = (miny + maxy)/2;
    //float d = distSq(cx, cy, x, y);
    
    float d = 1000000;
    for (PVector v : points) {
      float tempD = distSq(x, y, v.x, v.y);
      if( tempD < d) {
        d = tempD; 
      }
    }
    
    if(d < distance_threshold*distance_threshold) {
      return true;
    } else {
      return false;
    }
  }
  
  void add(float x, float y) {
    points.add(new PVector(x,y));
    minx = min(minx, x);
    miny = min(miny, y);
    maxx = max(maxx, x);
    maxy = max(maxy, y);
    avgx = (minx + maxx)/2;
    avgy = (miny + maxy)/2;
  }
  
  void show() {
    stroke(0);
    fill(255);
    strokeWeight(2);
    rectMode(CORNERS);
    //rect(minx,miny,maxx,maxy);
    for (PVector v : points) {
      stroke(0, 0, 255);
      point(v.x, v.y);
    }
  }
}
