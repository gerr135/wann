pragma Ada_2012;
package body wann.nets is

    ---------------
    -- AddNeuron --
    ---------------

    procedure AddNeuron (net : in out NNet'Class; NR : NeuronRec; idx : out NNIndex) is
        newNR : NeuronRec := NR;
    begin
        net.NewNeuron(idx);
        newNR.idx := idx;
        net.SetNeuron(newNR);
    end AddNeuron;

    procedure AddNeuron (net : in out NNet'Class; NR : NeuronRec) is
        newNR : NeuronRec := NR;
        idx : NNIndex_Base;
    begin
        net.NewNeuron(idx);
        newNR.idx := idx;
        net.SetNeuron(newNR);
    end AddNeuron;

    function AddNeuron (net : in out NNet'Class; NR : NeuronRec) return NNIndex is
        idx : NNIndex_Base;
    begin
        net.AddNeuron(NR,idx);
        return idx;
    end AddNeuron;

    procedure AddNeuron (net : in out NNet'Class; activat : ActivationType;
                        connects : ConnectArray; idx : out NNIndex) is
        NR : NeuronRec(Nin=>connects'Last) :=
            ( idx=>1, lag=>0.0,
              Nin => connects'Last,
              activat=>activat,
              weights => (others=>0.0),
              inputs  => connects );
    begin
        net.AddNeuron(NR,idx);
    end AddNeuron;

    procedure AddNeuron (net : in out NNet'Class; activat : ActivationType;
                        connects : ConnectArray) is
        idx : NNIndex_Base;
    begin
        net.AddNeuron(activat,connects,idx);
    end AddNeuron;

    function AddNeuron (net : in out NNet'Class; activat : ActivationType;
                        connects : ConnectArray) return NNIndex is
        idx : NNIndex_Base;
    begin
        net.AddNeuron(activat, connects,idx);
        return idx;
    end AddNeuron;


    -----------------
    -- ResetNeuron --
    -----------------

    procedure ResetNeuron (net : in out NNet'Class; NR : NeuronRec) is
    begin
        net.SetNeuron(NR);
    end ResetNeuron;

    procedure ResetNeuron (net : in out NNet'Class; idx  : NNIndex;
                           activat : ActivationType; connects : ConnectArray) is
        NR : NeuronRec(Nin=>connects'Last) :=
            ( idx=>idx, lag=>0.0,
              Nin => connects'Last,
              activat=>activat,
              weights => (others=>0.0),
              inputs  => connects );
    begin
        net.SetNeuron(NR);
    end ResetNeuron;

    procedure ResetNeuron (net : in out NNet'Class; idx  : NNIndex;
                            connects : ConnectArray) is
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

    procedure ReconnectNeuronRandom (net : in out NNet'Class; idx  : NNIndex;
                                    maxConnects : NIndex_Base := 0) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "ReconnectNeuronRandom unimplemented");
        raise Program_Error with "Unimplemented procedure ReconnectNeuronRandom";
    end ReconnectNeuronRandom;

    --------------------
    -- PopulateRandom --
    --------------------

    procedure PopulateRandom (net : in out NNet'Class; maxConnects : NIndex;
                                Npts : NNIndex_Base := 0) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "PopulateRandom unimplemented");
        raise Program_Error with "Unimplemented procedure PopulateRandom";
    end PopulateRandom;


    function ForwardProp(net : NNet'Class; inputs : InputArray) return OutputArray is
        Stub : OutputArray(1 .. net.No) := (others=>0.0);
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "PopulateRandom unimplemented");
        raise Program_Error with "Unimplemented procedure PopulateRandom";
        return Stub;
    end;

end wann.nets;
