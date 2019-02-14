--
-- wann.inputs.vectors package. Holds NNet inputs as Ada.Containers.Vectors
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
package wann.inputs.vectors is


    -------------------------------------------------
    -- Input type with functionality
    type Input_Type is new Input_Interface with private;

--     function  ToRec  (II : Input_Interface) return InputRec;
--     procedure FromRec(II : in out Input_Interface; IR : InputRec);

    overriding
    function Output(II : Input_Type; idx : OutputIndex) return NN.ConnectionIndex;

    overriding
    procedure Add_Output(NI : in out Input_Type; Output : NN.ConnectionIndex);

    overriding
    procedure Del_Output(NI : in out Input_Type; Output : NN.ConnectionIndex);


private

    use type NN.ConnectionIndex;
    package IO is new Ada.Containers.Vectors (Index_Type => OutputIndex, Element_Type => NN.ConnectionIndex);

    type Input_Type is new Input_Interface with record
        outputs : IO.Vector;
    end record;


end wann.inputs.vectors;
