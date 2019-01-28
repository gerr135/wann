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

   function PropForward
     (NI : Neuron_Interface'Class;
      data  : Value_Array)
      return Real
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "PropForward unimplemented");
      return raise Program_Error with "Unimplemented function PropForward";
   end PropForward;

   -----------------
   -- PropForward --
   -----------------

   procedure PropForward (NI : in out Stateful_Neuron_Interface'Class) is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "PropForward unimplemented");
      raise Program_Error with "Unimplemented procedure PropForward";
   end PropForward;

   ------------------
   -- PropBackward --
   ------------------

   procedure PropBackward (NI : in out Stateful_Neuron_Interface'Class) is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "PropBackward unimplemented");
      raise Program_Error with "Unimplemented procedure PropBackward";
   end PropBackward;

end wann.neurons;
