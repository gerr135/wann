pragma Ada_2012;

-- with Ada.Text_IO;
package body wann.nets.vectors is

    -------------------
    -- Dimension getters
    --
    overriding
    function NInputs (net : NNet) return NN.InputIndex is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "NInputs unimplemented");
        return raise Program_Error with "Unimplemented procedure NInputs";
    end;

    overriding
    function NOutputs(net : NNet) return NN.OutputIndex is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "NOutputs unimplemented");
        return raise Program_Error with "Unimplemented procedure NOutputs";
    end;

    overriding
    function NNeurons (net : NNet) return NN.NeuronIndex is
    begin
        return NN.NeuronIndex_Base(net.neurons.Length);
    end NNeurons;

    overriding
    function NLayers (net : NNet) return NN.LayerIndex is
    begin
        return NN.LayerIndex_Base(net.layers.Length);
    end NLayers;

    ---------------------------
    -- IO handling
    --
    overriding
    function  Input (net : NNet; i : NN.InputIndex)  return PI.Input_Interface'Class is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "Input unimplemented");
        return raise Program_Error with "Unimplemented procedure Input";
    end;

    overriding
    function  Output(net : NNet; o : NN.OutputIndex) return NN.ConnectionIndex is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "Output unimplemented");
        return raise Program_Error with "Unimplemented procedure Output";
    end;

    --------------------
    -- Neurons handling
    --
    overriding
    procedure Add_Neuron (net : in out NNet;
                          neur : in out PN.Neuron_Interface'Class;
                          idx : out NN.NeuronIndex)
    is
        use type Ada.Containers.Count_Type;
--         use Ada.Text_IO;
    begin
        idx := NN.NeuronIndex(net.neurons.Length + 1); -- new index
--         Put_Line("net.Add_Neuron(neur," & idx'Img & ")");
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
                    when NN.I => raise Program_Error with "Unimplemented del input connection";
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

    overriding
    function Neuron (net : aliased in out NNet; idx : NN.NeuronIndex)
        return Neuron_Reference
    is
        NVR : NV.Reference_Type := net.neurons.Reference(idx);
        NR : Neuron_Reference(NVR.Element);
    begin
        return NR;
    end Neuron;



    -------------------
    -- Layers handling
    --
    overriding
    procedure Set_Layer (net : in out NNet;
            idx : NN.LayerIndex; L : PL.Layer_Interface'Class)
    is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "Set_Layer unimplemented");
        raise Program_Error with "Unimplemented procedure Set_Layer";
    end Set_Layer;


 ------------
    -- Neuron --
    ------------
--     overriding
--     function Neuron (net : NNet; idx : NN.NeuronIndex)
--         return PN.Neuron_Interface'Class
--     is
--     begin
--         return net.neurons.Element(idx);
--     end Neuron;


    ------------------
    -- Layers_Ready --
    overriding
    function Layers_Ready (net : NNet) return Boolean is
    begin
        return net.Layers_Ready;
    end Layers_Ready;

    -----------
    -- Layer --
    overriding
    function Layer (net : NNet; idx : NN.LayerIndex)
        return PL.Layer_Interface'Class
    is
    begin
        return net.layers.Element(idx);
    end Layer;


--     ---------------------
--     -- Cached_NNet
--
--     overriding
--     function State (net : Cached_NNet) return NN.State_Vector is
--     begin
--         --  Generated stub: replace with real body!
--         pragma Compile_Time_Warning (Standard.True, "State unimplemented");
--         return raise Program_Error with "Unimplemented function State";
--     end State;
--
--     ---------------
--     -- Set_State --
--     ---------------
--
--     overriding procedure Set_State
--         (net : in out Cached_NNet;
--         NSV : NN.State_Vector)
--     is
--     begin
--         --  Generated stub: replace with real body!
--         pragma Compile_Time_Warning (Standard.True, "Set_State unimplemented");
--         raise Program_Error with "Unimplemented procedure Set_State";
--     end Set_State;

--     ----------------------------
--     -- Cached_Checked_NNet
--
--     overriding function State
--         (net : Cached_Checked_NNet)
--         return NN.Checked_State_Vector
--     is
--     begin
--         --  Generated stub: replace with real body!
--         pragma Compile_Time_Warning (Standard.True, "State unimplemented");
--         return raise Program_Error with "Unimplemented function State";
--     end State;
--
--     ---------------
--     -- Set_State --
--     ---------------
--
--     overriding procedure Set_State
--         (net : in out Cached_Checked_NNet;
--         NSV : NN.Checked_State_Vector)
--     is
--     begin
--         --  Generated stub: replace with real body!
--         pragma Compile_Time_Warning (Standard.True, "Set_State unimplemented");
--         raise Program_Error with "Unimplemented procedure Set_State";
--     end Set_State;

end wann.nets.vectors;
