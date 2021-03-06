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

-----------------------------------------------------------------------
-- General conventions
-- Neural Net (NNet) consists of Ni inputs, No outputs and Nn neurons organized in Nl layers
-- Connections are tracked by (ConnectionType, index) record, to discriminate between
-- inputs, outputs and other neurons.
--
-- Neurons are organized into layers. Can be added arbitrarely and sorted later.
-- Sort is "automatic" by invoking a corresponding method that performs topological sort.
-- All entities are defined in corresponding child modules and are indexed by corresponding indices.
-- Thus in each module we are going to have InputIndex, OutputIndex and SomeentryIndex.
-- Use the module.type notation to discriminate, this gives automatic dereference and readability.
--
-- NOTE: NNet-wide primitive types are defined in nnet_types which, logically, could be
-- a part of wann.nets. This separation is done to break cyclic dependncies and to avoid
-- name clashing while keeping common type naming scheme.
--
-- NOTE: All entities are numbered from 1 upwards. For each index type we define _base,
-- counting from 0, and subtype xxIndex itself, counting from 1.
--
-- NOTE: on package naming
-- Two-lerrer codes are used for instantiated packages throughout:
--   NN: nnet_types - common NNet types
--   PN: wann.neurons
--   PL: wann.layers
-- NOTE: all instantiations should happen only once!
-- thus, e.g. NN is instantiated right here, at top level, and used throughout
-- PN is instantiated in PL and then PL.PN is renamed to PN where necessary.
--------------------------------------------------------------------------

with GNATCOLL.Traces;

with nnet_types;

generic
    type Real is digits <>;
package wann is

    -- Logging
    -- We use gnatcoll.traces for logging in this project, as it is sufficiently simple 
    -- to handle but is easily tunable
    package GT renames GNATCOLL.Traces;
    Debug : constant GT.Trace_Handle := GT.Create ("DBG");

    
    ----------------------------
    -- exceptions
    --
    Data_Width_Mismatch : Exception;
    --  trying to pass data of mismatching size between inputs/outputs/next layer

    Unsorted_Net_Propagation : Exception;
    --  trying to propagate through NNet before creating layers

    Unset_Value_Access : Exception;
    --  trying to access a not-yet-set (or already cleared) cached value

    Invalid_Connection : Exception;
    --  trying to make connection that obviously makes no sense
    --  (connect neuron input to net output, etc..)

    package NN is new nnet_types(Real);

    ------------------------------------------------------------
    -- Some common types; basic and not requiring special naming
    --
    type Activation_Type is (Sigmoid, ReLu);
    type Activation_Function is access function (x : Real) return Real;
    -- the ready to use functions (activators and derivatives) are defined in wann.functions package

    -- how we move through layers
    type Propagation_Type is
             (Simple, -- cycle through neurons in layer; for basic use and in case of very sparse connections
              Matrix, -- compose a common matrix and do vector algebra; the common case
              GPU);   -- try to do linear algebra in GPU
    -- this will be (most likely) handled through layer types via OOP hierarchy.

    type Sort_Direction is (Forward, Backward);


    function  Get_Value(SV : NN.State_Vector; idx : NN.ConnectionIndex)
        return Real with Inline;
    --
    procedure Set_Value(SV : in out NN.State_Vector; idx : NN.ConnectionIndex;
                        value : Real) with Inline;
    --
    function Is_Valid(SV : NN.Checked_State_Vector; idx : NN.ConnectionIndex)
        return Boolean with Inline;
    --
    function  Get_Value(SV : NN.Checked_State_Vector; idx : NN.ConnectionIndex)
        return Real with Inline;
    --
    procedure Set_Value(SV : in out NN.Checked_State_Vector; idx : NN.ConnectionIndex;
                        value : Real) with Inline;

end wann;
