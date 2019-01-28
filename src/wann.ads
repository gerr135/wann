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
-- Neural Net (NNet) consists of Ni inputs, No outputs and Nn neurons
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
--------------------------------------------------------------------------

with nnet_types;

generic
    type Real is digits <>;
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


    package NNet is new nnet_types(Real);


end wann;
