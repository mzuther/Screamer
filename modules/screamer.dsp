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

declare name       "Screamer";
declare version    "1.4.0";
declare copyright  "(c) 2003-2020 Martin Zuther";
declare license    "GPL v3 or later";


import("stdfaust.lib");
mz = component("mzuther.dsp");

mathematical_overdrive = component("mathematical_overdrive.dsp").overdrive;
clip_distortion = component("clip_distortion.dsp").distortion;
modulo_distortion = component("modulo_distortion.dsp").distortion;
fractional_downsampler = component("fractional_downsampler.dsp").downsampler;


main_group(x) = hgroup("", x);

ovrd_group(x) = main_group(vgroup("[1] Mathematical overdrive", x));
clip_group(x) = main_group(vgroup("[2] Clip distortion", x));
mdst_group(x) = main_group(vgroup("[3] Modulo distortion", x));
dwns_group(x) = main_group(vgroup("[4] Fractional downsampler", x));


ovrd_threshold = ovrd_group(hslider(
    "[1] Threshold (0 disables) [style:slider][unit:dB]" ,
    0.0 , -40.0 , 0.0 , 1.0));

ovrd_drive = ovrd_group(hslider(
    "[2] Drive [style:slider][unit:exp]" ,
    10.0 , 1.0 , 100.0 , 1.0));

ovrd_gain = ovrd_group(hslider(
    "[3] Output gain [style:slider][unit:dB]" ,
    0.0 , -6.0 , 6.0 , 1.0));


clip_threshold = clip_group(hslider(
    "[1] Threshold (0 disables) [style:slider][unit:dB]" ,
    0.0 , -40.0 , 0.0 , 1.0));

clip_drive = clip_group(hslider(
    "[2] Drive [style:slider][unit:exp]" ,
    10.0 , 0.0 , 100.0 , 1.0));

clip_crucify = clip_group(checkbox(
    "[3] Crucify"));


mdst_modulo = mdst_group(hslider(
    "[1] Modulo (1 disables)" ,
    1 , 1 , 1e4 , 1));


dwns_factor = dwns_group(hslider(
    "[1] Factor (0.99 disables) [style:slider][unit:x]" ,
    0.99 , 0.99 , 32.0 , 0.01));

dwns_lfo_freq = dwns_group(hslider(
    "[2] LFO frequency [style:slider][unit:Hz]" ,
    0.0 , 0.0 , 10.0 , 0.01));

dwns_lfo_mod = dwns_group(hslider(
    "[3] LFO modulation [style:slider][unit:%]" ,
    0.0 , 0.0 , 100.0 , 1.0));


process = mz.stereo(
    mathematical_overdrive(ovrd_threshold , ovrd_drive , ovrd_gain) :
    clip_distortion(clip_threshold, clip_drive , clip_crucify) :
    modulo_distortion(mdst_modulo) :
    fractional_downsampler(dwns_factor , dwns_lfo_freq , dwns_lfo_mod)
);
