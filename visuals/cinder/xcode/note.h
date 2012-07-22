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

class Note {
public:
    Note(float, float);
    void update();
    void draw();
    bool alive();

    ci::Vec2f pos;
    int age;
};

#endif
