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


generic
    type Real is digits <>;
--     with function Img(E : Key_Type) return String;
package wann is

    Debug : Boolean := False;
    --  set this to True to make this lib spit out debug messages (to console)


    -- General conventions
    -- Neural Net (NNet) consists of Nin inputs, Nout outputs and Npts neurons
    -- Connections are tracked by (ConnectionType, index) record, to discriminate between
    -- inputs, outputs and other neurons.

    ----------------------------------
    --  Common stuff - info passing
    type ActivationType is (Sigmoid, ReLu);
    type ActivationFunction is access function (x : Real) return Real;

    ------------------------------------------------
    -- index types (to catch misplaced index errors)
    -- this one tracks inputs inside neuron
    type    InputIndex_Base is new Natural;
    subtype InputIndex is InputIndex_Base range 1 .. InputIndex_Base'Last;

    type OutputIndex is new Positive;

    -- this one tracks neurons in the NNet
    type    NeuronIndex_Base is new Natural;
    subtype NeuronIndex is NeuronIndex_Base range 1 .. NeuronIndex_Base'Last;

    -------------------------------------------------
    --  connection specification
    type ConnectionType is (I, O, N);
    -- Input, Output, Neuron, but intended to be used in assignment, so shorting it down

    type ConnectionRec is record
        T : ConnectionType;
        idx : Positive; -- used for text input most often, so its essentially a number
        -- could be made one of index types, but then it would make sense to use variant record
        -- and then we cannot make a simple array, as that's an unconstrained type..
    end record;

    type InConArray  is array (InputIndex range <>)  of ConnectionRec;
    type OutConArray is array (OutputIndex range <>) of ConnectionRec;
    type NConArray   is array (NeuronIndex range <>) of ConnectionRec;
    -- 1st two are specirfic for inputs/outputs,
    -- the last one used throughout neurons

    --------------------------------------------------
    -- values to be passed around
    type InputArray   is array (InputIndex  range<>) of Real;
    type OutputArray  is array (OutputIndex range<>) of Real;
    type WeightsArray is array (InputIndex_Base range <>) of Real;


    -----------------------------------------------------
    -- Main record types representing Neuron parameters.
    -- To be used for storage, IO and as an alphabet to form a linear description,
    -- a-la DNA/protein sequence. Then the NNet can be simply defined as some linear sequence
    -- in declaration which can be passed to the NNet constructor.
    --
    -- This is a reference representation of data, using Ada primitives.

    type NeuronRec(Nin : InputIndex) is record
        idx     : NeuronIndex; -- own index in NNet
        activat : ActivationType;
        lag     : Real;    -- delay of result propagation, unused for now
        weights : WeightsArray(0 .. Nin);
        inputs  : InConArray  (1 .. Nin);
    end record;
    type NeuronRecPtr is access NeuronRec;


end wann;
