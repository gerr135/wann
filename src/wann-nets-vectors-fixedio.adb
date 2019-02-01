pragma Ada_2012;
package body wann.nets.vectors.fixedIO is

--     ------------
--     -- Create --
--     ------------
--
--     function Create return NNet is
--         net : NNet;
--     begin
--         return net;
--         --  Generated stub: replace with real body!
--         pragma Compile_Time_Warning (Standard.True, "Create unimplemented");
--         return raise Program_Error with "Unimplemented function Create";
--     end Create;

   -----------------------
   -- Input_Connections --
   -----------------------

   overriding function Input_Connections
     (net : NNet)
      return NN.Input_Connection_Array
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Input_Connections unimplemented");
      return raise Program_Error with "Unimplemented function Input_Connections";
   end Input_Connections;

   ------------------------
   -- Output_Connections --
   ------------------------

   overriding function Output_Connections
     (net : NNet)
      return NN.Output_Connection_Array
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Output_Connections unimplemented");
      return raise Program_Error with "Unimplemented function Output_Connections";
   end Output_Connections;

   ----------------
   -- Add_Neuron --
   ----------------

   overriding procedure Add_Neuron
     (net : in out NNet;
      neur : PN.Neuron_Interface'Class;
      idx : out NN.NeuronIndex)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Add_Neuron unimplemented");
      raise Program_Error with "Unimplemented procedure Add_Neuron";
   end Add_Neuron;

   ----------------
   -- Del_Neuron --
   ----------------

   overriding procedure Del_Neuron
     (net : in out NNet;
      idx : NN.NeuronIndex)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Del_Neuron unimplemented");
      raise Program_Error with "Unimplemented procedure Del_Neuron";
   end Del_Neuron;

   ---------------
   -- Set_Layer --
   ---------------

   overriding procedure Set_Layer
     (net : in out NNet;
      idx : NN.LayerIndex;
      L : PL.Layer_Interface'Class)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Set_Layer unimplemented");
      raise Program_Error with "Unimplemented procedure Set_Layer";
   end Set_Layer;

end wann.nets.vectors.fixedIO;
