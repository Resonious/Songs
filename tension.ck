// Scales
[48, 50, 51, 53, 55, 57, 58, 60] @=> int cMinor[];

// Anyone's free to modify and read from this. Should be an
// array of 3 indices into a scale.
//
// Obviously many writers will cause confusing results...
// But perhaps interesting-sounding.
[0, 2, 4] @=> int currentChord[];

// Beat events
Event preBar;
Event preBeat;
Event preQuarter;
Event preHalf;

Event bar;
Event beat;
Event quarter;
Event half;

// Timing
4 => int bpb; // beats per bar
110.0 => float bpm; // beats per minute

// Crap to avoid precision problems
fun int figureOutSamplesPerBeat(float bpm) {
    1.0 / bpm => float mpb;
    1::minute/1::samp => float samplesPerMinute; // believe it or not...

    return Math.floor(mpb * samplesPerMinute) $ int;
}
figureOutSamplesPerBeat(bpm)::samp => dur samplesPerBeat;

// Shred to fire bar events
fun void fireBars() {
    while (true) {
        preBar.broadcast();
        me.yield();
        bar.broadcast();

        bpb * samplesPerBeat => now;
    }
}
spork ~ fireBars();

// Shred to fire beat events
fun void fireBeats() {
    while (true) {
        preBeat.broadcast();
        preHalf.broadcast();
        preQuarter.broadcast();
        me.yield();
        beat.broadcast();
        half.broadcast();
        quarter.broadcast();

        (samplesPerBeat / 4) => now;

        preQuarter.broadcast();
        me.yield();
        quarter.broadcast();

        (samplesPerBeat / 4) => now;

        preHalf.broadcast();
        preQuarter.broadcast();
        me.yield();
        half.broadcast();
        quarter.broadcast();

        (samplesPerBeat / 4) => now;

        preQuarter.broadcast();
        me.yield();
        quarter.broadcast();

        (samplesPerBeat / 4) => now;
    }
}
spork ~ fireBeats();

///////////////////////////////////////////////////////////////
// Main program!
///////////////////////////////////////////////////////////////


// Sounds a little jarring
fun void vocal() {
    VoicForm voice => dac;

    "mmm" => voice.phoneme;
    1000 => voice.freq;

    while (true) {
        0.9 => voice.speak;
        500::ms => now;
        1.0 => voice.quiet;
        500::ms => now;
    }
}

fun void bam() {
    // Play a chord
    spork ~ bam_play(0);
    spork ~ bam_play(1);
    spork ~ bam_play(2);
    bar => now;
    bar => now;

    preBar => now;
    <<< "Setting chord", now >>>;
    [1, 3, 5] @=> currentChord;
    bar => now;
    <<< "Done setting chord", now >>>;

    spork ~ bam_play(0);
    spork ~ bam_play(1);
    spork ~ bam_play(2);
    bar => now;

    preBar => now;
    <<< "Setting chord", now >>>;
    [0, 2, 4] @=> currentChord;
    bar => now;
    <<< "Done setting chord", now >>>;

    bar => now;
}
fun void bam_play(int note) {
    SqrOsc osc => ADSR env => dac; 

    0.005 => osc.gain;
    cMinor[currentChord[note]] + 12 => Std.mtof => osc.freq;
    
    env.set(1000::ms, 1000::ms, 0.5, 3000::ms);

    env.keyOn();
    1000::ms => now;
    env.keyOff();
    5000::ms => now;
}

fun void boopBeep() {
    SinOsc osc => ADSR env => dac;

    0.5 => osc.gain;

    cMinor @=> int scale[];

    // Indexes into the chord! (10 = rest)
    [0, 1, 0, 2, 
    10, 1, 0, 2
    ] @=> int pattern[];

    env.set(100::ms, 200::ms, 0.5, 200::ms);

    0 => int i;

    while (true) {
        if (pattern[i] == 10) {
            beat => now;
        }
        else {
            <<< "Playing note", now >>>;
            scale[currentChord[pattern[i]]] + 12 => Std.mtof => osc.freq;

            env.keyOn();
            25::ms => now;
            env.keyOff();

            beat => now;
        }

        (i+1)%pattern.size() => i;
    }
}

fun void percussionSimple() {
    Noise noise => LPF lpf => ADSR env => dac;

    500 => lpf.freq;

    env.set(1::ms, 10::ms, 0.1, 20::ms);

    0 => int i;

    while (true) {
        if (i % 2 == 0) {
            env.keyOn();
            25::ms => now;
            env.keyOff();

            quarter => now;

            env.keyOn();
            25::ms => now;
            env.keyOff();
        }
        else {
            env.keyOn();
            25::ms => now;
            env.keyOff();
        }

        beat => now;

        i+1 => i;
    }
}


// This is mucked up now. Didn't convert to beat events properly
fun void percussionComplex() {
    Noise noise => LPF lpf => ADSR env => dac;

    500 => lpf.freq;

    env.set(1::ms, 10::ms, 0.1, 20::ms);

    while (true) {
        env.keyOn();
        25::ms => now;
        env.keyOff();
        half => now;

        env.keyOn();
        25::ms => now;
        env.keyOff();
        half => now;

        env.keyOn();
        25::ms => now;
        env.keyOff();
        half => now;

        beat => now;

        for (0 => int i; i < 4; i++) {
            env.keyOn();
            25::ms => now;
            env.keyOff();
            quarter => now;
        }

        env.keyOn();
        25::ms => now;
        env.keyOff();
        half => now;

        env.keyOn();
        25::ms => now;
        env.keyOff();
        half => now;

        env.keyOn();
        25::ms => now;
        env.keyOff();
        half => now;

        beat => now;
    }
}

fun void mandolin() {
    Mandolin man => LPF lpf => dac;

    300.0 => lpf.freq;
    0.3 => man.gain;

    100.0 => float pitchStart;

    while (true) {
        Math.random2f( 0.2, 0.8 ) => man.pluckPos;

        cMinor[currentChord[0]] - 12 => int targetNote;
        targetNote => Std.mtof => man.freq;
        0.9 => man.pluck;

        // Slide pitch down
        now + 0.25::second => time target;
        while (now < target) {
            (target - now) / 0.25::second => float progress;

            targetNote => Std.mtof => float freq;
            freq + (progress * pitchStart) => man.freq;
            1::ms => now;
        }
        beat => now;
    }
}

spork ~ bam();
spork ~ mandolin();
spork ~ percussionSimple();
spork ~ boopBeep();
// spork ~ vocal();
30::second => now;
