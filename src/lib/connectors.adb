package body Connectors is

    procedure Add_Output(OI : in out Outputting_Interface'Class; Output : Connection_Type) is
    begin
        OI.Add_Output(1);
        OI.Connect_Output(Output);
    end;

end Connectors;
