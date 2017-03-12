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
declare version    "1.3.5";
declare copyright  "(c) 2003-2017 Martin Zuther";
declare license    "GPL v3 or later";


import("stdfaust.lib");
mz = component("mzuther.dsp");

fractional_downsampler = component("fractional_downsampler.dsp").downsampler;
modulo_distortion = component("modulo_distortion.dsp").distortion;
clip_distortion = component("clip_distortion.dsp").distortion;
mathematical_overdrive = component("mathematical_overdrive.dsp").overdrive;


main_group(x) = hgroup("", x);

ovrd_group(x) = main_group(vgroup("[1] Mathematical overdrive", x));
mdst_group(x) = main_group(vgroup("[2] Modulo distortion", x));
clip_group(x) = main_group(vgroup("[3] Clip distortion", x));
dwns_group(x) = main_group(vgroup("[4] Fractional downsampler", x));


ovrd_threshold = ba.db2linear(
    ovrd_group(hslider(
        "[01] Threshold (0 disables) [style:slider][unit:dB]" ,
        0.0 , -40.0 , 0.0 , 1.0)));

ovrd_drive = ovrd_group(hslider(
    "[02] Drive [style:slider][unit:exp]" ,
    10.0 , 1.0 , 100.0 , 1.0));

ovrd_gain = ba.db2linear(
    ovrd_group(hslider(
        "[03] Output gain [style:slider][unit:dB]" ,
        0.0 , -6.0 , 6.0 , 1.0)));


mdst_modulo = mdst_group(hslider(
    "[01] Modulo (1 disables)" ,
    1 , 1 , 1e4 , 1));


clip_threshold = ba.db2linear(
    clip_group(hslider(
        "[01] Threshold (0 disables) [style:slider][unit:dB]" ,
        0.0 , -40.0 , 0.0 , 1.0)));

clip_drive = clip_group(hslider(
    "[02] Drive [style:slider][unit:exp]" ,
    10.0 , 0.0 , 100.0 , 1.0));


dwns_factor = dwns_group(hslider(
    "[01] Factor (0.99 disables) [style:slider][unit:x]" ,
    0.99 , 0.99 , 32.0 , 0.01));

dwns_lfo_freq = dwns_group(hslider(
    "[02] LFO frequency [style:slider][unit:Hz]" ,
    0.0 , 0.0 , 10.0 , 0.01));

dwns_lfo_mod = dwns_group(hslider(
    "[03] LFO modulation [style:slider][unit:%]" ,
    0.0 , 0.0 , 100.0 , 1.0));


ovrd_drive_real = pow(10.0, (ovrd_drive - 0.01) / -50.0);
clip_drive_real = clip_drive / 100.0;

process = mz.stereo(
    mathematical_overdrive(ovrd_threshold , ovrd_drive_real , ovrd_gain) :
    modulo_distortion(mdst_modulo) :
    clip_distortion(clip_threshold, clip_drive_real) :
    fractional_downsampler(dwns_factor , dwns_lfo_freq , dwns_lfo_mod)
);
