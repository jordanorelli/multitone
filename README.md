Multitone is an experimental sound toy.  It is controlled with an iPad, but the sound synthesis and the graphics run on a computer. 

Demo video: https://vimeo.com/46550447

# Architecture

The iPad formats user input into OSC messages and sends them to the computer at a predefined UDP port (in this application, it's 9000).
A [Chuck](http://chuck.cs.princeton.edu/) synthesizer listens for OSC messages on port 9000.
When Chuck sees a new OSC message, it sonifies the data, producing a note.
Some OSC messages indicate control data; these messages are not sonified, but they alter some state in the Chuck synth.
When a note is to be sonified, Chuck formats a new OSC message and sends that over a different UDP port to the graphics front-end.  The graphics do not need to be run on the same computer, and the Processing and Cinder graphics apps are both stateless.
When the visualizer receives an OSC message, it draws some shape.  The message indicates the position and size of the shape to be drawn.

If you have not seen the application before, please refer to the [screenshots](http://imgur.com/a/vEQbX/all) to get a preview of the expected output.  The screenshot gallery includes a preview of the iPad layout, the output of the Cinder app, and the output of the Processing prototype.

The iPad runs [TouchOSC](http://itunes.apple.com/app/touchosc/id288120394?mt=8).  There are two TouchOSC layouts: one for iPad and one for iPhone.


# iPad layout

- The bottom portion is a big XY pad with multitouch support.  It supports up to five simultaneous touches.
- In the top right is a pair of mutually exclusive toggles (radio buttons, if you will).  These alternate between two tunings: on the left is an even-tempered, 12-tone tuning, and on the right is an even-tempered, 5-tone tuning.
- In the center-top is a quad of mutually exclusive toggles (a set of radio buttons).  These select between waveforms to be played.  They are, in order, sine waves, square waves, triangle waves, and sawtooth waves.
- In the top-right is a fader that adjusts the amount of reverb in the audio.

# Networking

The iPad sends control data in the OSC format to the computer.  I have found that performance is significantly better when using an ad-hoc network.  Messages are sent over UDP and the application layer effectively does nothing to ACK the messages; packet loss will totally fuck your communication.  As a result, I generally create an ad-hoc network on the laptop and connect to that from the iPad, because introducing a router has a tendency to cause spotty performance.

## Troubleshooting communication

If you experience a communication and you're not sure where it's coming from, I recommend installing [liblo](http://liblo.sourceforge.net/), which is an OSC library in C.  liblo comes with a tool called `oscdump`, which can be used to dump incoming OSC messages to stdout.  It is a useful tool for checking that you have received OSC messages.  For this project, the TouchOSC layouts are configured to target port 9000, so invoking the command `oscdump 9000` should print to stdout all the communication that is received from the iPad.

# Sound

All of the sound is programmed in [Chuck](http://chuck.cs.princeton.edu/).  The audio source is found under the `audio` directory.  To run the project, navigate to the `audio` directory and invoke the command `chuck tonepad.ck`.  You should see that it indicates that it is now listening.  At this point, you should be able to play the audio portion of the application.

# Graphics

There are two visualizers for this project.  The first was written in [Processing](http://processing.org/), but with alpha blending it was too slow.  (I have found the application to be stable and more performant in Processing 2.0a6 than in Processing 1.5.1).  After writing the Processing app, I decided to port it to C++ for performance reasons, and chose to use the Cinder framework.

## Processing

The Processing sketch can be found under `visuals/tonepad`.  It is dependent on [Andreas Schlegel's oscP5 library](http://www.sojamo.de/libraries/oscP5/).  You can download the library at that site, which will include install instructions.

Once the oscP5 library is installed, you should be able to run the Processing sketch by opening the `visuals/tonepad/tonepad.pde` file in the Processing IDE and hitting play.  You may need to adjust the resolution to fit your screen.

The Processing prototype includes different shapes for the different waveforms.  Sinewaves are rendered as circles, square waves are rendered as squares, triangle waves are rendered as triangles, and sawtooth waves are rendered as z-tetrominos.

## Cinder

I compiled the Cinder app and put it in the `bin` folder.  I have absolutely no idea if this will work on other computers but I figured it was worth a shot.

The source for the Cinder app can be found under `visuals/cinder`.  I have only tested it on OS X, so there is only an XCode project file.  I do not have a Windows machine to test it on, and Cinder does not support Linux as far as I know (sorry).

The Cinder project requires [Hector Sanches-Pajares' Cinder-OSC](https://github.com/hecspc/Cinder-OSC), which is a CinderBlock for handling OSC messages.  I was able to get this working by following the instructions found in [this blog post](https://forum.libcinder.org/#Topic/23286000000535031).

Odds are, if you don't have Cinder installed where I have it installed, this won't build correctly without fiddling with the import paths in the xcode project.  If you're installing Cinder fresh and would like to avoid the headache, I install Cinder to `/usr/local/cinder_0.8.4_mac`.

If I've done this correctly, you should be able to open the xcode project and just build it.
