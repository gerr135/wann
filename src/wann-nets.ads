--
-- Top NNet packege, holding abstract type/interface with utility, but no storage..
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

    type NNet is abstract tagged limited private;

    procedure NewNeuron(net : in out NNet; idx : out NNIndex_Base) is abstract;
    -- create new empty neuron emplacement and return its index
    -- needs overriding in dynamic/mutable net.
    -- Makes no sense for fixed nnet; that one should just return 0 (and do nothing otherwise).

    procedure DelNeuron(net : in out NNet; idx : NNIndex) is null;
    -- remove neuron from NNet, as with New, only for mutable representation

    procedure SetNeuron(net : in out NNet; neur : NeuronRec) is abstract;
    -- set neuron parameters


    -----------------------------------
    -- class-wide stuff: main utility

    --
    -- Neuron manipulation
    --
    function  AddNeuron(net : in out NNet'Class; neur : NeuronRec) return NNIndex;
    procedure AddNeuron(net : in out NNet'Class; neur : NeuronRec; idx : out NNIndex);
    procedure AddNeuron(net : in out NNet'Class; neur : NeuronRec);
    -- combines New and Set
    --
    function  AddNeuron(net : in out NNet'Class; activat : ActivationType; connects : ConnectArray) return NNIndex;
    procedure AddNeuron(net : in out NNet'Class; activat : ActivationType; connects : ConnectArray; idx : out NNIndex);
    procedure AddNeuron(net : in out NNet'Class; activat : ActivationType; connects : ConnectArray);
    -- New plus Set by parameters
    --
    procedure ResetNeuron(net : in out NNet'Class; neur : NeuronRec);
    procedure ResetNeuron(net : in out NNet'Class; idx  : NNIndex; activat : ActivationType; connects : ConnectArray);
    procedure ResetNeuron(net : in out NNet'Class; idx  : NNIndex; connects : ConnectArray);
    -- replaces neuron[idx] parameters, either all or partial

    --
    --  Nnet manipulation
    --
    procedure ReconnectNeuronRandom(net : in out NNet'Class; idx  : NNIndex; maxConnects : NIndex_Base := 0);
    procedure PopulateRandom (net : in out NNet'Class; maxConnects : NIndex; Npts : NNIndex_Base := 0);
    -- populates net with new neurons or resets existing one to random configuration
    -- Npts needs to be passed in case of empty mutable net, otherwise it simply rearranges existing net.


private

    type NNet is abstract tagged limited null record;
--         inputs  : IV.Vector;
--         outputs : OV.Vector;
--         neurons : NV.Vector;
--     end record;


end wann.nets;
