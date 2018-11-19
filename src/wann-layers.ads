--
-- wann.nets package. Holds definition and layout of the "main type" - the net itself.
--
--  NOTE: delerict module file for now. Due to the whole hierarchy being generic
-- (to allow float precision selection) I cannot use limited with. So all the layer code
-- is kept in wann.nets for now..
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

limited with wann.nets;

generic
package wann.layers is



private

--     function  ForwardPropLayer (net : NNet'Class; inputs : InputArray) return OutputArray;
    --     procedure BackwardPropLayer(net : in out NNet'Class; inputs : InputArray) return OutputArray;


    -- all NN calculations are typically done layer-by-layer
    -- these methods iterate over methods updating cached values to the next step
    procedure PropLayerForward (net : NNet'Class; idx : LayerIndex; propType : PropagationType := Matrix);
    procedure PropLayerBackward(net : NNet'Class; idx : LayerIndex; propType : PropagationType := Matrix);

    procedure PLFIndividual(net : NNet'Class; idx : LayerIndex);
    procedure PLFMatrix    (net : NNet'Class; idx : LayerIndex);
    procedure PLFGPU       (net : NNet'Class; idx : LayerIndex);


end wann.layers;
