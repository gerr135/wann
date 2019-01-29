pragma Ada_2012;
package body wann.layers is

   -----------------
   -- PropForward --
   -----------------

    function PropForward (L : Layer_Interface'Class; inputs : NN.State_Vector;
                          pType : Propagation_Type) return NN.State_Vector
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "PropForward unimplemented");
      return raise Program_Error with "Unimplemented function PropForward";
   end PropForward;

   -----------------
   -- PropForward --
   -----------------

   function PropForward (L : Layer_Interface'Class; inputs : NN.Checked_State_Vector;
                         pType : Propagation_Type) return NN.Checked_State_Vector
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "PropForward unimplemented");
      return raise Program_Error with "Unimplemented function PropForward";
   end PropForward;

   -----------------
   -- PropForward --
   -----------------

   procedure PropForward (L : Layer_Interface'Class; pType : Propagation_Type) is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "PropForward unimplemented");
      raise Program_Error with "Unimplemented procedure PropForward";
   end PropForward;

end wann.layers;
