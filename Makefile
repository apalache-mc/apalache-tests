# The main makefile to run all experiments in different configurations.
#
# Igor Konnov, Shon Feder 2020-2021

BASEDIR=$(shell pwd)

# Where we store the apalache binary
APALACHE_DIR=$(BASEDIR)/_apalache
# Where we run experiments
RUN_DIR=$(BASEDIR)/runs
# Where we save results
RES_DIR=$(BASEDIR)/results

# Supported strategies (used in the help)
strategies := 001indinv 002bmd

define helpmsg
Usage:

make help ..........................: print this message
make run strat=s version=v .........: run benchmarks for strategy 's' and apalache version 'v' and generate reports
make apalache version=v ............: download and install apalache version 'v'
make benchmark strat=s version=v ...: run the benchmarks for strategy 's' using apalache version 'v'
make report strat=s ................: generate the report from all results of running strategy 's'

where

	s is one of $(strategies)
	v is >= 0.7.3
endef
export helpmsg

.PHONY: help
help:
	@echo "$$helpmsg"

.PHONY: run
run: | verify-vars benchmark report

.PHONY: report
report: $(RES_DIR)/$(strat)-report.md | strat-is-defined

# Generate a report summarizing all results
# It depends on the result from a specified strat and version, but will include
# all results in the result directory.
$(RES_DIR)/$(strat)-report.md: $(RES_DIR)/$(strat)-apalache-$(version).csv | verify-vars 
	$(eval results=$(wildcard $(RES_DIR)/$(strat)-apalache-*.*.*.csv))
	@ [ "$(results)" ] || \
		( echo "error: no results found for strategy $(strat), cannot generate report." ;\
			echo "run 'make benchmark strat=$(strat) version=l.m.n' first";  exit 1)
	@echo ">> Building $(@F) from: $^"
	cd ./results && \
	 	$(BASEDIR)/scripts/mk-report.sh $(BASEDIR)/performance/$(strat)-apalache.csv $^ > $@

.PHONY: benchmark
benchmark: $(RES_DIR)/$(strat)-apalache-$(version).csv | verify-vars 

result-deps := $(APALACHE_DIR)/apalache-$(version)
dir-deps := $(APALACHE_DIR) $(RUN_DIR) $(RES_DIR)

# Generate and then run all the experiments for the given strat and version
$(RES_DIR)/$(strat)-apalache-$(version).csv: $(result-deps) | verify-vars $(dir-deps)
	$(eval $@_NAME=$(strat)-apalache-$(version)) # set the temporary variable
	$(BASEDIR)/scripts/mk-run.py $(BASEDIR)/performance/$(strat)-apalache.csv \
		$(APALACHE_DIR)/apalache-$(version) $(BASEDIR)/performance $(RUN_DIR)/$($@_NAME)
	(cd $(RUN_DIR)/$($@_NAME) && ./run-parallel.sh && \
		$(BASEDIR)/scripts/parse-logs.py . && \
		cp results.csv $(RES_DIR)/$($@_NAME).csv)

# invoke as `make apalache version=0.9.0`
.PHONY: apalache
apalache: $(APALACHE_DIR)/apalache-$(version) | version-is-defined

# Download and install (locally to this dir) the given version of apalache
$(APALACHE_DIR)/apalache-$(version): | $(APALACHE_DIR)
	@echo ">> Fetching $(@F)"
	VERSION=$(version) $(BASEDIR)/scripts/get-apalache.sh

$(APALACHE_DIR):
	mkdir -p $(APALACHE_DIR)

$(RUN_DIR):
	mkdir -p $(RUN_DIR)

$(RES_DIR):
	mkdir -p $(RES_DIR)

.PHONY: version-is-defined
version-is-defined:
	@test $(version) || \
		( echo "error: variable 'version' is undefined" ;\
			echo "run 'make help' for usage." ;\
			exit 1)

.PHONY: strat-is-defined
strat-is-defined:
	@test $(strat) || \
		( echo "error: variable 'strat' is undefined" ;\
			echo "run 'make help' for usage." ;\
			exit 1)

.PHONY: verify-vars
verify-vars: | version-is-defined strat-is-defined

.PHONY: clean
clean:
	(test -d $(RUN_DIR) && rm -rf $(RUN_DIR)/*) || echo "no $(RUN_DIR)"
	(test -d $(RES_DIR) && rm -rf $(RES_DIR)/*) || echo "no $(RES_DIR)"
	(test -d $(APALACHE_DIR) && rm -rf $(APALACHE_DIR)/*) || echo "no $(APALACHE_DIR)"

