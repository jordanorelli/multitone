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

Note::Note(float x, float y, float age_norm, gl::GlslProg _shader) {
    shader = _shader;
    pos = Vec2f(x, y);
    age = 0;
    max_age = age_norm * (250 - 40) + 40;
    max_radius = age_norm * (600 - 60) + 60;
    fade_ex = age_norm * 3 + 1;
    is_dead = false;
}

void Note::update() {
    alpha = 0.75 * pow(1 - ((float)age / max_age), fade_ex);
    radius = max_radius * pow((float)age / max_age, 1.4) + 5.0;
    age++;
    if(age >= max_age) {
        is_dead = true;
    }
}

void Note::draw() {
    shader.uniform("alpha", alpha);
    gl::drawSolidRect(Rectf(pos.x - radius, pos.y - radius, pos.x + radius, pos.y + radius));
}