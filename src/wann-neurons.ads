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

with wann.connectors;

generic
package wann.neurons is

    -------------------------------------
    --  Local input/output indices
    type    InputIndex_Base is new Natural;
    subtype InputIndex is InputIndex_Base range 1 .. InputIndex_Base'Last;
    type    OutputIndex_Base is new Natural;
    subtype OutputIndex is OutputIndex_Base range 1 .. OutputIndex_Base'Last;

    -- associated arrray types for holding params
    type Input_Connection_Array  is array (InputIndex range <>)  of NN.ConnectionIndex;
    type Output_Connection_Array is array (OutputIndex range <>) of NN.ConnectionIndex;
    type Weight_Array  is array (InputIndex_Base range <>) of Real;
    type Value_Array   is array (InputIndex range <>) of Real;


    -------------------------------------------------
    -- Neuron representation
    -- To be used for storage, IO and as an alphabet to form a linear description,
    -- a-la DNA/protein sequence. Then the NNet can be simply defined as some linear sequence
    -- in declaration which can be passed to the NNet constructor.
    --
    -- NOTE: outputs are not part of the "base topology", so it might make sense to have
    -- two record types
    type NeuronRec(Ni : InputIndex) is record
        idx     : NN.NeuronIndex_Base; -- own index in NNet
        activat : Activation_Type;
        lag     : Real;    -- delay of result propagation, unused for now
        weights : Weight_Array(0 .. Ni);
        inputs  : Input_Connection_Array  (1 .. Ni);
    end record;
    type NeuronRecPtr is access NeuronRec;

    -- An internal representation that includes more details that might change.
    -- To be used for passing neuron state around
    type NeuronRepr(<>) is private;
    type NeuronReprPtr is access NeuronRepr;

    ----------------------------------------------
    -- Neuron interface: to be used by layers and nets
    -- Multiple representations are possible, defined in child packages.
    --
    -- like Input_Interface, is based on Outputting_Interface, as output handling code is the same
    package PCN is new wann.Connectors(Index_Type=>OutputIndex);

    type Neuron_Interface is interface and PCN.Outputting_Interface;
--     type Neuron_Access is access Neuron_Interface;  -- should not ever be needed
    type NeuronClass_Access is access all Neuron_Interface'Class;

    -- NOTE on construction:
    -- Neurons are created with empty output list, to be populated by Add_Output calls..
    -- This should normally happen during insertion of Neuron into NNet and
    -- handled by the appropriate nnet type..

    -- primitives
    -- basic getters and setters; individual fields can be reset in a class-wide utility
    -- by calling basic Get/Set pair, but this is likely much less efficient, because
    -- large arrays will be often copied and discarded..
    -- Still, this is useful for setters, as neurons are going to be modded much less often
    -- than they would be used (notably for forward/back-prop). So this is still usefull for code minimization.
    function  ToRepr  (NI : Neuron_Interface) return NeuronRepr is abstract;
    procedure FromRepr(NI : in out Neuron_Interface; NR : NeuronRepr) is abstract;
    --
--     -- Outputs, on the other hand, are not part of primitive Rec,
--     -- and will need to be reset individually during rearrangement, so need some primitives for these..
--     -- The principal users should be Layer or NNet while adding/removeing/reconnecting neurons
--     procedure Add_Output(NI : in out Neuron_Interface; Output : NN.ConnectionIndex) is abstract;
--     procedure Del_Output(NI : in out Neuron_Interface; Output : NN.ConnectionIndex) is abstract;

    -- Still, it is better to provide direct getters for frequently used fields
    function NInputs (neur : Neuron_Interface) return InputIndex  is abstract;

    --
    function Input (neur : Neuron_Interface; idx : InputIndex)  return NN.ConnectionIndex is abstract;

    ------------------------------------------------------------
    --  stateful version, values are stored in the neuron itself
    --  only the output value is stored (as well as the "set" flag), inputs are looked up
    --  as outputs of incoming connections
    type Stateful_Neuron_Interface is interface and Neuron_Interface;
    type Stateful_NeuronClass_Access is access Stateful_Neuron_Interface'Class;

    procedure Set_Value(NI : in out Stateful_Neuron_Interface; val :  Real) is abstract;
    function  Value(NI : Stateful_Neuron_Interface) return Real is abstract;
    -- just basic getter/setter. Data validity should be handled in implementation
    function  Valid(NI : Stateful_Neuron_Interface) return Boolean is abstract;


    ----------------------
    -- Class-wide utility
    --
    -- Additional getters/setters
    -- mostly wrappers around FromRec, so inline them right here..
    -- the entire Rec:
    function  ToRec  (NI : Neuron_Interface'Class) return NeuronRec;
    -- and individual fields:
    function Index  (NI : Neuron_Interface'Class) return NN.NeuronIndex with Inline;
    function Activation(NI : Neuron_Interface'Class) return Activation_Type with Inline;
    function Weights(NI : Neuron_Interface'Class) return Weight_Array with Inline;
    function Inputs (NI : Neuron_Interface'Class) return Input_Connection_Array with Inline;

    procedure Set_Index  (NI : in out Neuron_Interface'Class; idx : NN.NeuronIndex);
    procedure Set_Activation(NI : in out Neuron_Interface'Class; activat : Activation_Type);
    procedure Set_Weights(NI : in out Neuron_Interface'Class; weights : Weight_Array);
    procedure Set_Inputs (NI : in out Neuron_Interface'Class; inputs  : Input_Connection_Array);
    -- Inputs/Outputs stand for input/output connections

    -- Data processing
    -- NOTE: these are for simple cases/small nets. For efficient calculations on large nets
    -- optimized layer-based propagators should be used instead.
    --
    -- basic ops, calcs use pre-picked (and repackages if needed) values
    function  Prop_Forward(neur : Neuron_Interface'Class; data  : Value_Array) return Real;
        -- makes the x*W+bias |-> activation calculation; caches output internally

    -- Utility wrappers for propagators
    --  prepare repackaged data arrays by picking corresponding values from global Net_State
    --  and pass those to basic calculators
    --
    -- stateless
    function  Prop_Forward(neur : Neuron_Interface'Class; inputs : NN.State_Vector)
        return NN.State_Vector;
    function  Prop_Forward(neur : Neuron_Interface'Class; inputs : NN.Checked_State_Vector)
        return NN.Checked_State_Vector;
    --
    -- procedural form (avoids recreating State_Vector all the time)
    procedure Prop_Forward(neur : Neuron_Interface'Class; SV : in out NN.State_Vector);
    procedure Prop_Forward(neur : Neuron_Interface'Class; SV : in out NN.Checked_State_Vector);
    -- stateful
    procedure Prop_Forward (neur : in out Stateful_Neuron_Interface'Class);
    procedure Prop_Backward(neur : in out Stateful_Neuron_Interface'Class);

private

    type NeuronRepr(Ni : InputIndex_Base; No : OutputIndex_Base) is record
        idx     : NN.NeuronIndex_Base; -- own index in NNet
        activat : Activation_Type;
        lag     : Real;    -- delay of result propagation, unused for now
        weights : Weight_Array(0 .. Ni);
        inputs  : Input_Connection_Array  (1 .. Ni);
        outputs : Output_Connection_Array (1 .. No);
        -- may add level index this belongs to, to avoid resorting upon structure load..
    end record;

end wann.neurons;
