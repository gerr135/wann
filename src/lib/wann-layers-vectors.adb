pragma Ada_2012;
package body wann.layers.vectors is

   -----------
   -- ToRec --
   -----------

   overriding function ToRec
     (L : Layer)
      return LayerRec
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
     (L : in out Layer;
      LR : LayerRec)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "FromRec unimplemented");
      raise Program_Error with "Unimplemented procedure FromRec";
   end FromRec;

   --------------
   -- NNeurons --
   --------------

   overriding function NNeurons
     (L : Layer)
      return NeuronIndex_Base
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "NNeurons unimplemented");
      return raise Program_Error with "Unimplemented function NNeurons";
   end NNeurons;

   ----------------
   -- Add_Neuron --
   ----------------

   overriding procedure Add_Neuron
     (L : in out Layer;
      Nidx : NN.ConnectionIndex)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Add_Neuron unimplemented");
      raise Program_Error with "Unimplemented procedure Add_Neuron";
   end Add_Neuron;

   ------------
   -- Neuron --
   ------------

   overriding function Neuron
     (L : Layer;
      idx : NeuronIndex)
      return PN.NeuronClass_Access
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Neuron unimplemented");
      return raise Program_Error with "Unimplemented function Neuron";
   end Neuron;

    --------------
    -- Generate --
    --------------

--    not overriding
   function Generate return Layer_Interface'Class
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Generate unimplemented");
      return raise Program_Error with "Unimplemented function Generate";
   end Generate;


--     function Generate return LayerClass_Access is
-- --         L : LayerClass_Access := Layer'Class Create;
--     begin
--         --         return L;
--         pragma Compile_Time_Warning (Standard.True, "Create unimplemented");
--         return raise Program_Error with "Unimplemented function Create";
--     end Generate;

end wann.layers.vectors;
