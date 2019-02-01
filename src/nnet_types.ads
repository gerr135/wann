--
-- Common NNet-wide types.
--
-- Many of the NNet entities (e.g. neurons, layers, nnet itself) have the same "principal parts",
-- such as inputs, outputs, etc.. These need to be indexed and, to simplify the naming pattern,
-- the indices and many other types are named the same (but in different modules).
-- The same stands for the NNet itself - it also has inputs, outputs, etc.
-- To prevent name clashes while keeping consistent naming scheme, we define such common types
-- here. This allows us to keep the same naming pattern but distinguish entities by prefixing
-- them with appropriate module name.
-- Otherwise, the contents of this module could have been declared at the top level (wann.ads).
--
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
package nnet_types is

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
    -- NOTE on type naming:
    -- unlike most other types/identifiers, the Index types are written run-in,
    -- i.e. without the '_' between type qualifier and Index.
    -- This is to easily distinguish the _Base variant (and other preffixes/suffixes, should such appear).
    --
    -- NOTE: All entities are numbered from 1 upwards. For each index type we define _base,
    -- counting from 0, and subtype xxIndex itself, counting from 1.

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
    -- The neuron inter-connection type
    type Connection_Type is (I, O, N);
    -- Input, Output, Neuron, but intended to be used in assignment, so shortening down
    --
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

    function State_Value(SV : State_Vector; idx : ConnectionIndex) return Real with Inline;


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

    function Is_Valid(SV : Checked_State_Vector; idx : ConnectionIndex)
        return Boolean with Inline;

    function Inputs_are_valid (SV : Checked_State_Vector) return Boolean;
    function Outputs_are_valid(SV : Checked_State_Vector) return Boolean;

end nnet_types;
