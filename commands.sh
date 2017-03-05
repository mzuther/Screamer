#! /bin/bash

# sudo apt install octave
faust2plot modules/screamer.dsp && ./screamer -n 32

faust2plot modules/screamer.dsp && ./screamer -n 32 > screamer.m && octave --persist screamer.m

# sudo apt install qt4-default qt4-qmake
faust2jaqt modules/screamer.dsp && ./screamer

rm -f screamer-svg/* ; faust2svg modules/screamer.dsp && faust2jaqt modules/screamer.dsp && ./screamer 
