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

    package PLV is new PL.vectors;

    --------------------------
    -- A mutable NNet type and methods
    type NNet is new NNet_Interface with private;

    -- Base constructor, create empty net with set Nin and Nout
    function Create (Nin : NNet_InputIndex; Nout : NNet_OutputIndex) return NNet;

    -- inherited methods
    -- getters
    overriding
    function GetNNeurons(net : NNet) return NNet_NeuronIndex;

    overriding
    function GetNLayers (net : NNet) return LayerIndex;

    -- data IO
    overriding
    function GetInputConnections (net : NNet) return NNet_InConnArray;

    overriding
    function GetOutputConnections(net : NNet) return NNet_OutConnArray;

    overriding
    function  GetNNetState(net : NNet) return NNet_StateVector;

    overriding
    procedure SetNNetState(net : in out NNet; NSV : NNet_StateVector);

    overriding
    function  GetNeuronValues(net : NNet) return NNet_ValueArray;


    -- neuron handling
    overriding
    procedure NewNeuron(net : in out NNet; idx : out NNet_NeuronIndex_Base);

    overriding
    procedure DelNeuron(net : in out NNet; idx : NNet_NeuronIndex);

    overriding
    function  GetNeuron(net : NNet; idx : NNet_NeuronIndex) return PN.NeuronCLass_Access;

    overriding
    procedure SetNeuron(net : in out NNet; neur : PN.NeuronCLass_Access);

    overriding
    function  LayersReady (net : NNet) return Boolean;

    overriding
    function  GetLayer(net : in NNet;     idx : LayerIndex) return PL.Layer_Interface'Class;

    overriding
    procedure SetLayer(net : in out NNet; idx : LayerIndex; LR :   PL.Layer_Interface'Class);

--     overriding
--     procedure SetInputValues(net : in out NNet; V : NNet_InputArray);


private

    -----------------
    -- A mutable NNet using Containers.Vectors and Connectors to link neurons and inputs/outputs
    --
    -- first common vector types
    package IV is new Ada.Containers.Vectors(Index_Type=>NNet_InputIndex,  Element_Type=>ConnectionIdx);
    package OV is new Ada.Containers.Vectors(Index_Type=>NNet_OutputIndex, Element_Type=>ConnectionIdx);
    package NV is new Ada.Containers.Vectors(Index_Type=>NNet_NeuronIndex, Element_Type=>ConnectionIdx);

    package LV is new Ada.Containers.Vectors(Index_Type=>LayerIndex,  Element_Type=>PLV.Layer,
                                             "=" => PLV."=");

    -- Finally the NNet
    type NNet is new NNet_Interface with record
        inputs  : IV.Vector;
        outputs : OV.Vector;
        neurons : NV.Vector;
        layers  : LV.Vector;
    end record;


end wann.nets.vectors;
