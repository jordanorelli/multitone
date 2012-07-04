fun float getFreq(float norm) {
    Math.pow(2, 1.0/12.0) => float toneStep;
    110.0 => float minFreq;
    (Math.floor(norm * 48.0)) $ int => int i;
    minFreq * Math.pow(toneStep, i) => float f;;
    <<< "getFreq toneStep:", toneStep, "minFreq:", minFreq, "i:", i, "f:", f >>>;
    return f;
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
    string path;
    TriOsc osc => ADSR env => NRev rev => Pan2 pan => dac;
    time lastUpdated;
    float x;
    float y;
    dur beat;

    0.08 => rev.mix;

    env.keyOff();
    env.set(20::ms, 10::ms, 0.6, 10::ms);
    0.5 => pan.pan;

    fun void init(OscRecv in, int _id) {
        0.6 => osc.gain;
        in @=> recv;
        _id => id;
        100::ms => beat;
        "/multixy/" + _id => path;
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

    /*
    fun float normFreq(float absFreq) {
        if(absFreq > maxFreq) return 1.0;
        if(absFreq < minFreq) return 0.0;
        return (absFreq - minFreq) / (maxFreq - minFreq);
    }
    */

    /*
    fun float abs(float norm) {
        return norm * (maxFreq - minFreq) + minFreq;
    }
    */
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

    fun void init(int port) {
        new OscRecv @=> recv;
        port => recv.port;
        recv.listen();
        for(0 => int i; i < voices.cap(); i++) {
            new XYVoice @=> voices[i];
            voices[i].init(recv, i + 1);
        }

        new Sustain @=> sustain;
        <<< "adding sustain at ", "/sustain" >>>;
        sustain.init(recv, "/sustain");
    }
}
