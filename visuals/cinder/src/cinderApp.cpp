#include "cinder/app/AppBasic.h"
#include "cinder/gl/gl.h"
#include "OscListener.h"
#include "NotePool.h"
#include "note.h"
#include <list>

#include "cinder/cairo/Cairo.h"
#include "cinder/Path2d.h"


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
    settings->setWindowSize(1340, 900);
    settings->setFrameRate(60.0f);
}

void cinderApp::setup() {
    //app::setFullScreen(true);
    gl::enableAlphaBlending();
    glEnableClientState( GL_VERTEX_ARRAY );
    glLineWidth(10);
    listener.setup(9001);
    
    for( int s = 0; s < NUM_SEGMENTS; s++ ) {
        float t = s / (float)NUM_SEGMENTS * 2.0f * 3.14159f;
        Note::verts[s*2+0] = math<float>::cos( t );
        Note::verts[s*2+1] = math<float>::sin( t );
    }
    glVertexPointer( 2, GL_FLOAT, 0, Note::verts );
}

void cinderApp::mouseDown( MouseEvent event ) {
}

void cinderApp::update() {
    pool.update();

    while(listener.hasWaitingMessages()) {        
        osc::Message msg;
        listener.getNextMessage(&msg);
        Note * note = pool.getNote();
        note->init(msg.getArgAsFloat(0) * app::getWindowWidth(),
                  (1.0 - msg.getArgAsFloat(1)) * app::getWindowHeight(),
                  msg.getArgAsFloat(2)
        );
        // do bad things happen if i don't read these?
        msg.getArgAsFloat(2);
        msg.getArgAsInt32(3);
    }
}

void cinderApp::draw() {
	gl::clear( Color( 0, 0, 0 ) ); 
    pool.draw();
    // cairo::Context ctx( cairo::createWindowSurface() );	
	// renderScene( ctx );
}

CINDER_APP_BASIC( cinderApp, RendererGl )
