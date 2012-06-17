int Width = 1440;
int Height = 900;
int scrollback = 100; // lines of scrollback in the console
int controllerPort = 9001;
OscHandler oscHandler;
Console console;

/*_____________________________________________________________________________
 * setup
 *____________________________________________________________________________*/
void setup() {
  size(Width, Height);
  smooth();
  oscHandler = new OscHandler();
  oscHandler.listen(controllerPort);
  console = new Console(scrollback);
}

/*_____________________________________________________________________________
 * run
 *____________________________________________________________________________*/
void draw() {
  background(0);
  oscHandler.draw();
  console.draw();
}

void oscEvent(OscMessage m) {
  println("received message");
  if(!m.isPlugged()) {
    println(
          "unknown message received at "
        +  m.addrPattern()
        + " with type "
        +  m.typetag()
    );
  }
}
