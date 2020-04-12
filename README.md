# Screamer

## Mathematical distortion and signal mangling

**Version 1.0** is the accurate [Faust][] reproduction of a VST
plug-in I wrote in 2003.  In later versions, I have modified the
parameter ranges and added some new functionality.

This signal mangler features a weird kind of overdrive (see source
code for exact formula), a hard-clip distortion, LFO-modulated bit
reduction and the possibility of calculating the modulo of a signal.
I have never heard anything like it, which is why I finally release it
to the wild.

**In case you choose to use the old version 1.0, be very careful!
  This thing gets super-loud faster than you can say
  "thingamajig"...**

## Code of conduct

Please read the [code of conduct][COC] before asking for help, filing
bug reports or contributing to this project.  Thanks!

## License

Copyright (c) 2003-2020 [Martin Zuther][]

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


[Martin Zuther]:  http://www.mzuther.de/
[COC]:            https://github.com/mzuther/Screamer/tree/master/CODE_OF_CONDUCT.markdown
[Faust]:          http://faust.grame.fr/
