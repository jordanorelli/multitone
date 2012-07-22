#include "cinder/app/AppBasic.h"
#include "cinder/gl/gl.h"
#include "OscListener.h"
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
    void clearDead();
    osc::Listener listener;

    std::list<Note> notes;
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
    for(list<Note>::iterator i = notes.begin(); i != notes.end(); ++i) {
        i->update();
    }

    this->clearDead();
    
    while(listener.hasWaitingMessages()) {
        osc::Message msg;
        listener.getNextMessage(&msg);
        float x = msg.getArgAsFloat(0) * app::getWindowWidth();
        float y = (1.0 - msg.getArgAsFloat(1)) * app::getWindowHeight();
        float reverb = msg.getArgAsFloat(2);
        int waveform = msg.getArgAsInt32(3);
        this->notes.push_back(Note(x, y));
    }
}

void cinderApp::draw() {
	// clear out the window with black
	gl::clear( Color( 0, 0, 0 ) ); 
    for(list<Note>::iterator i = notes.begin(); i != notes.end(); ++i) {
        i->draw();
    }
}

void cinderApp::clearDead() {
    for(list<Note>::iterator i = notes.begin(); i != notes.end(); ++i) {
        if(!i->alive()) {
            notes.erase(i);
        }
    }
}

CINDER_APP_BASIC( cinderApp, RendererGl )
