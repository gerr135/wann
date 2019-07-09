pragma Ada_2012;

with Ada.Integer_Text_IO;

package body wann.nets is

    ---------------------
    -- IO handling
    --
--     function  Input (net : NNet_Interface'Class; i : NN.InputIndex)  return PI.InputRec is
--         input : PI.Input_Interface'Class := net.Input(i);
--     begin
--         --  Generated stub: replace with real body!
--         pragma Compile_Time_Warning (Standard.True, "Input unimplemented");
--         return raise Program_Error with "Unimplemented procedure Input";
--     end;


    ---------------------
    -- Autosort_Layers --
    --
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
            net.Sort_Layers(net.LG, Direction);
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


   ------------------------------------------------------------------------
   -- Class-wides

   procedure Construct_From(net : in out NNet_Interface'Class; S : String) is
   begin
       --  Generated stub: replace with real body!
       pragma Compile_Time_Warning (Standard.True, "Construct_From unimplemented");
       raise Program_Error with "Unimplemented procedure Construct_From";
   end;


    procedure Print_Structure(net : in out NNet_Interface'Class;
                              F : Ada.Text_IO.File_Type := Ada.Text_IO.Standard_Output) is
        use Ada.Text_IO, Ada.Integer_Text_IO;
    begin
        Put(F, "printout of NNet layout:  ");
        if net.Layers_Sorted then
            Put_Line(F, "layer# |i1, i2.. |o1, o2.. ;");
            -- we print layer per line
            for l in 1 .. net.NLayers loop
                Put(F, "L" & l'Img & ": ");
                for n in 1 .. net.Layer(l).NNeurons loop
                    Put(F, net.Layer(l).Neuron(n).Index'Img & "|");
                    for input of net.Layer(l).Neuron(n).Inputs loop
                        -- inefficient, better be redone through indexed loop and individual .Input calls
                        Put(F, NN.Con2Str(input));
                    end loop;
                    Put(F,"|");
                    for output of net.Layer(l).Neuron(n).Outputs loop
                        -- see above note in Inputs loop for why .Outputs is yet unimplemented
                        Put(F, NN.Con2Str(output));
                    end loop;
                    Put(F,";  ");
                end loop;
                New_Line(F);
            end loop;
        else
            Put_Line(F, "unsorted layers;  neur# |i1, i2.. |o1, o2.. ;");
            -- we print stuff straight
            for n in 1 .. net.NNeurons loop
                Put("  ");
                Put(F, Integer(net.Neuron(n).Index), 2);
                Put(" |");
                for input of net.Neuron(n).Inputs loop
                    -- inefficient, better be redone through indexed loop and individual .Input calls
                    Put(F, NN.Con2Str(input) & " ");
                end loop;
                Put(F,"|");
                for output of net.Neuron(n).Outputs loop
                    -- see above note in Inputs loop for why .Outputs is yet unimplemented
                    Put(F, NN.Con2Str(output) & " ");
                end loop;
                Put_Line(F,";");
            end loop;
            New_Line(F);
        end if;
    end;

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
   procedure Sort_Layers (net : in out NNet_Interface'Class;
                          LG  : PL.Layer_Generator := Null;
                          Direction : Sort_Direction := Forward)
   is
       -- we need to implement the "simulation sorting" - run through connections starting from inputs
       -- and establishing the order..
       use PL;
   begin
       if (LG = Null) and (net.LG = Null) then
           raise Unset_Layer_Generator;
       end if;
       if LG /= Null then
           -- reset stored generator to the passed one (and use stored value throughout)
           net.LG := LG;
       end if;
       -- start with inputs and generate 1st layer
       declare
           L1 : PL.LayerClass_Access := net.LG.all;
           -- cannot create layers directly in interface/abstract type.
           --Need to pass a layer constructor in here..
       begin
           Null;
       end;
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
        Ni : NN.InputIndex  := net.NInputs;
        No : NN.OutputIndex := net.NOutputs;
        use type NN.InputIndex;
    begin
        -- check dimensions and if net has already been sorted
        if inputs'Length /= Ni then
            raise Data_Width_Mismatch;
        end if;
        if not net.Layers_Sorted then
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
        results : NN.Output_Array(1 .. net.NOutputs);
        use type NN.Connection_Type;
    begin
        for o in results'Range loop
            declare
                output : NN.ConnectionIndex := net.Output(o);
            begin
                if output.T = NN.N then
                    if not NSV.validN(output.Nidx) then
                        -- replace with Assert?
                        raise Unset_Value_Access;
                    end if;
                    results(o) := NSV.neuron(output.Nidx);
                else
                    if not NSV.validI(output.Iidx) then
                        -- replace with Assert?
                        raise Unset_Value_Access;
                    end if;
                    results(o) := NSV.input(output.Iidx);
                end if;
            end;
        end loop;
        return results;
    end Calc_Outputs;

    function Calc_Outputs (net : NNet_Interface'Class; NSV : NN.State_Vector)
        return NN.Output_Array
    is
        --
        results : NN.Output_Array(1 .. net.NOutputs);
        use type NN.Connection_Type;
    begin
        for o in results'Range loop
            declare
                output : NN.ConnectionIndex := net.Output(o);
            begin
                if output.T = NN.N then
                    results(o) := NSV.neuron(output.Nidx);
                else
                    results(o) := NSV.input(output.Iidx);
                end if;
            end;
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
        results  : NN.Output_Array(1 .. net.NOutputs);
        inValues : NN.Input_Array := net.Input_Values;
        neur : PN.Stateful_NeuronClass_Access;
        use type NN.Connection_Type;
    begin
        for o in results'Range loop
            declare
                output : NN.ConnectionIndex := net.Output(o);
            begin
                if output.T = NN.N then
                    neur := net.Neuron(output.Nidx);
                    if not neur.valid then
                        -- replace with Assert?
                        raise Unset_Value_Access;
                    end if;
                    results(o) := neur.value;
                else
                    results(o) := inValues(output.Iidx);
                end if;
            end;
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
