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
