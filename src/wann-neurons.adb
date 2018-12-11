pragma Ada_2012;
package body wann.neurons is

   -----------
   -- Index --
   -----------

   function Index (NI : Neuron_Interface'Class) return NNet_NeuronIndex is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Index unimplemented");
      return raise Program_Error with "Unimplemented function Index";
   end Index;

   -------------
   -- Activat --
   -------------

   function Activat (NI : Neuron_Interface'Class) return ActivationType is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Activat unimplemented");
      return raise Program_Error with "Unimplemented function Activat";
   end Activat;

   -------------
   -- Weights --
   -------------

   function Weights (NI : Neuron_Interface'Class) return WeightArray is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Weights unimplemented");
      return raise Program_Error with "Unimplemented function Weights";
   end Weights;

   ------------
   -- Inputs --
   ------------

   function Inputs (NI : Neuron_Interface'Class) return InConnArray is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Inputs unimplemented");
      return raise Program_Error with "Unimplemented function Inputs";
   end Inputs;

   -------------
   -- Outputs --
   -------------

   function Outputs (NI : Neuron_Interface'Class) return OutConnArray is
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
      idx : NNet_NeuronIndex)
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
      activat : ActivationType)
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
      weights : WeightArray)
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
      inputs  : InConnArray)
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
      outputs : OutConnArray)
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
      data  : ValueArray)
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
