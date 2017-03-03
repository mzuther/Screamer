declare name       "Screamer";
declare version    "0.03";
declare copyright  "(c) 2003-2017 Martin Zuther";
declare license    "GPL v3 or later";

import("stdfaust.lib");


if_then_else = _ != 0.0 , _ , _ : select2;
impulse_signal = 1 - 1';
stereo(mono) = par(i , 2 , mono);

divisor = hslider ("Downsample", 1.0 , 1.0 , 32.0 , 0.1);
downsample_selector = _ , _ >= divisor , 1, 0 - divisor : +(if_then_else) : _;
downsample_counter = (_ <: downsample_selector) ~ _;
downsample_trigger = downsample_counter : _ < 1;

sample_and_hold = (ro.cross(2) , _ : if_then_else : _) ~ _;

downsampler = downsample_trigger , _ : sample_and_hold : _;

process = stereo(downsampler);
