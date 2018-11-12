--
-- A child package holding main type definitions: NNet, layers, etc..
--
-- Copyright (C) 2018  <George Shapovalov> <gshapovalov@gmail.com>
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU Lesser General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--


generic
package wann.nets is

    type NNet_Fixed(Nin : InputIndex; Nout : OutputIndex; Npts : NNIndex) is tagged limited private;
    procedure Add_Neuron(net : in out NNet_Fixed; neur : NeuronRec_Fixed);

private

    type NNet_Fixed(Nin : InputIndex; Nout : OutputIndex; Npts : NNIndex) is tagged limited record
        neurons : NeuronsArray(1 .. Npts);
    end record;

end wann.nets;
