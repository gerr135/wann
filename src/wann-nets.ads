--
-- A child package holding main type definitions: NNet, layers, etc..
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
package wann.nets is

    -- Trying mixed inputs/outputs/neurons, selected by index ranges, for fixed nets.
    -- See Readme for description.
    type NNet_Fixed(Nin, Nout, Npts : NIndex) is tagged limited private;
    procedure ConnectNeuron(net : in out NNet_Fixed; idx : NNIndex; activat : ActivationType; connects : InputsArray);


    --------------------------
    -- A mutable NNet type and methods
    -- using separate inputs/outputs and Connector type
    -- See Readme for details on design and representation description..
    type NNet is tagged limited private;

    -- base constructor
    function Create (Nin : InputIndex; Nout : OutputIndex) return NNet;
    --
    -- utility constructor;
    -- creates a nnet with random interconnects, each output is linked to Random(maxConnects)
    -- inputs/neurons in a random manner
    function CreateRandom (Nin : InputIndex; Nout : OutputIndex; Npts : NNIndex; maxConnects : NIndex) return NNet;

    function AddNeuron(net : in out NNet; neur : NeuronRec) return NNIndex;
    -- adds new NeuronRec with weights; returns new index
    --
    function AddNeuron(net : in out NNet; activat : ActivationType; connects : InputsArray) return NNIndex;
    -- adds new neuron, topology only, no weights; returns new index
    --
    procedure DelNeuron(net : in out NNet; idx : NNIndex);
    -- deletes neuron by index
    --
    procedure ConnectNeuron(net : in out NNet; idx : NNIndex; activat : ActivationType; connects : InputsArray);
    -- replaces neuron[idx] activation function and connections byt new values

private

    type NNet_Fixed(Nin, Nout, Npts : NIndex) is tagged limited record
        -- cannot use InputsArray(1 .. Nin+Nout+Npts) as expressions on discriminats are not allowed
        -- which pretty much makes this design pointless
        inputs  : InputsArray(1 .. Nin);
        outputs : InputsArray(1 .. Nout);
        neurons : InputsArray(1 .. Npts);
    end record;


    -----------------
    -- A mutable NNet using Containers.Vectors and Connectors to link neurons and inputs/outputs

    type Connector is record
        idx : NNIndex;
    end record;

    package IV is new Ada.Containers.Vectors(Index_Type=>InputIndex,  Element_Type=>Connector);
    package OV is new Ada.Containers.Vectors(Index_Type=>OutputIndex, Element_Type=>Connector);

    type NNet is tagged limited record
        inputs  : IV.Vector;
        outputs : OV.Vector;
        neurons : NV.Vector;
    end record;


end wann.nets;
