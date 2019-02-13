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

with Ada.Containers.Vectors;
with Ada.Containers.Indefinite_Vectors;

with wann.layers.vectors;

generic
package wann.nets.vectors is


    ------------------------------
    --  NOTE
    --
    -- Do we allow NNet "signature" - its inputs/outputs to be mutable?
    -- This is not done in the majority of NNet libs out there,but I see no reason why not.
    -- That would go nicely along with the design principle of this lib..
    -- So, here goes (a more convoluted type hierarchy)
    -- NOTE: this should probably be split into multiple child packages,
    -- to keep it clean, but even more importantly, to prevent compiler confusion about constructors

    ------------------------------
    -- Proto_NNet
    -- an ADT handling neurons and layers only, base for further derivation
    type Proto_NNet is abstract new NNet_Interface with private;

    -- only a few of abstract methods make sense at this level,
    -- basically only the methods that do not touch IO
    -- Thus no specific IO handling or even creation/deletion of neurons
    overriding
    function NNeurons(net : Proto_NNet) return NN.NeuronIndex;

    overriding
    function NLayers (net : Proto_NNet) return NN.LayerIndex;

--     overriding
--     function  Neuron(net : Proto_NNet; idx : NN.NeuronIndex) return PN.Neuron_Interface'Class;

    overriding
    function  Neuron(net : aliased in out Proto_NNet; idx : NN.NeuronIndex) return Neuron_Reference;

    overriding
    function  Layers_Ready (net : Proto_NNet) return Boolean;

    overriding
    function  Layer(net : Proto_NNet; idx : NN.LayerIndex) return PL.Layer_Interface'Class;

    overriding
    procedure Set_Layer(net : in out Proto_NNet; idx : NN.LayerIndex; L : PL.Layer_Interface'Class);


    -- these two types below break compiler for some reason
--     --------------------------------------------------------------------
--     --  Cached_NNet
--     type Cached_Proto_NNet is abstract new Proto_NNet and Cached_NNet_Interface with private;
--
--     overriding
--     function  State(net : Cached_Proto_NNet) return NN.State_Vector;
--
--     overriding
--     procedure Set_State(net : in out Cached_Proto_NNet; NSV : NN.State_Vector);


--     type Cached_Checked_Proto_NNet is abstract new Proto_NNet and Cached_Checked_NNet_Interface with private;
--
--     overriding
--     function  State(net : Cached_Checked_Proto_NNet) return NN.Checked_State_Vector;
--
--     overriding
--     procedure Set_State(net : in out Cached_Checked_Proto_NNet; NSV : NN.Checked_State_Vector);



private

    -- utilized vector types
    use type PN.Neuron_Interface;
    package NV is new Ada.Containers.Indefinite_Vectors (
            Index_Type=>NN.NeuronIndex, Element_Type=>PN.Neuron_Interface'Class);

    package PLV is new PL.vectors;
    use type PLV.Layer;
    package LV is new Ada.Containers.Vectors(Index_Type=>NN.LayerIndex,  Element_Type=>PLV.Layer);

    -- the Proto_NNet types themselves
    type Proto_NNet is abstract new NNet_Interface with record
        neurons : NV.Vector;
        layers  : LV.Vector;
        Layers_Ready : Boolean := False;
    end record;

--     type Cached_Proto_NNet is abstract new Proto_NNet and Cached_NNet_Interface with null record;

--     type Cached_Checked_Proto_NNet is abstract new Proto_NNet and Cached_Checked_NNet_Interface with null record;

end wann.nets.vectors;

