pragma Ada_2012;
package body wann.layers is

    ------------------
    -- Prop_Forward --
    --
    --  Layer_Interface

    function Prop_Forward (L : Layer_Interface; inputs : NN.State_Vector) return NN.State_Vector is
        outputs : NN.State_Vector := inputs;
    begin
        for i in 1 .. Layer_Interface'Class(L).Length loop
            declare
                neur : PN.NeuronClass_Access := Layer_Interface'Class(L).Neuron(i);
            begin
                outputs := neur.Prop_Forward(outputs);
            end;
        end loop;
        return outputs;
    end Prop_Forward;

    function Prop_Forward (L : Layer_Interface; inputs : NN.Checked_State_Vector)
        return NN.Checked_State_Vector
    is
        outputs : NN.Checked_State_Vector := inputs;
    begin
        for i in 1 .. Layer_Interface'Class(L).Length loop
            declare
                neur : PN.NeuronClass_Access := Layer_Interface'Class(L).Neuron(i);
            begin
                outputs := neur.Prop_Forward(outputs);
            end;
        end loop;
        return outputs;
    end Prop_Forward;


    procedure Prop_Forward(L : Layer_Interface; SV : in out NN.State_Vector) is
    begin
        for i in 1 .. Layer_Interface'Class(L).Length loop
            declare
                neur : PN.NeuronClass_Access := Layer_Interface'Class(L).Neuron(i);
            begin
                neur.Prop_Forward(SV);
            end;
        end loop;
    end;

    procedure Prop_Forward(L : Layer_Interface; SV : in out NN.Checked_State_Vector) is
    begin
        for i in 1 .. Layer_Interface'Class(L).Length loop
            declare
                neur : PN.NeuronClass_Access := Layer_Interface'Class(L).Neuron(i);
            begin
                neur.Prop_Forward(SV);
            end;
        end loop;
    end;


    procedure Prop_Forward (L : Layer_Interface) is
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "Prop_Forward unimplemented");
        raise Program_Error with "Unimplemented procedure Prop_Forward";
    end Prop_Forward;

   -------------------------
   -- Matrix_Layer_Interface

   function Prop_Forward
     (L : Matrix_Layer_Interface;
      inputs : NN.State_Vector)
      return NN.State_Vector
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Prop_Forward unimplemented");
      return raise Program_Error with "Unimplemented function Prop_Forward";
   end Prop_Forward;

   ------------------
   -- Prop_Forward --
   ------------------

   function Prop_Forward
     (L : Matrix_Layer_Interface;
      inputs : NN.Checked_State_Vector)
      return NN.Checked_State_Vector
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Prop_Forward unimplemented");
      return raise Program_Error with "Unimplemented function Prop_Forward";
   end Prop_Forward;

   ------------------------
   -- Prop_Forward_Basic --
   ------------------------

   procedure Prop_Forward_Basic (L : Matrix_Layer_Interface) is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Prop_Forward_Basic unimplemented");
      raise Program_Error with "Unimplemented procedure Prop_Forward_Basic";
   end Prop_Forward_Basic;

end wann.layers;
