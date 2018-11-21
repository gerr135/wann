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

-- limited with wann.layers;
-- NOTE: due to whole hierarchy being generic we cannot limited with,
-- so layers are defined directly in this module

with wann.neurons, wann.layers;

generic
package wann.nets is

    package PN is new wann.neurons;
    package PL is new wann.layers;


    ----------------------------------------------------------------
    -- local indices and associated arrays:
    -- Input/output connections and data vector
    type    InputIndex_Base is new Natural;
    subtype InputIndex is InputIndex_Base range 1 .. InputIndex_Base'Last;
    type    OutputIndex is new Positive;
    --
    type InConnArray  is array (InputIndex range <>)  of ConnectionIdx;
    type OutConnArray is array (OutputIndex range <>) of ConnectionIdx;
    type ValueArray   is array (InputIndex range <>)  of Real;



    ----------------------------------------------------------------
    -- the main type of this package, the NNet itself
    --  making it an interface to allow composition (say with Controlled)
    type NNet_Interface is limited Interface;
    type NNet_Access is access NNet_Interface;

    -- Dimension getters; the setters are imnplementation-specific,
    -- and should either be handled during construction or be dynamic
    function GetNInputs (net : NNet_Interface) return InputIndex  is abstract;
    function GetNOutputs(net : NNet_Interface) return OutputIndex is abstract;
    function GetNNeurons(net : NNet_Interface) return NeuronIndex is abstract;
    function GetNLayers (net : NNet_Interface) return LayerIndex  is abstract;

    --  Neuron handling
    procedure NewNeuron(net : in out NNet_Interface; idx : out NeuronIndex_Base) is abstract;
    -- create new empty neuron emplacement and return its index
    -- needs overriding in dynamic/mutable net.
    -- Makes no sense for fixed nnet; that one should just return 0 (and do nothing otherwise).

    procedure DelNeuron(net : in out NNet_Interface; idx : NeuronIndex) is null;
    -- remove neuron from NNet_Interface, as with New, only for mutable representation

    -- neuron getter and setter
    function  GetNeuron(net : NNet_Interface; idx : NeuronIndex) return PN.NeuronCLass_Access is abstract;
    procedure SetNeuron(net : in out NNet_Interface; NA : PN.NeuronClass_Access) is abstract;

    -- layer handling
    function  LayersReady (net : NNet_Interface) return Boolean is abstract;
    function  GetLayer(net : NNet_Interface; idx : LayerIndex) return PL.Layer_Interface'Class  is abstract;
    procedure SetLayer(net : in out NNet_Interface; idx : LayerIndex; L : PL.Layer_Interface'Class) is abstract;

    -- data passage
    procedure SetInputValues(net : in out NNet_Interface; V : ValueArray) is abstract;



    -----------------------------------
    -- class-wide stuff: main utility

    --
    -- Neuron manipulation
    --
    function  AddNeuron(net : in out NNet_Interface'Class; NR : PN.NeuronRec) return NeuronIndex;
    procedure AddNeuron(net : in out NNet_Interface'Class; NR : PN.NeuronRec; idx : out NeuronIndex);
    procedure AddNeuron(net : in out NNet_Interface'Class; NR : PN.NeuronRec);
    -- combines New and Set
    --
    function  AddNeuron(net : in out NNet_Interface'Class; activat : ActivationType; connects : PN.InConnArray) return NeuronIndex;
    procedure AddNeuron(net : in out NNet_Interface'Class; activat : ActivationType; connects : PN.InConnArray; idx : out NeuronIndex);
    procedure AddNeuron(net : in out NNet_Interface'Class; activat : ActivationType; connects : PN.InConnArray);
    -- New plus Set by parameters
    --
    procedure ResetNeuron(net : in out NNet_Interface'Class; NR  : PN.NeuronRec);
    procedure ResetNeuron(net : in out NNet_Interface'Class; idx : NeuronIndex; activat : ActivationType; connects : PN.InConnArray);
    procedure ResetNeuron(net : in out NNet_Interface'Class; idx : NeuronIndex; connects : PN.InConnArray);
    -- replaces neuron[idx] parameters, either all or partial

    --
    --  Nnet manipulation
    --
    procedure ReconnectNeuronAtRandom(net : in out NNet_Interface'Class; idx  : NeuronIndex; maxConnects : InputIndex_Base := 0);
    procedure PopulateAtRandom (net : in out NNet_Interface'Class; maxConnects : InputIndex; Npts : NeuronIndex_Base := 0);
    -- populates net with new neurons or resets existing one to random configuration
    -- Npts needs to be passed in case of empty mutable net, otherwise it simply rearranges existing net.

    procedure SortForward (net : in out NNet_Interface'Class);
    procedure SortBackward(net : in out NNet_Interface'Class);
    -- perform a topological sort, (re-)creating layers tracking the connections,
    -- to allow optimizations (parallel computation, use of GPU).
    --
    -- Forward and backward may be different if cycles are present
    -- (which is a major modus operandi of this lib).

    --
    --  Propagation
    --
    -- forward propagation through trained net
    --  Ease of use wrapper: emulate stateless propagation
    function  ProcessInputs(net : NNet_Interface'Class; V : ValueArray) return ValueArray;
    --  Stateful propagation, representative of real data passage
    --  NOTE: initial values should be set first with SetInputValues
    procedure ProcessInputs(net : NNet_Interface'Class);
    function  ReadOutputs  (net : NNet_Interface'Class) return ValueArray;


--     procedure Train(net : in out NNet'Class; training_set : TBD);


end wann.nets;
