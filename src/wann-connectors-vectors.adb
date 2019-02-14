pragma Ada_2012;
package body wann.connectors.vectors is

   --------------
   -- NOutputs --
   --------------

   overriding function NOutputs
     (OI : Outputting_Type)
      return Index_Type
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "NOutputs unimplemented");
      return raise Program_Error with "Unimplemented function NOutputs";
   end NOutputs;

   ------------
   -- Output --
   ------------

   overriding function Output
     (OI : Outputting_Type;
      idx : Index_Type)
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
     (OI : in out Outputting_Type;
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
     (OI : in out Outputting_Type;
      Output : NN.ConnectionIndex)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Del_Output unimplemented");
      raise Program_Error with "Unimplemented procedure Del_Output";
   end Del_Output;

end wann.connectors.vectors;
