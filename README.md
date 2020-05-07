# apalache-tests

This repository contains various benchmarks for evaluating performance of the
[Apalache model checker](https://github.com/konnov/apalache). Many of these
benchmarks are adapted from the [TLA+
examples](https://github.com/tlaplus/Examples) and thus are distributed under
[their license](https://github.com/tlaplus/Examples/blob/master/LICENSE.md).
Some benchmarks have their own licenses, which we kindly ask you to respect.

## Performance benchmarks

See the results for [inductive invariants](results/001indinv-report.md)
and [bounded model checking](results/002bmc-report.md).

## Parametric benchmarks

Here we collect benchmarks that can be scaled according to some parameter. 
They are helpful to assess how various model checking methods scale wrt. the parameter.

See the results for:
  * [set addition](results/003SetAdd-report.md)
  * [set addition and deletion](results/004SetAddDel-report.md)
  * [set send and receive](results/005SetSndRcv-report.md)
  * [set send and receive with unreachable error state](results/006SetSndRcv_NoFullDrop-report.md)
  * [set send and receive with unreachable error state, encoded with cardinalities](results/007SetSndRcv_NoFullDropCard-report.md)
  * [integer clocks](results/008IntClocks-report.md)
  * [integer clocks with unreachable error state](results/009IntClocks_Bounded-report.md)


In these benchmarks we compare how symbolic approach of Apalache v. 0.7.0 behaves compared to explicit state model checking of TLC, and to the quantified SMT encoding of bounded model checking, solved with Z3. As we compare Apalache v. 0.7.0, against TLC and Z3, bundled with the current build of Apalache, we show v. 0.7.0 for those tools as well -- their actual versions are different!

## Warning

**These specifications should not be used for learning TLA+**.
We are collecting the specifications that are challenging for our model checker.
These specifications are usually modified in a way that makes it easier
Apalache to analyze them. So these specifications may contain bugs that were not present in the original specifications.

**If you like to learn TLA+**, check [Leslie Lamport's TLA+ Home Page](http://lamport.azurewebsites.net/tla/tla.html).
