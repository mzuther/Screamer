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


// impulse train: a one followed by an infinite number of zeros
impulse_train = 1.0 - 1.0' : _;


//                +---------+
//     index ---> |         |
//                |         |
//  stream_0 ---> | select2 | ---> output
//                |         |
//  stream_1 ---> |         |
//                +---------+
//
// If "index" is 0.0, the output is "stream_0", and if "index" is 1.0,
// the output is "stream_1".  Otherwise, the output is 0, and an error
// can occur during execution.
//
//
//                +---------+
// condition ---> |         |
//                |         |
//  stream_0 ---> |   if    | ---> output
//                |         |
//  stream_1 ---> |         |
//                +---------+
//
// If "condition" is exactly 0.0, the output is "stream_1".  In any
// other case, the output is "stream_0".  In contrast to "select2",
// this function prevents you from errors during execution.
if = _ , _ , _ : (_ != 0.0) , ro.cross(2) : select2 : _;


// If the input is below zero, the input is -1.0, otherwise it is 1.0.
get_sign = _ : if(_ < 0.0 , -1.0 , 1.0) : _;


// create a stereo effect
stereo(mono) = par(i , 2 , mono);


// recursion_with_initial_value = _ : +(_) ~ *(0.5) : _;
