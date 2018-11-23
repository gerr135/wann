pragma Ada_2012;
package body wann.nets is

    ---------------
    -- AddNeuron --
    ---------------

    procedure AddNeuron (net : in out NNet_Interface'Class; NR : PN.NeuronRec;
                         idx : out NNet_NeuronIndex) is
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
        idx : NNet_NeuronIndex_Base;
    begin
        net.AddNeuron(NR, idx);
    end AddNeuron;

    function AddNeuron (net : in out NNet_Interface'Class;
                        NR : PN.NeuronRec) return NNet_NeuronIndex is
        idx : NNet_NeuronIndex_Base;
    begin
        net.AddNeuron(NR,idx);
        return idx;
    end AddNeuron;

    procedure AddNeuron (net : in out NNet_Interface'Class; activat : ActivationType;
                         connects : PN.InConnArray; idx : out NNet_NeuronIndex) is
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
        idx : NNet_NeuronIndex_Base;
    begin
        net.AddNeuron(activat,connects,idx);
    end AddNeuron;

    function AddNeuron (net : in out NNet_Interface'Class; activat : ActivationType;
                        connects : PN.InConnArray) return NNet_NeuronIndex is
        --
        idx : NNet_NeuronIndex_Base;
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

    procedure ResetNeuron (net : in out NNet_Interface'Class; idx : NNet_NeuronIndex;
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

    procedure ResetNeuron (net : in out NNet_Interface'Class; idx : NNet_NeuronIndex;
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

    procedure ReconnectNeuronAtRandom (net : in out NNet_Interface'Class;
                idx  : NNet_NeuronIndex; maxConnects : PN.InputIndex_Base := 0) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "ReconnectNeuronAtRandom unimplemented");
        raise Program_Error with "Unimplemented procedure ReconnectNeuronAtRandom";
    end ReconnectNeuronAtRandom;

    ----------------------
    -- PopulateAtRandom --
    ----------------------

    procedure PopulateAtRandom (net : in out NNet_Interface'Class;
                Npts : NNet_NeuronIndex_Base;  maxConnects : PN.InputIndex_Base := 0) is
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

    ----------------------------------------------
    -- Stateless forward prop
    --
    function  CalcOutputs  (net : NNet_Interface'Class; V : NNet_ValueArray) return NNet_OutputArray is
        -- NNet_ValueArray contais outputs of all neurons at given time
        -- NOTE: if there are pass-through straight input->output connections,
        -- this method will defer to GetInputs and will raise UnsetValueAccess
        -- if SetInputValues was not called first.
        -- In a sense it will cease being stateless, but will not create side-effects.
        outputs : NNet_OutConnArray := net.GetOutputConnections;
        inputs  : NNet_InConnArray  := net.GetInputConnections;
        results : NNet_OutputArray(1 .. outputs'Last);
    begin
        for i in results'Range loop
            if outputs(i).T = N then
                results(i) := V(outputs(i).Nidx);
            else
                declare
                    inVals : NNet_InputArray := net.GetInputValues;
                begin
                    results(i) := inVals(outputs(i).Iidx);
                end;
            end if;
        end loop;
        return results;
    end;

    function ProcessInputs (net : NNet_Interface'Class; V : NNet_InputArray) return NNet_OutputArray is
        -- this is a stateless prop version. All intermidiate data kept and updated locally
    begin
        -- check dimensions and if net has already been sorted
        if V'Length /= net.GetInputConnections'Length then
            raise DataWidthMismatch;
        end if;
        if not net.LayersReady then
            raise UnsortedNetPropagation;
        end if;
        --
        declare
            -- 1st layer is a special case (as we do not use dumb pass-through neurons as inputs)
            L : PL.Layer_Interface'Class := net.GetLayer(1);
            -- there should always be at least 1
            netState : NNet_ValueArray(1 .. net.GetNNeurons) := L.PropForward(V);
            -- NOTE: layers can be interconnected in arbitrary way, to absolutely any neurons,
            -- so we need to pass a complete state around.
            -- See note in Readme for more details..
            -- Also, with properly sorted net we should not need to check if values
            -- are already assigned. All should happen in proper order, saving us some checks.
            --
            -- NOTE 2: not gonna work in present form!!
            -- as neurons are connected indeed arbitrarily - layer2+ to inputs are possible
            -- we need to construct and pass around a complete NNet state, including inputs and neurons
            -- and *that one* needs to be passed to layers, not either inputs or neurons..
        begin
            for li in 2 .. net.GetNLayers loop
                -- main cycle - just propagate through all layers, updating net state
                L := net.GetLayer(li);
                netState := L.PropForward(netState);
            end loop;
            return net.calcOutputs(netState);
            -- outputs can be connected to arbitrary layer, so we cannot simply ask last layer
            -- to calc it. SHould be at the net level
        end; -- declare
    end ProcessInputs;


end wann.nets;
