/* ----------------------------------------------------------------------------

   Screamer
   ========
   Mathematical distortion and signal mangling

   Copyright (c) 2003-2020 Martin Zuther (http://www.mzuther.de/)

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.

   Thank you for using free software!

---------------------------------------------------------------------------- */

import("stdfaust.lib");
mz = component("mzuther.dsp");


overdrive(threshold_pre , drive_pre , gain_pre) = process
with
{
    // pre-process parameters
    threshold = ba.db2linear(threshold_pre);
    drive = pow(10.0, (drive_pre - 0.01) / -50.0);
    gain = ba.db2linear(gain_pre);

    makeup_gain = (1.0 - drive) * threshold + drive : _;
    output_gain = makeup_gain * gain : _;

    temp_1 = 1.01 - threshold : _;
    temp_2 = _ : (_ - threshold) / temp_1 : _;

    overdriver = _ : pow(temp_2 , drive) * temp_1 + threshold : _;
    trigger = _ : abs <: mz.if(_ >= threshold , overdriver , _) : _;

    overdrive = _ <: mz.get_sign * trigger * output_gain : _;
    process = ba.bypass1(threshold >= 1.0 , overdrive);
};


process = overdrive(threshold , drive , gain)
with
{
    threshold = hslider(
        "[1] Threshold (0 disables) [style:slider][unit:dB]" ,
        0.0 , -40.0 , 0.0 , 1.0);

    drive = hslider(
        "[2] Drive [style:slider][unit:exp]" ,
        10.0 , 1.0 , 100.0 , 1.0);

    gain = hslider(
        "[3] Output gain [style:slider][unit:dB]" ,
        0.0 , -6.0 , 6.0 , 1.0);
};
