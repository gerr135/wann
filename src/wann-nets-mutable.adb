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
   -- Getter and setter --
   ---------------

    overriding
    function  GetNeuron(net : NNet_Mutable; idx : NNIndex) return NeuronRec is
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
    procedure SetNeuron (net : in out NNet_Mutable; neur : NeuronRec) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "SetNeuron unimplemented");
        raise Program_Error with "Unimplemented procedure SetNeuron";
    end SetNeuron;

end wann.nets.mutable;
