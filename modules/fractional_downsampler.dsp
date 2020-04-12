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


downsampler(factor , lfo_frequency , lfo_modulation) = process
with
{
    lfo = os.osc(lfo_frequency) * lfo_modulation / 100.0 : _;
    real_factor = factor * (1.0 + lfo) : _;

    adder = _ <: _ + mz.if(_ >= real_factor , 0.0 - real_factor , 1.0) : _;
    counter = adder ~ _ : _;

    cross_312 = _ , _ , _ : ro.cross(2) , _ : _ , ro.cross(2) : _ , _ , _;
    sample_and_hold = _ , _ : (cross_312 : mz.if : _) ~ _ : _;

    downsampler = counter < 1.0 , _ : sample_and_hold : _;
    process = ba.bypass1(factor < 1.0 , downsampler);
};


process = downsampler(factor , lfo_frequency , lfo_modulation)
with
{
    factor = hslider(
        "[1] Factor (0.99 disables) [style:slider][unit:x]" ,
        0.99 , 0.99 , 32.0 , 0.01);

    lfo_frequency = hslider(
        "[2] LFO frequency [style:slider][unit:Hz]" ,
        0.0 , 0.0 , 10.0 , 0.01);

    lfo_modulation = hslider(
        "[3] LFO modulation [style:slider][unit:%]" ,
        0.0 , 0.0 , 100.0 , 1.0);
};
