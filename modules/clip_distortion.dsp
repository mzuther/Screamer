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


distortion(threshold_pre , drive_pre , crucify) = process
with
{
    // pre-process parameters
    threshold = ba.db2linear(threshold_pre);
    drive = drive_pre / 100.0;

    makeup_gain = 1.0 / ba.db2linear(threshold_pre / 6.0) : _;

    clipper = _ - threshold : _ * (1.0 - drive) : _ + threshold;
    clipped_clipper = _ : clipper <: mz.if(abs > 1.0 , mz.get_sign , _) : _;

    trigger_crucified = _ <: mz.if(abs >= threshold , clipped_clipper , _) : _;
    trigger_clean = _ : abs <: mz.if(_ >= threshold , clipped_clipper , _) : _;
    trigger = _ <: mz.if(crucify , trigger_crucified , trigger_clean) : _;

    distortion = _ <: mz.get_sign * trigger * makeup_gain : _;
    process = ba.bypass1(threshold >= 1.0 , distortion);
};


process = distortion(threshold , drive , crucify)
with
{
    threshold = hslider(
        "[1] Threshold (0 disables) [style:slider][unit:dB]" ,
        0.0 , -40.0 , 0.0 , 1.0);

    drive = hslider(
        "[2] Drive [style:slider][unit:exp]" ,
        10.0 , 0.0 , 100.0 , 1.0);

    crucify = checkbox(
        "[3] Crucify");
};
