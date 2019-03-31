pragma Ada_2012;
package body connectors.vectors is

    --------------
    -- NOutputs --
    overriding
    function NOutputs (OI : Output_Vector) return Index_Type is
    begin
        return Index_Type(OI.outputs.Length);
    end NOutputs;

    ------------
    -- Output --
    ------------

    overriding
    function Output (OI : Output_Vector; idx : Index_Type) return Connection_Type is
    begin
        return OI.outputs(idx);
    end Output;

    ----------------
    -- Add_Output --
    overriding
    procedure Add_Output(OI : in out Output_Vector; N : Index_Type := 1) is
    begin
        for o of OI.outputs loop
            -- need to ensure that passed connection is not a duplicate
            if o = Output then
                raise Duplicate_Connection;
            end if;
        end loop;
        OI.outputs.Append(Output);
    end Add_Output;

    overriding
    procedure Connect_Output(OI : in out Output_Vector; Output : Connection_Type) is
    begin
        for o of OI.outputs loop
            -- need to ensure that passed connection is not a duplicate
            if o = Output then
                raise Duplicate_Connection;
            end if;
        end loop;
        OI.outputs.Append(Output);
    end Connect_Output;

    ----------------
    -- Del_Output --
    overriding
    procedure Del_Output (OI : in out Output_Vector; Output : Connection_Type) is
        -- The other side of connection has no concept of our internal index,
        -- so it cannot be passed to our method.
        -- So we do a search based on the passed idx (all connections are unique).
        -- and remove the index we found.
    begin
        -- search for connection
        for o in 1 .. Index_Type(OI.outputs.Length) loop
            -- need to ensure that passed connection is not a duplicate
            if OI.outputs(o) = Output then
                OI.outputs.Delete(o);
                return;
            end if;
        end loop;
        -- if we got here, connection was not found
        raise Connection_Not_Found;
    end Del_Output;

end connectors.vectors;
