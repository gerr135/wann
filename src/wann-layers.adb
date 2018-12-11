pragma Ada_2012;
package body wann.layers is

   -----------------
   -- Has_Element --
   -----------------

   function Has_Element (Pos : LL_Cursor) return Boolean is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Has_Element unimplemented");
      return raise Program_Error with "Unimplemented function Has_Element";
   end Has_Element;

   -----------------
   -- PropForward --
   -----------------

   function PropForward
     (L : Layer_Interface'Class;
      inputs : NNet_StateVector)
      return NNet_StateVector
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "PropForward unimplemented");
      return raise Program_Error with "Unimplemented function PropForward";
   end PropForward;

   -----------------
   -- PropForward --
   -----------------

   function PropForward
     (L : Layer_Interface'Class;
      inputs : NNet_CheckedStateVector)
      return NNet_CheckedStateVector
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "PropForward unimplemented");
      return raise Program_Error with "Unimplemented function PropForward";
   end PropForward;

   -----------------
   -- PropForward --
   -----------------

   procedure PropForward (L : Layer_Interface'Class) is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "PropForward unimplemented");
      raise Program_Error with "Unimplemented procedure PropForward";
   end PropForward;

end wann.layers;
