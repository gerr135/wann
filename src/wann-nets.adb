pragma Ada_2012;
package body wann.nets is

    ---------------
    -- AddNeuron --
    ---------------

    procedure AddNeuron (net : in out NNet'Class; NR : NeuronRec; idx : out NeuronIndex) is
        newNR : NeuronRec := NR;
    begin
        net.NewNeuron(idx);
        newNR.idx := idx;
        net.SetNeuron(newNR);
    end AddNeuron;

    procedure AddNeuron (net : in out NNet'Class; NR : NeuronRec) is
        newNR : NeuronRec := NR;
        idx : NeuronIndex_Base;
    begin
        net.NewNeuron(idx);
        newNR.idx := idx;
        net.SetNeuron(newNR);
    end AddNeuron;

    function AddNeuron (net : in out NNet'Class; NR : NeuronRec) return NeuronIndex is
        idx : NeuronIndex_Base;
    begin
        net.AddNeuron(NR,idx);
        return idx;
    end AddNeuron;

    procedure AddNeuron (net : in out NNet'Class; activat : ActivationType;
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

    procedure AddNeuron (net : in out NNet'Class; activat : ActivationType;
                        connects : InConArray) is
        idx : NeuronIndex_Base;
    begin
        net.AddNeuron(activat,connects,idx);
    end AddNeuron;

    function AddNeuron (net : in out NNet'Class; activat : ActivationType;
                        connects : InConArray) return NeuronIndex is
        idx : NeuronIndex_Base;
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

    procedure ResetNeuron (net : in out NNet'Class; idx  : NeuronIndex;
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

    procedure ResetNeuron (net : in out NNet'Class; idx  : NeuronIndex;
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

    procedure ReconnectNeuronRandom (net : in out NNet'Class; idx  : NeuronIndex;
                                    maxConnects : InputIndex_Base := 0) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "ReconnectNeuronRandom unimplemented");
        raise Program_Error with "Unimplemented procedure ReconnectNeuronRandom";
    end ReconnectNeuronRandom;

    --------------------
    -- PopulateRandom --
    --------------------

    procedure PopulateRandom (net : in out NNet'Class; maxConnects : InputIndex;
                                Npts : NeuronIndex_Base := 0) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "PopulateRandom unimplemented");
        raise Program_Error with "Unimplemented procedure PopulateRandom";
    end PopulateRandom;


    function ForwardProp(net : NNet'Class; inputs : InputArray) return OutputArray is
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
     (net : in out NNet'Class;
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
     (net : in out NNet'Class;
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

   procedure SortForward (net : in out NNet'Class) is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "SortForward unimplemented");
      raise Program_Error with "Unimplemented procedure SortForward";
   end SortForward;

   ------------------
   -- SortBackward --
   ------------------

   procedure SortBackward (net : in out NNet'Class) is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "SortBackward unimplemented");
      raise Program_Error with "Unimplemented procedure SortBackward";
   end SortBackward;

   -------------------
   -- ProcessInputs --
   -------------------

   function ProcessInputs
     (net : NNet'Class;
      inputs : InputArray)
      return OutputArray
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "ProcessInputs unimplemented");
      return raise Program_Error with "Unimplemented function ProcessInputs";
   end ProcessInputs;

end wann.nets;
