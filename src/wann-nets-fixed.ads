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

with Ada.Finalization; use Ada.Finalization;
-- with wann.layers;

generic
package wann.nets.fixed is

    NetOverflow : Exception;

    -- Trying mixed inputs/outputs/neurons, selected by index ranges, for fixed nets.
    -- See Readme for description.
    --------------------------
    -- A mutable NNet type and methods
    -- using separate inputs/outputs and Connector type
    -- See Readme for details on design and representation description..
    type NNet_Fixed(Nin : InputIndex; Nout : OutputIndex;
                    Npts : NeuronIndex; maxLayers : LayerIndex) is
        new Limited_Controlled and NNet_Interface with private;
    -- The NNet_Fixed id parametrized by discriminants
    -- However we cannot avoid allocation altogether, as there are varying size connections throughout
    -- So, we pretty much have to derive this type from Controlled;
    -- Limited_ might be lifter at some point if we ever need to copy existing NNet

    -- inherited methods
    -- getters
    overriding
    function GetNInputs (net : NNet_Fixed) return InputIndex;

    overriding
    function GetNOutputs(net : NNet_Fixed) return OutputIndex;

    overriding
    function GetNNeurons(net : NNet_Fixed) return NeuronIndex;

    overriding
    function GetNLayers (net : NNet_Fixed) return LayerIndex;


    -- neuron handling
    overriding
    procedure NewNeuron(net : in out Nnet_Fixed; idx : out NeuronIndex_Base);
    -- nothing to create for real, but try to mimick mutable

    overriding
    function  GetNeuron(net : NNet_Fixed; idx : NeuronIndex) return PN.NeuronClass_Access;

    overriding
    procedure SetNeuron(net : in out Nnet_Fixed; neur : PN.NeuronClass_Access);

    overriding
    function  GetLayer(net : in NNet_Fixed;     idx : LayerIndex) return PL.Layer_Interface'Class;

    overriding
    procedure SetLayer(net : in out NNet_Fixed; idx : LayerIndex; L :   PL.Layer_Interface'Class);



private

    -- trying to keep dynamic allocation to a minimum, so use discriminated arrays as much as possible
    type NeuronRepr(Nin : PN.InputIndex; Nout : PN.OutputIndex) is record
        idx   : NeuronIndex; -- own index in NNet
        afunc : ActivationType;
        wghts : PN.WeightArray (0 .. Nin);
        ins   : PN.InConnArray (1 .. Nin);
        outs  : PN.OutConnArray(1 .. Nout);
    end record;

    type NeuronReprPtr is access NeuronRepr;


    type NeuronArray is array(NeuronIndex range <>) of NeuronReprPtr;
    type LayerArray  is array(LayerIndex  range <>) of PL.LayerRecPtr;

    type NNet_Fixed(Nin : InputIndex; Nout : OutputIndex;
                    Npts : NeuronIndex; maxLayers : LayerIndex) is
                    new Limited_Controlled and NNet_Interface with record
        Nassigned : InputIndex_Base := 0;
        inputs  : InConnArray (1 .. Nin);
        outputs : OutConnArray(1 .. Nout);
        neurons : NeuronArray (1 .. Npts);
        NLayers : LayerIndex; -- actual number of layers created
        layers  : LayerArray(1 .. maxLayers);
    end record;

end wann.nets.fixed;
