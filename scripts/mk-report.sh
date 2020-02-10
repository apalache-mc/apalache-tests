#!/usr/bin/env bash
#
# Produce a markdown report for a set of performance CSVs.
#
# Igor Konnov, 2020

TASK=$1
shift 1
RESULTS=$@

which -s csvtomd || (echo "No csvtomd! Run: pip3 install csvtomd"; exit 1)

DIR=`dirname $0`
DIR=`cd "$DIR"; pwd`

seqno=1

cat <<EOF
# Results of `basename ${TASK}`

EOF

# produce the plots
"$DIR"/plot.py --logscale 01no "benchmark" 04time_sec "time, sec" \
    time-log.svg $RESULTS

"$DIR"/plot.py 01no "benchmark" 04time_sec "time, sec" \
    time.svg $RESULTS

"$DIR"/plot.py --logscale 01no "benchmark" 05mem_kb "memory, KB" \
    mem-log.svg $RESULTS

"$DIR"/plot.py 01no "benchmark" 05mem_kb "memory, KB" \
    mem.svg $RESULTS

"$DIR"/plot.py 01no "benchmark" 12ncells "number of arena cells" \
    ncells.svg $RESULTS

"$DIR"/plot.py 01no "benchmark" 13nclauses "number of SMT clauses" \
    nclauses.svg $RESULTS

# output the plots
cat <<EOF

## $seqno. Awesome plots

### $seqno.1. Time (logarithmic scale)

![time-log](time-log.svg "Time Log")

### $seqno.2. Time (linear)

![time-log](time.svg "Time Log")

### $seqno.3. Memory (logarithmic scale)

![mem-log](mem-log.svg "Memory Log")

### $seqno.4. Memory (linear)

![mem](mem.svg "Memory Log")

### $seqno.5. Number of arena cells (linear)

![ncells](ncells.svg "Number of arena cells")

### $seqno.6. Number of SMT clauses (linear)

![nclauses](nclauses.svg "Number of SMT clauses")
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

