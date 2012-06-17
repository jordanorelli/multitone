class Console
{
  String[] lines;
  PFont font;

  Console(int scrollback) {
    lines = new String[scrollback];
    font = loadFont("Inconsolata-16.vlw");
  }

  void draw() {

  }
}
