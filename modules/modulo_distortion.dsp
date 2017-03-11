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


distortion(modulo) = process
with
{
    modulo_remover(modulo) = _ <: _ - (_ % int(max(modulo , 1))) : _;
    distortion = _ : int(_ * 1e5) : modulo_remover(modulo) : float(_) / 1e5 : _;

    process = ba.bypass1(modulo <= 1 , distortion);
};


process = distortion(modulo)
with
{
    modulo = 1000;
};
