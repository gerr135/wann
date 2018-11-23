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


    -- NOTE: local indices are defined at the top level,
    -- as they have to be acessibel to al other children

    ----------------------------------------------------------------
    -- the main type of this package, the NNet itself
    --  making it an interface to allow composition (say with Controlled)
    type NNet_Interface is limited Interface;
    type NNet_Access is access NNet_Interface;

    -- Dimension getters; the setters are imnplementation-specific,
    -- and should either be handled during construction or be dynamic
    function GetNNeurons(net : NNet_Interface) return NNet_NeuronIndex is abstract;
    function GetNLayers (net : NNet_Interface) return LayerIndex  is abstract;

    -- data storage and propagation
    function  GetInputConnections (net : NNet_Interface) return NNet_InConnArray  is abstract;
    function  GetOutputConnections(net : NNet_Interface) return NNet_OutConnArray is abstract;
    --
    function  GetInputValues(net : NNet_Interface)     return NNet_InputArray  is abstract;
    procedure SetInputValues(net : in out NNet_Interface; V : NNet_InputArray) is abstract;
    -- NOTE: GetInputValues should raise  UnsetValueAccess if called before SetInputValues

    function  GetNeuronValues(net : NNet_Interface) return NNet_ValueArray is abstract;
    -- only getter, as neuron output data is set via propagaton

    --  Neuron handling
    procedure NewNeuron(net : in out NNet_Interface; idx : out NNet_NeuronIndex_Base) is abstract;
    -- create new empty neuron emplacement and return its index
    -- needs overriding in dynamic/mutable net.
    -- Makes no sense for fixed nnet; that one should just return 0 (and do nothing otherwise).

    procedure DelNeuron(net : in out NNet_Interface; idx : NNet_NeuronIndex) is null;
    -- remove neuron from NNet_Interface, as with New, only for mutable representation

    -- neuron getter and setter
    function  GetNeuron(net : NNet_Interface; idx : NNet_NeuronIndex) return PN.NeuronCLass_Access is abstract;
    procedure SetNeuron(net : in out NNet_Interface; NA : PN.NeuronClass_Access) is abstract;

    -- layer handling
    function  LayersReady (net : NNet_Interface) return Boolean is abstract;
    function  GetLayer(net : NNet_Interface; idx : LayerIndex) return PL.Layer_Interface'Class  is abstract;
    procedure SetLayer(net : in out NNet_Interface; idx : LayerIndex; L : PL.Layer_Interface'Class) is abstract;


    -----------------------------------------
    -- class-wide stuff: main utility

    --
    -- Neuron manipulation
    --
    function  AddNeuron(net : in out NNet_Interface'Class; NR : PN.NeuronRec) return NNet_NeuronIndex;
    procedure AddNeuron(net : in out NNet_Interface'Class; NR : PN.NeuronRec; idx : out NNet_NeuronIndex);
    procedure AddNeuron(net : in out NNet_Interface'Class; NR : PN.NeuronRec);
    -- combines New and Set
    --
    function  AddNeuron(net : in out NNet_Interface'Class; activat : ActivationType; connects : PN.InConnArray) return NNet_NeuronIndex;
    procedure AddNeuron(net : in out NNet_Interface'Class; activat : ActivationType; connects : PN.InConnArray; idx : out NNet_NeuronIndex);
    procedure AddNeuron(net : in out NNet_Interface'Class; activat : ActivationType; connects : PN.InConnArray);
    -- New plus Set by parameters
    --
    procedure ResetNeuron(net : in out NNet_Interface'Class; NR  : PN.NeuronRec);
    procedure ResetNeuron(net : in out NNet_Interface'Class; idx : NNet_NeuronIndex; activat : ActivationType; connects : PN.InConnArray);
    procedure ResetNeuron(net : in out NNet_Interface'Class; idx : NNet_NeuronIndex; connects : PN.InConnArray);
    -- replaces neuron[idx] parameters, either all or partial

    --
    --  Nnet manipulation
    --
    procedure ReconnectNeuronAtRandom(net : in out NNet_Interface'Class; idx  : NNet_NeuronIndex; maxConnects : PN.InputIndex_Base := 0);
    procedure PopulateAtRandom (net : in out NNet_Interface'Class; Npts : NNet_NeuronIndex_Base;  maxConnects : PN.InputIndex_Base := 0);
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
    -- first stateless: net state is completely internal to this proc, no side effects
    function  CalcOutputs  (net : NNet_Interface'Class; V : NNet_ValueArray) return NNet_OutputArray;
    function  ProcessInputs(net : NNet_Interface'Class; V : NNet_InputArray) return NNet_OutputArray;

    --  Stateful propagation:
    --  initial values should be set first with SetInputValues
--     procedure ProcessInputs(net : NNet_Interface'Class);
--     function  CalcOutputs  (net : NNet_Interface'Class) return NNet_OutputArray;


--     procedure Train(net : in out NNet'Class; training_set : TBD);


end wann.nets;
