fun void mandolinPart()
{
    Mandolin man => LPF lpf => dac;

    300.0 => lpf.freq;

    spork ~ sweepFreq(lpf);

    // Main "song" (plucking)

    [36, 38, 39] @=> int scale1[];
    [40, 44, 48] @=> int scale2[];//not using right now
    0 => int i;

    while (true) {
        scale1 @=> int scale[];
        /*if (Math.randomf() > 0.5) scale1 @=> scale;
        else scale2 @=> scale;*/

        Math.random2f( 0.2, 0.8 ) => man.pluckPos;
        scale[i] => Std.mtof => man.freq;

        0.9 => man.pluck;

        0.5::second => now;
        (i+1)%scale.size() => i;
    }
}


// Sweeper shred
fun void sweepFreq(FilterBasic filter)
{
    while (true) {
        500.0 + Math.sin(now/ms * 10.0)*200.0 => filter.freq;
        5::ms => now;
    }
}


mandolinPart();
