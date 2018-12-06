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

    ----------------------------
    -- exceptions
    DataWidthMismatch : Exception;
    --  trying to pass data vector to mismatching size inputs/outputs

    UnsortedNetPropagation : Exception;
    --  trying to propagate through NNet before creating layers

    UnsetValueAccess : Exception;
    --  trying to access a not-yet-set (or already cleared) cached value


    --------------------------------------------------------------------------
    -- General conventions
    -- Neural Net (NNet) consists of Ni inputs, No outputs and Nn neurons
    -- Connections are tracked by (ConnectionType, index) record, to discriminate between
    -- inputs, outputs and other neurons.

    type ActivationType is (Sigmoid, ReLu);
    type ActivationFunction is access function (x : Real) return Real;
    -- the ready to use functions (activators and derivatives) are defined in wann.functions package

    -- how we move through layers
    type PropagationType is
             (Simple, -- cycle through neurons in layer; for basic use and in case of very sparse connections
              Matrix, -- compose a common matrix and do vector algebra; the common case
              GPU);   -- try to do linear algebra in GPU
        -- this will be (most likely) handled through layer types via OOP hierarchy.

    ----------------------------
    -- Global indices
    --
    -- NOTE:
    -- each NNet subunit can have inputs and outputs, so each child package (.neurons, .layers, etc)
    -- defines its own Input/OuptutIndex type. The goal is to use them to represent
    -- inputs and outputs as physical entities where appropriate,
    -- and to catch "wrong index used" errors.
    -- Besides, having a single Input/Output index created bunch of confusion in design.
    --
    -- However, there are some common indices to which all subunits need access.
    -- Specifically, the NNet-wide indexing - global inputs, outputs and NNet neuron index.
    --
    type    NNet_NeuronIndex_Base is new Natural;
    subtype NNet_NeuronIndex is NNet_NeuronIndex_Base range 1 .. NNet_NeuronIndex_Base'Last;
    --
    type    NNet_InputIndex_Base is new Natural;
    subtype NNet_InputIndex is NNet_InputIndex_Base range 1 .. NNet_InputIndex_Base'Last;
    --
    type    NNet_OutputIndex is new Positive;

    --
    -- Tracking rearranged neuron layers
    type LayerIndex is new Positive;
    -- There is always at least one layer;
    -- However, unlike common neural net libs, there may not be a strict output layer.
    -- As neural connections can be a real mess containing cycles, a layer can contain
    -- a mixture of interconnections and "final" output connections.
    -- In general these will have to be treated on individual basis,
    -- so, checks should be made based on the ConnectionType of each output.
    --
    --  connection specification
    type ConnectionType is (I, O, N);
    -- Input, Output, Neuron, but intended to be used in assignment, so shortening down

--     type ConnectionIdx is record
--         T : ConnectionType;
--         idx : Positive; -- used for text input most often, so its essentially a number
--     end record;

    type ConnectionIdx(T : ConnectionType := N) is record
        case T is
            when I => Iidx : NNet_InputIndex;
            when N => Nidx : NNet_NeuronIndex;
            when O => Oidx : NNet_OutputIndex;
        end case;
    end record;

    type NNet_InConnArray  is array (NNet_InputIndex  range <>) of ConnectionIdx;
    type NNet_NConnArray   is array (NNet_NeuronIndex range <>) of ConnectionIdx;
    type NNet_OutConnArray is array (NNet_OutputIndex range <>) of ConnectionIdx;
    --
    -- Input, output and neuron state arrays
    --  values
    type NNet_InputArray  is array (NNet_InputIndex  range <>) of Real;
    type NNet_OutputArray is array (NNet_OutputIndex range <>) of Real;
    type NNet_ValueArray  is array (NNet_NeuronIndex range <>) of Real;
    --  validity
    type NNet_InputValidityArray  is array (NNet_InputIndex  range <>) of Boolean;
    type NNet_OutputValidityArray is array (NNet_OutputIndex range <>) of Boolean;
    type NNet_ValueValidityArray  is array (NNet_NeuronIndex range <>) of Boolean;


    -- State of the entire NNet
    --
    -- in order to provide possibility of data validity checks (e.g. whether data has
    -- propagated far enough) we encapsulate the state in a tagged record.
    --
    -- NOTE: most propagation routines should work correctly even without checks
    -- as proper layering should ensure that all the proper values are already availabble, when needed.
    -- However there is still a risk of silently using unassigned value, especially
    -- while the lib is in development, or when proper call order is not enforced.
    -- Therefore the safest way to go is to implement all agorithms with in-built checks,
    -- but also provide (after checked code is properly tested) the _unchecked
    -- version for the more critical/commonly used routines.
    --
    -- NOTE 2: as we allow completely arbitrary connections, we cannot check once per layer/block
    -- (which could be really cheap). So we need to provide a possibility to check
    -- every point..
    --
    --  Unchecked state vector
    type NNet_StateVector(Ni : NNet_InputIndex;
                          Nn : NNet_NeuronIndex; No : NNet_OutputIndex) is record
        input  : NNet_InputArray (1 .. Ni);
        neuron : NNet_ValueArray (1 .. Nn);
        output : NNet_OutputArray(1 .. No);
    end record;
    --
    --  Checked state vector
    type NNet_CheckedStateVector(Ni : NNet_InputIndex;
                          Nn : NNet_NeuronIndex; No : NNet_OutputIndex) is record
        input  : NNet_InputArray (1 .. Ni);
        neuron : NNet_ValueArray (1 .. Nn);
        output : NNet_OutputArray(1 .. No);
    --
        validI : NNet_InputValidityArray (1 .. Ni);
        validN : NNet_ValueValidityArray (1 .. Nn);
        validO : NNet_OutputValidityArray(1 .. No);
        -- using separate arrays here (rather than array of record with 2 entris)
        -- allows us to assign entire array, rather than copy item by item
        -- NOTE: passing a reference might be even more optimal for big nets,
        -- but better profile first before going with a more involved design
    end record;

    --     type DataPoint is record
--         Ok  : Boolean := False;
--         val : Real;
--     end record;
--
--     -- Input, output and neuron state arrays
--     type NNet_InputDPArray  is array (NNet_InputIndex  range <>) of DataPoint;
--     type NNet_OutputDPArray is array (NNet_OutputIndex range <>) of DataPoint;
--     type NNet_ValueDPArray  is array (NNet_NeuronIndex range <>) of DataPoint;

end wann;
