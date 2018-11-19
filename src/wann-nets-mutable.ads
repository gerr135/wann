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


generic
package wann.nets.mutable is

    type Layer_SimpleVector is new Abstract_Layer with private;
    -- this should be moved to separate package (and multiple Layer variants added there too)
    -- perhaps wann.layers can be reused to store all Layer realizations

    overriding
    function  Length(AL : Layer_SimpleVector) return NeuronIndex_Base;

    overriding
    function  Get(AL : Layer_SimpleVector) return LayerRec;

    overriding
    procedure Set(AL : in out Layer_SimpleVector; LR : LayerRec);


    --------------------------
    -- A mutable NNet type and methods
    type NNet_Mutable is new NNet_Interface with private;

    -- Base constructor, create empty net with set Nin and Nout
    function Create (Nin : InputIndex; Nout : OutputIndex) return NNet_Mutable;

    -- inherited methods
    -- getters
    overriding
    function GetNInputs (net : NNet_Mutable) return InputIndex;

    overriding
    function GetNOutputs(net : NNet_Mutable) return OutputIndex;

    overriding
    function GetNNeurons(net : NNet_Mutable) return NeuronIndex;

    overriding
    function GetNLayers (net : NNet_Mutable) return LayerIndex;


    -- neuron handling
    overriding
    procedure NewNeuron(net : in out NNet_Mutable; idx : out NeuronIndex_Base);

    overriding
    procedure DelNeuron(net : in out NNet_Mutable; idx : NeuronIndex);

    overriding
    function  GetNeuron(net : NNet_Mutable; idx : NeuronIndex) return NeuronRec;

    overriding
    procedure SetNeuron(net : in out NNet_Mutable; neur : NeuronRec);

    overriding
    function  GetLayer(net : in NNet_Mutable;     idx : LayerIndex) return Abstract_Layer'Class;

    overriding
    procedure SetLayer(net : in out NNet_Mutable; idx : LayerIndex; LR :   Abstract_Layer'Class);


private

    -----------------
    -- A mutable NNet using Containers.Vectors and Connectors to link neurons and inputs/outputs
    --
    -- first common vector types
    package IV is new Ada.Containers.Vectors(Index_Type=>InputIndex,  Element_Type=>ConnectionRec);
    package OV is new Ada.Containers.Vectors(Index_Type=>OutputIndex, Element_Type=>ConnectionRec);
    package NV is new Ada.Containers.Vectors(Index_Type=>NeuronIndex, Element_Type=>ConnectionRec);

    -- basic Layer realization - should be in a separate package
    type Layer_SimpleVector is new Abstract_Layer with record
        -- vector of neurons, no matrix recalculation
        neurons : NV.Vector;
    end record;

    package LV is new Ada.Containers.Indefinite_Vectors(Index_Type=>LayerIndex,  Element_Type=>Layer_SimpleVector);

    -- Finally the NNet
    type NNet_Mutable is new NNet_Interface with record
        inputs  : IV.Vector;
        outputs : OV.Vector;
        neurons : NV.Vector;
        layers  : LV.Vector;
    end record;


end wann.nets.mutable;
