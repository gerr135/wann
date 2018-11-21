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

    UnsetCacheAccess : Exception;
    --  trying to access a not-yet-set (or already cleared) cached value


    --------------------------------------------------------------------------
    -- General conventions
    -- Neural Net (NNet) consists of Nin inputs, Nout outputs and Npts neurons
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
    -- This one tracks neurons in the NNet - a global reference index
    type    NeuronIndex_Base is new Natural;
    subtype NeuronIndex is NeuronIndex_Base range 1 .. NeuronIndex_Base'Last;
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

    type ConnectionIdx is record
        T : ConnectionType;
        idx : Positive; -- used for text input most often, so its essentially a number
    end record;

--     type ConnectionIndex_Base is new Natural;
--     subtype ConnectionIndex is ConnectionIndex_Base range 1 .. ConnectionIndex_Base'Last;
--     --
--     type ConnectionArray   is array (ConnectionIndex range <>) of ConnectionIdx;
--     -- 1st two are specirfic for inputs/outputs,
--     -- the last one used throughout neurons

    --------------------------------------------------
    -- Values to be passed around
    -- Used as data vectors passed between layers, etc
    -- corresponding arrays or Ada.Containers.Vectors instances should be indexed by 
    -- an appropriate  XXXIndex in a corresponding package..
    type DataPoint is record
        assigned : Boolean;
        val      : Real;
    end record;


end wann;
