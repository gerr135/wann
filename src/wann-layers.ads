--
-- wann.layers package. Holds definition and layout of the layers of neurons.
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

generic
package wann.layers is

    package PN is new wann.neurons;

    -- Indices;
    -- Inputs/outputs, representative of "physical entiites"; use to catch "wrong index used" errors
    type    InputIndex_Base is new Natural;
    subtype InputIndex  is InputIndex_Base range 1 .. InputIndex_Base'Last;
    type    OutputIndex is new Positive;
    -- to track neurons associated with the layer
    type    NeuronIndex_Base is new Natural;
    subtype NeuronIndex is NeuronIndex_Base range 1 .. NeuronIndex_Base'Last;

    -- associated arrray types for holding params
    type Input_Connection_Array  is array (InputIndex range <>)  of NNet.ConnectionIndex;
    type Output_Connection_Array is array (OutputIndex range <>) of NNet.ConnectionIndex;
    type Neuron_Array is array (NeuronIndex range <>) of PN.NeuronClass_Access;


    -- representation record, to have common interface to pass data around
    type LayerRec(N : NeuronIndex) is record
        neurons : Neuron_Array(1 .. N);
        -- might get outputs or inputs here, so use generic neuronal array
        --weightMatrix : some matrix;
        -- these are stored in referenced neurons anyway
        -- however constructing a separate matrix may be useful if we need to pass it to, e.g. e GPU
        -- but will worry about this when (or if) I ever get there..
        --deltas? : likely need to store those too
    end record;
    type LayerRecPtr is access LayerRec;

    ----------------------------------------------
    -- Layer interface: to be used by NNet.
    -- As with NNet itself, multiple representations are possible
    -- so we make it an Interface with common functionality,
    -- leaving the representations details to children.
    -- (also to defer the representation choice, as I am not sure ATM what would work better)
    --
    -- Initial attempt to use a simple discriminated record would explode variants way too fast
    -- (multiple PropagationType's x multiple possible storage paradigms)
    -- So, use Interface with primitives here to keep it all sane.
    --
    -- At the bare level, Layer can be a simple list of neurons, with propagation done
    -- in a simple cycle (or parallel invocation) per-neuron.
    -- More advanced propagators may create (local?) vectors of values and weight matrices,
    -- to try to parallelize this via mpi or GPU use..
    -- I guess one sane design would us Layer.children packages for representation and pass
    -- propagators as separate objects. Propagators would be in their own package then..
    type Layer_Interface is interface;
    type LayerClass_Access is access Layer_Interface'Class;

    -- primitives
    function  ToRec  (LI : Layer_Interface) return LayerRec is abstract;
    procedure FromRec(LI : in out Layer_Interface; LR : LayerRec) is abstract;
    --     procedure Clear  (LI : in out Layer_Interface) is abstract;
    --
    function  Length(LI : Layer_Interface) return NeuronIndex_Base is abstract;
    procedure AddNeuron(LI : in out Layer_Interface; np : PN.NeuronClass_Access) is abstract;
    --     procedure DelNeuron(LI : Layer_Interface; idx : NeuronIndex) is abstract;
    function  GetNeuron(LI : Layer_Interface; idx : NeuronIndex) return PN.NeuronClass_Access is abstract;
    --     procedure SetNeuron(LI : Layer_Interface; idx : NeuronIndex; np : PN.Neuron_Access) is abstract;


    ----------------------------------
    --  class wide utility
    --
    --  stateless propagation, no side effects
    function  PropForward(L : Layer_Interface'Class; inputs : NNet.State_Vector) return NNet.State_Vector;
    function  PropForward(L : Layer_Interface'Class; inputs : NNet.Checked_State_Vector) return NNet.Checked_State_Vector;

    -- stateful propagation, only makes sense for some cases.
    --     procedure SetInputs(L : in out Layer_Interface'Class; inputs : ValueArray);
    procedure PropForward(L : Layer_Interface'Class);
    -- NOTE: layers only keep references to neurons, which in turn keep weights and do calcs
    -- no need for in out here. In fact we need in-only parameter here to allow pass-by-reference optimization

private

    type LL_Cursor is null record;

end wann.layers;
