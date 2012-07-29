//
//  NotePool.cpp
//  cinder
//
//  Created by Jordan Orelli on 7/21/12.
//  Copyright (c) 2012 betaworks. All rights reserved.
//

#include <iostream>
#include "NotePool.h"
#define POOL_SIZE 5000

NotePool::NotePool(ci::gl::GlslProg _shader) {
    shader = _shader;
}

void NotePool::update() {
    for( list<Note>::iterator it = notes.begin(); it != notes.end(); ++it ) {
        if(it->is_dead) {
            it = notes.erase(it);
            continue;
        }
        it->update();
    }
}

void NotePool::draw() {
    for( list<Note>::iterator it = notes.begin(); it != notes.end(); ++it ) {
        it->draw();
    }
}

void NotePool::addNote(float x, float y, float reverb) {
    notes.push_back(Note(x, y, reverb, shader));
}