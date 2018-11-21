pragma Ada_2012;
package body wann.nets.vectors is

    ------------
    -- Create --
    ------------

    function Create (Nin : InputIndex; Nout : OutputIndex) return NNet is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "Create unimplemented");
        return raise Program_Error with "Unimplemented function Create";
    end Create;

    ----------------
    -- getters
    overriding 
    function GetNInputs (net : NNet) return InputIndex is
    begin
        return InputIndex(net.inputs.Length);
    end GetNInputs;

    overriding 
    function GetNOutputs (net : NNet) return OutputIndex is
    begin
        return OutputIndex(net.Outputs.Length);
    end GetNOutputs;

    overriding 
    function GetNNeurons (net : NNet) return NeuronIndex is
    begin
        return NeuronIndex(net.neurons.Length);
    end GetNNeurons;

    overriding 
    function GetNLayers (net : NNet) return LayerIndex is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "GetNLayers unimplemented");
        return raise Program_Error with "Unimplemented function GetNLayers";
    end GetNLayers;

    ---------------
    -- NewNeuron --
    ---------------

    overriding 
    procedure NewNeuron (net : in out NNet; idx : out NeuronIndex_Base) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "NewNeuron unimplemented");
        raise Program_Error with "Unimplemented procedure NewNeuron";
    end NewNeuron;

    ---------------
    -- DelNeuron --
    ---------------

    overriding 
    procedure DelNeuron (net : in out NNet; idx : NeuronIndex) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "DelNeuron unimplemented");
        raise Program_Error with "Unimplemented procedure DelNeuron";
    end DelNeuron;

    ---------------
    -- GetNeuron --
    ---------------

    overriding 
    function GetNeuron (net : NNet; idx : NeuronIndex) return PN.NeuronCLass_Access is 
        Stub : PN.NeuronRec(Nin=>0) :=
            ( idx => 0, lag => 0.0,
            Nin => 0,
            activat => Sigmoid,
            weights => (others=>0.0),
            inputs  => (others=>(N,0)) );
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "GetNeuron unimplemented");
        return raise Program_Error with "Unimplemented function GetNeuron";
    end GetNeuron;

    ---------------
    -- SetNeuron --
    ---------------

    overriding 
    procedure SetNeuron (net : in out NNet; neur : PN.NeuronCLass_Access) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "SetNeuron unimplemented");
        raise Program_Error with "Unimplemented procedure SetNeuron";
    end SetNeuron;

    -----------------
    -- LayersReady --
    -----------------

    overriding 
    function LayersReady (net : NNet) return Boolean is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "LayersReady unimplemented");
        return raise Program_Error with "Unimplemented function LayersReady";
    end LayersReady;

    --------------
    -- GetLayer --
    --------------

    overriding 
    function GetLayer (net : NNet; idx : LayerIndex) return PL.Layer_Interface'Class is
    begin
        return net.layers.element(idx);
    end GetLayer;

    --------------
    -- SetLayer --
    --------------

    overriding 
    procedure SetLayer (net : in out NNet; idx : LayerIndex; 
                        LR : PL.Layer_Interface'Class) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "SetLayer unimplemented");
        raise Program_Error with "Unimplemented procedure SetLayer";
    end SetLayer;

    --------------------
    -- SetInputValues --
    --------------------

    overriding 
    procedure SetInputValues (net : in out NNet; V : ValueArray) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "SetInputValues unimplemented");
        raise Program_Error with "Unimplemented procedure SetInputValues";
    end SetInputValues;


    --------------------
    -- some old layers code fore reference
--     function  Length(AL : Layer_SimpleVector) return NeuronIndex_Base is
--     begin
--         return NeuronIndex_Base(AL.neurons.Length);
--     end;
-- 
--     function  Get(AL : Layer_SimpleVector) return LayerRec is
--         LR : LayerRec(N => AL.Length);
--     begin
--         for i in 1 .. AL.Length loop
--             LR.neurons(i) := AL.neurons.Element(i);
--         end loop;
--         return LR;
--     end;
-- 
--     procedure Set(AL : in out Layer_SimpleVector; LR : LayerRec) is
--         use Ada.Containers;
--     begin
--         AL.neurons.Set_Length(Count_Type(LR.N));
--         for i in 1 .. LR.N loop
--             AL.neurons.Replace_Element(i, LR.neurons(i));
--         end loop;
--     end;


end wann.nets.vectors;
