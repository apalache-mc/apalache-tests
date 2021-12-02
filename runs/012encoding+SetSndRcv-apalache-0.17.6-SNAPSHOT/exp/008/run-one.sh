#!/bin/bash
D=`dirname $0` && D=`cd "$D"; pwd` && cd "$D"
/usr/bin/time -f 'elapsed_sec: %e maxresident_kb: %M' -o time.out /usr/bin/timeout --foreground 2h /home/runner/work/apalache-tests/apalache-tests/_apalache/apalache-0.17.6-SNAPSHOT/bin/apalache-mc check --profiling=true --run-dir=./out --init=Init --next=Next --inv=Inv --smt-encoding=arrays --length=14 --cinit=CInit14  SetSndRcv.tla | tee apalache.out
exitcode="$?"
echo "EXITCODE=$exitcode"
exit "$exitcode"
