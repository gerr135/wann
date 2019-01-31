pragma Ada_2012;
package body wann.nets is

    -- basic utility

    -----------------
    -- Add_Neuron   --
    -----------------

    procedure Add_Neuron(net : in out NNet_Interface'Class; neur : PN.Neuron_Interface'Class) is
        idx : NN.NeuronIndex_Base;
    begin
        net.Add_Neuron(NR, idx);
    end Add_Neuron;


   -----------------
   -- Reset_Neuron --
   -----------------
    procedure Reset_Neuron
        (net : in out NNet_Interface'Class;
        NR  : PN.NeuronRec)
    is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "Reset_Neuron unimplemented");
        raise Program_Error with "Unimplemented procedure Reset_Neuron";
    end Reset_Neuron;

    procedure Reset_Neuron (net : in out NNet_Interface'Class;
        idx : NN.NeuronIndex; activat : Activation_Type;
        connects : PN.Input_Connection_Array)
    is
        --
        NR : PN.NeuronRec(Nin=>connects'Last) := (
            idx=>idx, lag=>0.0, Nin => connects'Last,
            activat=>activat, weights => (others=>0.0),
            inputs  => connects );
    begin
        net.Reset_Neuron(NR);
    end Reset_Neuron;

    procedure Reset_Neuron (net : in out NNet_Interface'Class;
        idx : NN.NeuronIndex; connects : PN.Input_Connection_Array)
    is
        --
        NR : PN.NeuronRec(Nin=>connects'Last) := (
            idx => idx, lag => 0.0, Nin => connects'Last,
            activat => net.Neuron(idx).activat, weights => (others=>0.0),
            inputs  => connects );
    begin
        net.Reset_Neuron(NR);
    end Reset_Neuron;

   --------------------------------
   -- Reconnect_Neuron_At_Random --
   --------------------------------

   procedure Reconnect_Neuron_At_Random
     (net : in out NNet_Interface'Class;
      idx  : NN.NeuronIndex;
      maxConnects : PN.InputIndex_Base := 0)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Reconnect_Neuron_At_Random unimplemented");
      raise Program_Error with "Unimplemented procedure Reconnect_Neuron_At_Random";
   end Reconnect_Neuron_At_Random;

   ----------------------
   -- Populate_At_Random --
   ----------------------

   procedure Populate_At_Random
     (net : in out NNet_Interface'Class;
      Npts : NN.NeuronIndex_Base;
      maxConnects : PN.InputIndex_Base := 0)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Populate_At_Random unimplemented");
      raise Program_Error with "Unimplemented procedure Populate_At_Random";
   end Populate_At_Random;

   -----------------
   -- Sort_Forward --
   -----------------

   procedure Sort_Forward (net : in out NNet_Interface'Class) is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Sort_Forward unimplemented");
      raise Program_Error with "Unimplemented procedure Sort_Forward";
   end Sort_Forward;

   ------------------
   -- Sort_Backward --
   ------------------

   procedure Sort_Backward (net : in out NNet_Interface'Class) is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Sort_Backward unimplemented");
      raise Program_Error with "Unimplemented procedure Sort_Backward";
   end Sort_Backward;



    ---------------------------------------------
    -- Stateless propagation
    --
   function PropForward (net : NNet_Interface'Class; inputs : NN.Input_Array) return NN.Output_Array is
        -- this is a stateless prop version. All intermidiate data are kept and updated locally
        -- NOTE: layers can be interconnected in arbitrary way, to absolutely any neurons,
        -- or even inputs/outputs directly, so we need to pass a complete state around.
        Ni : NN.InputIndex  := net.Input_Connections'Length;
        No : NN.OutputIndex := net.Output_Connections'Length;
        use type NN.InputIndex;
    begin
        -- check dimensions and if net has already been sorted
        if inputs'Length /= Ni then
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
            netState : NN.Checked_State_Vector(Ni=>Ni, Nn=>net.NNeurons, No=>No);
        begin
            for li in 2 .. net.NLayers loop
                -- main cycle - just propagate through all layers, updating net state
                L := net.Layer(li);
                netState := L.Prop_Forward(netState);
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

    function PropForward (net : Stateful_NNet_Interface'Class) return NN.Output_Array
    is
        L : PL.Layer_Interface'Class := net.Layer(1); -- use access?
    begin
        for li in 2 .. net.NLayers loop
            L := net.Layer(li);
            L.Prop_Forward;
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
