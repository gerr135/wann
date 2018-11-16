pragma Ada_2012;
package body wann.nets.fixed is


    overriding
    procedure NewNeuron (net : in out NNet_Fixed; idx : out NNIndex_Base) is
        -- everything is static, we do not really create any neurons..
        -- just return the number of next one with unassigned params.
    begin
        if net.Nassigned >= net.Npts then
            raise NetOverflow;
        end if;
        net.Nassigned := net.Nassigned + 1;
        idx := NNIndex(net.Nassigned);
        -- here we essentialy create a 1:1 mapping from inner to outer indices
    end NewNeuron;


   ---------------
   -- SetNeuron --
   ---------------

    overriding
    function  GetNeuron(net : NNet_Fixed; idx : NNIndex) return NeuronRec is
        Stub : NeuronRec(Nin=>0) :=
            ( idx => 0, lag => 0.0,
              Nin => 0,
              activat => Sigmoid,
              weights => (others=>0.0),
              inputs  => (others=>(N,0)) );
    begin
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "SetNeuron unimplemented");
        raise Program_Error with "Unimplemented procedure SetNeuron";
        return Stub;
    end GetNeuron;


    overriding
    procedure SetNeuron (net : in out NNet_Fixed; neur : NeuronRec) is
    begin
        -- init the inner neuron entry

        -- process all connections
        --  Generated stub: replace with real body!
        pragma Compile_Time_Warning (Standard.True, "SetNeuron unimplemented");
        raise Program_Error with "Unimplemented procedure SetNeuron";
    end SetNeuron;

end wann.nets.fixed;
