pragma Ada_2012;
package body wann.neurons.vectors is

   -----------
   -- ToRec --
   -----------

   overriding function ToRec
     (NI : Neuron)
      return NeuronRec
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "ToRec unimplemented");
      return raise Program_Error with "Unimplemented function ToRec";
   end ToRec;

   -------------
   -- FromRec --
   -------------

   overriding procedure FromRec
     (NI : in out Neuron;
      LR : NeuronRec)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "FromRec unimplemented");
      raise Program_Error with "Unimplemented procedure FromRec";
   end FromRec;

   ---------------
   -- AddOutput --
   ---------------

   overriding procedure AddOutput
     (NI : in out Neuron;
      Output : NN.ConnectionIndex)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "AddOutput unimplemented");
      raise Program_Error with "Unimplemented procedure AddOutput";
   end AddOutput;

   ---------------
   -- DelOutput --
   ---------------

   overriding procedure DelOutput
     (NI : in out Neuron;
      Output : NN.ConnectionIndex)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "DelOutput unimplemented");
      raise Program_Error with "Unimplemented procedure DelOutput";
   end DelOutput;

   -------------
   -- NInputs --
   -------------

   overriding function NInputs
     (neur : Neuron)
      return InputIndex
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "NInputs unimplemented");
      return raise Program_Error with "Unimplemented function NInputs";
   end NInputs;

   --------------
   -- NOutputs --
   --------------

   overriding function NOutputs
     (neur : Neuron)
      return OutputIndex
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "NOutputs unimplemented");
      return raise Program_Error with "Unimplemented function NOutputs";
   end NOutputs;

   -----------
   -- Input --
   -----------

   overriding function Input
     (neur : Neuron;
      idx : InputIndex)
      return NN.ConnectionIndex
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Input unimplemented");
      return raise Program_Error with "Unimplemented function Input";
   end Input;

   ------------
   -- Output --
   ------------

   overriding function Output
     (neur : Neuron;
      idx : OutputIndex)
      return NN.ConnectionIndex
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Output unimplemented");
      return raise Program_Error with "Unimplemented function Output";
   end Output;

   ------------
   -- Create --
   ------------

   not overriding function Create
     (NR : NeuronRec)
      return Neuron
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Create unimplemented");
      return raise Program_Error with "Unimplemented function Create";
   end Create;

   ------------
   -- Create --
   ------------

   not overriding function Create
     (activation : Activation_Type;
      connections : NN.Input_Connection_Array)
      return Neuron
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Create unimplemented");
      return raise Program_Error with "Unimplemented function Create";
   end Create;

end wann.neurons.vectors;
