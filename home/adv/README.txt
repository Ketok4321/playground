Advanced Esolang (adv in short) is an object oriented esolang.
Currently it's in development.

In adv there's:
 - no primitives
 - no static state

# Theory

The builtin library contains only very few classes, as everything that can be implemented by a library is meant to be implemented by a library. (you can dump its contents by running 'adv gen builtin -o builtin.adv'
The standard library can be found in the 'std' directory, among a lot of other things, it contains abstractions for creating a number implementation.
The most popular number implementation is called ClassNumber, and implements each number as a separate class, to obtain it, use a generator.

# Generators

Std library isn't enough to run an advanced program, most programs will also depend on some of the generated libraries.
In the 'generated' directory, you can find a gen.sh script.
Running it will generate class_number.adv and array.adv with a number of classes choosen to be optimal for this vm.

# Running adv programs

In the 'samples' directory there are example programs written in adv.
You can run them using 'adv run {path}'.
