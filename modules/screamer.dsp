/* ----------------------------------------------------------------------------

   Screamer
   ========
   Mathematical distortion and signal mangling

   Copyright (c) 2003-2017 Martin Zuther (http://www.mzuther.de/)

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

declare name       "Screamer";
declare version    "1.1";
declare copyright  "(c) 2003-2017 Martin Zuther";
declare license    "GPL v3 or later";


import("stdfaust.lib");
mz = component("mzuther.dsp");

fractional_downsampler = component("fractional_downsampler.dsp").downsampler;
modulo_distortion = component("modulo_distortion.dsp").distortion;
mathematical_overdrive = component("mathematical_overdrive.dsp").overdrive;


threshold = ba.db2linear(
    hslider(
        "[01] Threshold [style:slider][unit:dB]" ,
        0.0 , -40.0 , 0.0 , 1.0));

drive = hslider(
    "[02] Drive [style:slider][unit:exp]" ,
    70.0 , 1.0 , 100.0 , 1.0);

drive_real = pow(10.0, (drive - 0.01) / -50.0);

output = ba.db2linear(
    hslider(
        "[03] Output gain [style:slider][unit:dB]" ,
        0.0 , -24.0 , 0.0 , 1.0));

modulo = hslider(
    "[04] Modulo" ,
    1 , 1 , 1e4 , 1);

divisor = hslider(
    "[05] Downsample [style:slider][unit:x]" ,
    1.0 , 1.0 , 32.0 , 0.01);

lfo_frequency = hslider(
    "[06] LFO Frequency [style:slider][unit:Hz]" ,
    0.0 , 0.0 , 10.0 , 0.01);

lfo_modulation = hslider(
    "[07] LFO Modulation [style:slider][unit:%]" ,
    0.0 , 0.0 , 100.0 , 1.0);


process = mz.stereo(
    mathematical_overdrive(threshold , drive_real) :
    modulo_distortion(modulo) :
    fractional_downsampler(divisor , lfo_frequency , lfo_modulation) :
    _ * output);
