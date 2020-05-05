fun void percussion() {
    Noise noise => LPF lpf => ADSR env => dac;

    500 => lpf.freq;

    env.set(1::ms, 10::ms, 0.1, 20::ms);

    0 => int i;

    while (true) {
        env.keyOn();
        25::ms => now;
        env.keyOff();
        225::ms => now;

        if (i % 2 == 0) {
            env.keyOn();
            25::ms => now;
            env.keyOff();
            225::ms => now;
        }
        else {
            250::ms => now;
        }

        500::ms => now;
        i+1 => i;
    }
}

fun void mandolin() {
    Mandolin man => LPF lpf => dac;

    300.0 => lpf.freq;
    0.3 => man.gain;

    36 => int baseNote;

    while (true) {
        Math.random2f( 0.2, 0.8 ) => man.pluckPos;

        baseNote => Std.mtof => man.freq;
        0.9 => man.pluck;

        // gradually lower pitch over 0.25 seconds
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

spork ~ mandolin();
spork ~ percussion();
30::second => now;
