fun void shakerPart() {
    while (true) {
        Shakers sh => dac;
        // https://chuck.cs.princeton.edu/doc/program/ugen_full.html#Shakers

        3 => sh.preset;
        13 => sh.objects;

        sh.noteOn(1.0);
        250::ms => now;
        // sh.noteOff(1.0);
        500::ms => now;
    }
}

fun void percussionPart() {
    Noise noise => BPF bpf => ADSR env => dac;

    1400 => bpf.freq;
    400 => bpf.Q;

    50.0 => noise.gain;

    spork ~ sweepFreq(bpf);

    env.set(1::ms, 10::ms, 0.1, 20::ms);

    while (true) {
        env.keyOn();
        100::ms => now;
        env.keyOff();
        150::ms => now;
    }
}

fun void percussionWaaa() {
    Noise noise => LPF lpf => ADSR env => dac;

    500 => lpf.freq;

    // 50.0 => noise.gain;

    env.set(1::ms, 10::ms, 0.1, 20::ms);

    while (true) {
        env.keyOn();
        25::ms => now;
        env.keyOff();
        225::ms => now;

        env.keyOn();
        25::ms => now;
        env.keyOff();
        225::ms => now;

        500::ms => now;
    }
}

fun void squarePart() {
    // patch
    SqrOsc sqr => LPF lpf => ADSR env => dac;

    // low-pass filter and envelope
    4000 => lpf.freq;
    env.set(100::ms, 500::ms, .8, 1000::ms);
    120::ms => dur T; // Note length

    0.02 => sqr.gain;

    // pitches
    [60, 61, 59, 60] @=> int pitches[];

    0 => int i;
    while (true) {
        // pitch!!
        pitches[i] => Std.mtof => sqr.freq;
        (i+1) % pitches.size() => i;

        // play?
        env.keyOn();
        500::ms => now;
        env.keyOff();
        500::ms => now;
    }
}

fun void mandolinPart() {
    Mandolin man => LPF lpf => dac;

    300.0 => lpf.freq;
    0.3 => man.gain;

    spork ~ sweepFreq(lpf);

    // Main "song" (plucking)

    [36, 37, 35, 36] @=> int scale1[];
    [36, 37, 35, 36] @=> int scale2[];
    0 => int i;
    scale1 @=> int scale[];

    while (true) {
        Math.random2f( 0.2, 0.8 ) => man.pluckPos;
        scale[i] => Std.mtof => man.freq;

        0.9 => man.pluck;

        0.5::second => now;
        (i+1)%scale.size() => i;
        if (i == 0)
            if (Math.randomf() > 0.5) scale1 @=> scale;
            else scale2 @=> scale;
    }
}


fun void mandolinWaaa() {
    Mandolin man => LPF lpf => dac;

    300.0 => lpf.freq;
    0.3 => man.gain;

    36 => int baseNote;

    while (true) {
        Math.random2f( 0.2, 0.8 ) => man.pluckPos;

        baseNote => Std.mtof => man.freq;
        0.9 => man.pluck;

        // gradually raise pitch over 0.25 seconds
        now + 0.25::second => time target;
        while (now < target) {
            (target - now) / 0.25::second => float progress;

            baseNote => Std.mtof => float freq;
            freq + (progress * 100.0) => man.freq;
            1::ms => now;
        }
        0.25::second => now;
    }
}


// Sweeper shred
fun void sweepFreq(FilterBasic filter) {
    while (true) {
        500.0 + Math.sin(now/ms * 10.0)*200.0 => filter.freq;
        5::ms => now;
    }
}


// spork ~ mandolinPart();
spork ~ mandolinWaaa();
// spork ~ squarePart();
// spork ~ percussionPart();
spork ~ percussionWaaa();
// spork ~ shakerPart();
30::second => now;
