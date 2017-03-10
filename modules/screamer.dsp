declare name       "Screamer";
declare version    "0.3";
declare copyright  "(c) 2003-2017 Martin Zuther";
declare license    "GPL v3 or later";


import("stdfaust.lib");

fds = component("fractional_downsampler.dsp");
mod = component("modulo_distortion.dsp");
mz = component("mzuther.dsp");
od = component("overdrive.dsp");


threshold = ba.db2linear(
    hslider(
        "[01] Threshold [style:slider][unit:dB]" ,
        0.0 , -60.0 , 0.0 , 1.0));

drive = hslider(
    "[02] Drive [style:slider][unit:exp]" ,
    70.0 , 1.0 , 100.0 , 0.1)
    / 100.0;

divisor = hslider(
    "[03] Downsample [style:slider][unit:x]" ,
    1.0 , 1.0 , 32.0 , 0.01);

lfo_frequency = hslider(
    "[04] LFO Frequency [style:slider][unit:Hz]" ,
    0.0 , 0.0 , 10.0 , 0.01);

lfo_modulation = hslider(
    "[05] LFO Modulation [style:slider][unit:%]" ,
    0.0 , 0.0 , 100.0 , 1.0);

modulo = hslider(
    "[06] Modulo" ,
    1 , 1 , 1e4 , 1);

output = ba.db2linear(
    hslider(
        "[07] Output gain [style:slider][unit:dB]" ,
        0.0 , -20.0 , 0.0 , 0.5));


process = mz.stereo(
    od.overdrive(threshold , drive) :
    fds.downsampler(divisor , lfo_frequency , lfo_modulation) :
    mod.distortion(modulo) :
    _ * output);
