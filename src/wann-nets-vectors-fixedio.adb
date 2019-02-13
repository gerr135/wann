pragma Ada_2012;

with Ada.Text_IO;

package body wann.nets.vectors.fixedIO is

    -----------------------------
    -- Connection_Aray getters --

    overriding
    function Input_Connections (net : NNet) return NN.Input_Connection_Array is
    begin
        return net.inputs;
    end Input_Connections;

    overriding
    function Output_Connections (net : NNet) return NN.Output_Connection_Array is
    begin
        return net.outputs;
    end Output_Connections;


    --------------------
    -- Add/Del_Neuron --

    overriding
    procedure Add_Neuron (net : in out NNet;
                          neur : in out PN.Neuron_Interface'Class;
                          idx : out NN.NeuronIndex)
    is
        use type Ada.Containers.Count_Type;
        use Ada.Text_IO;
    begin
        idx := NN.NeuronIndex(net.neurons.Length + 1); -- new index
        Put_Line("net.Add_Neuron(neur," & idx'Img & ")");
        neur.Set_Index(idx);
        net.neurons.Append(neur);
        -- now connect neur inputs to outputs of other entities
        for i in 1 .. neur.NInputs loop
            declare
                input : NN.ConnectionIndex := neur.Input(i);
            begin
                case input.T is
                    when NN.I => raise Program_Error with "Unimplemented add input connection"; -- net.inputs(input.Iidx) := (NN.N,idx);
                    when NN.N => net.Neuron(input.Nidx).Add_Output((NN.N,idx));
                    -- ATTN: may need to rethink how Neuron's are returned
                    -- may be better to use access, to allow modification in dot notation..
                    when NN.O | NN.None => raise Invalid_Connection;
                end case;
            end;
        end loop;
        --  need more design of Net inputs/outputs
        --  to be able to connect to multiple entries oon the other side..
        pragma Compile_Time_Warning (Standard.True, "Del_Neuron unimplemented");
        raise Program_Error with "Unimplemented procedure Del_Neuron";
        -- check if we autosort layers
        if net.autosort_layers then
            net.Update_Layers(idx);
        end if;
    end Add_Neuron;

    overriding
    procedure Del_Neuron (net : in out NNet; idx : NN.NeuronIndex) is
        neur : PN.Neuron_Interface'Class := net.Neuron(idx);
    begin
        -- first disconnect the connections
        for i in 1 .. neur.NInputs loop
            declare
                input : NN.ConnectionIndex := neur.Input(i);
            begin
                case input.T is
                    when NN.I => net.inputs(input.Iidx) := (T=>NN.None);
                    when NN.N => raise Program_Error with "Unimplemented del input connection"; -- net.Neuron(input.Nidx).Del_Output(idx);
                    when NN.O | NN.None => raise Invalid_Connection;
                end case;
            end;
        end loop;
        for o in 1 .. neur.NOutputs loop
            declare
                output : NN.ConnectionIndex := neur.Output(o);
            begin
                case output.T is
                    when NN.I | NN.None => raise Invalid_Connection;
                    when NN.N => raise Program_Error with "Unimplemented del input connection"; --net.Neuron(output.Nidx).Del_Input((T=>NN.None));
                    when NN.O => raise Program_Error with "Unimplemented del input connection"; --net.outputs(output.Iidx) := (T=>NN.None);
                end case;
            end;
        end loop;
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "Del_Neuron unimplemented");
        raise Program_Error with "Unimplemented procedure Del_Neuron";
    end Del_Neuron;

   ---------------
   -- Set_Layer --
   ---------------

   overriding procedure Set_Layer
     (net : in out NNet;
      idx : NN.LayerIndex;
      L : PL.Layer_Interface'Class)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Set_Layer unimplemented");
      raise Program_Error with "Unimplemented procedure Set_Layer";
   end Set_Layer;

end wann.nets.vectors.fixedIO;
