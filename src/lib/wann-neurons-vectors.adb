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
        NR.lag     := neur.lag;
        -- assign inputs/weights - this is the most inefficient part,
        -- but should only be used on construction/topology change.
        NR.weights(0) := neur.weights(0);
        for i in 1 .. NR.Ni loop
            NR.weights(i) := neur.weights(i);
            NR.inputs(i)  := neur.inputs(i);
        end loop;
        for o in 1 .. NR.No loop
            NR.outputs(o)  := neur.outputs(o);
        end loop;
        --
        return NR;
    end ToRepr;

    overriding
    procedure FromRepr (neur : in out Neuron; NR : NeuronRepr) is
    begin
        neur.idx     := NR.idx;
        neur.activat := NR.activat;
        neur.lag     := NR.lag;
        -- assign inputs/weights
        neur.weights(0) := NR.weights(0);
        for i in 1 .. NR.Ni loop
            neur.weights(i) := NR.weights(i);
            neur.inputs(i)  := NR.inputs(i);
        end loop;
        for o in 1 .. NR.No loop
            neur.outputs(o)  := NR.outputs(o);
        end loop;
        --
    end FromRepr;

    ----------------------------
    -- Add/Del inputs and output
    --
    --  NOTE: these are Neuron primitives, only operate on this individual neuron
    --  other side of connections is updated by the enclosing NNet
    overriding
    procedure Add_Input (neur : in out Neuron; Input : NN.ConnectionIndex) is
    begin
        for i of neur.inputs loop
            -- ensure that passed connection is not a duplicate
            if i = Input then
                raise PCN.Duplicate_Connection;
            end if;
        end loop;
        neur.inputs.Append(Input);
    end Add_Input;

    overriding
    procedure Del_Input (neur : in out Neuron; Input : NN.ConnectionIndex) is
        -- same logic as in connectors.vectors
    begin
        -- search for the connection
        for i in 1 .. InputIndex(neur.inputs.Length) loop
            -- ensure that passed connection is not a duplicate
            if neur.inputs(i) = Input then
                neur.inputs.Delete(i);
                return;
            end if;
        end loop;
        -- if we got here, connection was not found
        raise PCN.Connection_Not_Found;
    end Del_Input;


    ------------------
    -- Inputs handling
    --
    overriding
    function NInputs (neur : Neuron) return InputIndex is
    begin
        return InputIndex_Base(neur.inputs.Length);
    end NInputs;

    overriding
    function Input (neur : Neuron; idx : InputIndex) return NN.ConnectionIndex is
    begin
        return neur.inputs.Element(idx);
    end Input;

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
                    connections : Input_Connection_Array;
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
