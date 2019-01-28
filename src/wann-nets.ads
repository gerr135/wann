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

with wann.neurons, wann.layers;

generic
package wann.nets is

    package PL is new wann.layers;
--     package PN is new wann.neurons; -- may run into trouble (package instantiation defines new types)
    -- better to use PL.PN instead
    package PN renames PL.PN;


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
    type NNet_Interface is limited Interface;
    type NNet_Access is access NNet_Interface;

    -- Dimension getters; the setters are imnplementation-specific,
    function NNeurons(net : NNet_Interface) return NNet.NeuronIndex is abstract;
    function NLayers (net : NNet_Interface) return NNet.LayerIndex  is abstract;

    -- data storage and propagation
    function  Input_Connections (net : NNet_Interface) return NNet.Input_Connection_Array  is abstract;
    function  Output_Connections(net : NNet_Interface) return NNet.Output_Connection_Array is abstract;

    --  Neuron handling
    procedure New_Neuron(net : in out NNet_Interface; idx : out NNet.NeuronIndex_Base) is abstract;
    -- create new empty neuron emplacement and return its index
    -- needs overriding in dynamic/mutable net.
    -- Makes no sense for fixed nnet; that one should just return 0 (and do nothing otherwise).

    procedure Del_Neuron(net : in out NNet_Interface; idx : NNet.NeuronIndex) is null;
    -- remove neuron from NNet_Interface, as with New, only for mutable representation

    -- neuron getter and setter
    function  Neuron(net : NNet_Interface; idx : NNet.NeuronIndex) return PN.NeuronClass_Access is abstract;
    procedure Set_Neuron(net : in out NNet_Interface; NA : PN.NeuronClass_Access) is abstract;

    -- layer handling
    function  Layers_Ready (net : NNet_Interface) return Boolean is abstract;
--     function  Layers(net : NNet_Interface) return PL.LayerList_Interface'Class is abstract;
    function  Layer(net : NNet_Interface; idx : NNet.LayerIndex) return PL.Layer_Interface'Class  is abstract;
    procedure Set_Layer(net : in out NNet_Interface; idx : NNet.LayerIndex; L : PL.Layer_Interface'Class) is abstract;


    --------------------
    --  "cached" nnet
    --  Stores neuron outputs in a state vector, uses base stateless neurons
    type Cached_NNet_Interface is limited interface and NNet_Interface;
    type Cached_NNet_Access    is access Cached_NNet_Interface;

    function  State(net : Cached_NNet_Interface) return NNet.State_Vector  is abstract;
    procedure SetState(net : in out Cached_NNet_Interface; NSV : NNet.State_Vector) is abstract;
    -- NOTE: GetInputValues should raise  UnsetValueAccess if called before SetInputValues
    function  NeuronValues(net : Cached_NNet_Interface) return NNet.Value_Array is abstract;
    -- only getter, as neuron output data is set via propagaton

    --------------------
    --  Stateful nnet
    --  Stores neuron outputs neurons themselves, uses stateful neurons
    type Stateful_NNet_Interface is limited interface and NNet_Interface;
    type Stateful_NNet_Access    is access Stateful_NNet_Interface;

    function  Input_Values(net : Stateful_NNet_Interface) return NNet.Input_Array is abstract;
    procedure Set_Input_Values(net : in out Stateful_NNet_Interface; IV : NNet.Input_Array) is abstract;
    --
    function  Neuron(net : Stateful_NNet_Interface; idx : NNet.NeuronIndex) return PN.Stateful_NeuronClass_Access is abstract;



    -----------------------------------------
    -- class-wide stuff: main utility

    --
    -- NNet construction
    --
    -- Neuron manipulation
    --
    function  AddNeuron(net : in out NNet_Interface'Class; NR : PN.NeuronRec) return NNet.NeuronIndex;
    procedure AddNeuron(net : in out NNet_Interface'Class; NR : PN.NeuronRec; idx : out NNet.NeuronIndex);
    procedure AddNeuron(net : in out NNet_Interface'Class; NR : PN.NeuronRec);
    -- combines New and Set
    --
    function  AddNeuron(net : in out NNet_Interface'Class; activat : Activation_Type; connects : PN.Input_Connection_Array) return NNet.NeuronIndex;
    procedure AddNeuron(net : in out NNet_Interface'Class; activat : Activation_Type; connects : PN.Input_Connection_Array; idx : out NNet.NeuronIndex);
    procedure AddNeuron(net : in out NNet_Interface'Class; activat : Activation_Type; connects : PN.Input_Connection_Array);
    -- New plus Set by parameters
    --
    procedure ResetNeuron(net : in out NNet_Interface'Class; NR  : PN.NeuronRec);
    procedure ResetNeuron(net : in out NNet_Interface'Class; idx : NNet.NeuronIndex; activat : Activation_Type; connects : PN.Input_Connection_Array);
    procedure ResetNeuron(net : in out NNet_Interface'Class; idx : NNet.NeuronIndex; connects : PN.Input_Connection_Array);
    -- replaces neuron[idx] parameters, either all or partial

    --
    --  Nnet manipulation
    --
    procedure ReconnectNeuronAtRandom(net : in out NNet_Interface'Class; idx  : NNet.NeuronIndex; maxConnects : PN.InputIndex_Base := 0);
    procedure PopulateAtRandom (net : in out NNet_Interface'Class; Npts : NNet.NeuronIndex_Base;  maxConnects : PN.InputIndex_Base := 0);
    -- populates net with new neurons or resets existing one to random configuration
    -- Npts needs to be passed in case of empty mutable net, otherwise it simply rearranges existing net.

    procedure SortForward (net : in out NNet_Interface'Class);
    procedure SortBackward(net : in out NNet_Interface'Class);
    -- perform a topological sort, (re-)creating layers tracking the connections,
    -- to allow optimizations (parallel computation, use of GPU).
    --
    -- Forward and backward may be different if cycles are present
    -- (which is a major modus operandi of this lib).

    ------------------------
    --  Propagation
    --
    -- Forward prop through trained net
    -- stateless propagation net state is completely internal to this proc, no side effects
    function  PropForward(net : NNet_Interface'Class; IV  : NNet.Input_Array)  return NNet.Output_Array;
    function  CalcOutputs(net : NNet_Interface'Class; NSV : NNet.Checked_State_Vector) return NNet.Output_Array;
    function  CalcOutputs(net : NNet_Interface'Class; NSV : NNet.State_Vector) return NNet.Output_Array;

    --  Stateful propagation:
    --  initial values should be set first with SetInputValues and then advanced within net,
    --  no need for passing around intermediate inputs/outputs

    -- cached version
    function  GetInputValues(net : Cached_NNet_Interface'Class)      return NNet.Input_Array;
    procedure SetInputValues(net : in out Cached_NNet_Interface'Class; IV : NNet.Input_Array);

    -- full statefull version
    function  PropForward(net : Stateful_NNet_Interface'Class) return NNet.Output_Array;
    function  CalcOutputs(net : Stateful_NNet_Interface'Class) return NNet.Output_Array;

    --     procedure Train(net : in out NNet'Class; training_set : TBD);


end wann.nets;

