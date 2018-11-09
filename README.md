# wann - Neural Networks the Ada way
Well, yeah, that would make it nnaw, but that acronym is plain unreadable, while wann sounds good :).

The idea here is to use Ada features, such as separate interface section with its powerful data layout capabilities, to separate network design and minimize actual code. Typically (with Ada) once the interfaces have been properly designed, the implementation code is trivial or boring. Here, in simple cases, it might not be needed at all. At least this is the idea. Plus, we would get a "fully compiled" (down to platform-specific optimizations of gcc) structure, which might be a bit more efficient, or might not, due to less parallelism..

This is more of an excersize at the moment, to get something a bit different from Keras, tensorflow and such and potentially test one idea of FSM (Flying Spagetti Monster) NN. Once the library basics are in I may experiment with one idea I have and depending on results either release it (as a separate project using this one) or abandon both altogehter..

Some specifics: the chosen approach is different from Keras, tensorflow or other common libs in that, instead of focusing on layers with (usually) full connectivity and directly translating that into matrix/"tensor" algebra, this will try to represent actual connections explicitly as the core structure. This fill feed into that one idea I want to test later..
Basic structure: the NN consists of connectrons (m-to-n inputs/outputs), which are composed of other connectrons, etc. recursively. Neuron (end-point, n-to-1) is one dpecial case of connectorn. This is designed to go "back to the roots" and mimick brain structure a bit more closely. Still, nothing revolutonally new, but maybe some small tweak might get useful.
