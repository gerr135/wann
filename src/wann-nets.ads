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

generic
package wann.nets is

    ----------------------------------------------
    -- First primitives, to exchange data.
    -- Layer representation in the NNet

    type LayerIndex is new Positive;
    -- Index to count rearranged neuron layers 1 .. 'Last
    -- 'Last is output layer, that can be treated specially on this simple check,
    -- so no extra marking should be necessary.

    -- representation record, to have common interface to pass data around
    type LayerRec(N : NeuronIndex) is record
        neurons : NConArray(1 .. N);
        -- might get outputs or inputs here, so use generic neuronal array
        --weightMatrix : some matrix;
        -- these are stored in referenced neurons anyway
        -- however constructing a separate matrix may be useful if we need to pass it to, e.g. e GPU
        -- but will worry about this when (or if) I ever get there..
        --deltas? : likely need to store those too
    end record;
    type LayerRecPtr is access LayerRec;



    ----------------------------------------------
    --  NNet - the principal type of this module
    -- forward declaration, for access discriminants
    type NNet_Interface;
    type NNet_Access is access NNet_Interface;

    ----------------------------------------------
    -- Layer interface: to be used by NNet.
    -- As with NNet itself, multiple representations are possible
    -- so we make it an Interface with common functionality,
    -- leaving the representations details to children.
    --
    -- Initial attempt to use a simple discriminated record would explode variants way too fast
    -- (multiple PropagationType's x multiple possible storage paradigms)
    -- So, use Interface with primitives here to keep it all sane.
    --
    -- discriminant NN points to the enveloping NNet.
    type Abstract_Layer(NN : NNet_Access) is abstract tagged private;

    function  Length(AL : Abstract_Layer) return NeuronIndex_Base is abstract;
    function  Get(AL : Abstract_Layer) return LayerRec is abstract;
    procedure Set(AL : in out Abstract_Layer; LR : LayerRec) is abstract;

    procedure PropForward(L : in out Abstract_Layer'Class);



    ----------------------------------------------------------------
    -- the main type of this package, the NNet itself
    --  making it an interface to allow composition (say with Controlled)
    type NNet_Interface is limited Interface;

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

    -- getter and setter
    function  GetNeuron(net : NNet_Interface; idx : NeuronIndex) return NeuronRec is abstract;
    procedure SetNeuron(net : in out NNet_Interface; NR : NeuronRec) is abstract;

    -- layer handling
    function  GetLayer(net : in NNet_Interface;     idx : LayerIndex) return Abstract_Layer'Class  is abstract;
    procedure SetLayer(net : in out NNet_Interface; idx : LayerIndex; L :    Abstract_Layer'Class) is abstract;



    -----------------------------------
    -- class-wide stuff: main utility

    --
    -- Neuron manipulation
    --
    function  AddNeuron(net : in out NNet_Interface'Class; NR : NeuronRec) return NeuronIndex;
    procedure AddNeuron(net : in out NNet_Interface'Class; NR : NeuronRec; idx : out NeuronIndex);
    procedure AddNeuron(net : in out NNet_Interface'Class; NR : NeuronRec);
    -- combines New and Set
    --
    function  AddNeuron(net : in out NNet_Interface'Class; activat : ActivationType; connects : InConArray) return NeuronIndex;
    procedure AddNeuron(net : in out NNet_Interface'Class; activat : ActivationType; connects : InConArray; idx : out NeuronIndex);
    procedure AddNeuron(net : in out NNet_Interface'Class; activat : ActivationType; connects : InConArray);
    -- New plus Set by parameters
    --
    procedure ResetNeuron(net : in out NNet_Interface'Class; NR : NeuronRec);
    procedure ResetNeuron(net : in out NNet_Interface'Class; idx  : NeuronIndex; activat : ActivationType; connects : InConArray);
    procedure ResetNeuron(net : in out NNet_Interface'Class; idx  : NeuronIndex; connects : InConArray);
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
    function  ProcessInputs(net : NNet_Interface'Class; inputs : InputArray) return OutputArray;
    -- forward propagation through trained net

--     procedure Train(net : in out NNet'Class; training_set : TBD);


private

    type Abstract_Layer(NN : NNet_Access) is abstract tagged null record;


--     function  ForwardPropLayer (net : NNet'Class; inputs : InputArray) return OutputArray;
    --     procedure BackwardPropLayer(net : in out NNet'Class; inputs : InputArray) return OutputArray;


    -- all NN calculations are typically done layer-by-layer
    -- these methods iterate over methods updating cached values to the next step
    procedure PropLayerForward (net : NNet_Interface'Class; idx : LayerIndex; propType : PropagationType := Matrix);
    procedure PropLayerBackward(net : NNet_Interface'Class; idx : LayerIndex; propType : PropagationType := Matrix);

    procedure PLFIndividual(net : NNet_Interface'Class; idx : LayerIndex);
    procedure PLFMatrix    (net : NNet_Interface'Class; idx : LayerIndex);
    procedure PLFGPU       (net : NNet_Interface'Class; idx : LayerIndex);


    type NeuronRepr(Nin : InputIndex; Nout : OutputIndex) is record
        idx   : NeuronIndex; -- own index in NNet
        afunc : ActivationType;
        wghts : WeightsArray(0 .. Nin);
        ins   : InConArray  (1 .. Nin);
        outs  : OutConArray (1 .. Nout);
    end record;

    type NeuronReprPtr is access NeuronRepr;

end wann.nets;
