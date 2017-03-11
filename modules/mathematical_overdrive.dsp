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


overdrive(threshold , drive) = process
with
{
    overdrive_temp_1 = 1.01 - threshold : _;
    overdrive_temp_2 = _ : (abs(_) - threshold) / overdrive_temp_1 : _;
    overdrive_calculate = _ : pow(overdrive_temp_2 , drive) * overdrive_temp_1 + threshold : _;
    overdrive_calculate_2 = _ <: ba.if(_ < 0.0 , 0 - overdrive_calculate , overdrive_calculate) : _;

    process = _ <: ba.if(abs(_) >= threshold , _ : overdrive_calculate_2 , _) : _;
};


process = overdrive(threshold , drive)
with
{
    threshold = -20.0;
    drive = 0.7;
};