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


distortion(modulo) = process
with
{
    modulotar(modulo) = _ <: _ - (_ % int(max(modulo , 1))) : _;

    distortion = _ : _ * 1e5 : int : modulotar(modulo) : float / 1e5 : _;
    process = ba.bypass1(modulo <= 1 , distortion);
};


process = distortion(modulo)
with
{
    modulo = hslider(
        "[1] Modulo (1 disables)" ,
        1 , 1 , 1e4 , 1);
};
