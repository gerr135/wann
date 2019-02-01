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
-- with Ada.Containers.Indefinite_Vectors;

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
    -- an ADT handling neurons only, base for further derivation
    type Proto_NNet is abstract new NNet_Interface with private;

    -- only a few of abstract methods make sense at this level,
    -- basically only the methods that do not touch IO
    -- Thus no specific IO handling or even creation/deletion of neurons
    overriding
    function NNeurons(net : Proto_NNet) return NN.NeuronIndex;

    overriding
    function NLayers (net : Proto_NNet) return NN.LayerIndex;

    overriding
    function  Neuron(net : Proto_NNet; idx : NN.NeuronIndex) return PN.NeuronClass_Access;
    -- we *can* existing one, this code should be common

    overriding
    function  Layers_Ready (net : Proto_NNet) return Boolean;

    overriding
    function  Layer(net : Proto_NNet; idx : NN.LayerIndex) return PL.Layer_Interface'Class;

    overriding
    procedure Set_Layer(net : in out Proto_NNet; idx : NN.LayerIndex; L : PL.Layer_Interface'Class);


    --------------------------------------------------------------------
    --  Cached_NNet
    type Cached_Proto_NNet is abstract new Proto_NNet and Cached_NNet_Interface with private;

    overriding
    function  State(net : Cached_Proto_NNet) return NN.State_Vector;

    overriding
    procedure Set_State(net : in out Cached_Proto_NNet; NSV : NN.State_Vector);



    ----------------------------------
    -- A mutable NNet with fixed IO
    type FixedIO_NNet(Ni : NN.InputIndex; No : NN.OutputIndex) is new Proto_NNet with private;

    -- Base constructor, create empty net with set Nin and Nout
    function Create return FixedIO_NNet;

    -- inherited methods, the rest that needs overriding
    -- getters
    overriding
    function Input_Connections (net : FixedIO_NNet) return NN.Input_Connection_Array;

    overriding
    function Output_Connections(net : FixedIO_NNet) return NN.Output_Connection_Array;


    -- neuron handling
    overriding
    procedure Add_Neuron(net : in out FixedIO_NNet; neur : PN.Neuron_Interface'Class;
                         idx : out NN.NeuronIndex);

    overriding
    procedure Del_Neuron(net : in out FixedIO_NNet; idx : NN.NeuronIndex);

    overriding
    procedure Set_Layer(net : in out FixedIO_NNet; idx : NN.LayerIndex; L : PL.Layer_Interface'Class);



    ----------------------------------
    -- A mutable NNet with mutable IO
    type MutableIO_NNet is new Proto_NNet with private;

    -- Base constructor, create empty net with some Nin and Nout
    function Create(Ni : NN.InputIndex; No : NN.OutputIndex) return MutableIO_NNet;

    -- inherited methods, the rest that needs overriding
    -- getters
    overriding
    function Input_Connections (net : MutableIO_NNet) return NN.Input_Connection_Array;

    overriding
    function Output_Connections(net : MutableIO_NNet) return NN.Output_Connection_Array;

    overriding
    procedure Add_Neuron(net : in out MutableIO_NNet; neur : PN.Neuron_Interface'Class;
                         idx : out NN.NeuronIndex);

    overriding
    procedure Del_Neuron(net : in out MutableIO_NNet; idx : NN.NeuronIndex);

    overriding
    procedure Set_Layer(net : in out MutableIO_NNet; idx : NN.LayerIndex; L : PL.Layer_Interface'Class);






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


    type Proto_NNet is abstract new NNet_Interface with record
        neurons : NV.Vector;
        layers  : LV.Vector;
    end record;


    type Cached_Proto_NNet is abstract new Proto_NNet and Cached_NNet_Interface with null record;


    type FixedIO_NNet(Ni : NN.InputIndex; No : NN.OutputIndex) is new Proto_NNet with null record;


    -- Finally the NNet
    type MutableIO_NNet is new Proto_NNet with record
        inputs  : IV.Vector;
        outputs : OV.Vector;
    end record;

end wann.nets.vectors;

