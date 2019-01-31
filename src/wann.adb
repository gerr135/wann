pragma Ada_2012;
package body wann is

    -----------------
    -- State_Value --
    -----------------

    function Get_Value (SV : NN.State_Vector; idx : NN.ConnectionIndex) return Real is
    begin
        return NN.State_Value(SV, idx);
    end Get_Value;

    procedure Set_Value(SV : in out NN.State_Vector; idx : NN.ConnectionIndex; value : Real) is
        use NN;
    begin
        case idx.T is
            when I => SV.input (idx.Iidx) := value;
            when N => SV.neuron(idx.Nidx) := value;
            when O => SV.output(idx.Oidx) := value;
        end case;
    end Set_Value;

    --------------
    -- Is_Valid --
    --------------

    function Is_Valid (SV : NN.Checked_State_Vector; idx : NN.ConnectionIndex) return Boolean is
    begin
        return NN.Is_Valid(SV, idx);
    end Is_Valid;

    -----------------
    -- State_Value --
    -----------------

    function Get_Value (SV : NN.Checked_State_Vector; idx : NN.ConnectionIndex) return Real is
        use NN;
    begin
        if Is_Valid(SV, idx) then
            case idx.T is
                when I => return SV.input (idx.Iidx);
                when N => return SV.neuron(idx.Nidx);
                when O => return SV.output(idx.Oidx);
            end case;
        else
            raise Unset_Value_Access;
        end if;
    end Get_Value;

    procedure Set_Value(SV : in out NN.Checked_State_Vector; idx : NN.ConnectionIndex; value : Real) is
        use NN;
    begin
        case idx.T is
            when I => SV.input (idx.Iidx) := value;
            when N => SV.neuron(idx.Nidx) := value;
            when O => SV.output(idx.Oidx) := value;
        end case;
    end Set_Value;

end wann;
