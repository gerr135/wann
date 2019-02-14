generic
    type Index_Type is range <>;
package wann.Connectors is

    -- exceptions associated with Outputting_Interface
    Duplicate_Connection : exception;
    Connection_Not_Found : exception;

    type Outputting_Interface is interface;
    -- This one is used to provide a common signature for output handling by neurons ans inputs
    -- both have outputs handled in the same way. Neuron_Interface provides additional input-related
    -- methods. And both Input_Interface and Neuron_Interface have more specific primitives.

    -- Output handling primitives. Only handle internals. The other side is handled by NNet
    --
    -- getters
    function NOutputs(OI : Outputting_Interface) return Index_Type is abstract;
    function Output  (OI : Outputting_Interface; idx : Index_Type) return NN.ConnectionIndex is abstract;
    --
    -- setters
    procedure Add_Output(OI : in out Outputting_Interface; Output : NN.ConnectionIndex) is abstract;
    procedure Del_Output(OI : in out Outputting_Interface; Output : NN.ConnectionIndex) is abstract;
    -- The other side has no knowledge of internal index (and it does not even exist at the Add_),
    -- so output to be deleted should be IDed by the NNet idx..

end wann.Connectors;

