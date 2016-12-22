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
  size (displayWidth, displayHeight);
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

boolean sketchFullScreen() {
  return true;
}
