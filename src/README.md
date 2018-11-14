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

## NNet inner layout
The most straightforward approach would be to intermix inputs, outputs and neurons, say
reserving 1 .. Nin indices for inputs, Nin+1 .. Nin+Nout for outputs and the rest for
actual neurons. This is how it is done commonly and how I attempted it initially. However
this only works
for the fixed nnets. At the very least, Nin and Nout have to be fixed, otherwise any
change to inputs/outputs would require a complete reindexing of all connections. An
alternative would be to use a separate Connector type, that can attach to all 3 classes.
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
