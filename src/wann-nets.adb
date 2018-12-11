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


    ---------------------------------------------------------
    -- propagators
    ----------------

    ----------------------------------------------
    -- Stateless forward prop
    --
    function  CalcOutputs  (net : NNet_Interface'Class; NSV : NNet_CheckedStateVector) return NNet_OutputArray is
        outputs : NNet_OutConnArray := net.GetOutputConnections;
--         inputs  : NNet_InConnArray  := net.GetInputConnections;
        results : NNet_OutputArray(1 .. outputs'Last);
    begin
        for i in results'Range loop
            if outputs(i).T = N then
                if not NSV.validN(outputs(i).Nidx) then
                    -- replace with Assert?
                    raise UnsetValueAccess;
                end if;
                results(i) := NSV.neuron(outputs(i).Nidx);
            else
                if not NSV.validI(outputs(i).Iidx) then
                    -- replace with Assert?
                    raise UnsetValueAccess;
                end if;
                results(i) := NSV.input(outputs(i).Iidx);
            end if;
        end loop;
        return results;
    end CalcOutputs;

    function  CalcOutputs  (net : NNet_Interface'Class; NSV : NNet_StateVector) return NNet_OutputArray is
        outputs : NNet_OutConnArray := net.GetOutputConnections;
        --         inputs  : NNet_InConnArray  := net.GetInputConnections;
        results : NNet_OutputArray(1 .. outputs'Last);
    begin
        for i in results'Range loop
            if outputs(i).T = N then
                results(i) := NSV.neuron(outputs(i).Nidx);
            else
                results(i) := NSV.input(outputs(i).Iidx);
            end if;
        end loop;
        return results;
    end CalcOutputs;

    function PropForward(net : NNet_Interface'Class; IV : NNet_InputArray) return NNet_OutputArray is
        -- this is a stateless prop version. All intermidiate data kept and updated locally
        -- NOTE: layers can be interconnected in arbitrary way, to absolutely any neurons,
        -- so we need to pass a complete state around.
    begin
        -- check dimensions and if net has already been sorted
        if IV'Length /= net.GetInputConnections'Length then
            raise DataWidthMismatch;
        end if;
        if not net.LayersReady then
            raise UnsortedNetPropagation;
        end if;
        --
        declare
            -- 1st layer is a special case (as we do not use dumb pass-through neurons as inputs)
            -- there should always be at least 1
            L : PL.Layer_Interface'Class := net.GetLayer(1);
            -- we also need a nnet value vector
            netState : NNet_CheckedStateVector(Ni=>net.GetInputConnections'Length,
                                               Nn=>net.GetNNeurons,
                                               No=>net.GetOutputConnections'Length);
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
    end PropForward;


    ---------------------------
    -- cached propagation
    function  GetInputValues(net : Cached_NNet_Interface'Class)      return NNet_InputArray is
        netState : NNet_StateVector:= net.GetNNetState;
    begin
        return netState.input;
    end;

    procedure SetInputValues(net : in out Cached_NNet_Interface'Class; IV : NNet_InputArray) is
        -- we only reassign the inputs, keep the other values untouched
        netState : NNet_StateVector:= net.GetNNetState;
    begin
        netState.input := IV;
        net.SetNNetState(netState);
    end;



    ---------------------------
    -- stateful propagation
    function  CalcOutputs(net : Stateful_NNet_Interface'Class) return NNet_OutputArray is
        outputs : NNet_OutConnArray := net.GetOutputConnections;
        inValues : NNet_InputArray := net.GetInputValues;
        results  : NNet_OutputArray(1 .. outputs'Last);
        neur : PN.Stateful_NeuronClass_Access;
    begin
        for i in results'Range loop
            if outputs(i).T = N then
                neur := net.GetNeuron(outputs(i).Nidx);
                if not neur.valid then
                    -- replace with Assert?
                    raise UnsetValueAccess;
                end if;
                results(i) := neur.GetValue;
            else
                results(i) := inValues(outputs(i).Iidx);
            end if;
        end loop;
        return results;
    end;

    function  PropForward(net : Stateful_NNet_Interface'Class) return NNet_OutputArray is
    begin
        for L of net.layers loop
            L.PropForward;
        end loop;
        return net.CalcOutputs;
    end;



end wann.nets;
