//Gravity simulator DOCTOR MYSTERY February 2014


ArrayList<Body> theuniverse;
ArrayList<Point> points;
int clicktime = 0;
PVector heading;
float initx, inity;
boolean runnew = true;
int gravconstant = 8;
int radiusscalar = 2;
int massscalar = 1;
float hue = 0;
int end;
color white = color(255);

Body TESTBODY;
PVector EMPTY;

void setup () {
  size (800, 750);
  background (0);
  fill(255, 255, 255);
  stroke(255);
  colorMode(HSB);
  textSize(14);

  theuniverse = new ArrayList<Body>();
  points = new ArrayList<Point>();
}

void draw() {

  if (keyPressed == true) {

    if (key == 32) {
      theuniverse.clear();
      points.clear();
      background(0);
    }
    if (keyCode == SHIFT) {
      points.clear();
    }
    if (keyCode == DOWN) {
      massscalar = 50;
    }
  }
  else {
    massscalar = 1;
  }

  background(0);

  if (mousePressed && (mouseButton == LEFT)) {

    if (runnew==true) {
      initx = mouseX;
      inity = mouseY;
      runnew = false;
    } 

    hue = 58/((100.0/clicktime+1)+1);
    fill(hue, 255, 255);
    stroke(hue, 255, 255);
    line(initx, inity, mouseX, mouseY);
    float inr = radiusscalar*pow(clicktime*massscalar, 0.33);
    ellipse(initx, inity, inr, inr);    
    clicktime++;
  }

  for (int w = 0; w<points.size(); w++) {
    set(points.get(w).x, points.get(w).y, white);
  }


  end = theuniverse.size();
  for (int i = 0; i < end; i++) {
    theuniverse.get(i).checktits(theuniverse);
  }
  for (int h = 0; h < end; h++) {
    theuniverse.get(h).update();
    if (theuniverse.get(h).x>0 && theuniverse.get(h).x<width && theuniverse.get(h).y>0 && theuniverse.get(h).y<height) {
      points.add(new Point(theuniverse.get(h).x, theuniverse.get(h).y));
    }
    theuniverse.get(h).display();
  }

  fill(0, 0, 255);
  text("Active Bodies: "+theuniverse.size(), 8, 15);
  text("Framerate: "+round(frameRate), 8, 30);
  //println(" ");
}


void mouseReleased () {

  heading = new PVector (mouseX-initx, mouseY-inity); 
  theuniverse.add(new Body(clicktime*massscalar, heading, initx, inity, theuniverse.size(), hue));

  clicktime = 0;
  runnew = true;
  massscalar = 1;
}

//boolean sketchFullScreen() {
//  return true;
//}
class Body {

  //Variables

  float x;
  float y;
  float mass ;
  PVector velocity;
  PVector accel;
  PVector force;
  float r;
  int index;
  float bodyhue;
  int sloppyend;


  //Constructor

  Body(float _time, PVector _inital, float _x, float _y, int _index, float _hue) {
    mass = _time;       
    x = _x;
    y = _y;
    velocity = new PVector (_inital.x/60, _inital.y/60);  
    force = new PVector (0, 0);
    accel = new PVector (0, 0);
    r = radiusscalar*pow(mass, 0.33);  
    index = _index;
    bodyhue = _hue;
  }

  //Methods

  void update () {
    accel.x = force.x/mass;
    accel.y = force.y/mass;
    velocity.x += accel.x;
    velocity.y += accel.y;    
    x += velocity.x;
    y += velocity.y;
    force = new PVector(0, 0);
   //print(index, ": ", velocity.mag(), " ");
  }

  void display () {
    fill(bodyhue, 255, 255);
    stroke(bodyhue, 255, 255);
    ellipse(x, y, r, r);
  }

  void checktits (ArrayList<Body> _Universe) {
    sloppyend = _Universe.size();
    for (int g = 0; g<sloppyend; g++) {
      if ( g != index) {
        PVector forceadd = new PVector ((_Universe.get(g).x-x), (_Universe.get(g).y-y));
        float dist = dist(x, y, _Universe.get(g).x, _Universe.get(g).y);
        if (dist> r-_Universe.get(g).r-2) {
          float mag = gravconstant*(mass*_Universe.get(g).mass)/(dist*dist);
          forceadd.mult(mag/forceadd.mag());
          force.add(forceadd);
        }
        else{
        combine(_Universe.get(g));
        }
      }
    }
  }
  
  void combine(Body _body) {
  float newmass = mass+_body.mass;
  float newhue = 58/((100.0/newmass+1)+1); 
  PVector newvelocity;
  newvelocity = new PVector((velocity.x*mass+_body.velocity.x*_body.mass)/(mass+_body.mass), (mass*velocity.y+_body.mass*_body.velocity.y)/(mass+_body.mass));
  theuniverse.set(index, new Body(newmass, newvelocity, x, y, index, newhue)); 
  theuniverse.remove(_body.index);
  end--;
  sloppyend--;
  for(int l = _body.index; l<theuniverse.size(); l++) {
  theuniverse.get(l).shift();
  }
  }
  
  void shift() {
  index--;
  }
  
}


class Point {
  int x;
  int y;
  
    Point(float xin, float yin) {
    x=round(xin);
    y=round(yin);    
    }
}


