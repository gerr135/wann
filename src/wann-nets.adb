pragma Ada_2012;
package body wann.nets is

    ---------------
    -- AddNeuron --
    ---------------

    function AddNeuron (net : in out NNet'Class; neur : NeuronRec) return NNIndex is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "AddNeuron unimplemented");
        return raise Program_Error with "Unimplemented function AddNeuron";
    end AddNeuron;

    ---------------
    -- AddNeuron --
    ---------------

    procedure AddNeuron (net : in out NNet'Class; neur : NeuronRec; idx : out NNIndex) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "AddNeuron unimplemented");
        raise Program_Error with "Unimplemented procedure AddNeuron";
    end AddNeuron;

    ---------------
    -- AddNeuron --
    ---------------

    procedure AddNeuron (net : in out NNet'Class; neur : NeuronRec) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "AddNeuron unimplemented");
        raise Program_Error with "Unimplemented procedure AddNeuron";
    end AddNeuron;

    ---------------
    -- AddNeuron --
    ---------------

    function AddNeuron (net : in out NNet'Class; activat : ActivationType;
                        connects : InputsArray) return NNIndex is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "AddNeuron unimplemented");
        return raise Program_Error with "Unimplemented function AddNeuron";
    end AddNeuron;

    ---------------
    -- AddNeuron --
    ---------------

    procedure AddNeuron (net : in out NNet'Class; activat : ActivationType;
                        connects : InputsArray; idx : out NNIndex) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "AddNeuron unimplemented");
        raise Program_Error with "Unimplemented procedure AddNeuron";
    end AddNeuron;

    ---------------
    -- AddNeuron --
    ---------------

    procedure AddNeuron (net : in out NNet'Class; activat : ActivationType;
                        connects : InputsArray) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "AddNeuron unimplemented");
        raise Program_Error with "Unimplemented procedure AddNeuron";
    end AddNeuron;

    -----------------
    -- ResetNeuron --
    -----------------

    procedure ResetNeuron (net : in out NNet'Class; neur : NeuronRec) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "ResetNeuron unimplemented");
        raise Program_Error with "Unimplemented procedure ResetNeuron";
    end ResetNeuron;

    -----------------
    -- ResetNeuron --
    -----------------

    procedure ResetNeuron (net : in out NNet'Class; idx  : NNIndex;
                            activat : ActivationType; connects : InputsArray) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "ResetNeuron unimplemented");
        raise Program_Error with "Unimplemented procedure ResetNeuron";
    end ResetNeuron;

    -----------------
    -- ResetNeuron --
    -----------------

    procedure ResetNeuron (net : in out NNet'Class; idx  : NNIndex;
                            connects : InputsArray) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "ResetNeuron unimplemented");
        raise Program_Error with "Unimplemented procedure ResetNeuron";
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

end wann.nets;
