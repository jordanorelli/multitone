import oscP5.*;
import netP5.*;

class Tick
{
  float x;
  float y;
  float d;
  float theta;
  int waveType;
  int age;
  int maxAge;

  Tick(float x, float y, float rev, int waveType) {
    this.theta = random(TWO_PI);
    this.x = x;
    this.y = y;
    this.maxAge = (int)lerp(10, 40, rev);
    this.waveType = waveType;
  }

  void draw() {
    switch(this.waveType) {
      case 1: // sin
        this.drawSin();
        break;
      case 2: // sqr
        this.drawSqr();
        break;
      case 3: // tri
        this.drawTri();
        break;
      case 4: // saw
        this.drawSaw();
        break;
    }
    this.age++;
  }

  void drawSin() {
    noFill();
    stroke(255, map(this.age, 0, this.maxAge, 255, 0));
    strokeWeight(this.age);
    this.d = this.age * this.maxAge;
    ellipse(this.x, this.y, this.d, this.d);
  }

  void drawSqr() {
    noFill();
    pushMatrix();
    translate(this.x, this.y);
    rotate(this.theta);
    stroke(255, map(this.age, 0, this.maxAge, 255, 0));
    strokeWeight(this.age);
    this.d = this.age * this.maxAge;
    rectMode(CENTER);
    rect(0, 0, this.d, this.d);
    popMatrix();
  }

  void drawSaw() {
    this.d = this.age * this.maxAge;
    stroke(255, map(this.age, 0, this.maxAge, 255, 0));
    strokeWeight(this.age);
    noFill();
    pushMatrix();
    translate(this.x, this.y);
    rotate(this.theta);
    beginShape();
    vertex(1.5 * this.d, 0.5 * this.d);
    vertex(1.5 * this.d, -1.5 * this.d);
    vertex(0.5 * this.d, -1.5 * this.d);
    vertex(0.5 * this.d, -0.5 * this.d);
    vertex(-1.5 * this.d, -0.5 * this.d);
    vertex(-1.5 * this.d, 1.5 * this.d);
    vertex(-0.5 * this.d, 1.5 * this.d);
    vertex(-0.5 * this.d, 0.5 * this.d);
    endShape(CLOSE);
    popMatrix();
  }

  void drawTri() {
    this.d = this.age * this.maxAge;
    noFill();
    pushMatrix();
    translate(this.x, this.y);
    rotate(this.theta);
    translate(0, 0.3 * this.d * sqrt(3));
    stroke(255, map(this.age, 0, this.maxAge, 255, 0));
    strokeWeight(this.age);
    beginShape();
    vertex(this.d, 0);
    vertex(0, -this.d * sqrt(3));
    vertex(-this.d, 0);
    endShape(CLOSE);
    popMatrix();
  }

  boolean dead() {
    return this.age >= this.maxAge;
  }
}

class Voice
{
  ArrayList presentTicks;
  ArrayList futureTicks;
  int id;

  Voice(int id) {
    this.presentTicks = new ArrayList();
    this.futureTicks = new ArrayList();
    this.id = id;
    println("voice " + id);
  }

  void draw() {
    for(int i = this.futureTicks.size() - 1; i >= 0; i--) {
      presentTicks.add(futureTicks.get(i));
      futureTicks.remove(i);
    }

    for(int i = this.presentTicks.size() - 1; i >= 0; i--) {
      Tick tick = (Tick)presentTicks.get(i);
      tick.draw();
      if(tick.dead()) {
        presentTicks.remove(i);
      }
    }
  }

  void xy(float x, float y, float rev, int waveType) {
    Tick tick = new Tick(lerp(0, width, x), lerp(height, 0, y), rev, waveType);
    futureTicks.add(tick);
    println("voice " + id + " received (" + x + ", " + y + ")");
  }
}

class OscHandler
{
  OscP5 oscP5;
  NetAddress outbound;
  Voice[] voices;

  OscHandler() {
    voices = new Voice[5];
    for(int i = 0; i < voices.length; i++) {
      voices[i] = new Voice(i + 1);
    }
  }

  void listen(int port) {
    this.oscP5 = new OscP5(this, port);
    for(int i = 0; i < voices.length; i++) {
      oscP5.plug(this.voices[i], "xy", "/voice/" + (i + 1));
    }
    println("listening on port " + port);
  }

  // nothing actually gets drawn, per se, it's just called that to indiicate
  // that it will run on ever frame.
  void draw() {
    for(int i = 0; i < this.voices.length; i++) {
      this.voices[i].draw();
    }
  }
}
