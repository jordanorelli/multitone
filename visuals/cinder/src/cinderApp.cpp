#include "cinder/app/AppBasic.h"
#include "cinder/gl/gl.h"
#include "OscListener.h"

using namespace ci;
using namespace ci::app;
using namespace std;

class cinderApp : public AppBasic {
  public:
	void setup();
	void mouseDown( MouseEvent event );	
	void update();
	void draw();
    void handleMessage(osc::Message *);
    osc::Listener listener;
};

void cinderApp::setup() {
    listener.setup(9001);
}

void cinderApp::mouseDown( MouseEvent event ) {
}

void cinderApp::handleMessage(osc::Message * msg) {
    std::string address = msg->getAddress();
    float x = msg->getArgAsFloat(0);
    float y = msg->getArgAsFloat(1);
    console() << address << " " << x << " " << y << endl;
}

void cinderApp::update() {
    while(listener.hasWaitingMessages()) {
        osc::Message msg;
        listener.getNextMessage(&msg);
        this->handleMessage(&msg);
    }
}

void cinderApp::draw() {
	// clear out the window with black
	gl::clear( Color( 0, 0, 0 ) ); 
}

CINDER_APP_BASIC( cinderApp, RendererGl )
