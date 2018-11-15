--
-- Top NNet packege, holding abstract type/interface with utility, but no storage..
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
package wann.nets.fixed is

    NetOverflow : Exception;
    
    -- Trying mixed inputs/outputs/neurons, selected by index ranges, for fixed nets.
    -- See Readme for description.
    --------------------------
    -- A mutable NNet type and methods
    -- using separate inputs/outputs and Connector type
    -- See Readme for details on design and representation description..
    type NNet_Fixed(Nin, Nout, Npts : NIndex) is new NNet with private;
    -- try to avoid allocation altogether and parametrize the nnet right there, by discriminants
    --
    -- NOTE: ATTN!! due to restriction on how discriminants can be used in record entries,
    -- Ntot should be set to toal entities: Ntot := Nin + Nout + Nneurons

    -- Base constructor, create empty net with set Nin and Nout
--     function Create  return NNet_Fixed;

    -- inherited methods
    overriding
    procedure NewNeuron(net : in out Nnet_Fixed; idx : out NNIndex_Base);
    -- nothing to create for real, but try to mimick mutable 

    overriding
    procedure SetNeuron(net : in out Nnet_Fixed; neur : NeuronRec);


private

    type NNet_Fixed(Nin, Nout, Npts : NIndex) is new NNet with record
        Nassigned : NIndex_Base := 0;
        inputs  : ConnectArray(1 .. Nin);
        outputs : ConnectArray(1 .. Nout);
        neurons : -- needs actual NeuronRec or expansion array;
    end record;

end wann.nets.fixed;
