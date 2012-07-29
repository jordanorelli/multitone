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
#include "cinder/gl/GlslProg.h"

#include "cinder/cairo/Cairo.h"

#define NUM_SEGMENTS 200
#define NUM_VERTS 400

class Note {
public:
    Note(float, float, float, ci::gl::GlslProg);
    void update();
    void draw();

    ci::Vec2f pos;
    int age;
    int max_age;
    float max_radius;
    float fade_ex;
    float alpha;
    float radius;
    bool is_dead;

private:
    ci::gl::GlslProg shader;    
};


#endif
