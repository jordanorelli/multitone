#include "cinder/app/AppBasic.h"
#include "cinder/gl/gl.h"
#include "OscListener.h"
#include "NotePool.h"
#include "note.h"
#include <list>

using namespace ci;
using namespace ci::app;
using namespace std;

class cinderApp : public AppBasic {
  public:
    void prepareSettings(Settings *);
	void setup();
	void mouseDown( MouseEvent event );	
	void update();
	void draw();
    osc::Listener listener;
    NotePool pool;
};

void cinderApp::prepareSettings(Settings *settings) {
    settings->setWindowSize(1024, 768);
    settings->setFrameRate(60.0f);
}

void cinderApp::setup() {
    // app::setFullScreen(true);
    gl::enableAlphaBlending();
    glEnableClientState( GL_VERTEX_ARRAY );
    glLineWidth(10);
    listener.setup(9001);
}

void cinderApp::mouseDown( MouseEvent event ) {
}

void cinderApp::update() {
    pool.update();

    while(listener.hasWaitingMessages()) {        
        osc::Message msg;
        listener.getNextMessage(&msg);
        pool.getNote()->pos = Vec2f(
                          msg.getArgAsFloat(0) * app::getWindowWidth(),
                          (1.0 - msg.getArgAsFloat(1)) * app::getWindowHeight()
        );
        float reverb = msg.getArgAsFloat(2);
        int waveform = msg.getArgAsInt32(3);
    }
}

void cinderApp::draw() {
	gl::clear( Color( 0, 0, 0 ) ); 
    pool.draw();
}

CINDER_APP_BASIC( cinderApp, RendererGl )
