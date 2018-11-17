pragma Ada_2012;
package body wann.nets.mutable is


    --------------------------------
    -- Dimension getters
    overriding
    function GetNInputs (net : NNet_Mutable) return InputIndex is
    begin
        return InputIndex(net.inputs.Length);
    end;

    overriding
    function GetNOutputs(net : NNet_Mutable) return OutputIndex is
    begin
        return OutputIndex(net.Outputs.Length);
    end;


    overriding
    function GetNNeurons(net : NNet_Mutable) return NeuronIndex is
    begin
        return NeuronIndex(net.neurons.Length);
    end;



   -----------------------
   -- Constructor(s)
    function Create (Nin : InputIndex; Nout : OutputIndex) return NNet_Mutable is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "Create unimplemented");
        return raise Program_Error with "Unimplemented function Create";
    end Create;

   -----------------------------
   -- neuron handling
    overriding
    procedure NewNeuron (net : in out NNet_Mutable; idx : out NeuronIndex_Base) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "NewNeuron unimplemented");
        raise Program_Error with "Unimplemented procedure NewNeuron";
    end NewNeuron;

    overriding
    procedure DelNeuron (net : in out NNet_Mutable; idx : NeuronIndex) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "DelNeuron unimplemented");
        raise Program_Error with "Unimplemented procedure DelNeuron";
    end DelNeuron;

    overriding
    function  GetNeuron(net : NNet_Mutable; idx : NeuronIndex) return NeuronRec is
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


    -------------------------------------------------------
    -- layer handling
    overriding
    function  GetLayer(net : in NNet_Mutable;     idx : LayerIndex) return LayerRec is
    begin
        return net.layers.element(idx);
    end;

    overriding
    procedure SetLayer(net : in out NNet_Mutable; idx : LayerIndex; LR :   LayerRec) is
    begin
        net.layers.Replace_Element(idx, LR);
    end;


    
end wann.nets.mutable;
