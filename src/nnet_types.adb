pragma Ada_2012;
package body nnet_types is

   ------------------------
   -- State_Value unckecked

    function State_Value (SV : State_Vector; idx : ConnectionIndex) return Real is
    begin
        case idx.T is
            when I => return SV.input (idx.Iidx);
            when N => return SV.neuron(idx.Nidx);
            when O => return SV.output(idx.Oidx);
        end case;
    end State_Value;

    --------------
    -- Is_Valid --
    --------------

    function Is_Valid (SV : Checked_State_Vector; idx : ConnectionIndex) return Boolean is
    begin
        case idx.T is
            when I => return SV.validI(idx.Iidx);
            when N => return SV.validN(idx.Nidx);
            when O => return SV.validO(idx.Oidx);
        end case;
    end Is_Valid;

end nnet_types;
