-- wann.nets package
-- Holds definition of the main type - the NNet, representing the neural net interface.
-- Specifics of data storage is in its children.
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

with wann.neurons;
with wann.layers.vectors;
with wann.inputs;
with connectors.vectors;

generic
package wann.nets is

    package PI  is new wann.inputs;

    package PL  is new wann.layers;
    package PLV is new PL.vectors;

    package PN renames PL.PN;
    --package PN is new wann.neurons; -- creates new package with new incompatible types


    -- NOTE 1: local indices are defined at the top level,
    -- as they have to be acessible to al other children

    -- NOTE 2: 2 paradigms of neural net data flow:
    --   1st: stateless net - net only holds topology and weights,
    --   actual signals are kept in external "state vector".
    --
    --   2nd: stateful net  - signals are passed throgh the net itself,
    --   neurons store not only weights and connections, but also current data output..

    ----------------------------------------------------------------
    -- the main type of this package, the NNet itself
    --  making it an interface to allow composition (say with Controlled)
    --  also to prototype the data access needs for different variants
    --
    -- This is the base version, consists of stateless neurons (topology and weights only);
    -- can be used for "light" forwardProp only, initiated from pre-trained net.
    --
    -- Some of the functionality is common to all, and is easiest to implement right here.
    -- So, like with Layer_Interface we make this one abstract tagged, rather than interface.
    -- We have no need for overlaying hierarchies so far..
    type NNet_Interface is abstract tagged limited private;
    type NNet_Access is access NNet_Interface'Class;

    -- Dimension getters; the setters are imnplementation-specific,
    function NInputs (net : NNet_Interface) return NN.InputIndex  is abstract;
    function NOutputs(net : NNet_Interface) return NN.OutputIndex is abstract; -- frm Connectors
    function NNeurons(net : NNet_Interface) return NN.NeuronIndex is abstract;
    function NLayers (net : NNet_Interface) return NN.LayerIndex  is abstract;

    -- net IO
    -- These would be inefficient in dynamic implementations (have to copy entire array to access one element)
    -- The 1st one is not even possible, as inputs have variable number of connections..
    --function  Input_Connections (net : NNet_Interface) return NN.Input_Connection_Array  is abstract;
    --function  Output_Connections(net : NNet_Interface) return NN.Output_Connection_Array is abstract;
    --
    -- So we access by element instead
    function  Input (net : NNet_Interface; i : NN.InputIndex)  return PI.Input_Interface'Class is abstract;
    function  Input (net : NNet_Interface'Class; i : NN.InputIndex)  return PI.InputRec;
    function  Output(net : NNet_Interface; o : NN.OutputIndex) return NN.ConnectionIndex is abstract; -- from Connectors

    --  Neuron handling
    -- NNet is conceptually a container. So we store/remove neurons with Add/Del_Neuron.
    -- As we have multiple neuron implementations, specific neurons should be created
    -- by their appropriate constructors and passed to the Add_Neuron method.
    --
    -- To handle neurons we need
    type Neuron_Reference (Data : not null access PN.Neuron_Interface'Class) is private
        with Implicit_Dereference => Data;


    procedure Add_Neuron(net  : in out NNet_Interface;
                         neur : in out PN.Neuron_Interface'Class; -- gotta be neuron itself, not reference, as NNet is essentially a container
                         idx : out NN.NeuronIndex) is abstract;
    -- adds pre-created neuron, return in idx new assigned NN.NeuronIndex
    -- and updates connections (outputs) of other net entities (other neurons, inputs, etc..)
    -- also should invalidate Layers_sorted or call sorting if autosort is set..

    procedure Del_Neuron(net : in out NNet_Interface; idx : NN.NeuronIndex) is null;
    -- remove neuron from NNet_Interface,
    -- as with Add, should update connections of affected entities and reset Layers_Sorted or autosort

    -- neuron getters
--     function  Neuron(net : NNet_Interface; idx : NN.NeuronIndex) return PN.Neuron_Interface'Class is abstract;
        -- this provides read-only access, passing by reference (tagged record)
    function  Neuron(net : aliased in out NNet_Interface; idx : NN.NeuronIndex) return Neuron_Reference is abstract;
        -- this provides read-write access via Accessor trick


    -- layer handling
    -- the (abstract) primitives
    function  Layers_Ready (net : NNet_Interface) return Boolean is abstract;
--     function  Layers(net : NNet_Interface) return PL.LayerList_Interface'Class is abstract;
    function  Layer(net : NNet_Interface; idx : NN.LayerIndex) return PL.Layer_Interface'Class  is abstract;
    procedure Set_Layer(net : in out NNet_Interface; idx : NN.LayerIndex; L : PL.Layer_Interface'Class) is abstract;

    -- autosort flag handling
    function  Autosort_Layers(net : NNet_Interface) return Boolean;
    procedure Set_Autosort_Layers(net : in out NNet_Interface;
                                  Autosort : Boolean; Direction : Sort_Direction := Forward);


    --------------------
    --  "cached" nnet
    --  Stores neuron outputs in a state vector, uses base stateless neurons
    type Cached_NNet_Interface is abstract new NNet_Interface with private;
    type Cached_NNet_Access    is access Cached_NNet_Interface;

    function  State(net : Cached_NNet_Interface) return NN.State_Vector  is abstract;
    procedure Set_State(net : in out Cached_NNet_Interface; NSV : NN.State_Vector) is abstract;
    -- NOTE: GetInputValues should raise  UnsetValueAccess if called before SetInputValues

    type Cached_Checked_NNet_Interface is abstract new NNet_Interface with private;
    type Cached_Checked_NNet_Access    is access Cached_NNet_Interface;

    function  State(net : Cached_Checked_NNet_Interface) return NN.Checked_State_Vector  is abstract;
    procedure Set_State(net : in out Cached_Checked_NNet_Interface; NSV : NN.Checked_State_Vector) is abstract;
    -- NOTE: GetInputValues should raise  UnsetValueAccess if called before SetInputValues

    --------------------
    --  Stateful nnet
    --  Stores neuron outputs in neurons themselves, uses stateful neurons
    type Stateful_NNet_Interface is abstract new NNet_Interface with private;
    type Stateful_NNet_Access    is access Stateful_NNet_Interface;

    function  Input_Values(net : Stateful_NNet_Interface) return NN.Input_Array is abstract;
    procedure Set_Input_Values(net : in out Stateful_NNet_Interface; IV : NN.Input_Array) is abstract;
    --
    function  Neuron(net : Stateful_NNet_Interface; idx : NN.NeuronIndex) return PN.Stateful_NeuronClass_Access is abstract;



    -----------------------------------------
    -- class-wide stuff: main utility
    --
    -- Neuron handling utility
    procedure Add_Neuron(net : in out NNet_Interface'Class; neur : in out PN.Neuron_Interface'Class);

    --
    --  NNet manipulation
    --
    procedure Reconnect_Neuron_At_Random(net : in out NNet_Interface'Class; idx  : NN.NeuronIndex; maxConnects : PN.InputIndex_Base := 0);
    procedure Populate_At_Random (net : in out NNet_Interface'Class; Npts : NN.NeuronIndex_Base;  maxConnects : PN.InputIndex_Base := 0);
    -- populates net with new neurons or resets existing one to random configuration
    -- Npts needs to be passed in case of empty mutable net, otherwise it simply rearranges existing net.

    procedure Sort_Layers (net : in out NNet_Interface'Class; Direction : Sort_Direction := Forward);
    -- perform a topological sort, (re-)creating layers tracking the connections,
    -- to allow optimizations (parallel computation, use of GPU).
    --
    -- Forward and backward sort will produce different layering if cycles are present
    -- (which is a major modus operandi of this lib).

    procedure Update_Layers (net : in out NNet_Interface'Class; idx : NN.NeuronIndex);
    -- called upon insertion/deletion of a neuron to update pre-sroted layers
    -- if Autosort_Layers = True.
    -- Updates layers starting from the inserted neuron, following its connections.
    -- May be more efficient (O(logN) instead of N*LogN) compared to complete sort.

    -- May need to add a method of sort validation if full state of neurons is saved/loaded


    ------------------------
    --  Propagation
    --
    -- Forward prop through trained net
    -- stateless propagation net state is completely internal to this proc, no side effects
    function  Prop_Forward(net : NNet_Interface'Class; inputs : NN.Input_Array)  return NN.Output_Array;
    --
    function  Calc_Outputs(net : NNet_Interface'Class; NSV : NN.Checked_State_Vector) return NN.Output_Array;
    function  Calc_Outputs(net : NNet_Interface'Class; NSV : NN.State_Vector) return NN.Output_Array;

    --  Cached NNet propagation
    --  initial values should be set first with Set_Input_Values and then advanced within net,
    --  no need for passing around intermediate inputs/outputs
    --
    -- first Unchecked version
    function  Input_Values(net : Cached_NNet_Interface'Class) return NN.Input_Array;
    --
    procedure Set_Input_Values(net : in out Cached_NNet_Interface'Class; IV : NN.Input_Array);
    --
    procedure Prop_Forward(net : Cached_NNet_Interface'Class);
    --
    function  Calc_Outputs(net : Stateful_NNet_Interface'Class) return NN.Output_Array;

    --  Checked version
    function  Input_Values(net : Cached_Checked_NNet_Interface'Class) return NN.Input_Array;
    --
    procedure Set_Input_Values(net : in out Cached_Checked_NNet_Interface'Class; IV : NN.Input_Array);
    --
    procedure Prop_Forward(net : Cached_Checked_NNet_Interface'Class);
    --
    function  Calc_Outputs(net : Cached_Checked_NNet_Interface'Class) return NN.Output_Array;


private

    type Neuron_Reference (Data : not null access PN.Neuron_Interface'Class) is null record;


    type NNet_Interface is abstract tagged limited record
        autosort_layers : Boolean := False;
        layer_sort_direction  : Sort_Direction := Forward;  -- reset by Sort_Layers
    end record;

    type Cached_NNet_Interface is abstract new NNet_Interface with null record;

    type Cached_Checked_NNet_Interface is abstract new NNet_Interface with null record;

    type Stateful_NNet_Interface is abstract new NNet_Interface with null record;

end wann.nets;

