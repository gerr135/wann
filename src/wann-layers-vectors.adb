pragma Ada_2012;
package body wann.layers.vectors is

   -----------
   -- ToRec --
   -----------

   overriding function ToRec (L : Layer) return LayerRec is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "ToRec unimplemented");
      return raise Program_Error with "Unimplemented function ToRec";
   end ToRec;

   -------------
   -- FromRec --
   -------------

   overriding procedure FromRec (L : in out Layer; LR : LayerRec) is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "FromRec unimplemented");
      raise Program_Error with "Unimplemented procedure FromRec";
   end FromRec;

   ------------
   -- Length --
   ------------

   overriding function Length (L : Layer) return NeuronIndex_Base is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Length unimplemented");
      return raise Program_Error with "Unimplemented function Length";
   end Length;

   ---------------
   -- AddNeuron --
   ---------------

   overriding
   procedure Add_Neuron (L : in out Layer; np : PN.NeuronCLass_Access) is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "AddNeuron unimplemented");
      raise Program_Error with "Unimplemented procedure AddNeuron";
   end Add_Neuron;

   ---------------
   -- GetNeuron --
   ---------------

   overriding
   function Get_Neuron (L : Layer; idx : NeuronIndex)
   return PN.NeuronClass_Access is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "GetNeuron unimplemented");
      return raise Program_Error with "Unimplemented function GetNeuron";
   end Get_Neuron;

end wann.layers.vectors;
