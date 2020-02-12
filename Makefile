# The main makefile to run all experiments in different configurations.
#
# Igor Konnov, 2020

# The directory where the builds of apalache are stored.
# The builds should be checked out before make is started.
BUILDS_DIR=$(HOME)/devl
BASEDIR=$(shell pwd)
RUN_DIR=$(BASEDIR)/runs
RES_DIR=$(BASEDIR)/results

REPORTS=$(RES_DIR)/001indinv-report.md $(RES_DIR)/002bmc-report.md

all: report

$(RES_DIR)/001indinv-report.md: $(RES_DIR)/001indinv-apalache-0.6.0.csv \
				  $(RES_DIR)/001indinv-apalache-0.5.2.csv
	./scripts/mk-report.sh ./performance/001indinv-apalache.csv $^ >$@

$(RES_DIR)/002bmc-report.md: $(RES_DIR)/002bmc-apalache-0.6.0.csv \
				  $(RES_DIR)/002bmc-apalache-0.5.2.csv
	./scripts/mk-report.sh ./performance/002bmc-apalache.csv $^ >$@

# can we avoid duplication between 02bmc-apalache and 01indinv-apalache?
$(RES_DIR)/001indinv-apalache-%.csv: prepare apalache-%
	FULLNAME=001indinv-apalache-$*  # e.g., 001indinv-apalache-0.5.2
	RD=$(RUN_DIR)/$(FULLNAME)
	./scripts/mk-run.sh ./performance/001indinv-apalache.csv \
		$(BUILDS_DIR)/apalache-$* ./performance $(RD)
	(cd $(RD) && ./run-parallel.sh && \
		$(BASEDIR)/scripts/parse-logs.py . && \
		cp results.csv $(RES_DIR)/$(FULLNAME).csv)

# can we avoid duplication between 02bmc-apalache and 01indinv-apalache?
$(RES_DIR)/002bmc-apalache-%.csv: prepare apalache-%
	FULLNAME=002bmc-apalache-$*  # e.g., 002bmc-apalache-0.5.2
	RD=$(RUN_DIR)/$(FULLNAME)
	./scripts/mk-run.sh ./performance/002bmc-apalache.csv \
		$(BUILDS_DIR)/apalache-$* ./performance $(RD)
	(cd $(RD) && ./run-parallel.sh && \
		$(BASEDIR)/scripts/parse-logs.py . && \
		cp results.csv $(RES_DIR)/$(FULLNAME).csv)

build: apalache-0.5.2 apalache-0.6.0

apalache-0.5.2:
	make -C $(BUILDS_DIR)/apalache-0.5.2

apalache-0.6.0:
	make -C $(BUILDS_DIR)/apalache-0.6.0

prepare:
	mkdir -p $(RUN_DIR)
	mkdir -p $(RES_DIR)

clean:
	(test -d $(RUN_DIR) && rm -rf $(RUN_DIR)/*) || echo "no $(RUN_DIR)"
	(test -d $(RES_DIR) && rm -rf $(RES_DIR)/*) || echo "no $(RES_DIR)"

