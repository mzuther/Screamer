import("stdfaust.lib");

mz = component("mzuther.dsp");


overdrive(threshold , drive) = process
with
{
    overdrive_temp_1 = 1.01 - threshold : _;
    overdrive_temp_2 = _ : (abs(_) - threshold) / overdrive_temp_1 : _;
    overdrive_calculate = _ : pow(overdrive_temp_2 , drive) * overdrive_temp_1 + threshold : _;
    overdrive_calculate_2 = _ <: mz.if_then_else(_ < 0.0 , 0 - overdrive_calculate , overdrive_calculate) : _;

    process = _ <: mz.if_then_else(abs(_) >= threshold , _ : overdrive_calculate_2 , _) : _;
};


process = overdrive(threshold , drive)
with
{
    threshold = -20.0;
    drive = 0.7;
};
