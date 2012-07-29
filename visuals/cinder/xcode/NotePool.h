//
//  NotePool.h
//  cinder
//
//  Created by Jordan Orelli on 7/21/12.
//  Copyright (c) 2012 betaworks. All rights reserved.
//

#ifndef cinder_NotePool_h
#define cinder_NotePool_h

#include "note.h"
#include "cinder/gl/GlslProg.h"
#include <list>

using namespace std;

class NotePool {
public:
    NotePool(ci::gl::GlslProg);
    void addNote(float x, float y, float reverb); // adds note objects to our pool
    void update();
    void draw();
private:
    std::list<Note> notes;
    ci::gl::GlslProg shader;
};

#endif
