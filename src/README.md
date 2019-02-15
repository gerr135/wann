# Design notes:

The ultimate goal of this lib (on top of getting some basic practice) is to have a
library supporting nasty unstructured NNets, where all kinds of loops are allowed. The
"flying spagetti monster" net in a sense. The standard most common layered approach (as
in Keras, tensorflow, etc) is not really applicable here. Such a net could be easily
expressed as neurons linking to other neurons and propagating (forward/back) by calling
each other's methods. However that leads to recursion - already a potential for nasty
slowdown (unless some spechial ARCH is used). Moreover, with loops allowed and no nasty
entanglments pevented, this is going to very quickly run astray. The calculations would
explode exponentially, and may not even reach the end of propagation, even forward one..

Instead the following approach is adopted:
1. Central point of this design: mutable nets.
The original idea calls for recursive structure of entire net composed of blocks
("connectrons"), which are in turn composed of other connectrons or neurons.
Neurons here can be treated as a special (and trivial) case of connectron, with an
n-to-1 mapping.
Specifics:
    1. Initial prototyping will deal with NNet composed of neurons. Once this part has clear
    structure and basic functionality, I can return to original idea and generalize.

    2. Mutability is essential for the final implementation, including ability to change
    number of inputs/outputs. However may start prototyping with fixed networks, to be
    able to test calculations - can compare with results produced by classical nets.

2. The delay:  -- NOTE: implementation is delayed for now as it is not clear how to handle it.
Below are the original ideas:
    1. An extra parameter is introduced: the delay. This is amount of time (float, in steps)
    the output from a given neuron is delayed. Upon arrival of new inputs, the output is
    calculated and stored and "activated" when delay has passed. Meanwhile old output value
    is transmitted. -- Implementation of delay is, well, delayed for the moment, as it is not
    very clear how to handle it..

    2. A simulation of the network is necessary. To track that a notion of a "field" is
    introduced. All outputs are stored/cached by the NNet object and passed to neurons as
    input on a new evaluation step.

    3. Backpropagation/training: weights/bias should be as usual, but delay factor may
    require some thinking. Perhaps something can be borrowed from RNNs. The most precise way
    would be to follow proper simulation: solve those nasty partial derivatives
    (over time and "space" - weights, but those are standard. The time though introduces a
    new dimension.)

# Package hierarchy
Most essential packages are rooted at wann.ads. However there are some common index/record types
that are representative of the NNet as a whole. These are defined in nnet_types.ads and
a common import point is declared in wann.ads as package NN is new nnet_types..
Thus, to keep the common notation for contextually similar types (indices, etc), they should
be referred throughout as NN.InputIndex (e.g.). Use package renamings to shorten this if you
import this from outside, rather than reinstantiating the package!

Hierarchy overview:
- wann.ads         root of package hierarchy
- wann.inputs
- wann.neurons
- wann.layers      these all hold appropriate NNet entities
- wann.nets        root of the NNet subhierarchy
- wann.nets.fixed      all-fixed NNet implementation, for reading established topology and using without mutation
- wann.nets.vectors    dynamic NNet root, Neurons can be dynamically rearranged
- wann.nets.vectors.fixedIO    dynamic neurons, fixed IO
- wann.nets.vectors.vectorIO   dynamic all, can even change number of NNet IO connections

NOTE on nets.. hierarchy:
- nets.fixed  - only one, as fixed neurons, variable IO does not make much sense
    or is likely not even possible.
- nets.vectors.fixedIO  - may not be feasible either, as, while total number of IO
    connections is fixed, individual inputs may change number of connections as neurons mutate

Simplyfy things for the moment: save current state in dev2 branch and create new branch dev3,
where nets. hierarchy is rolled back a level, only holding
- wann.nets.fixed
- wann.nets.vectors


# Representation notes

## General treatment - info propagation
The cached field and all the connections/weights could be represented in a most common
way - as a vector and connection matrix. However for the most intended use case, such
matrix would be extremely sparse. More importantly, due to the absence of clear blocking
(due to absence of sequential layers), not much processing serialization can be done  -
an entire matrix has to be kept full-size. With thousands or even millions of elements,
the 10^6x1-^6 matrix is way too big for parallel execution on any GPU collection now or
in foreseable future.

An approach to optimize or even plain make it workable:
The neurons in the net are topologically sorted, with those directly connected to inputs
forming 1st layer. Their outputs forming 2nd layer (including self-cycled neurons), etc..
Cycles are followed until all the outputs are reached/saturated, at which point they are
either dropped or continued, if simulation is followed through (say, to observe the
post-stimulation signals/oscillations..).

Such topological sorting and layering will allow to serialize the simulation,
significantly restricting the width of the network pass-band (back and forth).This should
make the training feasible on available hardware and allow further automation, as
described below. In particular, to keep the network reasonable even in auto-evolution
mode, an increasing score handicap maybe imposed when max width approaches some set
threshold.

This topological sorting can and should be automated. No manual input should be needed
beyond constructing the initial seed network.
The ultimate goal is to allow dynamic network that would add/remove neurons and
connections itself. Initial fit can be performed with a very small network. Then the
network should be allowed to grow to fit the training data better. Genetic algorithms can
be employed to produce a more optimal network.

## NNet indexing
The most straightforward approach would be to intermix inputs, outputs and neurons, say
reserving 1 .. Nin indices for inputs, Nin+1 .. Nin+Nout for outputs and the rest for
actual neurons. This is how it is done commonly and how I attempted it initially. However
this only works for the fixed nnets. At the very least, Nin and Nout have to be fixed,
otherwise any change to inputs/outputs would require a complete reindexing of all connections.

An alternative would be to use a separate Connector type, that can attach to all 3 classes.
This might allow a more streamlined type abstraction and inheritance, but may be less
efficiant than reindexing all the neurons. To summarize, 2 appoaches:

1. Keep a single Index type for inputs, outputs and neurons; distinguish them by reserving
index ranges:
    * inputs  :  1 .. Nin
    * outputs :  Nin + 1 .. Nin + Nout
    * neurons :  Nin + Nout + 1 .. Nin + Nout + Npts
This is a simple way that works well for nnets with fixed number of ins&outs.
Changing Nin or Nout would require a complete reindexing. Also, neurons would normally
track their inputs only, but backpropagation may benefit from keeping track of output
connections too. If all this logic is handled but neurn itself we break "clear analogy",
more importantly the code may be less clear (the intention of various parts/data
structures).

2. Keep neurons simple with all types well isolated. Introduce a Connector type, that
would carry info and connect neuron outputs to other inputs, and vice verse. This might be
less efficient, or not - depending how the backprop is implemented (forward prop
should be trivial either way). One way to keep it efficient, is to use Connectors to track
topology, but do all calculus at NNet/Connectron level - do topological sorting with
matrix calcs between layers. Another plus point is that COnnectors can be reused to
connect Connectrons, when the lib is generalized, as well as they may be necessary anyway
for LSTMs or other RNN/other advanced structures..

So, considering all this, I will likely go with the Connector approach, at least with the
mutable nets. Might try to do a fixed index approach with fixed nnets first, just to get
the formulas verified..

## NNet structure and organization
Major points:
NNet contains:
    - list of Neurons, indexed by NeuronIndex
    - list of layers, created/assigned by sort procedure
  attributes:
    - sorted: set to True by sort procedure. Add_Neuron methods should update layers too when sorted.

Layer contains:
    - list of neurons - needs also a way to access neuron info. Also wann.nets withs wann.layers
      so, to break up the cyclic deps layers contain list of Neuron_Accesses..
    - (optional/optimization) transition matrix?

Layers are constructed by NNet. NNet contains layers and neurons and operates on both. So,
layers are passed neur'Access at creation/modification and operate on those. This gives layers
access to neuron idx's as well as their input/optput connections.
The values are stored in a global data rec - either external or owned by NNet. This rec is
passed to neurons/layers to be updated as needed..

### More on layers
(from the comments in the code):
At the bare level, Layer can be a simple list of neurons, with propagation done
in a simple loop (possibly parallelizable) per-neuron.
More advanced propagators use vectors of values and weight matrices,
to try to parallelize this via mpi or GPU use..
To tie it all together an OOP paradigm is used, as the most natural representation.
The base type, called below Layer_Interface, provides only basic interface and functionality,
with Matrix_Layer_Interface and others overriding it to provide more elaborate propagators.
(with the notion that their derived types would hold additional data, thus they would expose
additional primitives too).

NOTE: layer type should be set at net creation type, as different layr types in hierarchy
would have different (extra) data. Thus it would be impossible anyway to run an optimized
(e.g. Matrix) prop on a net constructed from basic layers..
The other way around can be possible, but does not make much sense. But if it is
really desired, use of basic (inherited) propagator can be forced in a usual OOP way
(by performing a type view conversion).


## NNet linear representation formats
Two are envisioned:
1. human-readable string representation. Two variants:
    1. Complete representation for parsing in/out - JSON makes sense. Need to dig JSON lib
for Ada..
    Intended for proper IO/storage and ARCH independed exchange.
    JSON libs: 1 simple search yields 2 seemingly reasonable libs:
        1. an older but more stable feature-rich?, part of gnatcoll:
           https://docs.adacore.com/gnatcoll-docs/json.html<br>
           NOTE: it seems that a more up-to-date version of gnatcvoll is on github now:
           https://github.com/AdaCore/gnatcoll-core/blob/master/src/gnatcoll-json.ads<br>
           Gnatcoll itself was split into multiple packages:<br>
           https://github.com/AdaCore/gnatcoll  - original library, only README left
pointing the split parts
           https://github.com/AdaCore/gnatcoll-core  - the core library. The other parts
           are essentially just bindings to Python and other languages and libs.
        2. some github project, more recent required Ada-2012, but less features?
           In particular, no Unicode support:  https://github.com/onox/json-ada
    2. Compact topology-only: straight string with () for grouping or indented multiline
text?
    This one is intended for easy overview of the current topology..

2.  Binary - essentially an in-memory stream IO of representation records.
    For quick (binary) IO/storage and applying genetic algorythms
    (as these should have much better field-width consistency).

# Some links for training
CIFAR-10 - 32x32x3 images: https://www.cs.toronto.edu/~kriz/cifar.html


# Some misc notes, remarks from code

## wann.nets
On propagation through layers:
-- NOTE: !!
-- Layers represent just an ordering - that is, neurons in the same layes
-- can prop in parallel, but they can connect to arbitrary other layers;
-- essentially there is no real sequence here,
-- Therefore, we have to store the state of an entire net.
-- so we need a net-wide vector to pass around.
--
-- We achieve essentially the same result by storing the state
-- (current output value) in each neuron. So, we can as well do
-- a statefull propagation.
-- They are essentially identical. The only difference may be in
-- ease of parallelization on different platforms..

## storing values
NNet state can be stored either in "state record" or in neurons themselves.
In the 1st case, neurons only store connection topology, and we use separate record/vector
for forward propagation of values. In the 2nd case topolgy and passed values are mixed.
It is unclear at this point which approach is "better" (and what "better" even means).
Backpropagation updates weights as well, so storing w's separately would require a much
larger structure - an entire matrix, plus this would separate topology from weights and
may make it harder to trace the correspondence, or at least less readable. So, the 2nd way might be preferred in view of this.
However, this would require more elaborate class hierarchy:
Neuron -> Stateful_Neuron
NNet -> NStateful_NNet, etc..

## data organization
I toyed with an idea to create a common library of "List" type hierachy - basically iterable
and indexable container a-la Ada.Container.Vectors. The idea was to follow through with the
general design pattern and to have an interface at the top, that can be implemented as a fixed
array or overlaying or encapsulating ACV.Vector. This lead to creation of the ada_composition
project (available on GitHub). However while experimenting with that, I have triggered multiple
gnat bugs. Apparently the required to implement this features (this heavily relies on aspects
and makes use of more advance type composition and mixin techniques) are too fresh.
This ideam might get revisited in a few years, if gnat starts behaving better. But for now the
wann interfaces wiil rely on simple getters/setters.

## NNet dynamics
Additions are easy - we only add new entities and tie them to already existing indices..
Deletions are much more tricky: what to do with indices throughout if we delete neuron?
We can either
1. update all the indices upon each neuron addition. Which may lead to major overhead
    (as each edletion may potentially lead to complete renumbering ~O(N^2)), but will keep
    the net always consistent.
2. Alternatively we can just delete connections and leave neuron s is (marking it as deleted,
    say by its idx:=0). And then provide a prunning methods (call it Prune or Compact) that
    removes unconnected neurons and renumbers the ones still in the net..

Stricktly speaking, we do not need every NeuronIndex to point to an active neuron. Layers
would only contain active neurons anyway, and all calculations are done by layers. We can
have a sparse indexing throughout. Except for layers, but these are dynamically updated on any
topology change or recreated upon NNet overhaul completeion..

This (sparse indexing) stands for IO as well: there may be an advantage in some situations
to keep the NNet IO interface stable. In fact that will likely be desirable in the majority
of situations - better to have some disconnects rather than reshuffling all the connections
to the outside..
