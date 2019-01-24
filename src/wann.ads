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
    --
    Data_Width_Mismatch : Exception;
    --  trying to pass data of mismatching size between inputs/outputs/next layer

    Unsorted_Net_Propagation : Exception;
    --  trying to propagate through NNet before creating layers

    Unset_Value_Access : Exception;
    --  trying to access a not-yet-set (or already cleared) cached value


    --------------------------------------------------------------------------
    -- General conventions
    -- Neural Net (NNet) consists of Ni inputs, No outputs and Nn neurons
    -- Connections are tracked by (ConnectionType, index) record, to discriminate between
    -- inputs, outputs and other neurons.
    --
    -- Neurons are organized into layers. Can be added arbitrarely and sorted later.
    -- Sort is "automatic" by invoking a corresponding method that performs topological sort.
    -- All entities are defined in corresponding child modules and are indexed by corresponding indices.
    -- Thus in each module we are going to have InputIndex, OutputIndex and SomeentryIndex.
    -- Use the module.Index notation to discriminate, this gives automatic dereference and readability.
    -- Here, at top level we define "global" - visible by all indices,
    -- denoting global (nnet) inputs, outputs, neurons, layers, etc..
    --
    -- NOTE:  -- may cause problems by hiding "global" indices!!!
    -- each NNet subunit can have inputs and outputs, so each child package (.neurons, .layers, etc)
    -- defines its own Input/OuptutIndex type. The goal is to use them to represent
    -- inputs and outputs as physical entities where appropriate,
    -- and to catch "wrong index used" errors.
    -- Besides, having a single Input/Output index created bunch of confusion in design.
    --
    -- However, there are some common indices to which all subunits need access.
    -- Specifically, the NNet-wide indexing - global inputs, outputs and NNet neuron index.
    --
    -- For each index type we define _base, usually counting from 0, and subtype xxIndex itself,
    -- counting from 1.
    --
    -- NOTE on type naming:
    -- unlike most other types/identifiers, the Index types are written run-in, 
    -- i.e. without the '_' between type qualifier and Index.
    -- This is to easily distinguish the _Base variant.

    type    InputIndex_Base  is new Natural;
    subtype InputIndex  is InputIndex_Base  range 1 .. InputIndex_Base'Last;
    --
    type    OutputIndex_Base is new Natural;
    subtype OutputIndex is OutputIndex_Base range 1 .. OutputIndex_Base'Last;
    --
    type    NeuronIndex_Base is new Natural;
    subtype NeuronIndex is NeuronIndex_Base range 1 .. NeuronIndex_Base'Last;
    --
    type    LayerIndex_Base  is new Natural;
    subtype LayerIndex  is LayerIndex_Base  range 1 .. LayerIndex_Base'Last;
    -- There is always at least one layer;
    -- However, unlike common neural net libs, there may not be a strict input/output layer
    -- or even well defined layer structure.
    -- As neural connections can be a real mess containing cycles, a layer can contain
    -- a mixture of interconnections and "final" output connections.
    -- In general these will have to be treated on individual basis,
    -- so, checks should be made based on the ConnectionType of each output.

    --------------------------------------------------
    -- Topology
    -- Types for keeping/passing around connection info
    --
    -- First the connection type itself
    type Connection_Type is (I, O, N);
    -- Input, Output, Neuron, but intended to be used in assignment, so shortening down

    type ConnectionIndex(T : Connection_Type := N) is record
        case T is
            when I => Iidx : InputIndex;
            when N => Nidx : NeuronIndex;
            when O => Oidx : OutputIndex;
        end case;
    end record;

    -- now, arrays of connections
    type Input_Connection_Array  is array (InputIndex  range <>) of ConnectionIndex;
    type Neuron_Connection_Array is array (NeuronIndex range <>) of ConnectionIndex;
    type Output_Connection_Array is array (OutputIndex range <>) of ConnectionIndex;


    --------------------------------------------------
    -- NNet values.
    type Input_Array  is array (InputIndex  range <>) of Real;
    type Output_Array is array (OutputIndex range <>) of Real;
    type Value_Array  is array (NeuronIndex range <>) of Real;
    --  validity
    type Input_Validity_Array  is array (InputIndex  range <>) of Boolean;
    type Output_Validity_Array is array (OutputIndex range <>) of Boolean;
    type Value_Validity_Array  is array (NeuronIndex range <>) of Boolean;

    -- We need a common type to store/pass around the data.
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
    type State_Vector(Ni : InputIndex;
                          Nn : NeuronIndex; No : OutputIndex) is record
        input  : Input_Array (1 .. Ni);
        neuron : Value_Array (1 .. Nn);
        output : Output_Array(1 .. No);
    end record;
    --
    --  Checked state vector
    type Checked_State_Vector(Ni : InputIndex;
                                 Nn : NeuronIndex; No : OutputIndex) is record
        input  : Input_Array (1 .. Ni);
        neuron : Value_Array (1 .. Nn);
        output : Output_Array(1 .. No);
        --
        validI : Input_Validity_Array (1 .. Ni);
        validN : Value_Validity_Array (1 .. Nn);
        validO : Output_Validity_Array(1 .. No);
        -- using separate arrays here (rather than array of record with 2 entris)
        -- allows us to assign entire array, rather than copy item by item
        -- NOTE: passing a reference might be even more optimal for big nets,
        -- but better profile first before going with a more involved design
    end record;



    ---------------------------------------------------------
    -- Some other (non-topological) parameters.
    -- These will likely be split off to separate child module at some later point, as they grow.
    type Activation_Type is (Sigmoid, ReLu);
    type Activation_Function is access function (x : Real) return Real;
    -- the ready to use functions (activators and derivatives) are defined in wann.functions package

    -- how we move through layers
    type Propagation_Type is
             (Simple, -- cycle through neurons in layer; for basic use and in case of very sparse connections
              Matrix, -- compose a common matrix and do vector algebra; the common case
              GPU);   -- try to do linear algebra in GPU
        -- this will be (most likely) handled through layer types via OOP hierarchy.



end wann;
