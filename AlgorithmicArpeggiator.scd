/*

  ___  _                  _ _   _               _         ___                              _       _
 / _ \| |                (_) | | |             (_)       / _ \                            (_)     | |
/ /_\ \ | __ _  ___  _ __ _| |_| |__  _ __ ___  _  ___  / /_\ \_ __ _ __   ___  __ _  __ _ _  __ _| |_ ___  _ __
|  _  | |/ _` |/ _ \| '__| | __| '_ \| '_ ` _ \| |/ __| |  _  | '__| '_ \ / _ \/ _` |/ _` | |/ _` | __/ _ \| '__|
| | | | | (_| | (_) | |  | | |_| | | | | | | | | | (__  | | | | |  | |_) |  __/ (_| | (_| | | (_| | || (_) | |
\_| |_/_|\__, |\___/|_|  |_|\__|_| |_|_| |_| |_|_|\___| \_| |_/_|  | .__/ \___|\__, |\__, |_|\__,_|\__\___/|_|
          __/ |                                                    | |          __/ | __/ |
         |___/                                                     |_|         |___/ |___/


______ _____ ___ ______  ___  ________
| ___ \  ___/ _ \|  _  \ |  \/  |  ___|
| |_/ / |__/ /_\ \ | | | | .  . | |__
|    /|  __|  _  | | | | | |\/| |  __|
| |\ \| |__| | | | |/ /  | |  | | |___
\_| \_\____|_| |_/___/   \_|  |_|____/


This is an algorihmic arpeggiator, which is like a normal arpeggiator only way cooler. Basically, all you need to do to start playing is:
     1) Hook up a MIDI keyboard to your computer
     2) Set your input parameters below
     3) Execute the block of code and start playing

Below I will explain the input parameters:

~octaves - This controls the number of octaves that the notes you play will span across For example, if the octave is set to 2, then the arpeggiator will play the chord you're holding down in addition to the smae chord one octave higher.

~tempo - This sets the tempo of the arpeggiator, essentially the speed that it arpeggiates at

~arp_rate - This sets the note subdivision at which the arpeggiator will play. For reference: 1 = quarter note, 0.5 = eighth note, 0.25 = sixteenth note, etc.

~mode - This sets the mode or the note ordering algorithm of the arpeggiator. There are 8 modes available which I'll explain below, using a C major 7 chord (C-E-G-B) as an example.
    -up: Arpeggiates through the chord upwards, i.e. C-E-G-B
    -down: Arpeggiates through the chord downwards, i.e. B-G-E-C
    -up-down: Arpeggiates upwards then dowards, i.e. C-E-G-B-G-E-C
    -down-up: Arpeggiates downwards then upwards, i.e. B-G-E-C-E-G-B
    -funnel-up: Funnels the notes starting from the bottom, playing the bottom note, then the top note, then the next bottom note, then
     the next top note, etc. i.e. C-B-E-G
    -funnel-down: Funnels the notes starting from the top, playing the top note, then the bottom note, then the next top note, then the
     next bottom note, etc. i.e. B-C-G-E
    -stairs: Plays the notes in a stepwise sequence, i.e. C-E-G-E-G-B-G-B-C
    -random Plays the notes in a random ordering

~amp_mode - This sets the algorithm for setting amplitude of the notes. There are 5 modes which I'll explain below.
    -static: All amplitudes are constant
    -ascend: Amplitudes start quiet and get louder throughout the arpeggiation
    -descend: Amplitudes start loud and get quieter throughout the arpeggiation
    -drunk: Amplitude is centered around a constant value but has a chance to deviate and be louder or quiter
    -random: Amplitude is a random value

~pan_mode - This sets the algorithm for setting panning of the notes. There are 5 modes which I'll explain below.
    -static: All panning is centered
    -waveLR: Panning moves in a wave from left to right
    -waveRL: Panning moves in a wave from right to left
    -ping-pong: Panning oscillates between right and left
    -random: Panning is in a random position

~density - This is a value between 0 and 1 that controls the chance that a note will be skipped in the arpeggiation. If density is set to 1, no notes will be skipped. If it's set to 0.5, half the notes will be skipped. If it's set to 0, all the notes will be skipped.

~chord_chance - This is a value between 0 and 1 that controls the chance that the arpeggiator will play a chord instead of an individual note. The higher the chord_chance, the more likely it is that it will play a chord.

~swap_chance - This is a value between 0 and 1 that controls the chance that the arpeggiator will swap a note in the pattern with another one, changing the ordering. The higher the swap_chance, the more likely it is that it will swap two notes

~chaos - This is a value between 0 and 1 that controls the chance that the arpeggiator will add a non-chord note into the sequence. The higher the chaos, the more likely that a non-chord tone will be added.


All input parameters can be set either by hard coding the values at the top of the code block, or by using continuous control inputs on your MIDI keyboard (except for ~octaves and ~arp_rate, which can only be set via code). If your midi controller has continuos control inputs, you may assign the number of those inputs to the "~cc" variables labeled 1 through 8. The parameter that each input controls is shown next to the variables below. My midi controller used inputs 14-21, though your controller may be different. You can find the number of your input simply by moving them, and the input number followed by the value will be displayed in the post window.

*/


(
// INPUT PARAMETERS
~octaves = 2;
~tempo = 80;
~arp_rate = 0.25;
~mode = "up-down"; // up, down, up-down, down-up, funnel-up, funnel-down, stairs, random
~amp_mode = "ascend"; // static, ascend, descend, drunk, random
~pan_mode = "random"; // static, waveLR, waveRL, ping-pong, random
~density = 1;
~chord_chance = 0.1;
~swap_chance = 0.2;
~chaos = 0;

~cc1 = 14; // Controls ~tempo
~cc2 = 15; /* Controls ~mode (the 128 values are divided equally among the 8 modes, such that 0-15 correspond to the "up" mode,
           16-31 correspond to the "down" mode, 32-63 correspond to the "up-down" mode, etc. The same is true of the pan_mode
           and amp_mode controls  */
~cc3 = 16; // Controls ~amp_mode
~cc4 = 17; // Controls ~pan_mode
~cc5 = 18; /* Controls ~density (Note that a cc value of 0 corresponds to a density of 1. As you increase the cc value, the
           density will get lower */
~cc6 = 19; // Controls ~chord_chance
~cc7 = 20; // Controls ~swap_chance
~cc8 = 21; // Controls ~chaos

// END INPUT PARAMETERS


// Boot server
s.boot;

// Creates arrays for storing active notes and patterns
~active = Array.new(30);
~pattern = Array.new(30);

// Start Midi client
MIDIClient.init;
MIDIIn.connectAll;

// Create tempo clock
t = TempoClock.new();
t.tempo = ~tempo/60;

// MIDI Input func
~on = MIDIFunc.noteOn({
    arg vel, nn, chan, src;

    // If Routine was yielded because there were no active notes, start it again
    if (~active.size == 0,
        {~scheduler.play(t)}
    );

    // Add new note to currently active notes
    ~active.add(nn);

});

// Midi note off function
~off = MIDIFunc.noteOff({
    arg vel, nn;

    // remove note from active note list when it gets note off message
    ~active.remove(nn);

});

// Midi CC function
~ccFunc = MIDIFunc.cc({
    arg val, num, chan, src;
    [num, val].postln;

    // Map CC values to parameters values based on CC input number
    if (num == ~cc1, {
        ~tempo = val.linlin(0, 127, 60, 200);
        t.tempo = ~tempo/60
    });

    if (num == ~cc2, {
        var mode = case
        {val < 16} {~mode = "up".postln}
        {val >= 16 && val < 32} {~mode = "down".postln}
        {val >= 32 && val < 48} {~mode = "up-down".postln}
        {val >= 48 && val < 64} {~mode = "down-up".postln}
        {val >= 64 && val < 80} {~mode = "funnel-up".postln}
        {val >= 80 && val < 96} {~mode = "funnel-down".postln}
        {val >= 96 && val < 112} {~mode = "stairs".postln}
        {val >= 112} {~mode = "random".postln};
    });

    if (num == ~cc3, {
        var mode = case
        {val < 26} {~amp_mode = "static".postln}
        {val >= 26 && val < 51} {~amp_mode = "ascend".postln}
        {val >= 51 && val < 77} {~amp_mode = "descned".postln}
        {val >= 77 && val < 102} {~amp_mode = "drunk".postln}
        {val >= 102} {~amp_mode = "random".postln};
    });

    if (num == ~cc4, {
        var mode = case
        {val < 26} {~pan_mode = "static"}
        {val >= 26 && val < 51} {~pan_mode = "waveLR".postln}
        {val >= 51 && val < 77} {~pan_mode = "waveRL".postln}
        {val >= 77 && val < 102} {~pan_mode = "ping-pong".postln}
        {val >= 102} {~pan_mode = "random".postln};
    });


    if (num == ~cc5, {
        ~density = val.linlin(0, 127, 1, 0)
    });

    if (num == ~cc6, {
        ~chord_chance = val.linlin(0, 127, 0, 1)
    });

    if (num == ~cc7, {
        ~swap_chance = val.linlin(0, 127, 0, 1)
    });

    if (num == ~cc8, {
        ~chaos = val.linlin(0, 127, 0, 1);
    });
});

// Create SynthDef for playing notes
SynthDef.new(\tone, {
    arg freqs=#[0, 0, 0, 0, 0], amp=0.3, amps=#[0.1,0,0,0,0], pos=0;
    var sig, sig1, sig2, sig3, sig4, sig5, env;
    sig1 = Pan2.ar(LFTri.ar(freqs[0]), pos, amps[0]);
    sig2 = Pan2.ar(LFTri.ar(freqs[1]), pos, amps[1]);
    sig3 = Pan2.ar(LFTri.ar(freqs[2]), pos, amps[2]);
    sig4 = Pan2.ar(LFTri.ar(freqs[3]), pos, amps[3]);
    sig5 = Pan2.ar(LFTri.ar(freqs[4]), pos, amps[4]);
    env = EnvGen.kr(Env.perc, doneAction:2);
    sig = Mix([sig1, sig2, sig3, sig4, sig5]) * env * amp;
    Out.ar(0, sig);
}).add;


// Scheduler for handling all of the arpeggiation algorithms and sequencing them
~scheduler = Routine.new({
    var octave = 0;
    var curNote = -1;
    var panPos = 0;
    var sweep = 0;
    var amp = 0.1;
    var prev = 0.8;

    // run on a loop to iterate through notes in the active sequence
    loop {
        var octCount = 0;
        var freqArray;
        var ampArray;

        // Create array that will store active notes plus octaves
        ~allNotes = Array.newClear(~active.size * ~octaves);

        // Iterate through and add from active list, jumping octave whenever we reach end of list
        ~allNotes.do({arg item, i;
            ~allNotes.put(i, ~active.wrapAt(i) + (octCount * 12));

            // Check to see if we need to jump an octave
            if (((i + 1) % ~active.size) == 0,
                {octCount = octCount + 1}
            );
        });

        // Remove duplicates
        ~allNotes = ~allNotes.as(Set).as(Array);

        // Sort notes by value depending on mode
        if (~mode == "up", {
            ~pattern = ~allNotes.sort({arg a, b; a < b})
        });

        if (~mode == "down", {
            ~pattern = ~allNotes.sort({arg a, b; a > b})
        });

        if (~mode == "up-down", {
            ~pattern = ~allNotes.sort({arg a, b; a < b}).mirror1
        });

        if (~mode == "down-up", {
            ~pattern = ~allNotes.sort({arg a, b; a > b}).mirror1
        });

        if (~mode == "random", {
            ~pattern = ~allNotes.scramble;
        });

        if (~mode == "funnel-up", {
            var flag = 1;
            var temp = ~allNotes;

            ~pattern = Array.newClear(~allNotes.size);

            (~allNotes.size).do({arg i;
                if (flag == 1, {
                    ~pattern.put(i, temp.minItem);
                    temp.remove(temp.minItem)
                },
                // Else
                {
                    ~pattern.put(i, temp.maxItem);
                    temp.remove(temp.maxItem)
                });

                flag = flag * -1;
            });
        });

        if (~mode == "funnel-down", {
            var flag = 1;
            var temp = ~allNotes;

            ~pattern = Array.newClear(~allNotes.size);

            (~allNotes.size).do({arg i;
                if (flag == 1, {
                    ~pattern.put(i, temp.maxItem);
                    temp.remove(temp.maxItem)
                },
                // Else
                {
                    ~pattern.put(i, temp.minItem);
                    temp.remove(temp.minItem)
                });

                flag = flag * -1;
            });
        });

        if (~mode == "stairs", {
            var sorted = ~allNotes.sort({arg a, b; a < b});

            if (~allNotes.size > 2, {
                ~pattern = Array.newClear((~allNotes.size - 2) * 3);

                (~allNotes.size - 2).do({arg i;
                    3.do({arg j;
                        ~pattern.put((i * 3) + j, sorted[i + j]);
                    });
                })
            },
            //Else
            {~pattern = sorted}
            );
        });

        // Set panning mode
        if (~pan_mode == "static", {
            panPos = 0;
        });

        if (~pan_mode == "waveLR", {
            sweep = ((sweep + 0.1) % 2);
            panPos = sweep - 1;
        });

        if (~pan_mode == "waveRL", {
            sweep = ((sweep + 0.1) % 2);
            panPos = (sweep - 1) * -1;
        });

        if (~pan_mode == "ping-pong", {
            panPos = ((panPos + 1) % 2) - 0.5;
        });

        if (~pan_mode == "random", {
            panPos = 2.0.rand - 1;
        });

        if (~amp_mode == "static", {
            amp = 0.5;
        });

        // Set amplitude mode
        if (~amp_mode == "ascend", {
            var step = 0.8 / ~pattern.size;
            amp = ((amp + step) % (step * ~pattern.size)).min(1);
        });

        if (~amp_mode == "descend", {
            var step = 0.8 / ~pattern.size;
            prev = ((prev + step) % (step * ~pattern.size)).min(1);
            amp = 0.8 - prev;
        });

        if (~amp_mode == "random", {
            amp = 1.1.rand - 0.1;
        });

        if (~amp_mode == "drunk", {
            if (1.0.rand < 0.25, {
                amp = 1.1.rand - 0.1;
            },
            // Else
            {amp = 0.5}
            );
        });

        // Iterate current note through active array
        curNote = (curNote + 1) % ~pattern.size;

        // Check if there are any active notes
        if (~active.size != 0,

            // Make sure there are note in the pattern, and check for swap chance
            if (~pattern.size != 0, {
                if (1.0.rand < ~swap_chance, {
                    ~pattern.swap((~pattern.size).rand, (~pattern.size).rand);
                    if (1.0.rand < ~swap_chance, {
                        ~pattern.swap((~pattern.size).rand,(~pattern.size).rand);
                        if (1.0.rand < ~swap_chance, {
                            ~pattern.swap((~pattern.size).rand, (~pattern).size.rand);
                        });
                    });
                });
            });

            // Make sure there are note in the pattern, and check for chaos chance
            if (~pattern.size != 0, {
                if (1.0.rand < ~chaos, {
                    ~pattern.put(~pattern.size.rand, ~pattern.minItem.rrand(~pattern.maxItem));
                    if (1.0.rand < ~chaos, {
                        ~pattern.put(~pattern.size.rand, ~pattern.minItem.rrand(~pattern.maxItem));
                        if (1.0.rand < ~chaos, {
                            ~pattern.put(~pattern.size.rand, ~pattern.minItem.rrand(~pattern.maxItem));
                        });
                    });
                });
            });

            ~pattern.postln;

            // Make sure the note for the current iteration exists (to prevent errors)
            if (~pattern[curNote] != nil, {
                freqArray = [~pattern[curNote].midicps];
                ampArray = [1,0,0,0,0];

                // Check for chord chance and construct chord based on notes in the pattern set
                if (1.0.rand < ~chord_chance, {
                    var chord_sel = ~pattern.shift(curNote * -1);
                    chord_sel = chord_sel.as(Set).as(Array);

                    chord_sel.do({arg item, i;
                        if ((~pattern[curNote] - item).abs > 12, {
                            chord_sel.removeAt(i)
                        })
                    });

                    chord_sel.do({arg item, i;
                        chord_sel[i] = item.midicps;
                    });

                    freqArray = freqArray.add(chord_sel).flat;
                    ampArray = [0.4, 0.4, 0.4, 0.4, 0.4];
                });
            });

            // Instantiate Synth and set it's values to the parameters we just calculated
            {Synth.new (
                \tone,
                [
                    \freqs, freqArray,
                    \amp, [0, amp].wchoose([1 - ~density, ~density]),
                    \amps, ampArray,
                    \pos, panPos
                ]
            )},
            // Else yield routine and clear pattern if there were not active notes
            {
                ~scheduler.yield;
                ~pattern = [];
                curNote = -1;
                octave = 0;
            };
        );

        // Wait for duration set by tempoClock before playing next note
        ~arp_rate.wait;
    };
    });
)

1.rand;

s.makeGui;