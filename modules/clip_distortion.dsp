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


distortion(threshold) = process
with
{
    distortion = _ <: ba.if(_ >= threshold , threshold , ba.if(_ <= (0 - threshold) , -threshold , _)) : _;
    process = ba.bypass1(threshold >= 1.0 , distortion);
};


process = distortion(threshold_real)
with
{
    threshold = -20.0;

    threshold_real = ba.db2linear(threshold);
};
