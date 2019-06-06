package body Connectors is

    procedure Add_and_Connect(OI : in out Connector_Interface'Class; Output : Connection_Type) is
    begin
        OI.Add_Output(1);
        OI.Connect_Output(OI.NOutputs, Output);
    end;

    procedure Connect_Next_Unused(OI : in out Connector_Interface'Class; val : Connection_Type) is
    begin
        for idx in Index_Type'First .. OI.NOutputs loop
            if OI.Output(idx) = No_Connection then
                OI.Connect_Output(idx, val);
                return;
            end if;
        end loop;
        -- if we got here, no unused connections are available
        raise Connection_Not_Found;
    end;

end Connectors;
