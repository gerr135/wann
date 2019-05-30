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

with Ada.Containers.Vectors;
with connectors.vectors;

generic
package wann.neurons.vectors is

    package PCNV is new PCN.vectors(Neuron_Interface);

    type Neuron is new PCNV.Connector_Vector and Neuron_Interface with private;

    -- inherited primitives
    overriding
    function  ToRepr  (neur : Neuron) return NeuronRepr;
    overriding
    procedure FromRepr(neur : in out Neuron; NR : NeuronRepr);
    --
    overriding
    function NInputs (neur : Neuron) return InputIndex ;
    --
    overriding
    function Input (neur : Neuron; idx : InputIndex)  return NN.ConnectionIndex;
    --
    overriding
    procedure Add_Input(neur : in out Neuron; Input : NN.ConnectionIndex);
    overriding
    procedure Del_Input(neur : in out Neuron; Input : NN.ConnectionIndex);
    --
    -- Outputs are inherited from connectors

    ---------------
    -- constructors
    --
    not overriding
    function Create(NR : NeuronRec) return Neuron;

    not overriding
    function Create(activation : Activation_Type;
                    connections : Input_Connection_Array;
                    weights  : Weight_Array) return Neuron;

    not overriding
    function Create(activation : Activation_Type;
                    connections : Input_Connection_Array;
                    maxWeight : Real) return Neuron;
    -- Create with weight uniformly distributed in [0 .. maxWeight]


private

    -- needed vector types
    use type NN.ConnectionIndex;
    package IV is new Ada.Containers.Vectors(Index_Type=>InputIndex,  Element_Type=>NN.ConnectionIndex);
    package OV is new Ada.Containers.Vectors(Index_Type=>OutputIndex, Element_Type=>NN.ConnectionIndex);
    package WV is new Ada.Containers.Vectors(Index_Type=>InputIndex_Base, Element_Type=>Real);

    type Neuron is new PCNV.Connector_Vector and Neuron_Interface with record
        idx     : NN.NeuronIndex_Base; -- own index in NNet
        activat : Activation_Type;
        lag     : Real;    -- delay of result propagation, unused for now
        inputs  : IV.Vector;
        outputs : OV.Vector;
        weights : WV.Vector;
    end record;

end wann.neurons.vectors;
