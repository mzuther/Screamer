declare name       "Screamer";
declare version    "0.1";
declare copyright  "(c) 2003-2017 Martin Zuther";
declare license    "GPL v3 or later";

import("stdfaust.lib");


// constant vs variable Q
//
//               +---------+
//    index ---> |         |
//               |         |
// stream_0 ---> | select2 | ---> output
//               |         |
// stream_1 ---> |         |
//               +---------+
// 
// If "index" is 0, the output is "stream_0", and if "index" is 1,
// the output is "stream_1".  Otherwise, the output is 0, and an
// error can occur during execution.
if_then_else = _ != 0.0 , _ , _ : select2;

impulse_signal = 1 - 1';
stereo(mono) = par(i , 2 , mono);
recursion_with_initial_value = _ : +(_) ~ *(0.5) : _;

divisor = hslider ("Downsample [unit:x]", 1.0 , 1.0 , 32.0 , 0.01);
lfo_frequency = hslider ("LFO Frequency [style:slider][unit:Hz]", 0.0 , 0.0 , 10.0 , 0.01);
lfo_modulation = hslider ("LFO Modulation [style:slider][unit:%]", 0 , 0 , 100 , 1);
modulo = hslider ("Modulo", 1 , 1 , 1e4 , 1);

downsample_divisor = divisor * (1 + lfo);
downsample_selector = _ , _ >= downsample_divisor , 1, 0 - downsample_divisor : +(if_then_else) : _;
downsample_counter = (_ <: downsample_selector) ~ _;
downsample_trigger = downsample_counter : _ < 1;

lfo = os.osc(lfo_frequency) * lfo_modulation / 100.0;

sample_and_hold = (ro.cross(2) , _ : if_then_else : _) ~ _;
downsampler = downsample_trigger , _ : sample_and_hold : _;

modulo_remover = _ <: _ - (_ % int(max(modulo, 1))) : _;
modulo_distortion = _ : int(_ * 1e5) : modulo_remover : float(_) / 1e5 : _;

process = stereo(downsampler : modulo_distortion);
