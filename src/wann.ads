--
-- <one line to give the library's name and an idea of what it does.>
-- Copyright (C) 2018  <copyright holder> <email>
-- 
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
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
    --  set this to True to get some reporting on the go..
        
    type ActivationType is (Sigmoid, ReLu);
    type ActivationFunction is access function (x : Real) return Real;

    -- index types (to catch misplaced i errors)
    -- this one tracks inputs inside neuron
    type NIndex_Base is new Natural;
    subtype NIndex is NIndex_Base range 1 .. NIndex_Base'Last;

    -- this one tracks neurons in the NNet
    type NNIndex_Base is new Natural;
    subtype NNIndex is NNIndex_Base range 1 .. NNIndex_Base'Last;

    type NeuronIdxArray is array (NIndex range <>) of NNIndex;
    type WeightsArray is array (NIndex_Base range <>) of Real;

    type NeuronRec(Nin : NIndex) is record
        idx     : NNIndex; -- own index in 
        activat : ActivationType;
        weights : WeightsArray(0 .. Nin);
        inputs  : NeuronIdxArray(1 .. Nin);
        lag     : Real;
    end record;

    -- NNet inputs, outputs and the network specification
    -- these types can be used as an alphabet to form a linear description, a-la DNA/protein sequence
    -- then the Nnet can be simply defined as some linear sequence in declaration which can 
    -- be passed to the NNet constructor.

    type InputIndex is new Positive;
    type OutputIndex is new Positive;

    type NeuronsArray is array (NNIndex range <>) of NeuronRec;
    
    type NNetRec(Nin : InputIndex; Nout : OutputIndex; Nneur : NNIndex) is record
        neurons : NeuronsArray(1 .. Nneur);
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
