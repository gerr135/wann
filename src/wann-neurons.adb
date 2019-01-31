pragma Ada_2012;
package body wann.neurons is

   -----------
   -- Index --
   -----------

   function Index (NI : Neuron_Interface'Class) return NN.NeuronIndex is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Index unimplemented");
      return raise Program_Error with "Unimplemented function Index";
   end Index;

   -------------
   -- Activat --
   -------------

   function Activat (NI : Neuron_Interface'Class) return Activation_Type is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Activat unimplemented");
      return raise Program_Error with "Unimplemented function Activat";
   end Activat;

   -------------
   -- Weights --
   -------------

   function Weights (NI : Neuron_Interface'Class) return Weight_Array is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Weights unimplemented");
      return raise Program_Error with "Unimplemented function Weights";
   end Weights;

   ------------
   -- Inputs --
   ------------

   function Inputs
     (NI : Neuron_Interface'Class)
      return Input_Connection_Array
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Inputs unimplemented");
      return raise Program_Error with "Unimplemented function Inputs";
   end Inputs;

   -------------
   -- Outputs --
   -------------

   function Outputs
     (NI : Neuron_Interface'Class)
      return Output_Connection_Array
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Outputs unimplemented");
      return raise Program_Error with "Unimplemented function Outputs";
   end Outputs;

   --------------
   -- SetIndex --
   --------------

   procedure SetIndex
     (NI : in out Neuron_Interface'Class;
      idx : NN.NeuronIndex)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "SetIndex unimplemented");
      raise Program_Error with "Unimplemented procedure SetIndex";
   end SetIndex;

   ----------------
   -- SetActivat --
   ----------------

   procedure SetActivat
     (NI : in out Neuron_Interface'Class;
      activat : Activation_Type)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "SetActivat unimplemented");
      raise Program_Error with "Unimplemented procedure SetActivat";
   end SetActivat;

   ----------------
   -- SetWeights --
   ----------------

   procedure SetWeights
     (NI : in out Neuron_Interface'Class;
      weights : Weight_Array)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "SetWeights unimplemented");
      raise Program_Error with "Unimplemented procedure SetWeights";
   end SetWeights;

   ---------------
   -- SetInputs --
   ---------------

   procedure SetInputs
     (NI : in out Neuron_Interface'Class;
      inputs  : Input_Connection_Array)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "SetInputs unimplemented");
      raise Program_Error with "Unimplemented procedure SetInputs";
   end SetInputs;

   ----------------
   -- SetOutputs --
   ----------------

   procedure SetOutputs
     (NI : in out Neuron_Interface'Class;
      outputs : Output_Connection_Array)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "SetOutputs unimplemented");
      raise Program_Error with "Unimplemented procedure SetOutputs";
   end SetOutputs;

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
