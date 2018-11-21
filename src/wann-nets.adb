pragma Ada_2012;
package body wann.nets is

    ---------------
    -- AddNeuron --
    ---------------

    procedure AddNeuron (net : in out NNet_Interface'Class; NR : PN.NeuronRec; 
                         idx : out NeuronIndex) is
        newNR : PN.NeuronRec := NR;
    begin
        net.NewNeuron(idx);
        newNR.idx := idx;
        -- net.SetNeuron(newNR);
        pragma Compile_Time_Warning (Standard.True, "AddNeuron unimplemented");
        raise Program_Error with "Unimplemented function AddNeuron";
    end AddNeuron;

    procedure AddNeuron (net : in out NNet_Interface'Class; NR : PN.NeuronRec) is
        -- keep the code centralized: just call above variant and discard extra index
        idx : NeuronIndex_Base;
    begin
        net.AddNeuron(NR, idx);
    end AddNeuron;

    function AddNeuron (net : in out NNet_Interface'Class; 
                        NR : PN.NeuronRec) return NeuronIndex is
        idx : NeuronIndex_Base;
    begin
        net.AddNeuron(NR,idx);
        return idx;
    end AddNeuron;

    procedure AddNeuron (net : in out NNet_Interface'Class; activat : ActivationType; 
                         connects : PN.InConnArray; idx : out NeuronIndex) is
        --
        NR : PN.NeuronRec(Nin=>connects'Last) := (
            idx=>1, lag=>0.0,
            Nin => connects'Last,
            activat=>activat,
            weights => (others=>0.0),
            inputs  => connects );
    begin
        net.AddNeuron(NR,idx);
    end AddNeuron;

    procedure AddNeuron (net : in out NNet_Interface'Class; activat : ActivationType; 
                         connects : PN.InConnArray) is
        --
        idx : NeuronIndex_Base;
    begin
        net.AddNeuron(activat,connects,idx);
    end AddNeuron;

    function AddNeuron (net : in out NNet_Interface'Class; activat : ActivationType; 
                        connects : PN.InConnArray) return NeuronIndex is
        --
        idx : NeuronIndex_Base;
    begin
        net.AddNeuron(activat, connects,idx);
        return idx;
    end AddNeuron;

    
    -----------------
    -- ResetNeuron --
    -----------------

    procedure ResetNeuron (net : in out NNet_Interface'Class; NR  : PN.NeuronRec) is
    begin
--         net.SetNeuron(NR);
        pragma Compile_Time_Warning (Standard.True, "ReconnectNeuronAtRandom unimplemented");
        raise Program_Error with "Unimplemented procedure ReconnectNeuronAtRandom";
    end ResetNeuron;

    procedure ResetNeuron (net : in out NNet_Interface'Class; idx : NeuronIndex; 
                           activat : ActivationType; connects : PN.InConnArray) is
        --
        NR : PN.NeuronRec(Nin=>connects'Last) := ( 
            idx=>idx, lag=>0.0,
            Nin => connects'Last,
            activat=>activat,
            weights => (others=>0.0),
            inputs  => connects );
    begin
        net.ResetNeuron(NR);
    end ResetNeuron;

    procedure ResetNeuron (net : in out NNet_Interface'Class; idx : NeuronIndex; 
                           connects : PN.InConnArray) is
        --
        NR : PN.NeuronRec(Nin=>connects'Last) := ( 
            idx => idx, lag => 0.0,
            Nin => connects'Last,
            activat => net.GetNeuron(idx).activat,
            weights => (others=>0.0),
            inputs  => connects );
    begin
        net.ResetNeuron(NR);
    end ResetNeuron;

    
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

    -----------------
    -- SortForward --
    -----------------

    procedure SortForward (net : in out NNet_Interface'Class) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "SortForward unimplemented");
        raise Program_Error with "Unimplemented procedure SortForward";
    end SortForward;

    ------------------
    -- SortBackward --
    ------------------

    procedure SortBackward (net : in out NNet_Interface'Class) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "SortBackward unimplemented");
        raise Program_Error with "Unimplemented procedure SortBackward";
    end SortBackward;

    -------------------
    -- ProcessInputs --
    -------------------

    function ProcessInputs (net : NNet_Interface'Class; V : ValueArray) return ValueArray is
        -- this is a stateless prop version. All intermidiate data passed locally
    begin
        -- check dimensions
        if V'Length /= net.GetNInputs then
            raise DataWidthMismatch;
        end if;
        if not net.LayersReady then
            raise UnsortedNetPropagation;
        end if;
        --
        for li in 1 .. net.GetNLayers loop
            declare
                -- need to dynamically pass layers and data vectors
                L : PL.Layer_Interface'Class := net.GetLayer(li);
                V : PL.ValueArray := L.PropForward;
            begin
                L.PropForward;
            end;
        end loop;
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "ProcessInputs unimplemented");
        return raise Program_Error with "Unimplemented function ProcessInputs";
    end ProcessInputs;

    -------------------
    -- ProcessInputs --
    -------------------

    procedure ProcessInputs (net : NNet_Interface'Class) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "ProcessInputs unimplemented");
        raise Program_Error with "Unimplemented procedure ProcessInputs";
    end ProcessInputs;

    -----------------
    -- ReadOutputs --
    -----------------

    function ReadOutputs (net : NNet_Interface'Class) return ValueArray is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "ReadOutputs unimplemented");
        return raise Program_Error with "Unimplemented function ReadOutputs";
    end ReadOutputs;

end wann.nets;
