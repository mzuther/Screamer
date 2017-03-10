import("stdfaust.lib");

mz = component("mzuther.dsp");


downsampler(divisor , lfo_frequency , lfo_modulation) = process
with
{
    lfo = os.osc(lfo_frequency) * lfo_modulation / 100.0 : _;

    real_divisor = divisor * (1 + lfo) : _;
    downsample_selector = _ <: _ , _ >= real_divisor , 0 - real_divisor , 1 : +(mz.if_then_else) : _;
    counter = downsample_selector ~ _ : _;

    sample_and_hold = _ , _ : (ro.cross(2) , _ : _ , ro.cross(2) : mz.if_then_else : _) ~ _ : _;

    process = counter < 1 , _ : sample_and_hold : _;
};


process = downsampler(divisor , lfo_frequency , lfo_modulation)
with {
    divisor = 1.5;
    lfo_frequency = 0.2;
    lfo_modulation = 25.0;
};
