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

GLfloat * Note::verts = new float[NUM_VERTS];

Note::Note() {
    pos = Vec2f(0, 0);
    age = 0;
    inPool = true;
}

void Note::init(float x, float y, float ageNorm) {
    pos = Vec2f(x, y);
    age = 0;
    // norm * diff + min
    maxAge = ageNorm * (250 - 40) + 40;
    maxRadius = ageNorm * (600 - 60) + 60;
    fadeEx = ageNorm * 3 + 1;
}

void Note::draw() {
    //this->drawCircle();
    this->drawTorus();
}

void Note::drawCircle() {
    gl::color(ColorA8u(255, 0, 0, 255 * 0.75 * pow(1 - ((float)this->age / this->maxAge), this->fadeEx)));
    float radius = this->maxRadius * pow((float)this->age / this->maxAge, 1.4) + 5.0;
    glPushMatrix();
    glTranslatef(this->pos.x, this->pos.y, 0);
    glScalef(radius, radius, 1);
    glDrawArrays( GL_LINE_LOOP, 0, NUM_SEGMENTS );
    glPopMatrix();   
}

void Note::drawTriangle() {
}

void Note::drawTorus() {
    gl::pushMatrices();
    gl::translate(this->pos);
    gl::drawTorus(100.0, 200.0);
    gl::popMatrices();
}

void Note::update() {
    if(this->age >= this->maxAge) {
        this->age = 0;
        this->inPool = true;
    }
    this->age++;
}
