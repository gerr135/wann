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



    ---------------------------------------------
    -- Stateless propagation
    --
    function PropForward (net : NNet_Interface'Class; IV  : NN.Input_Array)
            return NN.Output_Array is
        -- this is a stateless prop version. All intermidiate data are kept and updated locally
        -- NOTE: layers can be interconnected in arbitrary way, to absolutely any neurons,
        -- or even inputs/outputs directly, so we need to pass a complete state around.
        Ni : NN.InputIndex := net.Input_Connections'Length;
        use type NN.InputIndex;
    begin
        -- check dimensions and if net has already been sorted
        if IV'Length /= Ni then
            raise Data_Width_Mismatch;
        end if;
        if not net.Layers_Ready then
            raise Unsorted_Net_Propagation;
        end if;
        --
        declare
            -- 1st layer is a special case (as we do not use dumb pass-through neurons as inputs)
            -- there should always be at least 1
            L : PL.Layer_Interface'Class := net.Layer(1);
            -- we also need a nnet value vector
            netState : NN.Checked_State_Vector(Ni=>Ni, Nn=>net.NNeurons,
                                               No=>net.Output_Connections'Length);
        begin
            for li in 2 .. net.NLayers loop
                -- main cycle - just propagate through all layers, updating net state
                L := net.Layer(li);
                netState := L.PropForward(netState);
            end loop;
            return net.calcOutputs(netState);
            -- outputs can be connected to arbitrary layer, so we cannot simply ask last layer
            -- to calc it. SHould be at the net level
        end; -- declare
    end PropForward;

    function CalcOutputs (net : NNet_Interface'Class; NSV : NN.Checked_State_Vector)
            return NN.Output_Array is
            -- consider pre/post-conditions?
        --
        outputs : NN.Output_Connection_Array := net.Output_Connections;
        results : NN.Output_Array(1 .. outputs'Last);
        use type NN.Connection_Type;
    begin
        for i in results'Range loop
            if outputs(i).T = NN.N then
                if not NSV.validN(outputs(i).Nidx) then
                    -- replace with Assert?
                    raise Unset_Value_Access;
                end if;
                results(i) := NSV.neuron(outputs(i).Nidx);
            else
                if not NSV.validI(outputs(i).Iidx) then
                    -- replace with Assert?
                    raise Unset_Value_Access;
                end if;
                results(i) := NSV.input(outputs(i).Iidx);
            end if;
        end loop;
        return results;
    end CalcOutputs;

    function CalcOutputs (net : NNet_Interface'Class; NSV : NN.State_Vector)
            return NN.Output_Array is
        --
        outputs : NN.Output_Connection_Array := net.Output_Connections;
        results : NN.Output_Array(1 .. outputs'Last);
        use type NN.Connection_Type;
    begin
        for i in results'Range loop
            if outputs(i).T = NN.N then
                results(i) := NSV.neuron(outputs(i).Nidx);
            else
                results(i) := NSV.input(outputs(i).Iidx);
            end if;
        end loop;
        return results;
    end CalcOutputs;


   --------------------
   -- Cached_NNet

    function GetInputValues (net : Cached_NNet_Interface'Class) return NN.Input_Array is
        netState : NN.State_Vector:= net.State;
    begin
        return netState.input;
    end GetInputValues;

    procedure SetInputValues (net : in out Cached_NNet_Interface'Class; IV : NN.Input_Array) is
        -- we only reassign the inputs, keep the other values untouched
        netState : NN.State_Vector:= net.State;
    begin
        netState.input := IV;
        net.SetState(netState);
    end SetInputValues;


   ----------------------------------
   -- Stateful propagation

    function PropForward (net : Stateful_NNet_Interface'Class) return NN.Output_Array is
        L : PL.Layer_Interface'Class := net.Layer(1); -- use access?
    begin
        for li in 2 .. net.NLayers loop
            L := net.Layer(li);
            L.PropForward;
        end loop;
        return net.CalcOutputs;
    end PropForward;

   function CalcOutputs (net : Stateful_NNet_Interface'Class) return NN.Output_Array is
       outputs  : NN.Output_Connection_Array := net.Output_Connections;
       results  : NN.Output_Array(1 .. outputs'Last);
       inValues : NN.Input_Array := net.Input_Values;
       neur : PN.Stateful_NeuronClass_Access;
       use type NN.Connection_Type;
   begin
       for i in results'Range loop
           if outputs(i).T = NN.N then
               neur := net.Neuron(outputs(i).Nidx);
               if not neur.valid then
                   -- replace with Assert?
                   raise Unset_Value_Access;
               end if;
               results(i) := neur.value;
           else
               results(i) := inValues(outputs(i).Iidx);
           end if;
       end loop;
       return results;
   end CalcOutputs;

end wann.nets;
