-- wann.nets.fixed package
-- An implementation of NNet with fixed topology (neurons and IO)
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

with wann.neurons, wann.layers;

generic
package wann.nets.fixed is

    ----------------------------------------------------------------
    -- the main type
    --
    -- This type is primarily intended for the "end use" - the NNet with set topology.
    -- Still can be used for "final optimization", but is not supposed to mutate any more..
    type NNet(Ni : NN.InputIndex;
              No : NN.OutputIndex;
              Nn : NN.NeuronIndex;
              Nl : NN.LayerIndex)
    is
        new Limited_Controlled and NNet_Interface with private;

    -- Dimension getters; the setters are imnplementation-specific,
    overriding
    function NInputs (net : NNet) return NN.InputIndex;

    overriding
    function NOutputs(net : NNet) return NN.OutputIndex;

    overriding
    function NNeurons(net : NNet) return NN.NeuronIndex;

    overriding
    function NLayers (net : NNet) return NN.LayerIndex;

    -- NNet IO
    overriding
    function  Input (net : NNet; i : NN.InputIndex)  return PI.Input_Interface'Class;

    overriding
    function  Output(net : NNet; o : NN.OutputIndex) return NN.ConnectionIndex;

    --  Neuron handling
    overriding
    procedure Add_Neuron(net  : in out NNet;
                         neur : in out PN.Neuron_Interface'Class; -- pre-created neuron
                         idx : out NN.NeuronIndex);

    overriding
    procedure Del_Neuron(net : in out NNet; idx : NN.NeuronIndex);

    overriding
    function  Neuron(net : aliased in out NNet; idx : NN.NeuronIndex) return Neuron_Reference;
        -- this provides read-write access via Accessor trick


    -- layer handling
    overriding
    function  Layers_Ready (net : NNet) return Boolean;

    overriding
    function  Layer(net : NNet; idx : NN.LayerIndex) return PL.Layer_Interface'Class ;

    overriding
    procedure Set_Layer(net : in out NNet; idx : NN.LayerIndex; L : PL.Layer_Interface'Class);


private

    type NeuronArray is array(NN.NeuronIndex range <>) of PN.NeuronReprPtr;
    type LayerArray  is array(NN.LayerIndex  range <>) of PL.LayerRecPtr;

    type NNet(Ni : NN.InputIndex; No : NN.OutputIndex;
              Nn : NN.NeuronIndex; Nl : NN.LayerIndex)
    is new Limited_Controlled and NNet_Interface with record
        Nneurons : NN.NeuronIndex_Base := 0; -- actual number of neurons
        NLayers  : NN.LayerIndex_Base  := 0; -- and layers so far created
        inputs   : NNet_InConnArray (1 .. Nin); -- ATTN!! needs refactoring, use array or InputRecPtr perhaps
        outputs  : NN.Output_Connection_Array(1 .. Nout);
        neurons  : NeuronArray(1 .. Nn);
        layers   : LayerArray (1 .. Nl);
    end record;

end wann.nets.fixed;

