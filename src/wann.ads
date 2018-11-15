--
-- "Neural Networks the Ada Way" - top level library module, defining constants,
--  record types and JSON/binary data formats to be passed around.
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


with Ada.Containers.Vectors;

generic
    type Real is digits <>;
--     with function Img(E : Key_Type) return String;
package wann is

    Debug : Boolean := False;
    --  set this to True to make this lib spit out debug messages (to console)

    -- General conventions
    -- Neural Net (NNet) consists of Nin inputs, Nout outputs and Npts neurons
    -- Neuron connections are tracked by connections index in range 1 .. Nin + Nout + Npts
    --  First Nin numbers denote inputs  (1 .. Nin),
    --  next Nout numbers denote outputs (Nin+1 .. Nin+Nout)
    --  the rest of numbers index actual neurons (Nin+Nout+1 .. Nin+Nout+Npts)

    type ActivationType is (Sigmoid, ReLu);
    type ActivationFunction is access function (x : Real) return Real;

    ------------------------------------------------
    -- index types (to catch misplaced index errors)
    -- this one tracks inputs inside neuron
    type NIndex_Base is new Natural;
    subtype NIndex is NIndex_Base range 1 .. NIndex_Base'Last;

    -- this one tracks neurons in the NNet
    type NNIndex_Base is new Natural;
    subtype NNIndex is NNIndex_Base range 1 .. NNIndex_Base'Last;

    type InputIndex  is new Positive;
    type OutputIndex is new Positive;
    -- check if it makes more sense to use NIndex instead of these two


    ---------------------------------------------------
    --  connection specification
    type ConnectionType is (I, O, N);
    -- Input, Output, Neuron, but intended to be used in assignment, so shorting it down
    type ConnectionRec is record
        T : ConnectionType;
        idx : Positive; -- used for text input most often, so its essentially a number
        -- could be made one of index types, but then it would make sense to use variant record
        -- and then we cannot make a simple array, as that's an unconstrained type..
    end record;


    --- index arrays. Primarily used by immutable records, but may be useful throughout.
    type ConnectArray is array (NIndex range <>) of ConnectionRec;
    type WeightsArray is array (NIndex_Base range <>) of Real;


    -----------------------------------------------------
    -- Main record types representing Neuron and NNet parameters.
    -- These types can be used as an alphabet to form a linear description,
    -- a-la DNA/protein sequence. Then the NNet can be simply defined as some linear sequence
    -- in declaration which can be passed to the NNet constructor.

    -----------------
    -- A base, immutable version, using only core Ada types (arrays, etc).
    -- This is a reference representation of data, used as a basis for binary/JSON strings.

    type NeuronRec(Nin : NIndex) is record
        idx     : NNIndex; -- own index in NNet
        activat : ActivationType;
        lag     : Real;    -- delay of result propagation
        weights : WeightsArray(0 .. Nin);
        inputs  : ConnectArray (1 .. Nin);
    end record;
    --
--     type NeuronRecPtr   is access NeuronRec;
--     type NeuronRecArray is array (NNIndex range <>) of NeuronRecPtr;
--
--
--     type NNetRec(Nin : InputIndex; Nout : OutputIndex; Npts : NNIndex) is record
--         neurons : NeuronRecArray(1 .. Npts);
--         -- incomplete. Needs some more play with to decide which params to keep in what form
--     end record;



    --------------------------------------
    -- Lets define the common NNet interface here.
    -- Specific implementations (fixed arrays or mutale collection-based; in-memory, on-disk, etc)
    -- will be done in child packages

    type NNet_Interface is limited interface;
    -- don't see the reason to pass it around, but may lift "limited" later..
    procedure AddNeuron(net : in out NNet_Interface; neur : NeuronRec) is abstract;
    procedure DelNeuron(net : in out NNet_Interface; idx : NNIndex) is abstract;
    procedure ReplaceNeuron(net : in out NNet_Interface; idx: NNIndex; neur : NeuronRec) is abstract;
    function  GetNeuron(net : NNet_Interface; idx : NNIndex) return NeuronRec is abstract;

    -- perform topological sort - can make 'Class and implement once only?
    procedure SortForward (net : NNet_Interface) is null;
    procedure SortBackward(net : NNet_Interface) is null;

private


    -- actual data that may be used in neuron arrays
    -- we also need to track where outputs are connected (e.g for backprop)
    -- but this info is unneeded to create initial topology
--     type NeuronT is record
--         neur : NeuronRec;
--         outs : ConnectArray;
--     end record;
    
    -----------------
    -- A mutable using Containers.Vectors
    -- Both NeuronRec and NNetRec can change not only the specific connections,
    -- but also number of neurons and connections

    package WV is new Ada.Containers.Vectors(Index_Type=>NIndex, Element_Type=>Real);
    package NV is new Ada.Containers.Vectors(Index_Type=>NIndex, Element_Type=>NNIndex);

    type NeuronRec_Mutable is record
        idx     : NNIndex; -- own index in the enclosing NNet
        activat : ActivationType;
        lag     : Real;    -- delay of result propagation
        weights : WV.Vector;
        inputs  : NV.Vector;
    end record;

end wann;
