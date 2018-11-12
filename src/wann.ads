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


with Ada.Containers.Vectors;

generic
    type Real is digits <>;
--     with function Img(E : Key_Type) return String;
package wann is

    Debug : Boolean := False;
    --  set this to True to make this lib spit out debug messages (to console)
        
    type ActivationType is (Sigmoid, ReLu);
    type ActivationFunction is access function (x : Real) return Real;

    -- index types (to catch misplaced i errors)
    -- this one tracks inputs inside neuron
    type NIndex_Base is new Natural;
    subtype NIndex is NIndex_Base range 1 .. NIndex_Base'Last;

    -- this one tracks neurons in the NNet
    type NNIndex_Base is new Natural;
    subtype NNIndex is NNIndex_Base range 1 .. NNIndex_Base'Last;

    --- index arrays. Primarily used by immutable records, but may be useful throughout.
    type NeuronIdxArray is array (NIndex range <>) of NNIndex;
    type WeightsArray is array (NIndex_Base range <>) of Real;


    -----------------------------------------------------
    -- Main record types representing Neuron and NNet parameters.
    -- These types can be used as an alphabet to form a linear description, 
    -- a-la DNA/protein sequence. Then the NNet can be simply defined as some linear sequence
    -- in declaration which can be passed to the NNet constructor.

    -----------------
    -- First, a base, immutable NNet/Neuron version, using only core Ada types (arrays, etc).

    type NeuronRec_Fixed(Nin : NIndex) is record
        idx     : NNIndex; -- own index in NNet
        activat : ActivationType;
        lag     : Real;    -- delay of result propagation
        weights : WeightsArray(0 .. Nin);
        inputs  : NeuronIdxArray(1 .. Nin);
    end record;
    --
    type NeuronRec_Fixed_Ptr is access NeuronRec_Fixed;
    type NeuronsArray is array (NNIndex range <>) of NeuronRec_Fixed_Ptr;

    type InputIndex  is new Positive;
    type OutputIndex is new Positive;
    
    type NNetRec(Nin : InputIndex; Nout : OutputIndex; Npts : NNIndex) is record
        neurons : NeuronsArray(1 .. Npts);
        -- incomplete. Needs some more play with to decide which params to keep in what form
    end record;


    -----------------
    -- A mutable using Containers.Vectors
    -- Both NeuronRec and NNetRec can change not only the specific connections,
    -- but also number of neurons and connections
    
    package WV is new Ada.Containers.Vectors(Index_Type=>NIndex, Element_Type=>Real);
    package NV is new Ada.Containers.Vectors(Index_Type=>NIndex, Element_Type=>NNIndex);

    type NeuronRec_Mutable is record
        idx     : NNIndex; -- own index in the enclosing NNet
        activat : ActivationType;
        lag     : Real;    -- delay of result propagation
        weights : WV.Vector;
        inputs  : NV.Vector;
    end record;

    
--     type NNet is private;
    type Neuron(Nin : NIndex) is private;

private

    type Neuron(Nin : NIndex) is record
        activat : ActivationType;
        weights : WeightsArray(0 .. Nin);
        inputs  : NeuronIdxArray(1 .. Nin);
        lag     : Real;
    end record;

end wann;
