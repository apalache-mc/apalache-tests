# The main makefile to run all experiments in different configurations.
#
# Igor Konnov, 2020

# The directory where the builds of apalache are stored.
# The builds should be checked out before make is started.
BUILDS_DIR=$(HOME)/devl
BASEDIR=$(shell pwd)
RUN_DIR=$(BASEDIR)/runs
RES_DIR=$(BASEDIR)/results

all: runs

runs: run-0.5.2 run-0.6.0

run-0.5.2: prepare apalache-0.5.2
	./scripts/mk-run.sh ./performance/002bmc-apalache.csv \
		$(BUILDS_DIR)/apalache-0.5.2 ./performance $(RUN_DIR)/0.5.2
	(cd $(RUN_DIR)/0.5.2 && ./run-parallel.sh && \
		$(BASEDIR)/scripts/parse-logs.py . && \
		cp results.csv $(RES_DIR)/002bmc-apalache-0.5.2.csv)

run-0.6.0: prepare apalache-0.6.0
	./scripts/mk-run.sh ./performance/002bmc-apalache.csv \
		$(BUILDS_DIR)/apalache-0.6.0 ./performance $(RUN_DIR)/0.6.0
	(cd $(RUN_DIR)/0.6.0 && ./run-parallel.sh && \
		$(BASEDIR)/scripts/parse-logs.py . && \
		cp results.csv $(RES_DIR)/002bmc-apalache-0.6.0.csv)

apalache-0.5.2:
	make -C $(BUILDS_DIR)/apalache-0.5.2

apalache-0.6.0:
	make -C $(BUILDS_DIR)/apalache-0.6.0

prepare:
	mkdir -p $(RUN_DIR)
	mkdir -p $(RES_DIR)

