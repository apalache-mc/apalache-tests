#!/usr/bin/env bash
#
# Produce a markdown report for a set of performance CSVs.
#
# Igor Konnov, Shon Feder 2020-2021

set -euo pipefail

if [ "$#" -lt 2 ]; then
    echo "Use: $0 benchmarks.csv result_1.csv ... result_n.csv"
    exit 1
fi

TASK=$1
shift 1
RESULTS=$@
PREFIX=$(basename -s '.csv' ${TASK})

which csvtomd >/dev/null || (echo "No csvtomd! Run: pip3 install csvtomd"; exit 1)

DIR=`dirname $0`
DIR=`cd "$DIR"; pwd`

seqno=1

cat <<EOF
# Results of $PREFIX

EOF

# produce the plots
"$DIR"/plot.py --logscale 01no "benchmark" 04time_sec "time, sec" \
    $PREFIX-time-log.svg $RESULTS

"$DIR"/plot.py 01no "benchmark" 04time_sec "time, sec" \
    $PREFIX-time.svg $RESULTS

"$DIR"/plot.py --logscale 01no "benchmark" 05mem_kb "memory, KB" \
    $PREFIX-mem-log.svg $RESULTS

"$DIR"/plot.py 01no "benchmark" 05mem_kb "memory, KB" \
    $PREFIX-mem.svg $RESULTS

"$DIR"/plot.py 01no "benchmark" 12ncells "number of arena cells" \
    $PREFIX-ncells.svg $RESULTS

"$DIR"/plot.py 01no "benchmark" 13nclauses "number of SMT clauses" \
    $PREFIX-nclauses.svg $RESULTS

# output the plots
cat <<EOF

## $seqno. Awesome plots

### $seqno.1. Time (logarithmic scale)

![time-log]($PREFIX-time-log.svg "Time Log")

### $seqno.2. Time (linear)

![time-log]($PREFIX-time.svg "Time Log")

### $seqno.3. Memory (logarithmic scale)

![mem-log]($PREFIX-mem-log.svg "Memory Log")

### $seqno.4. Memory (linear)

![mem]($PREFIX-mem.svg "Memory Log")

### $seqno.5. Number of arena cells (linear)

![ncells]($PREFIX-ncells.svg "Number of arena cells")

### $seqno.6. Number of SMT clauses (linear)

![nclauses]($PREFIX-nclauses.svg "Number of SMT clauses")
EOF

seqno=$((1+seqno))

cat <<EOF

## $seqno. Input parameters

EOF

seqno="$((seqno+1))"

# produce the md table with the input
csvtomd <"$TASK"

# produce the md tables with the results
for f in $RESULTS; do
    cat <<EOF

## $seqno. Detailed results: `basename $f`

EOF
   "$DIR/humanise-csv.py" <"$f" | csvtomd 
    
   seqno="$((seqno+1))"
done

