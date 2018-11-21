pragma Ada_2012;
package body wann.nets is

    -----------------------------------
    -- Layer class-wides
    procedure PropForward(L : in out Abstract_Layer'Class) is
    begin
        pragma Compile_Time_Warning (Standard.True, "PropForward unimplemented");
        raise Program_Error with "Unimplemented procedure PropForward";
    end;

    ---------------
    -- AddNeuron --
    ---------------

    procedure AddNeuron (net : in out NNet_Interface'Class; NR : NeuronRec; idx : out NeuronIndex) is
        newNR : NeuronRec := NR;
    begin
        net.NewNeuron(idx);
        newNR.idx := idx;
        net.SetNeuron(newNR);
    end AddNeuron;

    procedure AddNeuron (net : in out NNet_Interface'Class; NR : NeuronRec) is
        newNR : NeuronRec := NR;
        idx : NeuronIndex_Base;
    begin
        net.NewNeuron(idx);
        newNR.idx := idx;
        net.SetNeuron(newNR);
    end AddNeuron;

    function AddNeuron (net : in out NNet_Interface'Class; NR : NeuronRec) return NeuronIndex is
        idx : NeuronIndex_Base;
    begin
        net.AddNeuron(NR,idx);
        return idx;
    end AddNeuron;

    procedure AddNeuron (net : in out NNet_Interface'Class; activat : ActivationType;
                        connects : InConArray; idx : out NeuronIndex) is
        NR : NeuronRec(Nin=>connects'Last) :=
            ( idx=>1, lag=>0.0,
            Nin => connects'Last,
            activat=>activat,
            weights => (others=>0.0),
            inputs  => connects );
    begin
        net.AddNeuron(NR,idx);
    end AddNeuron;

    procedure AddNeuron (net : in out NNet_Interface'Class; activat : ActivationType;
                        connects : InConArray) is
        idx : NeuronIndex_Base;
    begin
        net.AddNeuron(activat,connects,idx);
    end AddNeuron;

    function AddNeuron (net : in out NNet_Interface'Class; activat : ActivationType;
                        connects : InConArray) return NeuronIndex is
        idx : NeuronIndex_Base;
    begin
        net.AddNeuron(activat, connects,idx);
        return idx;
    end AddNeuron;


    -----------------
    -- ResetNeuron --
    -----------------

    procedure ResetNeuron (net : in out NNet_Interface'Class; NR : NeuronRec) is
    begin
        net.SetNeuron(NR);
    end ResetNeuron;

    procedure ResetNeuron (net : in out NNet_Interface'Class; idx  : NeuronIndex;
                            activat : ActivationType; connects : InConArray) is
        NR : NeuronRec(Nin=>connects'Last) :=
            ( idx=>idx, lag=>0.0,
                Nin => connects'Last,
                activat=>activat,
                weights => (others=>0.0),
                inputs  => connects );
    begin
        net.SetNeuron(NR);
    end ResetNeuron;

    procedure ResetNeuron (net : in out NNet_Interface'Class; idx  : NeuronIndex;
                            connects : InConArray) is
        NR : NeuronRec(Nin=>connects'Last) :=
            ( idx => idx, lag => 0.0,
                Nin => connects'Last,
                activat => net.GetNeuron(idx).activat,
                weights => (others=>0.0),
                inputs  => connects );
    begin
        net.ResetNeuron(NR);
    end ResetNeuron;

    ---------------------------
    -- ReconnectNeuronRandom --
    ---------------------------

    procedure ReconnectNeuronRandom (net : in out NNet_Interface'Class; idx  : NeuronIndex;
                                    maxConnects : InputIndex_Base := 0) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "ReconnectNeuronRandom unimplemented");
        raise Program_Error with "Unimplemented procedure ReconnectNeuronRandom";
    end ReconnectNeuronRandom;

    --------------------
    -- PopulateRandom --
    --------------------

    procedure PopulateRandom (net : in out NNet_Interface'Class; maxConnects : InputIndex;
                                Npts : NeuronIndex_Base := 0) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "PopulateRandom unimplemented");
        raise Program_Error with "Unimplemented procedure PopulateRandom";
    end PopulateRandom;


    function ForwardProp(net : NNet_Interface'Class; inputs : InputArray) return OutputArray is
        Stub : OutputArray(1 .. net.GetNOutputs) := (others=>0.0);
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "PopulateRandom unimplemented");
        raise Program_Error with "Unimplemented procedure PopulateRandom";
        return Stub;
    end;



        -----------------------------
    -- ReconnectNeuronAtRandom --
    -----------------------------

    procedure ReconnectNeuronAtRandom
        (net : in out NNet_Interface'Class;
        idx  : NeuronIndex;
        maxConnects : InputIndex_Base := 0)
    is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "ReconnectNeuronAtRandom unimplemented");
        raise Program_Error with "Unimplemented procedure ReconnectNeuronAtRandom";
    end ReconnectNeuronAtRandom;

    ----------------------
    -- PopulateAtRandom --
    ----------------------

    procedure PopulateAtRandom
        (net : in out NNet_Interface'Class;
        maxConnects : InputIndex;
        Npts : NeuronIndex_Base := 0)
    is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "PopulateAtRandom unimplemented");
        raise Program_Error with "Unimplemented procedure PopulateAtRandom";
    end PopulateAtRandom;


    -------------------------------
    -- Topological Sorting

    procedure SortForward (net : in out NNet_Interface'Class) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "SortForward unimplemented");
        raise Program_Error with "Unimplemented procedure SortForward";
    end SortForward;

    procedure SortBackward (net : in out NNet_Interface'Class) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "SortBackward unimplemented");
        raise Program_Error with "Unimplemented procedure SortBackward";
    end SortBackward;

    ----------------------------------------
    -- Actual calculations

    function  ProcessInputs(net : NNet_Interface'Class; inputs : ValueArray) return ValueArray is
    begin
        -- check dimensions
        if inputs.Length != net.GetNInputs then
            raise DataWidthMismatch;
        end if;
        if not net.LayersReady then
            raise UnsortedNetPropagation;
        end if;
        -- first set the inputs in net
        for li in 1 .. net.GetNLayers loop
            declare
                L : Layer_Interface'Class := net.GetLayer(li);
                V : PL.ValueArray := L.PropForward()
            begin
                L.PropForward;
            end;
        end loop;
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "ProcessInputs unimplemented");
        return raise Program_Error with "Unimplemented function ProcessInputs";
    end ProcessInputs;



    procedure PropLayerForward (net : NNet_Interface'Class; idx : LayerIndex; propType : PropagationType := Matrix) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "ProcessInputs unimplemented");
        raise Program_Error with "Unimplemented function ProcessInputs";
    end PropLayerForward;

    procedure PropLayerBackward(net : NNet_Interface'Class; idx : LayerIndex; propType : PropagationType := Matrix) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "SortForward unimplemented");
        raise Program_Error with "Unimplemented procedure SortForward";
    end PropLayerBackward;

    procedure PLFIndividual(net : NNet_Interface'Class; idx : LayerIndex) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "SortForward unimplemented");
        raise Program_Error with "Unimplemented procedure SortForward";
    end PLFIndividual;

    procedure PLFMatrix    (net : NNet_Interface'Class; idx : LayerIndex) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "SortForward unimplemented");
        raise Program_Error with "Unimplemented procedure SortForward";
    end PLFMatrix;

    procedure PLFGPU       (net : NNet_Interface'Class; idx : LayerIndex) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "SortForward unimplemented");
        raise Program_Error with "Unimplemented procedure SortForward";
    end PLFGPU;



end wann.nets;
