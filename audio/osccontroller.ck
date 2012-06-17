/*____________________________________________________________________
class OscController implements the receiving end of a physical OSC controller,
(which, in this project, is TouchOSC.)
____________________________________________________________________*/
class XYVoice
{
    OscRecv recv;
    int id;
    string path;
    SqrOsc osc => ADSR env => NRev rev => Pan2 pan => dac;
    float minFreq;
    float maxFreq;

    110 => minFreq;
    1760 => maxFreq;
    0.2 => rev.mix;

    env.keyOff();
    env.set(4::ms, 10::ms, 0.2, 10::ms);
    0.5 => pan.pan;

    fun void init(OscRecv in, int x) {
        in @=> recv;
        x => id;
        "/multixy/" + id => path;
        spork ~ listen();
    }

    fun void listen() {
        <<< "listening on " + path >>>;
        recv.event(path, "ff") @=> OscEvent @ e;
        float x;
        float y;
        OscSend out;
        out.setHost("localhost", 9001);

        while(true) {
            e => now;
            while(e.nextMsg()) {
                e.getFloat() => y;
                e.getFloat() => x;
            }

            x => out.addFloat;
            y => out.addFloat;
            out.startMsg("/voice/" + id, "ff");
            <<< "SEND", "/voice/" + id, x, y >>>;

            (x * 2) - 1 => pan.pan;
            abs(y) => osc.freq;
            env.keyOn();
            20::ms => now;
            env.keyOff();
        }
    }

    fun float normFreq(float absFreq) {
        if(absFreq > maxFreq) return 1.0;
        if(absFreq < minFreq) return 0.0;
        return (absFreq - minFreq) / (maxFreq - minFreq);
    }

    fun float abs(float norm) {
        return norm * (maxFreq - minFreq) + minFreq;
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
