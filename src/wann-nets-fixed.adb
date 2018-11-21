pragma Ada_2012;
package body wann.nets.fixed is

    ---------------------------------------------------
    --  Dimension getters
    overriding 
    function GetNInputs (net : NNet_Fixed) return InputIndex is
    begin
        return net.Nin;
    end GetNInputs;

    overriding 
    function GetNOutputs (net : NNet_Fixed) return OutputIndex is
    begin
        return net.Nout;
    end GetNOutputs;

    overriding 
    function GetNNeurons (net : NNet_Fixed) return NeuronIndex is
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


    ---------------
    -- NewNeuron --
    ---------------

    overriding 
    procedure NewNeuron (net : in out Nnet_Fixed; idx : out NeuronIndex_Base) is
    begin
        if net.Nassigned >= InputIndex(net.Npts) then
            raise NetOverflow;
        end if;
        net.Nassigned := net.Nassigned + 1;
        idx := NeuronIndex(net.Nassigned);
        -- here we essentialy create a 1:1 mapping from inner to outer indices
    end NewNeuron;

    ---------------
    -- GetNeuron --
    ---------------

    overriding 
    function GetNeuron (net : NNet_Fixed; idx : NeuronIndex) return PN.NeuronClass_Access is
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

    overriding 
    procedure SetInputValues (net : in out NNet_Fixed; V : ValueArray) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "SetInputValues unimplemented");
        raise Program_Error with "Unimplemented procedure SetInputValues";
    end SetInputValues;

end wann.nets.fixed;
