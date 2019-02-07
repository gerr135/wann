pragma Ada_2012;
package body wann.neurons.vectors is

   -----------
   -- ToRec --
   -----------

   overriding function ToRec (NI : Neuron) return NeuronRec is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "ToRec unimplemented");
      return raise Program_Error with "Unimplemented function ToRec";
   end ToRec;

   -------------
   -- FromRec --
   -------------

   overriding procedure FromRec (NI : in out Neuron; LR : NeuronRec) is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "FromRec unimplemented");
      raise Program_Error with "Unimplemented procedure FromRec";
   end FromRec;

   ---------------
   -- AddOutput --
   ---------------

   overriding procedure Add_Output (NI : in out Neuron; Output : NN.ConnectionIndex) is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "AddOutput unimplemented");
      raise Program_Error with "Unimplemented procedure AddOutput";
   end Add_Output;

   ---------------
   -- DelOutput --
   ---------------

   overriding procedure Del_Output
     (NI : in out Neuron;
      Output : NN.ConnectionIndex)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "DelOutput unimplemented");
      raise Program_Error with "Unimplemented procedure DelOutput";
   end Del_Output;

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

   overriding function Input (neur : Neuron;
        idx : InputIndex) return NN.ConnectionIndex
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Input unimplemented");
      return raise Program_Error with "Unimplemented function Input";
   end Input;

   ------------
   -- Output --
   ------------

   overriding function Output (neur : Neuron;
        idx : OutputIndex) return NN.ConnectionIndex
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Output unimplemented");
      return raise Program_Error with "Unimplemented function Output";
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
   function Create (activation : Activation_Type;
        connections : NN.Input_Connection_Array) return Neuron
   is
       neur : Neuron;
   begin
       neur.idx := 0;
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

end wann.neurons.vectors;
