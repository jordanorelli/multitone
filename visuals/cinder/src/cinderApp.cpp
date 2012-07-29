#include "cinder/app/AppBasic.h"
#include "cinder/gl/gl.h"
#include "cinder/gl/GlslProg.h"
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
	void update();
	void draw();
    osc::Listener listener;
    NotePool * pool;    
    gl::GlslProg shader;

};

void cinderApp::prepareSettings(Settings *settings) {
    // settings->setWindowSize(1340, 900);
    settings->setWindowSize(1024, 768);
    settings->setFrameRate(60.0f);
}

void cinderApp::setup() {
    // app::setFullScreen(true);
    gl::enableAlphaBlending();
    shader = gl::GlslProg(loadResource("passThru_vert.glsl"), loadResource("red_frag.glsl"));
    listener.setup(9001);
    pool = new NotePool(shader);
}

void cinderApp::update() {
    pool->update();

    while(listener.hasWaitingMessages()) {        
        osc::Message msg;
        listener.getNextMessage(&msg);
        float x = msg.getArgAsFloat(0) * app::getWindowWidth();
        float y = (1.0 - msg.getArgAsFloat(1)) * app::getWindowHeight();
        float reverb = msg.getArgAsFloat(2);
        msg.getArgAsInt32(3);
        pool->addNote(x, y, reverb);
    }
}

void cinderApp::draw() {
	gl::clear( Color( 0, 0, 0 ) ); 
    shader.bind();
    pool->draw();
    shader.unbind();
}

CINDER_APP_BASIC( cinderApp, RendererGl )
