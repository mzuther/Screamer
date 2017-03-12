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
mz = component("mzuther.dsp");


overdrive(threshold , drive) = process
with
{
    overdrive_temp_1 = 1.01 - threshold : _;
    overdrive_temp_2 = _ : (abs(_) - threshold) / overdrive_temp_1 : _;
    overdrive_calculate = _ : pow(overdrive_temp_2 , drive) * overdrive_temp_1 + threshold : _;
    overdrive_calculate_2 = _ <: mz.if_then_else(_ < 0.0 , -1.0 , 1.0) * overdrive_calculate : _;

    overdrive = _ <: mz.if_then_else(abs(_) >= threshold , _ : overdrive_calculate_2 , _) :  *((1.0 - drive) * threshold + drive) : _;

    process = ba.bypass1(threshold >= 1.0 , overdrive);
};


process = overdrive(threshold_real , drive_real)
with
{
    threshold = -20.0;
    drive = 10;

    threshold_real = ba.db2linear(threshold);
    drive_real = pow(10.0, (drive - 0.01) / -50.0);
};
