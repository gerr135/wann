pragma Ada_2012;
package body wann.nets.vectors is

   ------------
   -- Create --
   ------------

    function Create (Nin : NN.InputIndex; Nout : NN.OutputIndex) return NNet is
        net : NNet;
    begin
        return net;
        -- all ACV.Vectors are initialized empty by default, not much else to do for now
    end Create;

    overriding
    function NNeurons (net : NNet) return NN.NeuronIndex is
    begin
        return NN.NeuronIndex_Base(net.neurons.Length);
    end NNeurons;

    overriding
    function NLayers (net : NNet) return NN.LayerIndex is
    begin
        return NN.LayerIndex_Base(net.layers.Length);
    end NLayers;

   -----------------------
   -- Input_Connections --
    overriding
    function Input_Connections (net : NNet) return NN.Input_Connection_Array is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "Input_Connections unimplemented");
        return raise Program_Error with "Unimplemented function Input_Connections";
    end Input_Connections;

   ------------------------
   -- Output_Connections --
   ------------------------

    overriding
    function Output_Connections (net : NNet) return NN.Output_Connection_Array is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "Output_Connections unimplemented");
        return raise Program_Error with "Unimplemented function Output_Connections";
    end Output_Connections;

    ----------------
    -- New_Neuron --
    overriding
    procedure New_Neuron (net : in out NNet; idx : out NN.NeuronIndex_Base) is
        use type Ada.Containers.Count_Type;
    begin
        idx := NN.NeuronIndex(net.neurons.Length + 1);
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "New_Neuron unimplemented");
        raise Program_Error with "Unimplemented procedure New_Neuron";
    end New_Neuron;

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

   ------------
   -- Neuron --
   ------------

   overriding function Neuron
     (net : NNet;
      idx : NN.NeuronIndex)
      return PN.NeuronClass_Access
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Neuron unimplemented");
      return raise Program_Error with "Unimplemented function Neuron";
   end Neuron;

   ----------------
   -- Set_Neuron --
   ----------------

   overriding procedure Set_Neuron
     (net : in out NNet;
      NA : PN.NeuronClass_Access)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Set_Neuron unimplemented");
      raise Program_Error with "Unimplemented procedure Set_Neuron";
   end Set_Neuron;

   ------------------
   -- Layers_Ready --
   ------------------

   overriding function Layers_Ready
     (net : NNet)
      return Boolean
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Layers_Ready unimplemented");
      return raise Program_Error with "Unimplemented function Layers_Ready";
   end Layers_Ready;

   -----------
   -- Layer --
   -----------

   overriding function Layer
     (net : NNet;
      idx : NN.LayerIndex)
      return PL.Layer_Interface'Class
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Layer unimplemented");
      return raise Program_Error with "Unimplemented function Layer";
   end Layer;

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

   -----------
   -- State --
   -----------

   overriding function State
     (net : Cached_NNet)
      return NN.State_Vector
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "State unimplemented");
      return raise Program_Error with "Unimplemented function State";
   end State;

   --------------
   -- SetState --
   --------------

   overriding procedure SetState
     (net : in out Cached_NNet;
      NSV : NN.State_Vector)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "SetState unimplemented");
      raise Program_Error with "Unimplemented procedure SetState";
   end SetState;

   ------------------
   -- NeuronValues --
   ------------------

   overriding function NeuronValues
     (net : Cached_NNet)
      return NN.Value_Array
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "NeuronValues unimplemented");
      return raise Program_Error with "Unimplemented function NeuronValues";
   end NeuronValues;

end wann.nets.vectors;
