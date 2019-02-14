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
package connectors.vectors is

    -------------------------------------------------
    -- Input type with functionality
    type Outputting_Type is new Outputting_Interface with private;

    overriding
    function NOutputs(OI : Outputting_Type) return Index_Type;

    overriding
    function Output  (OI : Outputting_Type; idx : Index_Type) return Connection_Type;
    --
    -- setters
    overriding
    procedure Add_Output(OI : in out Outputting_Type; Output : Connection_Type);

    overriding
    procedure Del_Output(OI : in out Outputting_Type; Output : Connection_Type);

private

    use type Connection_Type;
    package CV is new Ada.Containers.Vectors (Index_Type => Index_Type, Element_Type => Connection_Type);

    type Outputting_Type is new Outputting_Interface with record
        outputs : CV.Vector;
    end record;

end connectors.vectors;
