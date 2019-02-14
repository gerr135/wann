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

-- This package alows a mutable NNet "signature" - its inputs/outputs to change their
-- connections and even number. This is not done in the majority of NNet libs out there,
-- but this follow directly the paradigm of this lib - mutable nnets.
--
-- NOTE: conceptually it is possible to fix the number of inputs/outputs but mutate
-- neurons inside. However, practically, we still would have to use mutable representation
-- for the inputs at least, unless we prohibit varying inputs of the 1st neuron layer..
-- As the other combination - fixed neurons but mutable IO - does not even make much sense,
-- we would be blowing up our package hierarchy for unclearly formulated concept.
-- (we would have to have nets.vectors-fixedIO/mutableIO subpackages)
-- So, we keep things simple for the moment..


with Ada.Containers.Vectors;
with Ada.Containers.Indefinite_Vectors;

with wann.layers.vectors;
with connectors.vectors;

generic
package wann.nets.vectors is

    ------------------------------
    -- mutable NNet
    --
    type NNet is new NNet_Interface with private;

    overriding
    function NInputs (net : NNet) return NN.InputIndex;

    overriding
    function NOutputs(net : NNet) return NN.OutputIndex;

    overriding
    function NNeurons(net : NNet) return NN.NeuronIndex;

    overriding
    function NLayers (net : NNet) return NN.LayerIndex;

    -- IO handling
    overriding
    function  Input (net : NNet; i : NN.InputIndex)  return PI.Input_Interface'Class;

    overriding
    function  Output(net : NNet; o : NN.OutputIndex) return NN.ConnectionIndex;

    -- neuron handling
    overriding
    procedure Add_Neuron(net : in out NNet; neur : in out PN.Neuron_Interface'Class;
                         idx : out NN.NeuronIndex);

    overriding
    procedure Del_Neuron(net : in out NNet; idx : NN.NeuronIndex);

    overriding
    procedure Set_Layer(net : in out NNet; idx : NN.LayerIndex; L : PL.Layer_Interface'Class);

    overriding
    function  Neuron(net : aliased in out NNet; idx : NN.NeuronIndex) return Neuron_Reference;

    -- Layers handling
    overriding
    function  Layers_Ready (net : NNet) return Boolean;

    overriding
    function  Layer(net : NNet; idx : NN.LayerIndex) return PL.Layer_Interface'Class;


private

    use type PI.Input_Vector;
    package IV is new Ada.Containers.Vectors(Index_Type=>NN.InputIndex,  Element_Type=>PI.Input_Vector);

    use type NN.ConnectionIndex;
    package OV is new Ada.Containers.Vectors(Index_Type=>NN.OutputIndex, Element_Type=>NN.ConnectionIndex);

    -- utilized vector types
    use type PN.Neuron_Interface;
    package NV is new Ada.Containers.Indefinite_Vectors (
            Index_Type=>NN.NeuronIndex, Element_Type=>PN.Neuron_Interface'Class);

    use type PLV.Layer;
    package LV is new Ada.Containers.Vectors(Index_Type=>NN.LayerIndex,  Element_Type=>PLV.Layer);

    -- the NNet types themselves
    type NNet is new NNet_Interface with record
        inputs  : IV.Vector;
        outputs : OV.Vector;
        neurons : NV.Vector;
        layers  : LV.Vector;
        Layers_Ready : Boolean := False;
    end record;

end wann.nets.vectors;

