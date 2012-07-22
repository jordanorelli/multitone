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
#include <list>

using namespace std;

class NotePool {
public:
    NotePool();
    Note * getNote();
    void putNote(Note *);
    void update();
    void draw();
private:
    Note * notes;
};


#endif
