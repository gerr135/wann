pragma Ada_2012;

-- with Ada.Text_IO;
package body wann.nets.vectors is

    -------------------
    -- Dimension getters
    --
    overriding
    function NInputs (net : NNet) return NN.InputIndex_Base is
    begin
        return NN.InputIndex(net.inputs.Length);
    end;

    overriding
    function NOutputs(net : NNet) return NN.OutputIndex_Base is
    begin
        return NN.OutputIndex(net.outputs.Length);
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
        return net.inputs(i);
    end;

    overriding
    function  Output(net : NNet; o : NN.OutputIndex) return NN.ConnectionIndex is
    begin
        return net.outputs(o);
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
    begin
        -- generate new index
        idx := NN.NeuronIndex(net.neurons.Length + 1); -- new index
        GT.Trace(Debug, "net.Add_Neuron" & idx'Img);
        -- set generated idx in neuron and add it to the NNet container
        neur.Set_Index(idx);
        net.neurons.Append(neur);
        -- now connect neuron inputs to outputs of other entities that are already in NNet
        for i in 1 .. neur.NInputs loop
            declare
                input : NN.ConnectionIndex := neur.Input(i);
            begin
                GT.Trace(Debug, "  adding input" & i'Img
                         & "  (" & NN.Con2Str(input) & ")");
                case input.T is
                    when NN.I => net.inputs (input.Iidx).Add_and_Connect((NN.N,idx));
                    when NN.N => net.neurons(input.Nidx).Add_and_Connect((NN.N,idx));
                    when NN.O | NN.None => raise Invalid_Connection;
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
        neur : PN.Neuron_Interface'Class := net.Neuron(idx);
        self : NN.ConnectionIndex := (NN.N, idx);
    begin
        -- first disconnect the connections
        for i in 1 .. neur.NInputs loop
            declare
                input : NN.ConnectionIndex := neur.Input(i);
            begin
                case input.T is
                    when NN.I => net.inputs (input.Iidx).Del_Output(self);
                    when NN.N => net.neurons(input.Nidx).Del_Output(self);
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
                    when NN.N => net.neurons(output.Nidx).Del_Input(self);
                    when NN.O => net.outputs(output.Oidx) := (T=>NN.None);
                end case;
            end;
        end loop;
        -- Now for the tricky part
        -- Need to delete the neuron
        -- and liberate its idx, by compacting all other entries
        -- and updating corresponding indices of all affected connections
        --
        -- Implementation postponed until design is clear:
        -- there are multiple possible approaches on how to handle deletions:
        -- 1. we can update all the indices upon every deletion.
        --    Less efficient, as every delete can force renumbering of the same indices
        --    but can use A.C.Vectors directly.
        -- 2. Can keep indices unchanged upon deletion, and update them by a separate "compact" procedure.
        --    more eofficient, but less automatic - need not forget to call compact if needed.
        --    A.C.Vectors autocompacts upon deletion, so cannot be used as is. Need another
        --    container that supports sparse indexing..
        -- (see also Readme)
        pragma Compile_Time_Warning (Standard.True, "Del_Neuron unimplemented");
        raise Program_Error with "Unimplemented procedure Del_Neuron";
    end Del_Neuron;

    overriding
    function Neuron (net : aliased in out NNet; idx : NN.NeuronIndex)
        return PN.Neuron_Reference
    is
        NVR : NV.Reference_Type := net.neurons.Reference(idx);
        NR  : PN.Neuron_Reference(NVR.Element);
    begin
        return NR;
    end Neuron;

--     overriding
--     function Neuron (net : NNet; idx : NN.NeuronIndex)
--         return PN.Neuron_Interface'Class
--     is
--     begin
--         return net.neurons.Element(idx);
--     end Neuron;


    ------------------------
    -- Layer handling
    overriding
    procedure Add_Layer(net : in out NNet; L   : in out PL.Layer_Interface'Class;
                        idx : out NN.LayerIndex)
    is
    begin
        pragma Compile_Time_Warning (Standard.True, "Add_Layer unimplemented");
        raise Program_Error with "Unimplemented procedure Add_Layer";
    end;

    overriding
    procedure Del_Layer(net : in out NNet; idx : NN.LayerIndex) is
    begin
        pragma Compile_Time_Warning (Standard.True, "Del_Layer unimplemented");
        raise Program_Error with "Unimplemented procedure Del_Layer";
    end;

    overriding
    function  Layer(net : aliased in out NNet;
                    idx : NN.LayerIndex) return PL.Layer_Reference is
        LVR : LV.Reference_Type := net.layers.Reference(idx);
        LR  : PL.Layer_Reference(LVR.Element);
    begin
        return LR;
    end Layer;

    overriding
    function Layer (net : NNet; idx : NN.LayerIndex)
        return PL.Layer_Interface'Class
    is
    begin
        return net.layers.Element(idx);
    end Layer;

    overriding
    function Layers_Sorted (net : NNet) return Boolean is
    begin
        return net.Layers_Ready;
    end Layers_Sorted;


    -------------------------------------------------------
    --  new methods
    --
    -- Constructors
    --
    not overriding
    function Create(Ni : NN.InputIndex; No : NN.OutputIndex) return NNet is
        emptyInput  : PI.Input_Vector;
        emptyOutput : NN.ConnectionIndex := (T=>NN.None);
    begin
        return net : NNet do
            net.inputs.Append(emptyInput, Ada.Containers.Count_Type(Ni));
            net.outputs.Append(emptyOutput, Ada.Containers.Count_Type(No));
            -- the rest of fields are autoinit to proper (emty vector) values
        end return;
    end;

    not overriding
    function Create_From(S : string) return NNet is
    begin
        return net : NNet do
            net.Construct_From(S);
        end return;
    end;


    ---------------------------------------------------------
    -- Input handling

    not overriding
    procedure Add_Input(net : in out NNet; N : NN.InputIndex := 1) is
        emptyInput  : PI.Input_Vector;
    begin
        net.inputs.Append(emptyInput, Ada.Containers.Count_Type(N));
    end;

    not overriding
    procedure Del_Input(net : in out NNet; idx : NN.InputIndex) is
    begin
        -- as with Neuron deletion, this is a tricky issue, as it may require reindexing
        -- many connections
        -- Postponed until design is clear
        pragma Compile_Time_Warning (Standard.True, "Del_Input unimplemented");
        raise Program_Error with "Unimplemented procedure Del_Input";
    end;

    overriding
    procedure Add_Output(net : in out NNet; N : NN.OutputIndex := 1) is
        emptyOutput  : NN.ConnectionIndex := (T=>NN.None);
    begin
        net.outputs.Append(emptyOutput, Ada.Containers.Count_Type(N));
    end;

    overriding
    procedure Connect_Output(net : in out NNet; idx : NN.OutputIndex; val : NN.ConnectionIndex) is
    begin
        -- A NNet output takes signal from a single neuron or input
        -- but we have to set both sides of a connection
        net.outputs.Replace_Element(idx, val);  -- direct assignment raises "discriminant check failed" here..
        case val.T is
            when NN.I => net.inputs (val.Iidx).Add_and_Connect((NN.O,idx));
            when NN.N => net.neurons(val.Nidx).Add_and_Connect((NN.O,idx));
            when NN.O | NN.None => raise Invalid_Connection;
        end case;
    end;

    overriding
    procedure Del_Output(net : in out NNet; Output : NN.ConnectionIndex) is
    begin
        -- as with Neuron deletion, this is a tricky issue, as it may require reindexing
        -- many connections
        -- Postponed until design is clear
        pragma Compile_Time_Warning (Standard.True, "Del_Output unimplemented");
        raise Program_Error with "Unimplemented procedure Del_Output";
    end;


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
