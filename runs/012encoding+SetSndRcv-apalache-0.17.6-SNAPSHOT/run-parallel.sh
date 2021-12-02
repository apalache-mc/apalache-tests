#!/bin/bash
cd "/home/runner/work/apalache-tests/apalache-tests/runs/012encoding+SetSndRcv-apalache-0.17.6-SNAPSHOT"
parallel -a /home/runner/work/apalache-tests/apalache-tests/runs/012encoding+SetSndRcv-apalache-0.17.6-SNAPSHOT/run-all.sh --delay 3 --results 'out/{#}/'  
