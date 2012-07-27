//
//  note.h
//  cinder
//
//  Created by Jordan Orelli on 7/21/12.
//  Copyright (c) 2012 betaworks. All rights reserved.
//

#ifndef cinder_note_h
#define cinder_note_h
#include "cinder/Vector.h"
#include "cinder/gl/gl.h"
#include "cinder/cairo/Cairo.h"

#define NUM_SEGMENTS 200
#define NUM_VERTS 400

class Note {
public:
    static GLfloat * verts;
    Note();
    void init(float, float, float);
    void update();
    void draw();

    ci::Vec2f pos;
    int age;
    int maxAge;
    float maxRadius;
    float fadeEx;
    bool inPool;

private:
    void drawCircle();
    void drawTriangle();
    void drawTorus();
    
    
};


#endif
