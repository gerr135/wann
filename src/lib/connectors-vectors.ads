--
-- connectors.vectors package. Implements basic common code for (Neuron/NNet) output vectors
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
    type Base is abstract tagged limited private;
package connectors.vectors is

    -------------------------------------------------
    -- Input type with functionality
    type Connector_Vector is abstract new Base and Connector_Interface with private;

    overriding
    function NOutputs(OI : Connector_Vector) return Index_Base;

    overriding
    function Output  (OI : Connector_Vector; idx : Index_Type) return Connection_Type;
    --
    -- setters
    overriding
    procedure Add_Output(OI : in out Connector_Vector; N : Index_Type := 1);

    overriding
    procedure Connect_Output(OI : in out Connector_Vector; idx : Index_Type; val : Connection_Type);

    overriding
    procedure Del_Output(OI : in out Connector_Vector; Output : Connection_Type);


private

    use type Connection_Type;
    package CV is new Ada.Containers.Vectors (Index_Type => Index_Type, Element_Type => Connection_Type);

    type Connector_Vector is abstract new Base and Connector_Interface with record
        outputs : CV.Vector;
    end record;

    pragma Inline(NOutputs, Output);

end connectors.vectors;
