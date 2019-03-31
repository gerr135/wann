-- This is a common interface for outputs of neurons and the net.
-- the semantics seem to be similar, even if connection designation may have different meaning
--
-- In case of Neurons a single output is connected to multiple other entities (neurons or outputs).
-- In the case of NNet, multiple outputs with each connected to a single entity.
-- So, in either case, its NN.Connection_Index on the other side..

generic
    type Index_Base is range <>;     -- an internal index of outputs
    type Connection_Type is private; -- an external handle, most likely NN.Connection_Index in all cases
package Connectors is

    -- exceptions associated with Outputting_Interface
    Duplicate_Connection : exception;
    Connection_Not_Found : exception;

    subtype Index_Type is Index_Base range Index_Base'First + 1 .. Index_Base'Last;

    type Outputting_Interface is limited interface;
    -- This one is used to provide a common signature for output handling by neurons ans inputs
    -- both have outputs handled in the same way. Neuron_Interface provides additional input-related
    -- methods. And both Input_Interface and Neuron_Interface have more specific primitives.

    -- Output handling primitives. Only handle internals. The other side is handled by NNet
    function NOutputs(OI : Outputting_Interface) return Index_Base is abstract;
    function Output  (OI : Outputting_Interface; idx :  Index_Type) return Connection_Type is abstract;

    -- general use case is to pre-create neuron/net with given amount of connections
    -- so we need separate Add_ and Connect_ methods
--     procedure Add_Output(OI : in out Outputting_Interface; N : Index_Type := 1) is abstract;

    procedure Connect_Output(OI : in out Outputting_Interface; Output : Connection_Type) is abstract;

--     procedure Del_Output(OI : in out Outputting_Interface; Output : Connection_Type) is abstract;
    -- The other side has no knowledge of internal index (and it does not even exist at the Add_),
    -- so output to be deleted should be IDed by the NNet idx..



    ----------------------------------------------------
    -- common class-wide functionality, basic wrapper(s)
    procedure Add_Output(OI : in out Outputting_Interface'Class; Output : Connection_Type);
        -- a basic wrapper, calling Add_Output and then Connect_Output for a single entry

end Connectors;
