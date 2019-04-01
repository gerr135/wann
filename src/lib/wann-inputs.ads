--
-- wann.inputs package. Holds NNet input mapping types
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
-- Unlike NNet outputs, which take input from only 1 neuron,
-- the inputsa are 1-to-many mappings. Each NNet input branches to multiple entities:
-- either neurons or outputs.
-- This is more complex than a simple Output_Connection_Array, but is way simple than Neuron
-- (which is a many-to-many mapping with active core).

with connectors.vectors;

generic
package wann.inputs is

    -------------------------------------
    --  Local indices
    --  Only output index, as these *are* the inputs, they take only single entry but distribute to many
    type    OutputIndex_Base is new Natural;
    subtype OutputIndex is OutputIndex_Base range 1 .. OutputIndex_Base'Last;

    -- associated arrray types for holding params
    type Output_Connection_Array is array (OutputIndex range <>) of NN.ConnectionIndex;


    -------------------------------------------------
    -- Input representation
    type InputRec(No : OutputIndex) is record
        idx     : NN.InputIndex_Base; -- own index in NNet
        outputs : Output_Connection_Array (1 .. No);
    end record;

--     type InputRec_array is array (OutputIndex range <>) of InputRec;


    -------------------------------------------------
    -- Input type with functionality
    --
    -- this is basically the Outputting_Interface with a specific Index type
    package PCI  is new Connectors(Index_Base      => OutputIndex_Base,
                                   Connection_Type => NN.ConnectionIndex,
                                   No_Connection   => NN.No_Connection );

    type Input_Interface is interface and PCI.Outputting_Interface;

    type MyBase is abstract tagged null record;
    package PCIV is new PCI.vectors(Base=>MyBase);
    type Input_Vector is new PCIV.Output_Vector and Input_Interface with private;
    -- NOTE: "and Input_Interface" is implicit via Connectors structure.
    -- Making this explicit here to make this relation visible and to ensure that
    -- it does not get lost in some refactoring..

private

    type Input_Vector is new PCIV.Output_Vector and Input_Interface with record
        idx     : NN.InputIndex_Base;
    end record;

end wann.inputs;
