declare name       "Screamer";
declare version    "0.04";
declare copyright  "(c) 2003-2017 Martin Zuther";
declare license    "GPL v3 or later";

import("stdfaust.lib");


if_then_else = _ != 0.0 , _ , _ : select2;
impulse_signal = 1 - 1';
stereo(mono) = par(i , 2 , mono);
recursion_with_initial_value = _ : +(_) ~ *(0.5) : _;

divisor = hslider ("Downsample [unit:x]", 1.0 , 1.0 , 32.0 , 0.01);
downsample_divisor = divisor * (1 + lfo);
downsample_selector = _ , _ >= downsample_divisor , 1, 0 - downsample_divisor : +(if_then_else) : _;
downsample_counter = (_ <: downsample_selector) ~ _;
downsample_trigger = downsample_counter : _ < 1;

sample_and_hold = (ro.cross(2) , _ : if_then_else : _) ~ _;

lfo_frequency = hslider ("LFO Frequency [style:slider][unit:Hz]", 0.0 , 0.0 , 10.0 , 0.01);
lfo_modulation = hslider ("LFO Modulation [style:slider][unit:%]", 0 , 0 , 100 , 1);
lfo = os.osc(lfo_frequency) * lfo_modulation / 100.0;

downsampler = downsample_trigger , _ : sample_and_hold : _;

process = stereo(downsampler);
