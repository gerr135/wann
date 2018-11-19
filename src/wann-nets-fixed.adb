pragma Ada_2012;
package body wann.nets.fixed is

    ---------------------------------------------------
    --  Dimension getters
    overriding
    function GetNInputs (net : NNet_Fixed) return InputIndex is
    begin
        return net.Nin;
    end;

    overriding
    function GetNOutputs(net : NNet_Fixed) return OutputIndex is
    begin
        return net.Nout;
    end;


    overriding
    function GetNNeurons(net : NNet_Fixed) return NeuronIndex is
    begin
        return net.Npts;
    end;


    overriding
    function GetNLayers (net : NNet_Fixed) return LayerIndex is
    begin
        return raise Program_Error with "Unimplemented function GetNLayers";
    end;


    --------------------------------------------
    -- Neuron handling
    overriding
    procedure NewNeuron (net : in out NNet_Fixed; idx : out NeuronIndex_Base) is
        -- everything is static, we do not really create any neurons..
        -- just return the number of next one with unassigned params.
    begin
        if net.Nassigned >= InputIndex(net.Npts) then
            raise NetOverflow;
        end if;
        net.Nassigned := net.Nassigned + 1;
        idx := NeuronIndex(net.Nassigned);
        -- here we essentialy create a 1:1 mapping from inner to outer indices
    end NewNeuron;


    overriding
    function  GetNeuron(net : NNet_Fixed; idx : NeuronIndex) return NeuronRec is
        Stub : NeuronRec(Nin=>0) :=
            ( idx => 0, lag => 0.0,
              Nin => 0,
              activat => Sigmoid,
              weights => (others=>0.0),
              inputs  => (others=>(N,0)) );
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "SetNeuron unimplemented");
        raise Program_Error with "Unimplemented procedure SetNeuron";
        return Stub;
    end GetNeuron;


    overriding
    procedure SetNeuron (net : in out NNet_Fixed; neur : NeuronRec) is
    begin
        -- init the inner neuron entry

        -- process all connections
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "SetNeuron unimplemented");
        raise Program_Error with "Unimplemented procedure SetNeuron";
    end SetNeuron;


    ---------------------------------------------
    -- Layer handling
    overriding
    function  GetLayer(net : in NNet_Fixed;     idx : LayerIndex) return Abstract_Layer'Class is
    begin
--         return net.layers(idx).all;
        -- Range_Error is raised by language itself if out of range
        -- no extra checks necessary..
        pragma Compile_Time_Warning (Standard.True, "GetLayer unimplemented");
        return raise Program_Error with "Unimplemented procedure GetLayer";
    end;

    overriding
    procedure SetLayer(net : in out NNet_Fixed; idx : LayerIndex; LR :   Abstract_Layer'Class) is
    begin
--         net.layers(idx).all := LR;
        pragma Compile_Time_Warning (Standard.True, "GetLayer unimplemented");
        raise Program_Error with "Unimplemented procedure GetLayer";
    end;



end wann.nets.fixed;
