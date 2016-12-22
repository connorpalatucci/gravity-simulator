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


