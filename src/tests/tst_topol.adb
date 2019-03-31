--
-- base test unit declaring and creating small nnets
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--

with Ada.Command_Line, GNAT.Command_Line;
with Ada.Text_IO, Ada.Integer_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with wann.nets.vectors;
with wann.neurons.vectors;

procedure tst_topol is

    use Ada.Text_IO;

    package PW is new wann(Real => Float);
    package PNet   is new PW.nets;
    package PNetV  is new PNet.vectors;
    package PN renames PNet.PN;
    package PNV is new PN.vectors;

    use PW; use NN;

    neur1 : PNV.Neuron := PNV.Create(Sigmoid, ((I,1),(I,2)), maxWeight => 1.0);
    net1  : PNetV.NNet := PNetV.Create(2,1);
--     inputs1  : NN.Input_Array := (0.0, 1.0);
--     outputs1 : NN.Output_Array(1..1);


begin  -- main
--     processCommandLine (params);
    Put_Line("creating basic 1-neuron network");
    net1.Add_Neuron(neur1);
    net1.Connect_Output((N,1));
    -- Add_Output is called implicitly by Create above
    -- all outputs are already pre-created, we just need to connect them..
    Put_Line("added neuron 1 and connected to output 1");
    net1.Print_Structure;
    --
--     Put_Line("running forward prop");
--     outputs1 := net1.Prop_Forward(inputs1);
--     Put_Line("done, output1 = " & outputs1(1)'Img);
end tst_topol;
