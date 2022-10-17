class Blob {
  float minx;
  float maxx;
  float miny;
  float maxy;
  

  Blob(float x, float y){
    minx = x;
    miny = y;
    maxx = x;
    maxy = y;
  }

  boolean isNear(float x, float y) {
    float cx = (minx + maxx)/2;
    float cy = (miny + maxy)/2;

    float d = distSq(cx, cy, x, y);
    
    if(d < distance_threshold) {
      return true;
    } else {
      return false;
    }
  }
  
  void add(float px, float py) {
     minx = min(minx, x);
     miny = min(miny, y);
     maxx = max(maxx, x);
     maxy = max(maxy, y);
  }
  
  void show() {
    stroke(0);
    fill(255);
    strokeWeight(2);
    rectMode(CORNERS);
    rect(minx,miny,maxx,maxy);
  }
}
