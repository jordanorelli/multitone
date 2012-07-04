int toneMode;

fun float getFreq(float norm) {
    <<< "getFreq:", norm, toneMode >>>;
    if (toneMode == 1) {
        return getFreqChromatic(norm);
    } else {
        return getFreqPentatonic(norm);
    }
}

fun float getFreqChromatic(float norm) {
    Math.pow(2, 1.0/12.0) => float toneStep;
    110.0 => float minFreq;
    (Math.floor(norm * 48.0)) $ int => int i;
    minFreq * Math.pow(toneStep, i) => float f;;
    return f;
}

fun float getFreqPentatonic(float norm) {
    Math.pow(2, 1.0/5.0) => float toneStep;
    110.0 => float minFreq;
    (Math.floor(norm * 20.0)) $ int => int i;
    minFreq * Math.pow(toneStep, i) => float f;;
    return f;
}

class PitchToggle
{
    OscRecv recv;
    int id;

    fun void init(OscRecv in, int _id) {
        _id => id;
        in @=> recv;
        spork ~ listen();
    }

    fun void listen() {
        "/pitchtoggle/1/" + id => string path;
        <<< "listening on" + path >>>;
        float i;
        recv.event(path, "f") @=> OscEvent @ e;
        while(true) {
            e => now;
            while(e.nextMsg()) {
                e.getFloat() => i;
            }
            if (i == 1.0) {
                id => toneMode;
            }
            <<< "RECV", path, i >>>;
        }

    }
}

/*____________________________________________________________________
class OscController implements the receiving end of a physical OSC controller,
(which, in this project, is TouchOSC.)
____________________________________________________________________*/
class XYVoice
{
    OscRecv recv;
    OscSend out;
    int id;
    TriOsc osc => ADSR env => NRev rev => Pan2 pan => dac;
    time lastUpdated;
    float x;
    float y;
    dur beat;

    0.28 => rev.mix;

    env.keyOff();
    env.set(20::ms, 40::ms, 0.6, 40::ms);
    0.5 => pan.pan;

    fun void init(OscRecv in, int _id) {
        0.6 => osc.gain;
        in @=> recv;
        _id => id;
        100::ms => beat;
        now => lastUpdated;
        out.setHost("localhost", 9001);
        spork ~ listen();
        spork ~ play();
    }

    // function play is responsible for playing audio notes and sending
    // relevant OSC data to the front end.
    fun void play() {
        beat - (now % beat) => now;
        while(true) {
            // if we've been updated sometime after the last note was played, play another note.
            if(now - lastUpdated < beat) {
                playNote();
            }
            beat - (now % beat) => now;
        }
    }

    fun void playNote() {
        (x * 2) - 1 => pan.pan;
        //abs(y) => osc.freq;
        getFreq(y) => osc.freq;
        env.keyOn();
        beat * 0.4 => now;
        env.keyOff();
        x => out.addFloat;
        y => out.addFloat;
        out.startMsg("/voice/" + id, "ff");
        <<< "SEND", "/voice/" + id, x, y >>>;
    }

    // function listen is responsible for listening for incoming OSC messages
    // and updating the state information for the current voice.
    fun void listen() {
        "/multixy/" + id => string path;
        <<< "listening on " + path >>>;
        recv.event(path, "ff") @=> OscEvent @ e;
        while(true) {
            e => now;
            while(e.nextMsg()) {
                e.getFloat() => y;
                e.getFloat() => x;
                now => lastUpdated;
            }
            <<< "RECV", x, y >>>;
        }
    }
}

class Sustain
{
    OscRecv @ recv;
    string path;
    int isDown;

    fun void init(OscRecv @ in, string p) {
        in @=> recv;
        p => path;
        spork ~ listen();
    }

    fun void listen() {
        <<< "listening on " + path >>>;
        recv.event(path, "i") @=> OscEvent @ e;
        while(true) {
            e => now;
            while(e.nextMsg()) {
                e.getInt() => isDown;
            }
            <<< path, isDown >>>;
        }
    }
}

public class OscController
{
    OscRecv @ recv;
    Sustain @ sustain;
    XYVoice @ voices[5];
    PitchToggle @ pitchModes[2];

    fun void init(int port) {
        new OscRecv @=> recv;
        port => recv.port;
        recv.listen();
        for(0 => int i; i < voices.cap(); i++) {
            new XYVoice @=> voices[i];
            voices[i].init(recv, i + 1);
        }

        for(0 => int i; i < pitchModes.cap(); i++) {
            new PitchToggle @=> pitchModes[i];
            pitchModes[i].init(recv, i + 1);
        }

        new Sustain @=> sustain;
        <<< "adding sustain at ", "/sustain" >>>;
        sustain.init(recv, "/sustain");

        spork ~ reverbListener();
    }

    fun void reverbListener() {
        <<< "listening on /reverbMix" >>>;
        recv.event("/reverbMix", "f") @=> OscEvent @ e;
        float mix;
        while(true) {
            e => now;
            while(e.nextMsg()) {
                e.getFloat() => mix;
            }
            for(0 => int i; i < voices.cap(); i++) {
                mix => voices[i].rev.mix;
            }
            <<< "MIX", mix >>>;
        }
    }
}
