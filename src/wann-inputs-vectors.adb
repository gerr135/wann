pragma Ada_2012;
package body wann.inputs.vectors is

   ------------
   -- Output --
   ------------

   overriding function Output
     (II : Input_Type;
      idx : OutputIndex)
      return NN.ConnectionIndex
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Output unimplemented");
      return raise Program_Error with "Unimplemented function Output";
   end Output;

   ----------------
   -- Add_Output --
   ----------------

   overriding procedure Add_Output
     (NI : in out Input_Type;
      Output : NN.ConnectionIndex)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Add_Output unimplemented");
      raise Program_Error with "Unimplemented procedure Add_Output";
   end Add_Output;

   ----------------
   -- Del_Output --
   ----------------

   overriding procedure Del_Output
     (NI : in out Input_Type;
      Output : NN.ConnectionIndex)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Del_Output unimplemented");
      raise Program_Error with "Unimplemented procedure Del_Output";
   end Del_Output;

end wann.inputs.vectors;
