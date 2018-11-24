pragma Ada_2012;
package body wann.nets.fixed is

    ---------------------------------------------------
    --  Dimension getters
    overriding
    function GetNNeurons (net : NNet_Fixed) return NNet_NeuronIndex is
    begin
        return net.Npts;
    end GetNNeurons;

    overriding
    function GetNLayers (net : NNet_Fixed) return LayerIndex is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "GetNLayers unimplemented");
        return raise Program_Error with "Unimplemented function GetNLayers";
    end GetNLayers;

    ----------------------
    --  data IO
    overriding
    function GetInputConnections (net : NNet_Fixed) return NNet_InConnArray is
    begin
        return net.inputs;
    end GetInputConnections;

    overriding
    function GetOutputConnections (net : NNet_Fixed) return NNet_OutConnArray is
    begin
        return net.outputs;
    end GetOutputConnections;

    overriding
    function  GetNNetState(net : NNet_Fixed) return NNet_StateVector is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "NewNeuron unimplemented");
        return raise Program_Error with "Unimplemented procedure NewNeuron";
    end GetNNetState;

    overriding
    procedure SetNNetState(net : in out NNet_Fixed; NSV : NNet_StateVector) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "SetLayer unimplemented");
        raise Program_Error with "Unimplemented procedure SetLayer";
    end SetNNetState;

    overriding
    function  GetNeuronValues(net : NNet_Fixed) return NNet_ValueArray is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "NewNeuron unimplemented");
        return raise Program_Error with "Unimplemented procedure NewNeuron";
    end GetNeuronValues;


    ---------------
    -- NewNeuron --
    ---------------

    overriding
    procedure NewNeuron (net : in out Nnet_Fixed; idx : out NNet_NeuronIndex_Base) is
    begin
        if net.Nassigned >= net.Npts then
            raise NetOverflow;
        end if;
        net.Nassigned := net.Nassigned + 1;
        idx := net.Nassigned;
        -- here we essentialy create a 1:1 mapping from inner to outer indices
    end NewNeuron;

    ---------------
    -- GetNeuron --
    ---------------

    overriding
    function GetNeuron (net : NNet_Fixed; idx : NNet_NeuronIndex) return PN.NeuronClass_Access is
        Stub : PN.NeuronRec(Nin=>0) := (
            idx => 0, lag => 0.0,
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
    procedure SetNeuron (net : in out Nnet_Fixed; neur : PN.NeuronClass_Access) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "SetNeuron unimplemented");
        raise Program_Error with "Unimplemented procedure SetNeuron";
    end SetNeuron;

    -----------------
    -- LayersReady --
    -----------------

    overriding
    function LayersReady (net : NNet_Fixed) return Boolean is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "LayersReady unimplemented");
        return raise Program_Error with "Unimplemented function LayersReady";
    end LayersReady;

    --------------
    -- GetLayer --
    --------------

    overriding
    function GetLayer (net : in NNet_Fixed; idx : LayerIndex) return PL.Layer_Interface'Class is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "GetLayer unimplemented");
        return raise Program_Error with "Unimplemented function GetLayer";
    end GetLayer;

    --------------
    -- SetLayer --
    --------------

    overriding
    procedure SetLayer (net : in out NNet_Fixed; idx : LayerIndex; L : PL.Layer_Interface'Class) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "SetLayer unimplemented");
        raise Program_Error with "Unimplemented procedure SetLayer";
    end SetLayer;

    --------------------
    -- SetInputValues --
    --------------------

--     overriding
--     procedure SetInputValues (net : in out NNet_Fixed; V : NNet_InputArray) is
--     begin
--         --  Generated stub: replace with real body!
--         pragma Compile_Time_Warning (Standard.True, "SetInputValues unimplemented");
--         raise Program_Error with "Unimplemented procedure SetInputValues";
--     end SetInputValues;

end wann.nets.fixed;
