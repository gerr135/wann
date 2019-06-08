pragma Ada_2012;

with Ada.Strings.Fixed;

package body nnet_types is

    function Con2Str(connection : ConnectionIndex) return String is
        use Ada.Strings, Ada.Strings.Fixed;
    begin
        return connection.T'Img &
            (case connection.T is
                when None=> "",
                when I   => Trim(connection.Iidx'Img, Side => Both),
                when N   => Trim(connection.Nidx'Img, Side => Both),
                when O   => Trim(connection.Oidx'Img, Side => Both)
            );
    end;

   ------------------------
   -- State_Value unckecked

    function State_Value (SV : State_Vector; idx : ConnectionIndex) return Real is
    begin
        case idx.T is
            when I => return SV.input (idx.Iidx);
            when N => return SV.neuron(idx.Nidx);
            when O => return SV.output(idx.Oidx);
            when None => NUll;
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
            when None => NUll;
        end case;
    end Is_Valid;


    function Inputs_are_valid (SV : Checked_State_Vector) return Boolean is
    begin
        for i in 1 .. SV.Ni loop
            if not SV.validI(i) then
                return False;
            end if;
        end loop;
        return True;
    end;


    function Outputs_are_valid(SV : Checked_State_Vector) return Boolean is
    begin
        for o in 1 .. SV.No loop
            if not SV.validO(o) then
                return False;
            end if;
        end loop;
        return True;
    end;

end nnet_types;
