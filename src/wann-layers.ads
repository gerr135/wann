--
-- wann.layers package. Holds definition and layout of the layers of neurons.
--
--  NOTE: delerict module file for now. Due to the whole hierarchy being generic
-- (to allow float precision selection) I cannot use limited with. So all the layer code
-- is kept in wann.nets for now..
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

-- Try to make this independent of wann.nets;
-- Will likely contain a list of pointers to neurons - to access the inherent data,
-- but will not operate on NNet structures.

with Ada.Iterator_Interfaces;

with wann.neurons;

generic
package wann.layers is

    package PN is new wann.neurons;

    -- Indices;
    -- to track neurons associated with the layer
    type NeuronIndex_Base is new Natural;
    subtype NeuronIndex is NeuronIndex_Base range 1 .. NeuronIndex_Base'Last;
    -- Inputs/outputs, representative of "physical entiites"; use to catch "wrong index used" errors
    type    InputIndex_Base is new Natural;
    subtype InputIndex is InputIndex_Base range 1 .. InputIndex_Base'Last;
    type OutputIndex is new Positive;

    -- associated arrray types for holding params
--     type ValueArray   is array (InputIndex range <>)  of DataPoint;
    type InConnArray  is array (InputIndex range <>)  of ConnectionIdx;
    type OutConnArray is array (OutputIndex range <>) of ConnectionIdx;
    type LayerNeuronsArray is array (NeuronIndex range <>) of PN.NeuronClass_Access;
    -- or need NeuronClass_Access?


    -- representation record, to have common interface to pass data around
    type LayerRec(N : NeuronIndex) is record
        neurons : LayerNeuronsArray(1 .. N);
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


    -------------------------------------------------
    -- list of layers, providing iterator interface
    type LayerList_Interface is interface with 
        Default_Iterator  => Iterate,
        Iterator_Element  => Layer_Interface'Class,
        Constant_Indexing => Element_Value;

    type LL_Cursor is private;
    function Has_Element (Pos : LL_Cursor) return Boolean;

    package LL_Iterators is new Ada.Iterator_Interfaces(LL_Cursor, Has_Element);

    function Iterate(Container : LayerList_Interface) return LL_Iterators.Forward_Iterator'Class;
    function Element_Value (Container : LayerList_Interface; Pos : LL_Cursor) return Layer_Interface'Class;
    -- Could also return a reference type as defined in the Part 1 Gem

    ----------------------------------
    --  class wide utility
    --
    --  stateless propagation, no side effects
    function  PropForward(L : in out Layer_Interface'Class; inputs : NNet_InputArray) return NNet_ValueArray;
    function  PropForward(L : in out Layer_Interface'Class; inputs : NNet_ValueArray) return NNet_ValueArray;

    -- stateful propagation, only makes sense for some cases.
--     procedure SetInputs(L : in out Layer_Interface'Class; inputs : ValueArray);
--     procedure PropForward(L : in out Layer_Interface'Class);

private

    type LL_Cursor is null record;

end wann.layers;
