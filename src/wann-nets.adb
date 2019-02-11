pragma Ada_2012;
package body wann.nets is

    ---------------------
    -- Autosort_Layers --

    function Autosort_Layers (net : NNet_Interface) return Boolean is
    begin
        return net.autosort_layers;
    end Autosort_Layers;

    procedure Set_Autosort_Layers (net : in out NNet_Interface;
                                   Autosort : Boolean;
                                   Direction : Sort_Direction := Forward)
    is
    begin
        net.autosort_layers := Autosort;
        net.layer_sort_direction := Direction;
        if Autosort then
            net.Sort_Layers(Direction);
        end if;
    end Set_Autosort_Layers;

   ----------------
   -- Add_Neuron --
   procedure Add_Neuron (net : in out NNet_Interface'Class;
                         neur : in out PN.Neuron_Interface'Class)
   is
       idx : NN.NeuronIndex_Base;
   begin
       net.Add_Neuron(neur, idx);
   end Add_Neuron;


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

   ------------------------
   -- Populate_At_Random --
   ------------------------

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
   -- Sort_Layers --
   -----------------

   procedure Sort_Layers
     (net : in out NNet_Interface'Class;
      Direction : Sort_Direction := Forward)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Sort_Layers unimplemented");
      raise Program_Error with "Unimplemented procedure Sort_Layers";
   end Sort_Layers;

   -------------------
   -- Update_Layers --
   -------------------

   procedure Update_Layers
     (net : in out NNet_Interface'Class;
      idx : NN.NeuronIndex)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Update_Layers unimplemented");
      raise Program_Error with "Unimplemented procedure Update_Layers";
   end Update_Layers;


    -----------------
    -- PropForward --
    function Prop_Forward (net : NNet_Interface'Class; inputs : NN.Input_Array)
        return NN.Output_Array
    is
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
            return net.Calc_Outputs(netState);
            -- outputs can be connected to arbitrary layer, so we cannot simply ask last layer
            -- to calc it. SHould be at the net level
        end; -- declare
    end Prop_Forward;


    -----------------
    -- CalcOutputs --
    -----------------

    function Calc_Outputs (net : NNet_Interface'Class; NSV : NN.Checked_State_Vector)
        return NN.Output_Array
    is
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
    end Calc_Outputs;

    function Calc_Outputs (net : NNet_Interface'Class; NSV : NN.State_Vector)
        return NN.Output_Array
    is
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
    end Calc_Outputs;


    ------------------------------
    -- Cached_NNet_Interface

    function Input_Values (net : Cached_NNet_Interface'Class)
        return NN.Input_Array
    is
        netState : NN.State_Vector:= net.State;
    begin
        return netState.input;
    end Input_Values;

    procedure Set_Input_Values (net : in out Cached_NNet_Interface'Class;
                                IV : NN.Input_Array)
    is
        -- we only reassign the inputs, keep the other values untouched
        netState : NN.State_Vector:= net.State;
    begin
        netState.input := IV;
        net.Set_State(netState);
    end Set_Input_Values;

    procedure Prop_Forward (net : Cached_NNet_Interface'Class) is
        L : PL.Layer_Interface'Class := net.Layer(1); -- use access?
    begin
        for li in 2 .. net.NLayers loop
            L := net.Layer(li);
            L.Prop_Forward;
        end loop;
    end Prop_Forward;

    function Calc_Outputs (net : Stateful_NNet_Interface'Class)
        return NN.Output_Array
    is
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
    end Calc_Outputs;


    --------------------------------------
    -- Cached_Checked_NNet_Interface

    function Input_Values (net : Cached_Checked_NNet_Interface'Class)
        return NN.Input_Array
    is
        netState : NN.Checked_State_Vector:= net.State;
    begin
        if NN.Inputs_are_valid(netState) then
            return netState.input;
        else
            raise Unset_Value_Access;
        end if;
    end Input_Values;

    procedure Set_Input_Values (net : in out Cached_Checked_NNet_Interface'Class;
                                IV : NN.Input_Array)
    is
        -- we only reassign the inputs, keep the other values untouched
        netState : NN.Checked_State_Vector:= net.State;
        use type NN.InputIndex_Base;
    begin
        -- check if we are passed the same size array
        if netState.Ni /= IV'Length then
            raise Data_Width_Mismatch;
        end if;
        netState.input := IV; --should be safe here
        -- now set the validity bits
        for i in 1 .. netState.Ni loop
            netState.validI(i) := True;
        end loop;
        net.Set_State(netState);
    end Set_Input_Values;


    ------------------
    -- Prop_Forward --
    ------------------

    procedure Prop_Forward (net : Cached_Checked_NNet_Interface'Class) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "Prop_Forward unimplemented");
        raise Program_Error with "Unimplemented procedure Prop_Forward";
    end Prop_Forward;

    ------------------
    -- Calc_Outputs --
    ------------------

    function Calc_Outputs
        (net : Cached_Checked_NNet_Interface'Class)
        return NN.Output_Array
    is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "Calc_Outputs unimplemented");
        return raise Program_Error with "Unimplemented function Calc_Outputs";
    end Calc_Outputs;

end wann.nets;
