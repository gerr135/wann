pragma Ada_2012;
package body wann.inputs.vectors is

    ------------
    -- Output --
    overriding
    function Output (IT : Input_Type; idx : OutputIndex) return NN.ConnectionIndex is
    begin
        return IT.outputs(idx);
    end Output;

    ----------------
    -- Add_Output --
    overriding
    procedure Add_Output (IT : in out Input_Type; Output : NN.ConnectionIndex) is
    begin
        for o of IT.outputs loop
            -- need to ensure that passed connection is not a duplicate
            if o = Output then
                raise Duplicate_Connection;
            end if;
        end loop;
        IT.outputs.Append(Output);
    end Add_Output;

    ----------------
    -- Del_Output --
    overriding
    procedure Del_Output (IT : in out Input_Type; Output : NN.ConnectionIndex) is
        -- The other side of connection has no concept of our internal index,
        -- so it cannot be passed to our method.
        -- So we do a search based on the passed idx (all connections are unique).
        -- and remove the index we found.
    begin
        -- search for connection
        for o in 1 .. OutputIndex(IT.outputs.Length) loop
            -- need to ensure that passed connection is not a duplicate
            if IT.outputs(o) = Output then
                IT.outputs.Delete(o);
                return;
            end if;
        end loop;
        -- if we got here, connection was not found
        raise Connection_Not_Found;
    end Del_Output;

end wann.inputs.vectors;
