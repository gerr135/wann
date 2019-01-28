pragma Ada_2012;
package body wann.nets is

   ---------------
   -- AddNeuron --
   ---------------

   function AddNeuron
     (net : in out NNet_Interface'Class;
      NR : PN.NeuronRec)
      return NN.NeuronIndex
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "AddNeuron unimplemented");
      return raise Program_Error with "Unimplemented function AddNeuron";
   end AddNeuron;

   ---------------
   -- AddNeuron --
   ---------------

   procedure AddNeuron
     (net : in out NNet_Interface'Class;
      NR : PN.NeuronRec;
      idx : out NN.NeuronIndex)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "AddNeuron unimplemented");
      raise Program_Error with "Unimplemented procedure AddNeuron";
   end AddNeuron;

   ---------------
   -- AddNeuron --
   ---------------

   procedure AddNeuron
     (net : in out NNet_Interface'Class;
      NR : PN.NeuronRec)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "AddNeuron unimplemented");
      raise Program_Error with "Unimplemented procedure AddNeuron";
   end AddNeuron;

   ---------------
   -- AddNeuron --
   ---------------

   function AddNeuron
     (net : in out NNet_Interface'Class;
      activat : Activation_Type;
      connects : PN.Input_Connection_Array)
      return NN.NeuronIndex
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "AddNeuron unimplemented");
      return raise Program_Error with "Unimplemented function AddNeuron";
   end AddNeuron;

   ---------------
   -- AddNeuron --
   ---------------

   procedure AddNeuron
     (net : in out NNet_Interface'Class;
      activat : Activation_Type;
      connects : PN.Input_Connection_Array;
      idx : out NN.NeuronIndex)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "AddNeuron unimplemented");
      raise Program_Error with "Unimplemented procedure AddNeuron";
   end AddNeuron;

   ---------------
   -- AddNeuron --
   ---------------

   procedure AddNeuron
     (net : in out NNet_Interface'Class;
      activat : Activation_Type;
      connects : PN.Input_Connection_Array)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "AddNeuron unimplemented");
      raise Program_Error with "Unimplemented procedure AddNeuron";
   end AddNeuron;

   -----------------
   -- ResetNeuron --
   -----------------

   procedure ResetNeuron
     (net : in out NNet_Interface'Class;
      NR  : PN.NeuronRec)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "ResetNeuron unimplemented");
      raise Program_Error with "Unimplemented procedure ResetNeuron";
   end ResetNeuron;

   -----------------
   -- ResetNeuron --
   -----------------

   procedure ResetNeuron
     (net : in out NNet_Interface'Class;
      idx : NN.NeuronIndex;
      activat : Activation_Type;
      connects : PN.Input_Connection_Array)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "ResetNeuron unimplemented");
      raise Program_Error with "Unimplemented procedure ResetNeuron";
   end ResetNeuron;

   -----------------
   -- ResetNeuron --
   -----------------

   procedure ResetNeuron
     (net : in out NNet_Interface'Class;
      idx : NN.NeuronIndex;
      connects : PN.Input_Connection_Array)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "ResetNeuron unimplemented");
      raise Program_Error with "Unimplemented procedure ResetNeuron";
   end ResetNeuron;

   -----------------------------
   -- ReconnectNeuronAtRandom --
   -----------------------------

   procedure ReconnectNeuronAtRandom
     (net : in out NNet_Interface'Class;
      idx  : NN.NeuronIndex;
      maxConnects : PN.InputIndex_Base := 0)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "ReconnectNeuronAtRandom unimplemented");
      raise Program_Error with "Unimplemented procedure ReconnectNeuronAtRandom";
   end ReconnectNeuronAtRandom;

   ----------------------
   -- PopulateAtRandom --
   ----------------------

   procedure PopulateAtRandom
     (net : in out NNet_Interface'Class;
      Npts : NN.NeuronIndex_Base;
      maxConnects : PN.InputIndex_Base := 0)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "PopulateAtRandom unimplemented");
      raise Program_Error with "Unimplemented procedure PopulateAtRandom";
   end PopulateAtRandom;

   -----------------
   -- SortForward --
   -----------------

   procedure SortForward (net : in out NNet_Interface'Class) is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "SortForward unimplemented");
      raise Program_Error with "Unimplemented procedure SortForward";
   end SortForward;

   ------------------
   -- SortBackward --
   ------------------

   procedure SortBackward (net : in out NNet_Interface'Class) is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "SortBackward unimplemented");
      raise Program_Error with "Unimplemented procedure SortBackward";
   end SortBackward;

   -----------------
   -- PropForward --
   -----------------

   function PropForward
     (net : NNet_Interface'Class;
      IV  : NN.Input_Array)
      return NN.Output_Array
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "PropForward unimplemented");
      return raise Program_Error with "Unimplemented function PropForward";
   end PropForward;

   -----------------
   -- CalcOutputs --
   -----------------

   function CalcOutputs
     (net : NNet_Interface'Class;
      NSV : NN.Checked_State_Vector)
      return NN.Output_Array
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "CalcOutputs unimplemented");
      return raise Program_Error with "Unimplemented function CalcOutputs";
   end CalcOutputs;

   -----------------
   -- CalcOutputs --
   -----------------

   function CalcOutputs
     (net : NNet_Interface'Class;
      NSV : NN.State_Vector)
      return NN.Output_Array
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "CalcOutputs unimplemented");
      return raise Program_Error with "Unimplemented function CalcOutputs";
   end CalcOutputs;

   --------------------
   -- GetInputValues --
   --------------------

   function GetInputValues
     (net : Cached_NNet_Interface'Class)
      return NN.Input_Array
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "GetInputValues unimplemented");
      return raise Program_Error with "Unimplemented function GetInputValues";
   end GetInputValues;

   --------------------
   -- SetInputValues --
   --------------------

   procedure SetInputValues
     (net : in out Cached_NNet_Interface'Class;
      IV : NN.Input_Array)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "SetInputValues unimplemented");
      raise Program_Error with "Unimplemented procedure SetInputValues";
   end SetInputValues;

   -----------------
   -- PropForward --
   -----------------

   function PropForward
     (net : Stateful_NNet_Interface'Class)
      return NN.Output_Array
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "PropForward unimplemented");
      return raise Program_Error with "Unimplemented function PropForward";
   end PropForward;

   -----------------
   -- CalcOutputs --
   -----------------

   function CalcOutputs
     (net : Stateful_NNet_Interface'Class)
      return NN.Output_Array
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "CalcOutputs unimplemented");
      return raise Program_Error with "Unimplemented function CalcOutputs";
   end CalcOutputs;

end wann.nets;
