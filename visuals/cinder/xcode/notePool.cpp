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

NotePool::NotePool() {
    notes = new Note[POOL_SIZE];
}

Note * NotePool::getNote() {
    for(int i = 0; i < POOL_SIZE; i++) {
        if(notes[i].inPool) {
            notes[i].inPool = false;
            return &notes[i];
        }
    }
    throw(2398); // what the fuck, c++
}

void NotePool::putNote(Note * note) {
    for(int i = 0; i < POOL_SIZE; i++) {
        if(&notes[i] == note) {
            notes[i].inPool = true;
        }
    }
}

void NotePool::update() {
    for(int i = 0; i < POOL_SIZE; i++) {
        if(!notes[i].inPool) {
            notes[i].update();
        }
    }
}

void NotePool::draw() {
    for(int i = 0; i < POOL_SIZE; i++) {
        if(!notes[i].inPool) {
            notes[i].draw();
        }
    }
}