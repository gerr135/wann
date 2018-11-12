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
1. An extra parameter is introduced: the delay. This is amount of time (float, in steps) 
the output from a given neuron is delayed. Upon arrival of new inputs, the output is 
calculated and stored and "activated" when delay has passed. Meanwhile old output value 
is transmitted.

2. A simulation of the network is necessary. To track that a notion of a "field" is 
introduced. All outputs are stored/cached by the NNet object and passed to neurons as 
input on a new evaluation step.

3. Backpropagation/training: weights/bias should be as usual, but delay factor may 
require some thinking. Perhaps something can be borrowed from RNNs. The most precise way 
would be to follow proper simulation: solve those nasty partial derivatives 
(over time and "space" - weights, but those are standard. The time though introduces a 
new dimension.)


# Representation notes

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

## Representation formats
Two are envisioned: 
1. human-readable string representation. Two variants:
    1. Complete representation for parsing in/out - JSON makes sense. Need to dig JSON lib for Ada..
    Intended for proper IO/storage and ARCH independed exchange.
    JSON libs: 1 simple search yields 2 seemingly reasonable libs:
        1. an older but more stable feature-rich?, part of gnatcoll: 
           https://docs.adacore.com/gnatcoll-docs/json.html<br>
           NOTE: it seems that a more up-to-date version of gnatcvoll is on github now:
           https://github.com/AdaCore/gnatcoll-core/blob/master/src/gnatcoll-json.ads<br>
           Gnatcoll itself was split into multiple packages:<br>
           https://github.com/AdaCore/gnatcoll  - original library, only README left pointing the split parts
           https://github.com/AdaCore/gnatcoll-core  - the core library. The other parts 
           are essentially just bindings to Python and other languages and libs.
        2. some github project, more recent required Ada-2012, but less features? 
           In particular, no Unicode support:  https://github.com/onox/json-ada
    2. Compact topology-only: straight string with () for grouping or indented multiline text?
    This one is intended for easy overview of the current topology..

2.  Binary - essentially an in-memory stream IO of representation records. 
    For quick (binary) IO/storage and applying genetic algorythms 
    (as these should have much better field-width consistency).
