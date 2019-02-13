# wann - Neural Networks the Ada way
Well, yeah, that would make it nnaw, but that acronym is plain unreadable, while wann
sounds good :).

The idea here is to use Ada features, such as separate interface section with its
powerful data layout capabilities, to separate network design and minimize actual code.
Typically (with Ada) once the interfaces have been properly designed, the implementation
code is trivial or boring. Here, in simple cases, it might not be needed at all. At least
this is the idea. Plus, we would get a "fully compiled" (down to platform-specific
optimizations of gcc) structure, which might be a bit more efficient, or might not, due
to less parallelism..

This is more of an excersize at the moment, to get something a bit different from Keras,
tensorflow and such and potentially test one idea of FSM (Flying Spagetti Monster) NN.
Once the library basics are in I may experiment with one idea I have and depending on
results either release it (as a separate project using this one) or abandon both
altogehter..

# Some specifics:
the chosen approach is different from Keras, tensorflow or other common
libs in that, instead of focusing on layers with (usually) full connectivity and directly
translating that into matrix/"tensor" algebra, this will try to represent actual
connections explicitly as the core structure. This fill feed into that one idea I want to
test later..

## Basic structure:
the NN consists of connectrons (m-to-n inputs/outputs), which are
composed of other connectrons. Neuron (end-point, n-to-1) is one special
case of connectorn. This is designed to go "back to the roots" and mimick brain structure
a bit more closely. Still, nothing revolutonally new, but maybe some small tweak might
get useful.

The initial implementation will handle just one "connectron". Recursive layering will wait
until the initial prototyping is done and single blob thing is working.

### Topology layout
NNet consists of [inputs,neurons,outputs; layers].
- input:  1-to-N connection, each is connected to multiple neurons
- neuron: N-to-N connection. Multiple outputs, single output value shared with multiple other inputs
- output: 1-to-1. Takes input from a single neuron.
    To mix inputs we need an active entity, which is essentially a neuron anyway. So Outputs are
    purely a service buffer in NNet.

- layers: do not hold extra stuff or do not pass extra info. They are there to organize neurons.
    Created automatically by sort methods or autoupdated if autosort is set.

NOTE: NNet is essentially an N-to-N thingy, a "connectron" cited above. We should npt need
an extra class/type to hold that connectron separately. The recursive structure can be added
a bit later as a feature, by allowing NNet to contain other NNets rather than only neurons..
The possible uses of this:
1. complexification. Especially coupled with automutations, this can be a powerful mechanism
    to go beyond simple uses. (human readability of the ensuing "spagetty mess" is not the
    desired feature here. In fact, the main design principle *is* to leave this behind and
    allow as much mess as the system itself can handle. Ada is of use here to ensure the
    consistency of the basic elements of the unrelying strucutre.)

2. comprehensibility. Quite the contrary effect might be achieved at the same time. If the
    net is allowed to evolve, it may develop "base blocks" serving some common purpose.
    Some known layouts can be used as seeds to facilitate the convergence towards what we expect
    to be essential blocks (visual recognition, text processing, etc..). Left to evolve,
    we may be able to retain these conceptually understood blocks in the net.

NOTE 2: the balance between these two utilities may be controlled to some extent by varying
the cost of creation/destruction of inner NNet units. Set it higher than Neuron creation/destruction,
by a little or by orders of magnitude..


For the design/data representation specifics see Readme under src/.

# On the choice of language:
Basically, why Ada? Well, the real question here is "why not *my favorite language*"?
So:

1. Why not Python?
Python is great. Especially for quick prototyping or when you want to quickly layout some
blocks to form soem basic structure and then play with it. Unfortunately absence of
proper data typing and abstraction and pretty much complete absence of checks make it
ill-suited for big and/or long-term projects. Especially if you expect to go in bursts of
a few weeks coding interspaced by month or years of inactivity. Any attempt to get back
into interrupted code that counts in thousands of lines and which you did not touch for
over a year, quickly turns into depressive or even futile endeavor..

This is where Ada excels: by forcing you think hard of design up-front and then enforcing
all those pedantic checks even on your data layout design (you can compile your ideas -
literally), it forces you to keep your code and design documents in some reasonable
order. Typically its rather easy to get back in and understand the intention that you had
some years ago, when you laid out the basics. In any case, way easier than in any other
language I used regulatly (C++ family, Python, Java).

Finally, as *the Ada compiler* is essentially gcc, you can prepare your code for a
specific ARCH, gaining all the C-level optimization features.

2. Why not C/C++?
Well, yes, it might get you that last bit of optimization, and it does have some data
layout capabilities, but its a far cry from Ada's capabilities (for constructing data
types and all the integrated checks). So, most points wrt Python stand here too. Plus,
optimization-wise its not much diffeernt - both (Ada ans C++) are frontends to gcc. With
some switches (if you are willing to risk losing month of training time to possibly gain
a day in a process) you may disable any or all of the additional checks that Ada performs
by default and get basically the same binary code..


Finally, if by some miracle this thing gets popular enough (or even complete), I might
provide Python/C bindings to the library.
