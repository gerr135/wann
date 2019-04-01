package body Connectors is

    procedure Add_Output(OI : in out Outputting_Interface'Class; Output : Connection_Type) is
    begin
        OI.Add_Output(1);
        OI.Connect_Output(OI.NOutputs, Output);
    end;

    procedure Connect_Next_Unused(OI : in out Outputting_Interface'Class; val : Connection_Type) is
    begin
        for idx in Index_Type'First .. OI.NOutputs loop
            if OI.Output(idx) = No_Connection then
                OI.Connect_Output(idx, val);
                return;
            end if;
        end loop;
    end;

end Connectors;
