--
-- Top NNet packege, holding abstract type/interface with utility, but no storage..
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


generic
package wann.nets is

    ----------------------------------------------
    -- Layer representation in the NNet
    -- I would much rather hide these details in private part and child packages,
    -- but unfortuantely Ada does not allow it: "abstract subprograms must be visible (RM 3.9.3(10))"
    
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

    ----------------------------------------------------------------
    -- the main type of this package, the NNet itself
    -- Making it an interface to allow composition (say with Controlled)
    
    type NNet is limited Interface;

    -- Dimension getters; the setters are imnplementation-specific,
    -- and should either be handled during construction or be dynamic
    function GetNInputs (net : NNet) return InputIndex  is abstract;
    function GetNOutputs(net : NNet) return OutputIndex is abstract;
    function GetNNeurons(net : NNet) return NeuronIndex is abstract;

    --  Neuron handling
    procedure NewNeuron(net : in out NNet; idx : out NeuronIndex_Base) is abstract;
    -- create new empty neuron emplacement and return its index
    -- needs overriding in dynamic/mutable net.
    -- Makes no sense for fixed nnet; that one should just return 0 (and do nothing otherwise).

    procedure DelNeuron(net : in out NNet; idx : NeuronIndex) is null;
    -- remove neuron from NNet, as with New, only for mutable representation

    -- getter and setter
    function  GetNeuron(net : NNet; idx : NeuronIndex) return NeuronRec is abstract;
    procedure SetNeuron(net : in out NNet; NR : NeuronRec) is abstract;

    -- layer handling
    function  GetLayer(net : in NNet;     idx : LayerIndex) return LayerRec  is abstract;
    procedure SetLayer(net : in out NNet; idx : LayerIndex; LR :   LayerRec) is abstract;



    -----------------------------------
    -- class-wide stuff: main utility

    --
    -- Neuron manipulation
    --
    function  AddNeuron(net : in out NNet'Class; NR : NeuronRec) return NeuronIndex;
    procedure AddNeuron(net : in out NNet'Class; NR : NeuronRec; idx : out NeuronIndex);
    procedure AddNeuron(net : in out NNet'Class; NR : NeuronRec);
    -- combines New and Set
    --
    function  AddNeuron(net : in out NNet'Class; activat : ActivationType; connects : InConArray) return NeuronIndex;
    procedure AddNeuron(net : in out NNet'Class; activat : ActivationType; connects : InConArray; idx : out NeuronIndex);
    procedure AddNeuron(net : in out NNet'Class; activat : ActivationType; connects : InConArray);
    -- New plus Set by parameters
    --
    procedure ResetNeuron(net : in out NNet'Class; NR : NeuronRec);
    procedure ResetNeuron(net : in out NNet'Class; idx  : NeuronIndex; activat : ActivationType; connects : InConArray);
    procedure ResetNeuron(net : in out NNet'Class; idx  : NeuronIndex; connects : InConArray);
    -- replaces neuron[idx] parameters, either all or partial

    --
    --  Nnet manipulation
    --
    procedure ReconnectNeuronAtRandom(net : in out NNet'Class; idx  : NeuronIndex; maxConnects : InputIndex_Base := 0);
    procedure PopulateAtRandom (net : in out NNet'Class; maxConnects : InputIndex; Npts : NeuronIndex_Base := 0);
    -- populates net with new neurons or resets existing one to random configuration
    -- Npts needs to be passed in case of empty mutable net, otherwise it simply rearranges existing net.

    procedure SortForward (net : in out NNet'Class);
    procedure SortBackward(net : in out NNet'Class);
    -- perform a topological sort, (re-)creating layers tracking the connections,
    -- to allow optimizations (parallel computation, use of GPU).
    -- 
    -- Forward and backward may be different if cycles are present 
    -- (which is a major modus operandi of this lib).
    
    --
    --  Propagation
    --
    function  ProcessInputs(net : NNet'Class; inputs : InputArray) return OutputArray;
    -- forward propagation through trained net
    
--     procedure Train(net : in out NNet'Class; training_set : TBD);


private

--     function  ForwardPropLayer (net : NNet'Class; inputs : InputArray) return OutputArray;
--     procedure BackwardPropLayer(net : in out NNet'Class; inputs : InputArray) return OutputArray;
    
    type NeuronRepr(Nin : InputIndex; Nout : OutputIndex) is record
        idx   : NeuronIndex; -- own index in NNet
        afunc : ActivationType;
        wghts : WeightsArray(0 .. Nin);
        ins   : InConArray  (1 .. Nin);
        outs  : OutConArray (1 .. Nout);
    end record;

    type NeuronReprPtr is access NeuronRepr;
    
--     type NNet is abstract tagged limited null record; -- might actually use an Interface here..
        -- Othat than that, NNet will consist of layers which are used for actual computation
        -- layers are created by SortForward and SortBackward - topological sort of connections
        -- and updated when neurons are added/deleted/reconnected..
        -- not sure how to make NNet_Fixed completely, well, fixed, or if it makes sense at all,
        -- maybe weill go on with mutable only

    

end wann.nets;
