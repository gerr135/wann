pragma Ada_2012;

with Ada.Numerics.Float_Random;

package body wann.neurons.vectors is

    ----------------
    -- To/FromRec --
    --
    overriding
    function ToRepr (neur : Neuron) return NeuronRepr is
        NR : NeuronRepr(Ni => InputIndex_Base (neur.inputs.Length),
                       No => OutputIndex_Base(neur.outputs.Length));
    begin
        NR.idx     := neur.idx;
        NR.activat := neur.activat;
        NR.lag     := 0.0;
        -- assign inputs/weights - this is the most inefficient part,
        -- but should only be used on construction/topology change.
        NR.weights(0) := neur.weights(0);
        for i in 1 .. NR.Ni loop
            NR.weights(i) := neur.weights(i);
            NR.inputs(i)  := neur.inputs(i);
        end loop;
        --
        return NR;
    end ToRepr;

    overriding
    procedure FromRepr (NI : in out Neuron; LR : NeuronRepr) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "FromRec unimplemented");
        raise Program_Error with "Unimplemented procedure FromRec";
    end FromRepr;

    -------------------
    -- Add/DelOutput --
    --
    overriding
    procedure Add_Output (neur : in out Neuron; Output : NN.ConnectionIndex) is
    begin
        neur.outputs.Append(Output);
    end Add_Output;

    overriding
    procedure Del_Output (neur : in out Neuron; Output : NN.ConnectionIndex) is
        -- unclear how the calls should be made - del by index or NN index
        -- may need to change interface
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "DelOutput unimplemented");
        raise Program_Error with "Unimplemented procedure DelOutput";
    end Del_Output;

    ------------------
    -- NInputs/Outputs
    --
    overriding
    function NInputs (neur : Neuron) return InputIndex is
    begin
        return InputIndex_Base(neur.inputs.Length);
    end NInputs;

    overriding
    function NOutputs (neur : Neuron) return OutputIndex is
    begin
        return OutputIndex_Base(neur.outputs.Length);
    end NOutputs;

    --------------------------
    -- Input/Output getters --
    --
    overriding
    function Input (neur : Neuron; idx : InputIndex) return NN.ConnectionIndex is
    begin
        return neur.inputs.Element(idx);
    end Input;

    overriding
    function Output (neur : Neuron; idx : OutputIndex) return NN.ConnectionIndex is
    begin
        return neur.outputs.Element(idx);
    end Output;

    ------------
    -- Create --
    ------------

    not overriding
    function Create (NR : NeuronRec) return Neuron is
        neur : Neuron;
    begin
        neur.idx := NR.idx;
        neur.activat := NR.activat;
        neur.lag := 0.0;
        -- populate inputs and weights vectors
        for i in NR.inputs'Range loop
            neur.inputs.Append(NR.inputs(i));
        end loop;
        for w in NR.weights'Range loop
            neur.weights.Append(NR.weights(w));
        end loop;
        return neur;
    end Create;

    not overriding
    function Create(activation : Activation_Type;
                    connections : Input_Connection_Array;
                    weights  : Weight_Array) return Neuron
    is
        neur : Neuron;
    begin
        neur.idx := 0;
        neur.activat := activation;
        neur.lag := 0.0;
        -- populate inputs and weights vectors
        for i in connections'Range loop
            neur.inputs.Append(connections(i));
        end loop;
        for w in weights'Range loop
            neur.weights.Append(weights(w));
        end loop;
        return neur;
    end Create;

    not overriding
    function Create(activation : Activation_Type;
                    connections : NN.Input_Connection_Array;
                    maxWeight : Real) return Neuron
    is
        neur : Neuron;
        G : Ada.Numerics.Float_Random.Generator;
        use Ada.Numerics.Float_Random;
    begin
        neur.idx := 0;
        neur.activat := activation;
        neur.lag := 0.0;
        -- populate inputs and weights vectors
        for i in connections'Range loop
            neur.inputs.Append(connections(i));
        end loop;
        -- generate random weights
        Reset(G);
        for w in 0 .. neur.NInputs loop
            neur.weights.Append(Real(Random(G)) * maxWeight);
        end loop;
        return neur;
    end Create;

end wann.neurons.vectors;
