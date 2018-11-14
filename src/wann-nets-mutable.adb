pragma Ada_2012;
package body wann.nets.mutable is

   ------------
   -- Create --
   ------------

    function Create (Nin : InputIndex; Nout : OutputIndex) return NNet_Mutable is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "Create unimplemented");
        return raise Program_Error with "Unimplemented function Create";
    end Create;

   ---------------
   -- NewNeuron --
   ---------------

    overriding
    procedure NewNeuron (net : in out NNet_Mutable; idx : out NNIndex_Base) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "NewNeuron unimplemented");
        raise Program_Error with "Unimplemented procedure NewNeuron";
    end NewNeuron;

   ---------------
   -- DelNeuron --
   ---------------

    overriding
    procedure DelNeuron (net : in out NNet_Mutable; idx : NNIndex) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "DelNeuron unimplemented");
        raise Program_Error with "Unimplemented procedure DelNeuron";
    end DelNeuron;

   ---------------
   -- SetNeuron --
   ---------------

    overriding
    procedure SetNeuron (net : in out NNet_Mutable; neur : NeuronRec) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "SetNeuron unimplemented");
        raise Program_Error with "Unimplemented procedure SetNeuron";
    end SetNeuron;

end wann.nets.mutable;
