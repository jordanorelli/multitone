import oscP5.*;
import netP5.*;

class Tick
{
  float x;
  float y;
  float d;
  int age;
  int maxAge;

  Tick(float x, float y, float rev) {
    this.x = x;
    this.y = y;
    this.maxAge = (int)lerp(10, 40, rev);
  }

  void draw() {
    noFill();
    stroke(255, map(this.age, 0, this.maxAge, 255, 0));
    // stroke(255);
    strokeWeight(this.age);
    this.d = this.age * this.maxAge;
    ellipse(this.x, this.y, this.d, this.d);
    this.age++;
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

  void xy(float x, float y, float rev) {
    Tick tick = new Tick(lerp(0, width, x), lerp(height, 0, y), rev);
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
