--
-- test layer creation and sorting
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--

with Ada.Text_IO, Ada.Integer_Text_IO;
-- with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with wann.nets.vectors;
with wann.neurons.vectors;

procedure tst_layers01 is

    use Ada.Text_IO;

    package PW is new wann(Real => Float);
    package PNet   is new PW.nets;
    package PNetV  is new PNet.vectors;
    package PN renames PNet.PN;
    package PNV is new PN.vectors;

    use PW; use NN;

begin  -- main
    Put_Line("creating net of 3 neurons in parallel (1 layer)");
    declare
        neur1 : PNV.Neuron := PNV.Create(Sigmoid, ((I,1),(I,2)), maxWeight => 1.0);
        neur2 : PNV.Neuron := PNV.Create(Sigmoid, ((I,1),(I,2),(I,3)), maxWeight => 1.0);
        neur3 : PNV.Neuron := PNV.Create(Sigmoid, ((I,2),(I,3)), maxWeight => 1.0);
        net   : PNetV.NNet := PNetV.Create(Ni=>3, No=>3);
    begin
        net.Add_Neuron(neur1);
        net.Connect_Output(1,(N,1));
        net.Add_Neuron(neur2);
        net.Connect_Output(2,(N,2));
        net.Add_Neuron(neur3);
        net.Connect_Output(3,(N,3));
        net.Print_Structure;
        Put_Line("sorting layers..");
--         net.Sort_Layers;
        net.Print_Structure;
    end;
    --
    New_Line;
    Put_Line("creating net with 5 neurons in 2 layers");
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
end tst_layers01;
