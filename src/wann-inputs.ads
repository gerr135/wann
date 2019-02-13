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


generic
package wann.inputs is

    -------------------------------------
    --  Local indices
    --  Only output index, as these *are* the inputs, they take only single entry but distribute to many
    type    OutputIndex_Base is new Natural;
    subtype OutputIndex is OutputIndex_Base range 1 .. OutputIndex_Base'Last;

    -- associated arrray types for holding params
    type Output_Connection_Array is array (OutputIndex range <>) of NN.ConnectionIndex;
    type Value_Array   is array (InputIndex range <>) of Real;


    -------------------------------------------------
    -- Input representation
    type InputRec(No : OutputIndex) is record
        idx     : NN.InputIndex_Base; -- own index in NNet
        outputs : Output_Connection_Array (1 .. No);
    end record;

--     type InputRec_array is array (OutputIndex range <>) of InputRec;

    -------------------------------------------------
    -- Input type with functionality
    type Input_Interface is interface and Outputting_Interface;
    type InputClass_Access is access all Neuron_Interface'Class;

--     function  ToRec  (II : Input_Interface) return InputRec is abstract;
--     procedure FromRec(II : in out Input_Interface; IR : InputRec) is abstract;
    --
    function Output(II : Input_Interface; idx : OutputIndex) return NN.ConnectionIndex is abstract;

end wann.inputs;
