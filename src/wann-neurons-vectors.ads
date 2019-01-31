--
-- wann.neurons.vectors package. ACV-based implementation, mutable.
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
package wann.neurons.vectors is

    type Neuron is new Neuron_Interface with private;

    -- inherited primitives
    overriding
    function  ToRec  (NI : Neuron_Interface) return NeuronRec;
    overriding
    procedure FromRec(NI : in out Neuron_Interface; LR : NeuronRec);
    --
    overriding
    procedure AddOutput(NI : in out Neuron_Interface; Output : NN.ConnectionIndex);
    overriding
    procedure DelOutput(NI : in out Neuron_Interface; Output : NN.ConnectionIndex);

    -- Still, it is better to provide direct getters for frequently used fields
    overriding
    function NInputs (neur : Neuron_Interface) return InputIndex ;
    overriding
    function NOutputs(neur : Neuron_Interface) return OutputIndex;
    --
    overriding
    function Input (neur : Neuron_Interface; idx : InputIndex)  return NN.ConnectionIndex;
    overriding
    function Output(neur : Neuron_Interface; idx : OutputIndex) return NN.ConnectionIndex;

    -----------
    -- constructors
    not overriding
    function Create()

        -- old interface to be reintegrated here
        function  AddNeuron(net : in out NNet_Interface'Class; NR : PN.NeuronRec) return NNet_NeuronIndex;
        procedure AddNeuron(net : in out NNet_Interface'Class; NR : PN.NeuronRec; idx : out NNet_NeuronIndex);
        procedure AddNeuron(net : in out NNet_Interface'Class; NR : PN.NeuronRec);
        -- combines New and Set
        --
        function  AddNeuron(net : in out NNet_Interface'Class; activat : ActivationType; connects : PN.InConnArray) return NNet_NeuronIndex;
        procedure AddNeuron(net : in out NNet_Interface'Class; activat : ActivationType; connects : PN.InConnArray; idx : out NNet_NeuronIndex);
        procedure AddNeuron(net : in out NNet_Interface'Class; activat : ActivationType; connects : PN.InConnArray);


end wann.neurons.vectors;
