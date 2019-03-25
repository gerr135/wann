pragma Ada_2012;

-- with Ada.Text_IO;

package body wann.neurons is

    --------------------------------------------------
    -- basic getters/setters (wrappers around FromRec)
    --
    function  ToRec  (NI : Neuron_Interface'Class) return NeuronRec is
        NRp : NeuronRepr := NI.ToRepr;
        NR : NeuronRec :=
            (Ni=>NRp.Ni, idx=> NRp.idx,
             activat => NRp.activat,
             lag     => 0.0,
             weights => NRp.weights,
             inputs  => NRp.inputs );
    begin
        return NR;
    end;

    function Index (NI : Neuron_Interface'Class) return NN.NeuronIndex is
    begin
        return NI.ToRec.idx;
    end Index;

    function Activation (NI : Neuron_Interface'Class) return Activation_Type is
    begin
        return NI.ToRec.activat;
    end Activation;

    function Weights (NI : Neuron_Interface'Class) return Weight_Array is
    begin
        return NI.ToRec.weights;
    end Weights;

    function Inputs (NI : Neuron_Interface'Class) return Input_Connection_Array is
    begin
        return NI.ToRec.inputs;
    end Inputs;

    function Outputs (NI : Neuron_Interface'Class) return Output_Connection_Array is
        outs : Output_Connection_Array(1 .. NI.NOutputs);
    begin
        for o in 1 .. NI.NOutputs loop
            outs(o) := NI.Output(o);
        end loop;
        return outs;
    end Outputs;


    --------------
    -- Settters
    --
    -- ATTN!! looks like this approach (resetting a field via converting back and forth
    -- through Rec representaition) is causing "errorneour memory access" at run time
    -- Should probably go back to individual primitives
    procedure Set_Index (NI : in out Neuron_Interface'Class;
        idx : NN.NeuronIndex)
    is
    begin
        GT.Trace(Debug, "NI.Set_Index" & idx'Img);
        declare
            NR : NeuronRepr := NI.ToRepr;
        begin
            NR.idx := idx;
            NI.FromRepr(NR);
        end;
        -- quite cumbersome. May be much better to make it primitive abstract overridable by specific implementation
    end Set_Index;

    procedure Set_Activation (NI : in out Neuron_Interface'Class;
                                activat : Activation_Type)
    is
        NR : NeuronRepr := NI.ToRepr;
    begin
        NR.activat := activat;
        NI.FromRepr(NR);
    end Set_Activation;

    procedure Set_Weights (NI : in out Neuron_Interface'Class;
                        weights : Weight_Array)
    is
        NR : NeuronRepr := NI.ToRepr;
    begin
        NR.weights := weights;
        NI.FromRepr(NR);
    end Set_Weights;

    procedure Set_Inputs
        (NI : in out Neuron_Interface'Class;
        inputs  : Input_Connection_Array)
    is
        NR : NeuronRepr := NI.ToRepr;
    begin
        NR.inputs := inputs;
        NI.FromRepr(NR);
    end Set_Inputs;


   -----------------
   -- PropForward --
   -----------------

    function Prop_Forward (neur : Neuron_Interface'Class; data  : Value_Array) return Real is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "PropForward unimplemented");
        return raise Program_Error with "Unimplemented function PropForward";
    end Prop_Forward;

    function  Prop_Forward(neur : Neuron_Interface'Class; inputs : NN.State_Vector)
        return NN.State_Vector
    is
        outputs : NN.State_Vector := inputs;
        Ni : InputIndex := neur.NInputs;
        data : Value_Array(1 .. Ni);
        result : Real;
    begin
        for i in 1 .. Ni loop
            data(i) := Get_Value(inputs, neur.Input(i));
        end loop;
        result := neur.Prop_Forward(data);
        for o in 1 .. neur.NOutputs loop
            Set_Value(outputs,neur.Output(o), result);
        end loop;
        return outputs;
    end;

    function  Prop_Forward(neur : Neuron_Interface'Class; inputs : NN.Checked_State_Vector)
        return NN.Checked_State_Vector
    is
        outputs : NN.Checked_State_Vector := inputs;
        Ni : InputIndex := neur.NInputs;
        data : Value_Array(1 .. Ni);
        result : Real;
    begin
        for i in 1 .. Ni loop
            data(i) := Get_Value(inputs, neur.Input(i));
        end loop;
        result := neur.Prop_Forward(data);
        for o in 1 .. neur.NOutputs loop
            Set_Value(outputs,neur.Output(o), result);
        end loop;
        return outputs;
    end;

    procedure Prop_Forward(neur : Neuron_Interface'Class; SV : in out NN.State_Vector) is
        data : Value_Array(1 .. neur.NInputs);
        result : Real;
    begin
        for i in 1 .. neur.NInputs loop
            data(i) := Get_Value(SV, neur.Input(i));
        end loop;
        result := neur.Prop_Forward(data);
        for o in 1 .. neur.NOutputs loop
            Set_Value(SV,neur.Output(o), result);
        end loop;
    end;

    procedure Prop_Forward(neur : Neuron_Interface'Class; SV : in out NN.Checked_State_Vector) is
        data : Value_Array(1 .. neur.NInputs);
        result : Real;
    begin
        for i in 1 .. neur.NInputs loop
            data(i) := Get_Value(SV, neur.Input(i));
            -- extra (validity) checks are performed by overloaded Get_Value function here
            -- otherwise the code is identical (to non-checked version)
        end loop;
        result := neur.Prop_Forward(data);
        for o in 1 .. neur.NOutputs loop
            Set_Value(SV,neur.Output(o), result);
        end loop;
    end;


    -- stateful
    procedure Prop_Forward (neur : in out Stateful_Neuron_Interface'Class) is begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "PropForward unimplemented");
        raise Program_Error with "Unimplemented procedure PropForward";
    end Prop_Forward;

   ------------------
   -- PropBackward --
   ------------------

   procedure Prop_Backward (neur : in out Stateful_Neuron_Interface'Class) is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "PropBackward unimplemented");
      raise Program_Error with "Unimplemented procedure PropBackward";
   end Prop_Backward;

end wann.neurons;
