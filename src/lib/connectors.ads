-- This is a service subpackage, containing utility connection types - e.g. 1-to-many connections.
-- The semantics seem to be similar, even if connection designation may have different meaning,
-- so it makes sense to have a single common package for all such instances.
--
-- NOTE: the outputs are unique (otherwise we get duplicate connections).
--
-- In case of Neurons a single output is connected to multiple other entities (neurons or outputs).
-- In the case of NNet, single NNet input can be connected to multiple neurons
-- (or even outputs directly, in a pass-thrugh configuration).
-- So, in either case, its NN.Connection_Index on the other side..
--
-- NOTE: this only handles common code for the "container" itself - add/delete/assign, etc.
-- Any adjustment on the other side needs to be done in derived methods, as only actual neuons/nets
-- would have access to appropriate data..

generic
    type Index_Base is range <>;     -- index of eintries - externally defined
    type Connection_Type is private; -- an external handle, most likely NN.Connection_Index in all cases
    No_Connection : Connection_Type;
package Connectors is

    -- exceptions associated with Connector_Interface
    Duplicate_Connection : exception;
        -- raised when trying to add a duplicate index to prevent identical connections

    Connection_Not_Found : exception;
        -- raised by Del_Output or any lookup by external index (when not found)
        -- raised by Connect_Next_Unused if no free ends are found

    subtype Index_Type is Index_Base range Index_Base'First + 1 .. Index_Base'Last;

    ----------------------------------------------------------
    -- main type
    -- Used to provide a common signature for output handling by neurons ans inputs
    -- both have outputs handled in the same way. Neuron_Interface provides additional input-related
    -- methods. And both Input_Interface and Neuron_Interface have more specific primitives.
    --
    type Connector_Interface is limited interface;

    -- Output handling primitives. Only handle internals.
    -- The other side should be handled by calling entity
    function NOutputs(OI : Connector_Interface) return Index_Base is abstract;
    function Output  (OI : Connector_Interface; idx :  Index_Type) return Connection_Type is abstract;

    -- general use case is to pre-create neuron/net with given amount of connections
    -- so we need separate Add_ and Connect_ methods
    procedure Add_Output(OI : in out Connector_Interface; N : Index_Type := 1) is abstract;

    procedure Connect_Output(OI : in out Connector_Interface;
                             idx : Index_Type;      -- which output
                             val : Connection_Type  -- to where
                            ) is abstract;

    procedure Del_Output(OI : in out Connector_Interface; Output : Connection_Type) is abstract;
    -- The other side has no knowledge of internal index,
    -- so output to be deleted should be IDed by the NNet idx..


    ----------------------------------------------------
    -- common class-wide functionality, basic wrapper(s)
    --
    procedure Add_and_Connect(OI : in out Connector_Interface'Class; Output : Connection_Type);
    -- a basic wrapper, calling Add_Output and then Connect_Output for a single entry

    procedure Connect_Next_Unused(OI : in out Connector_Interface'Class; val : Connection_Type);
    -- loop through existing outputs and assign first unattached.

end Connectors;
