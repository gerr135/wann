--
-- base test unit declaring and creating small nnets
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--

with Ada.Command_Line, GNAT.Command_Line;
with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with wann.nets.vectors;
with wann.neurons.vectors;

procedure tst_forward_prop_01 is

    use Ada.Text_IO, Ada.Float_Text_IO;

    package PW is new wann(Real => Float);
    package PNet   is new PW.nets;
    package PNetV  is new PNet.vectors;
    package PN renames PNet.PN;
    package PNV is new PN.vectors;

    use PW; use NN;

begin  -- main
    Put_Line("basic 1-neuron mixer network (equal weights):");
    declare
        neur : PNV.Neuron := PNV.Create(activation  => Sigmoid,
                                        connections => ((I,1),(I,2)),
                                        weights     => (0.0, 0.5, 0.5));
        net  : PNetV.NNet := PNetV.Create(Ni=>2, No=>1);
--         outs : NN.Output_Array(1..1);
    begin
        net.Add_Neuron(neur);
        net.Connect_Output(1,(N,1));
        net.Print_Structure;
        --
        Put_Line("running forward prop tests..");
        Put("  [1,0] -> "); Put(net.Prop_Forward((1.0, 0.0))(1), 4,2); New_Line;
        Put("  [0,1] -> "); Put(net.Prop_Forward((0.0, 1.0))(1), 4,2); New_Line;
        Put("  [1,1] -> "); Put(net.Prop_Forward((1.0, 1.0))(1), 4,2); New_Line;
    end;
    --
    New_Line;
    Put_Line("creating 2-neuron network");
    declare
        neur1 : PNV.Neuron := PNV.Create(Sigmoid, ((I,1),(I,2)), maxWeight => 1.0);
        neur2 : PNV.Neuron := PNV.Create(Sigmoid, ((I,1),(I,2)), maxWeight => 1.0);
        net   : PNetV.NNet := PNetV.Create(Ni=>2, No=>2);
    begin
        net.Add_Neuron(neur1);
        net.Connect_Output(1,(N,1));
        net.Add_Neuron(neur2);
        net.Connect_Output(2,(N,2));
        net.Print_Structure;
    end;
    --
    New_Line;
    Put_Line("creating 2-layer network from 3 neurons");
    declare
        neur1 : PNV.Neuron := PNV.Create(Sigmoid, ((I,1),(I,2)), maxWeight => 1.0);
        neur2 : PNV.Neuron := PNV.Create(Sigmoid, ((I,1),(I,2)), maxWeight => 1.0);
        neur3 : PNV.Neuron := PNV.Create(Sigmoid, ((N,1),(N,2)), maxWeight => 1.0);
        net   : PNetV.NNet := PNetV.Create(Ni=>2, No=>1);
    begin
        net.Add_Neuron(neur1);
        net.Add_Neuron(neur2);
        net.Add_Neuron(neur3);
        net.Connect_Output(1,(N,3));
        net.Print_Structure;
    end;
end tst_forward_prop_01;
