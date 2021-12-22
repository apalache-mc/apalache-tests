# Results of 012encoding+SetSndRcv-apalache


## 1. Awesome plots

### 1.1. Time (logarithmic scale)

![time-log](012encoding+SetSndRcv-apalache-time-log.svg "Time Log")

### 1.2. Time (linear)

![time-log](012encoding+SetSndRcv-apalache-time.svg "Time Log")

### 1.3. Memory (logarithmic scale)

![mem-log](012encoding+SetSndRcv-apalache-mem-log.svg "Memory Log")

### 1.4. Memory (linear)

![mem](012encoding+SetSndRcv-apalache-mem.svg "Memory Log")

### 1.5. Number of arena cells (linear)

![ncells](012encoding+SetSndRcv-apalache-ncells.svg "Number of arena cells")

### 1.6. Number of SMT clauses (linear)

![nclauses](012encoding+SetSndRcv-apalache-nclauses.svg "Number of SMT clauses")

## 2. Input parameters

no  |  filename                      |  tool      |  timeout  |  init  |  inv  |  next  |  args
----|--------------------------------|------------|-----------|--------|-------|--------|-----------------------------------------------------
1   |  array-encoding/SetSndRcv.tla  |  apalache  |  2h       |  Init  |  Inv  |  Next  |  --smt-encoding=arrays --length=0 --cinit=CInit0
2   |  array-encoding/SetSndRcv.tla  |  apalache  |  2h       |  Init  |  Inv  |  Next  |  --smt-encoding=arrays --length=2 --cinit=CInit2
3   |  array-encoding/SetSndRcv.tla  |  apalache  |  2h       |  Init  |  Inv  |  Next  |  --smt-encoding=arrays --length=4 --cinit=CInit4
4   |  array-encoding/SetSndRcv.tla  |  apalache  |  2h       |  Init  |  Inv  |  Next  |  --smt-encoding=arrays --length=6 --cinit=CInit6
5   |  array-encoding/SetSndRcv.tla  |  apalache  |  2h       |  Init  |  Inv  |  Next  |  --smt-encoding=arrays --length=8 --cinit=CInit8
6   |  array-encoding/SetSndRcv.tla  |  apalache  |  2h       |  Init  |  Inv  |  Next  |  --smt-encoding=arrays --length=10 --cinit=CInit10
7   |  array-encoding/SetSndRcv.tla  |  apalache  |  2h       |  Init  |  Inv  |  Next  |  --smt-encoding=arrays --length=12 --cinit=CInit12
8   |  array-encoding/SetSndRcv.tla  |  apalache  |  2h       |  Init  |  Inv  |  Next  |  --smt-encoding=arrays --length=14 --cinit=CInit14
9   |  array-encoding/SetSndRcv.tla  |  apalache  |  2h       |  Init  |  Inv  |  Next  |  --smt-encoding=oopsla19 --length=0 --cinit=CInit0
10  |  array-encoding/SetSndRcv.tla  |  apalache  |  2h       |  Init  |  Inv  |  Next  |  --smt-encoding=oopsla19 --length=2 --cinit=CInit2
11  |  array-encoding/SetSndRcv.tla  |  apalache  |  2h       |  Init  |  Inv  |  Next  |  --smt-encoding=oopsla19 --length=4 --cinit=CInit4
12  |  array-encoding/SetSndRcv.tla  |  apalache  |  2h       |  Init  |  Inv  |  Next  |  --smt-encoding=oopsla19 --length=6 --cinit=CInit6
13  |  array-encoding/SetSndRcv.tla  |  apalache  |  2h       |  Init  |  Inv  |  Next  |  --smt-encoding=oopsla19 --length=8 --cinit=CInit8
14  |  array-encoding/SetSndRcv.tla  |  apalache  |  2h       |  Init  |  Inv  |  Next  |  --smt-encoding=oopsla19 --length=10 --cinit=CInit10
15  |  array-encoding/SetSndRcv.tla  |  apalache  |  2h       |  Init  |  Inv  |  Next  |  --smt-encoding=oopsla19 --length=12 --cinit=CInit12
16  |  array-encoding/SetSndRcv.tla  |  apalache  |  2h       |  Init  |  Inv  |  Next  |  --smt-encoding=oopsla19 --length=14 --cinit=CInit14

## 3. Detailed results: 012encoding+SetSndRcv-apalache-0.19.1-SNAPSHOT.csv

01:no  |  02:tool   |  03:status  |  04:time_sec  |  05:depth  |  05:mem_kb  |  10:ninit_trans  |  11:ninit_trans  |  12:ncells  |  13:nclauses  |  14:navg_clause_len
-------|------------|-------------|---------------|------------|-------------|------------------|------------------|-------------|---------------|--------------------
1      |  apalache  |  NoError    |  3s           |  0         |  189MB      |  0               |  0               |  12         |  7.0          |  6.0
2      |  apalache  |  NoError    |  3s           |  0         |  193MB      |  0               |  0               |  83         |  74           |  9.0
3      |  apalache  |  NoError    |  3s           |  0         |  210MB      |  0               |  0               |  207        |  197          |  11
4      |  apalache  |  NoError    |  4s           |  0         |  211MB      |  0               |  0               |  355        |  348          |  12
5      |  apalache  |  NoError    |  21s          |  0         |  215MB      |  0               |  0               |  527        |  527          |  13
6      |  apalache  |  NoError    |  4m04s        |  0         |  248MB      |  0               |  0               |  723        |  734          |  14
7      |  apalache  |  NoError    |  46m          |  0         |  321MB      |  0               |  0               |  943        |  969          |  15
8      |  apalache  |  Timeout    |  2h02m        |  0         |  3.0MB      |  0               |  0               |  1.0K       |  1.0K         |  15
9      |  apalache  |  NoError    |  5s           |  0         |  191MB      |  0               |  0               |  13         |  11           |  6.0
10     |  apalache  |  NoError    |  4s           |  0         |  193MB      |  0               |  0               |  93         |  99           |  9.0
11     |  apalache  |  NoError    |  4s           |  0         |  205MB      |  0               |  0               |  235        |  258          |  11
12     |  apalache  |  NoError    |  5s           |  0         |  204MB      |  0               |  0               |  401        |  445          |  12
13     |  apalache  |  NoError    |  5s           |  0         |  205MB      |  0               |  0               |  591        |  660          |  14
14     |  apalache  |  NoError    |  11s          |  0         |  233MB      |  0               |  0               |  805        |  903          |  15
15     |  apalache  |  NoError    |  1m01s        |  0         |  236MB      |  0               |  0               |  1.0K       |  1.0K         |  16
16     |  apalache  |  NoError    |  4m04s        |  0         |  229MB      |  0               |  0               |  1.0K       |  1.0K         |  17
