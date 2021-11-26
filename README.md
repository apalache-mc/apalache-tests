# apalache-tests

This repository contains various benchmarks for evaluating performance of the
[Apalache model checker][apalache]. Many of these benchmarks are adapted from
the [TLA+ examples](https://github.com/tlaplus/Examples) and thus are
distributed under [their
license](https://github.com/tlaplus/Examples/blob/master/LICENSE.md). Some
benchmarks have their own licenses, which we kindly ask you to respect.

## Performance benchmarks

See the results for [inductive invariants](results/001indinv-report.md)
and [bounded model checking](results/002bmc-report.md).

## Parametric benchmarks

Here we collect benchmarks that can be scaled according to some parameter.
They are helpful to assess how various model checking methods scale wrt. the parameter.

See the results for:

- [set addition](results/003SetAdd-report.md)
- [set addition and deletion](results/004SetAddDel-report.md)
- [set send and receive](results/005SetSndRcv-report.md)
- [set send and receive with unreachable error state](results/006SetSndRcv_NoFullDrop-report.md)
- [set send and receive with unreachable error state, encoded with cardinalities](results/007SetSndRcv_NoFullDropCard-report.md)
- [integer clocks](results/008IntClocks-report.md)
- [integer clocks with unreachable error state](results/009IntClocks_Bounded-report.md)

In these benchmarks we compare how symbolic approach of Apalache v. 0.7.0 behaves compared to explicit state model checking of TLC, and to the quantified SMT encoding of bounded model checking, solved with Z3. As we compare Apalache v. 0.7.0, against TLC and Z3, bundled with the current build of Apalache, we show v. 0.7.0 for those tools as well -- their actual versions are different!

## Usage

Benchmarks are run via GitHub actions, configured in
[.github/workflows/benchmarks.yml](.github/workflows/benchmarks.yml).

New benchmarks are run automatically from the `unstable` branch of [Apalache][]
every Saturday.

You can manually trigger the benchmarks to run for a specific released version
(or from `unstable` by specifying the version as `unreleased`) by selecting "Run
workflow" from the [Run Benchmarks action][gh-action].

You can also specify a strategy to run. Valid strategies are listed in the
[./STRATEGIES](./STRATEGIES) and [./ENCODING_STRATEGIES](./ENCODING_STRATEGIES)
files. Additionally, you can supply the string `arrays-encoding` to run all
strategies focused on benchmarking the experimental array-based SMT encoding.

[gh-action]: https://github.com/informalsystems/apalache-tests/actions?query=workflow%3A%22Run+Benchmarks%22

### Running the benchmarks locally

#### Dependencies

- Python3, including
  - `matplotlib` via `pip install matplotlib`
  - `csvtomd` via `pip install csvtomd`
  - (if you use pipenv, then just `pipenv shell`)
- [GNU Parallel](https://www.gnu.org/software/parallel/)
  - Ubuntu: `apt install parallel`

##### On Mac OS

- [gnu-time](https://formulae.brew.sh/formula/gnu-time)
- `gtimeout` via `brew install coreutils`

##### On Linux

- [time](https://www.gnu.org/software/time/)

#### Running the benchmarks locally

For instructions on how to run benchmarks and generate the reports, run

```sh
make help
```

New reports are saved into [./results](./results).

#### NOTES

- The source of truth for currently supported strategies is the file
  [./STRATEGIES](./STRATEGIES).

## Warning

**These specifications should not be used for learning TLA+**.
We are collecting the specifications that are challenging for our model checker.
These specifications are usually modified in a way that makes it easier
Apalache to analyze them. So these specifications may contain bugs that were not present in the original specifications.

**If you like to learn TLA+**, check [Leslie Lamport's TLA+ Home Page](http://lamport.azurewebsites.net/tla/tla.html).

[apalache]: https://github.com/informalsystems/apalache
