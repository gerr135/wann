pragma Ada_2012;
package body wann.nets.vectors is

    --------------
    -- NNeurons --
    --------------
    overriding
    function NNeurons (net : Proto_NNet) return NN.NeuronIndex is
    begin
        return NN.NeuronIndex_Base(net.neurons.Length);
    end NNeurons;

    -------------
    -- NLayers --
    -------------
    overriding
    function NLayers (net : Proto_NNet) return NN.LayerIndex is
    begin
        return NN.LayerIndex_Base(net.layers.Length);
    end NLayers;

    ------------
    -- Neuron --
    ------------
    overriding
    function Neuron (net : Proto_NNet; idx : NN.NeuronIndex)
        return PN.NeuronClass_Access
    is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "Neuron unimplemented");
        return raise Program_Error with "Unimplemented function Neuron";
    end Neuron;

    ------------------
    -- Layers_Ready --
    overriding
    function Layers_Ready (net : Proto_NNet) return Boolean is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "Layers_Ready unimplemented");
        return raise Program_Error with "Unimplemented function Layers_Ready";
    end Layers_Ready;

    -----------
    -- Layer --
    overriding
    function Layer (net : Proto_NNet; idx : NN.LayerIndex)
        return PL.Layer_Interface'Class
    is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "Layer unimplemented");
        return raise Program_Error with "Unimplemented function Layer";
    end Layer;

    ---------------
    -- Set_Layer --
    overriding
    procedure Set_Layer (net : in out Proto_NNet; idx : NN.LayerIndex;
                         L : PL.Layer_Interface'Class)
    is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "Set_Layer unimplemented");
        raise Program_Error with "Unimplemented procedure Set_Layer";
    end Set_Layer;

    -----------
    -- State --
    overriding
    function State (net : Cached_Proto_NNet) return NN.State_Vector is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "State unimplemented");
        return raise Program_Error with "Unimplemented function State";
    end State;

    ---------------
    -- Set_State --
    ---------------

    overriding procedure Set_State
        (net : in out Cached_Proto_NNet;
        NSV : NN.State_Vector)
    is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "Set_State unimplemented");
        raise Program_Error with "Unimplemented procedure Set_State";
    end Set_State;

    -----------
    -- State --
    -----------

    overriding function State
        (net : Cached_Checked_Proto_NNet)
        return NN.Checked_State_Vector
    is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "State unimplemented");
        return raise Program_Error with "Unimplemented function State";
    end State;

    ---------------
    -- Set_State --
    ---------------

    overriding procedure Set_State
        (net : in out Cached_Checked_Proto_NNet;
        NSV : NN.Checked_State_Vector)
    is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "Set_State unimplemented");
        raise Program_Error with "Unimplemented procedure Set_State";
    end Set_State;

end wann.nets.vectors;
