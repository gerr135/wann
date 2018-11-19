--
-- wann.nets package. Holds definition and layout of the "main type" - the net itself.
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
package wann.layers is

    ----------------------------------------------
    -- Layer representation in the NNet
    
    type LayerIndex is new Positive;
    -- Index to count rearranged neuron layers 1 .. 'Last
    -- 'Last is output layer, that can be treated specially on this simple check, 
    -- so no extra marking should be necessary.

    -- representation record, to have common interface to pass data around
    type LayerRec(N : NeuronIndex) is record
        neurons : NConArray(1 .. N); 
            -- might get outputs or inputs here, so use generic neuronal array
        --weightMatrix : some matrix;   
            -- these are stored in referenced neurons anyway
            -- however constructing a separate matrix may be useful if we need to pass it to, e.g. e GPU
            -- but will worry about this when (or if) I ever get there..
        --deltas? : likely need to store those too
    end record;

    type LayerRecPtr is access LayerRec;


    ----------------------------------------------
    -- the type to be used by NNet.
    -- As with NNet itself, multiple representations are possible
    -- so we make it an Interface with common functionality,
    -- leaving the representations details to children.

    type LayerInterface is limited interface;


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
