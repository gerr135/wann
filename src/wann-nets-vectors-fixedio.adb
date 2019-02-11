pragma Ada_2012;
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
    begin
        idx := NN.NeuronIndex(net.neurons.Length + 1); -- new index
        neur.Set_Index(idx);
        net.neurons.Append(neur);
        -- now connect neur inputs to outputs of other entities
        for i in 1 .. neur.NInputs loop
            declare
                input : NN.ConnectionIndex := neur.Input(i);
                incoming : NN.ConnectionIndex := (NN.N, idx);
            begin
                case input.T is
                    when NN.I => raise Program_Error with "Unimplemented input connection";
                    when NN.N => net.Neuron(input.Nidx).Add_Output(incoming);
                    -- ATTN: may need to rethink how Neuron's are returned
                    -- may be better to use access, to allow modification in dot notation..
                    when NN.O => raise Invalid_Connection;
                end case;
            end;
        end loop;
        -- check if we autosort layers
        if net.autosort_layers then
            net.Update_Layers(idx);
        end if;
    end Add_Neuron;

    overriding
    procedure Del_Neuron (net : in out NNet; idx : NN.NeuronIndex) is
    begin
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
