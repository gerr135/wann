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

with wann.nets.vectors.fixedIO;
with wann.neurons.vectors;

procedure run_customNN is

    use Ada.Text_IO;

    package PW is new wann(Real => Float);
    package PNet   is new PW.nets;
    package PNetV  is new PNet.vectors;
    package PNetVF is new PNetV.fixedIO;
    package PN renames PNet.PN;
    package PNV is new PN.vectors;

    use PW; use NN;

    neur1 : PNV.Neuron := PNV.Create(Sigmoid, ((I,1),(I,2)), 1.0);
    net1  : PNetVF.NNet(Ni=>2, No=>1);


begin  -- main
--     processCommandLine (params);
    Put_Line("creating basic 1-neuron network");
    net1.Add_Neuron(neur1);
end run_customNN;
