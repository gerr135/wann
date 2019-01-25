--
-- wann.neurons package. Holds definition and layout of the neuron interface.
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

with Lists;

generic
package wann.neurons is


    -------------------------------------
    --  Local input/output indices
    type    InputIndex_Base is new Natural;
    subtype InputIndex is InputIndex_Base range 1 .. InputIndex_Base'Last;
    type OutputIndex is new Positive;


    -- associated arrray types for holding params
    type Input_Connection_Array  is array (InputIndex range <>)  of ConnectionIndex;
    type Output_Connection_Array is array (OutputIndex range <>) of ConnectionIndex;
    type Weight_Array  is array (InputIndex_Base range <>) of Real;
    type Value_Array   is array (InputIndex range <>) of Real;


    -------------------------------------------------
    -- Neuron representation
    -- To be used for storage, IO and as an alphabet to form a linear description,
    -- a-la DNA/protein sequence. Then the NNet can be simply defined as some linear sequence
    -- in declaration which can be passed to the NNet constructor.
    type NeuronRec(Nin : InputIndex) is record
        idx     : NNet_NeuronIndex; -- own index in NNet
        activat : Activation_Type;
        lag     : Real;    -- delay of result propagation, unused for now
        weights : Weight_Array(0 .. Nin);
        inputs  : Input_Connection_Array  (1 .. Nin);
    end record;
    type NeuronRecPtr is access NeuronRec;

    ----------------------------------------------
    -- Neuron interface: to be used by layers and NNet.
    -- Multiple representations are possible, defined in child packages.
    type Neuron_Interface is interface;
--     type Neuron_Access is access Neuron_Interface;  -- should not ever be needed
    type NeuronClass_Access is access all Neuron_Interface'Class;

    -- primitives
    -- basic getters and setters; individual fields can be reset in a class-wide utility
    -- by calling basic Get/Set pair.
    -- Neurons are going to be modded much rarer than other calcs (notably forward/back-prop),
    -- so better minimize code to override and don't worry much about efficiency of rare methods.
    function  ToRec  (NI : Neuron_Interface) return NeuronRec is abstract;
    procedure FromRec(NI : in out Neuron_Interface; LR : NeuronRec) is abstract;
    --
    -- Outputs, on the other hand, are not part of primitive Rec,
    -- and will need to be reset individually during rearrangement, so need some primitives for these..
    -- The principal users should be Layer or NNet while adding/removeing/reconnecting neurons
    procedure AddOutput(NI : in out Neuron_Interface; Output : ConnectionIndex) is abstract;
    procedure DelOutput(NI : in out Neuron_Interface; Output : ConnectionIndex) is abstract;


    ------------
    --  stateful version, that keeps current value stored
    type Stateful_Neuron_Interface is interface and Neuron_Interface;
    type Stateful_NeuronClass_Access is access Stateful_Neuron_Interface'Class;

    procedure SetValue(NI : in out Stateful_Neuron_Interface; val :  Real) is abstract;
    function  GetValue(NI : Stateful_Neuron_Interface) return Real is abstract;
    -- just basic getter/setter. Data validity should be handled in implementation
    function  Valid (NI : Stateful_Neuron_Interface) return Boolean is abstract;


    ----------
    -- Class-wide utility
    --
    -- Additional getters/setters
    function Index  (NI : Neuron_Interface'Class) return NNet_NeuronIndex;
    function Activat(NI : Neuron_Interface'Class) return Activation_Type;
    function Weights(NI : Neuron_Interface'Class) return Weight_Array;
    function Inputs (NI : Neuron_Interface'Class) return Input_Connection_Array;
    function Outputs(NI : Neuron_Interface'Class) return Output_Connection_Array;

    procedure SetIndex  (NI : in out Neuron_Interface'Class; idx : NNet_NeuronIndex);
    procedure SetActivat(NI : in out Neuron_Interface'Class; activat : Activation_Type);
    procedure SetWeights(NI : in out Neuron_Interface'Class; weights : Weight_Array);
    procedure SetInputs (NI : in out Neuron_Interface'Class; inputs  : Input_Connection_Array);
    procedure SetOutputs(NI : in out Neuron_Interface'Class; outputs : Output_Connection_Array);
    -- Inputs/Outputs stand for input/output connections

    -- Data processing
    function  PropForward(NI : Neuron_Interface'Class; data  : Value_Array) return Real;
        -- makes the x*W+bias |-> activation calculation; caches output internally
--     function  StoredResult(NI : Neuron_Interface'Class) return Real;
        -- returns stored output. Raises UnsetCacheAccess is value has not yet been calculated
    --
    -- for basic testing/small nets.
    -- for anything serious, Layer propagators should be used..
    procedure PropForward (NI : in out Stateful_Neuron_Interface'Class);
    procedure PropBackward(NI : in out Stateful_Neuron_Interface'Class);


    ------------------------------------------------------
    -- List/vector of neurons
    -- as everywhere else, this module defines interface. Specific implementation is in children

    package PNL is new Lists(NNet_NeuronIndex, Neuron_Interface);
    type NeuronList_Interface is interface and PNL.List_Interface;

end wann.neurons;
