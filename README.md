# Algorithmic-Arpeggiator

This is an algorithmic arpeggiator I built in SuperCollider. It has many parameters (which can be mapped to Midi CC knobs) that control various algorithmic processes of the arpeggiation, such as density, panning, amplitude, direction, and more. 

# Requirements 

SuperCollider v3.10 or later
Midi Keyboard/Controller

# Setup

1) Hook up a MIDI keyboard to your computer
2) Set your input parameters in the designated area in the code (line 75)
3) Execute the code block and start playing

# Input Parameters

~octaves - This controls the number of octaves that the notes you play will span across For example, if the octave is set to 2, then the arpeggiator will play the chord you're holding down in addition to the smae chord one octave higher.

~tempo - This sets the tempo of the arpeggiator, essentially the speed that it arpeggiates at

~arp_rate - This sets the note subdivision at which the arpeggiator will play. For reference: 1 = quarter note, 0.5 = eighth note, 0.25 = sixteenth note, etc.

~mode - This sets the mode or the note ordering algorithm of the arpeggiator. There are 8 modes available which I'll explain below, using a C major 7 chord (C-E-G-B) as an example.  
    -up: Arpeggiates through the chord upwards, i.e. C-E-G-B  
    -down: Arpeggiates through the chord downwards, i.e. B-G-E-C  
    -up-down: Arpeggiates upwards then dowards, i.e. C-E-G-B-G-E-C  
    -down-up: Arpeggiates downwards then upwards, i.e. B-G-E-C-E-G-B  
    -funnel-up: Funnels the notes starting from the bottom, playing the bottom note, then the top note, then the next bottom     note, then the next top note, etc. i.e. C-B-E-G  
    -funnel-down: Funnels the notes starting from the top, playing the top note, then the bottom note, then the next top     note, then the next bottom note, etc. i.e. B-C-G-E  
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

# Credits

Created by Sam Lopate
