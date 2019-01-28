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

    --------------------------
    -- A mutable NNet type and methods
    type NNet is new NNet_Interface with private;

    -- Base constructor, create empty net with set Nin and Nout
    function Create (Nin : NN.InputIndex; Nout : NN.OutputIndex) return NNet;

    -- inherited methods
    -- getters
    overriding
    function NNeurons(net : NNet) return NN.NeuronIndex;

    overriding
    function NLayers (net : NNet) return NN.LayerIndex;

    -- data IO
    overriding
    function Input_Connections (net : NNet) return NN.Input_Connection_Array;

    overriding
    function Output_Connections(net : NNet) return NN.Output_Connection_Array;


    -- neuron handling
    overriding
    procedure New_Neuron(net : in out NNet; idx : out NN.NeuronIndex_Base);

    overriding
    procedure Del_Neuron(net : in out NNet; idx : NN.NeuronIndex);


    overriding
    function  Neuron(net : NNet; idx : NN.NeuronIndex) return PN.NeuronClass_Access;

    overriding
    procedure Set_Neuron(net : in out NNet; NA : PN.NeuronClass_Access);

    overriding
    function  Layers_Ready (net : NNet) return Boolean;

    overriding
    function  Layer(net : NNet; idx : NN.LayerIndex) return PL.Layer_Interface'Class;

    overriding
    procedure Set_Layer(net : in out NNet; idx : NN.LayerIndex; L : PL.Layer_Interface'Class);

    --     overriding
    --     procedure SetInputValues(net : in out NNet; V : NNet_InputArray);


    type Cached_NNet is new NNet and Cached_NNet_Interface with private;

    overriding
    function  State(net : Cached_NNet) return NN.State_Vector;

    overriding
    procedure SetState(net : in out Cached_NNet; NSV : NN.State_Vector);

    overriding
    function  NeuronValues(net : Cached_NNet) return NN.Value_Array;



private

    -----------------
    -- A mutable NNet using Containers.Vectors and Connectors to link neurons and inputs/outputs
    --
    -- first common vector types
    use type NN.ConnectionIndex;
    package IV is new Ada.Containers.Vectors(Index_Type=>NN.InputIndex,  Element_Type=>NN.ConnectionIndex);
    package OV is new Ada.Containers.Vectors(Index_Type=>NN.OutputIndex, Element_Type=>NN.ConnectionIndex);
    package NV is new Ada.Containers.Vectors(Index_Type=>NN.NeuronIndex, Element_Type=>NN.ConnectionIndex);

    package PLV is new PL.vectors;
    use type PLV.Layer;
    package LV is new Ada.Containers.Vectors(Index_Type=>NN.LayerIndex,  Element_Type=>PLV.Layer);

    -- Finally the NNet
    type NNet is new NNet_Interface with record
        inputs  : IV.Vector;
        outputs : OV.Vector;
        neurons : NV.Vector;
        myLayers : LV.Vector;
    end record;

    type Cached_NNet is new NNet and Cached_NNet_Interface with null record;

end wann.nets.vectors;

