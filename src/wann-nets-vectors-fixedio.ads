--
-- An implementation of NNet using Ada.Containers.Vectors with fixed IO width
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

with Ada.Containers.Vectors;
-- with Ada.Containers.Indefinite_Vectors;

with wann.layers.vectors;

generic
package wann.nets.vectors.fixedIO is


    ----------------------------------
    -- A mutable NNet with fixed IO
    type NNet(Ni : NN.InputIndex; No : NN.OutputIndex) is new Proto_NNet with private;

    -- Base constructor, create empty net with set Nin and Nout
--     function Create return NNet;

    -- inherited methods, the rest that needs overriding
    -- getters
    overriding
    function Input_Connections (net : NNet) return NN.Input_Connection_Array;

    overriding
    function Output_Connections(net : NNet) return NN.Output_Connection_Array;


    -- neuron handling
    overriding
    procedure Add_Neuron(net : in out NNet; neur : PN.Neuron_Interface'Class;
                         idx : out NN.NeuronIndex);

    overriding
    procedure Del_Neuron(net : in out NNet; idx : NN.NeuronIndex);

    overriding
    procedure Set_Layer(net : in out NNet; idx : NN.LayerIndex; L : PL.Layer_Interface'Class);




private

    -- these are defined in the parent package
--     use type NN.ConnectionIndex;
--     package NV is new Ada.Containers.Vectors(Index_Type=>NN.NeuronIndex, Element_Type=>NN.ConnectionIndex);

--     package PLV is new PL.vectors;
--     use type PLV.Layer;
--     package LV is new Ada.Containers.Vectors(Index_Type=>NN.LayerIndex,  Element_Type=>PLV.Layer);


    type NNet(Ni : NN.InputIndex; No : NN.OutputIndex) is new Proto_NNet with record
        inputs  : NN.Input_Connection_Array (1 .. Ni);
        outputs : NN.Output_Connection_Array(1 .. No);
    end record;


end wann.nets.vectors.fixedIO;

