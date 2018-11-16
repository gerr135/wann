--
-- An implementation of NNet using Ada.Containers.Vectors
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
package wann.nets.mutable is

    --------------------------
    -- A mutable NNet type and methods
    -- using separate inputs/outputs and Connector type
    -- See Readme for details on design and representation description..
    type NNet_Mutable is new NNet with private;

    -- Base constructor, create empty net with set Nin and Nout
    function Create (Nin : InputIndex; Nout : OutputIndex) return NNet_Mutable;

    -- inherited methods
    overriding
    procedure NewNeuron(net : in out NNet_Mutable; idx : out NNIndex_Base);

    overriding
    procedure DelNeuron(net : in out NNet_Mutable; idx : NNIndex);

    overriding
    function  GetNeuron(net : NNet_Mutable; idx : NNIndex) return NeuronRec;

    overriding
    procedure SetNeuron(net : in out NNet_Mutable; neur : NeuronRec);



private

    -----------------
    -- A mutable NNet using Containers.Vectors and Connectors to link neurons and inputs/outputs

    type Connector is record
        idx : NNIndex;
    end record;

    package IV is new Ada.Containers.Vectors(Index_Type=>InputIndex,  Element_Type=>Connector);
    package OV is new Ada.Containers.Vectors(Index_Type=>OutputIndex, Element_Type=>Connector);

    type NNet_Mutable is new NNet with record
        inputs  : IV.Vector;
        outputs : OV.Vector;
        neurons : NV.Vector;
    end record;


end wann.nets.mutable;
