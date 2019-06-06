pragma Ada_2012;
package body connectors.vectors is

    overriding
    function NOutputs (OI : Connector_Vector) return Index_Base is
    begin
        return Index_Base(OI.outputs.Length);
    end NOutputs;

    overriding
    function Output (OI : Connector_Vector; idx : Index_Type) return Connection_Type is
    begin
        return OI.outputs(idx);
    end Output;

    ----------------
    -- Add_Output --
    overriding
    procedure Add_Output(OI : in out Connector_Vector; N : Index_Type := 1) is
        -- add N unconnected entries
    begin
        OI.outputs.Append(No_Connection, Count => Ada.Containers.Count_Type(N));
    end Add_Output;

    overriding
    procedure Connect_Output(OI : in out Connector_Vector; idx : Index_Type; val : Connection_Type) is
    begin
        -- need to ensure that passed connection is not a duplicate of already attached one
        -- (except the one at idx)
        for o in Index_Type'First .. idx - 1 loop
            if OI.outputs(o) = val then
                raise Duplicate_Connection;
            end if;
        end loop;
        for o in idx + 1 .. OI.NOutputs loop
            if OI.outputs(o) = val then
                raise Duplicate_Connection;
            end if;
        end loop;
        OI.outputs.Replace_Element(idx, val);
    end Connect_Output;

    ----------------
    -- Del_Output --
    overriding
    procedure Del_Output (OI : in out Connector_Vector; Output : Connection_Type) is
        -- The other side of connection has no concept of our internal index,
        -- so it cannot be passed to our method.
        -- So we do a search based on the passed idx (all connections are unique).
        -- and remove the index we found.
    begin
        -- search for connection
        for o in 1 .. Index_Type(OI.outputs.Length) loop
            if OI.outputs(o) = Output then
                OI.outputs.Delete(o);
                return;
            end if;
        end loop;
        -- if we got here, connection was not found
        raise Connection_Not_Found;
    end Del_Output;


end connectors.vectors;
