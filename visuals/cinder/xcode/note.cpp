//
//  note.cpp
//  cinder
//
//  Created by Jordan Orelli on 7/21/12.
//  Copyright (c) 2012 betaworks. All rights reserved.
//

#include "note.h"
#include "cinder/app/AppBasic.h"
#include "cinder/gl/gl.h"
#include "cinder/Color.h"
#include <math.h>

using namespace ci;
using namespace ci::app;


int Note::maxAge = 250;

Note::Note() {
    pos = Vec2f(0, 0);
    age = 0;
    inPool = true;
}

Note::Note(float x, float y) {
    pos = Vec2f(x, y);
    age = 0;
}

void Note::draw() {
    gl::color(ColorA8u(255, 0, 0, 255 * 0.75 * pow(1 - (this->age / 250.0), 1.3)));

    float maxRadius = 500.0;
    float maxAge = 250.0;
    float radius = maxRadius * pow(this->age / maxAge, 1.3) + 5.0;

    int numSegments = (int)math<double>::floor( radius * M_PI * 2 );
    if( numSegments < 2 ) numSegments = 2;
    
    GLfloat *verts = new float[numSegments*2];
    for( int s = 0; s < numSegments; s++ ) {
        float t = s / (float)numSegments * 2.0f * 3.14159f;
        verts[s*2+0] = this->pos.x + math<float>::cos( t ) * radius;
        verts[s*2+1] = this->pos.y + math<float>::sin( t ) * radius;
    }
    glVertexPointer( 2, GL_FLOAT, 0, verts );
    glDrawArrays( GL_LINE_LOOP, 0, numSegments );
    delete [] verts;
}

void Note::update() {
    if(this->age >= 250) {
        console() << "ok, it happened." << std::endl;
        this->age = 0;
        this->inPool = true;
    }
    this->age++;
}
