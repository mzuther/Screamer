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

import("stdfaust.lib");


downsampler(divisor , lfo_frequency , lfo_modulation) = process
with
{
    lfo = os.osc(lfo_frequency) * lfo_modulation / 100.0 : _;

    real_divisor = divisor * (1 + lfo) : _;
    downsample_selector = _ <: _ , _ >= real_divisor , 0 - real_divisor , 1 : +(ba.if) : _;
    counter = downsample_selector ~ _ : _;

    sample_and_hold = _ , _ : (ro.cross(2) , _ : _ , ro.cross(2) : ba.if : _) ~ _ : _;
    downsampler = counter < 1 , _ : sample_and_hold : _;

    process = ba.bypass1(divisor < 1.0 , downsampler);
};


process = downsampler(divisor , lfo_frequency , lfo_modulation)
with {
    divisor = 1.5;
    lfo_frequency = 0.2;
    lfo_modulation = 25.0;
};
