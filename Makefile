# The main makefile to run all experiments in different configurations.
#
# Igor Konnov, Shon Feder, 2020

# The versions of apalache to benchmark
#
# A version should correspond to a docker tag for an image available on
# https://hub.docker.com/r/apalache/mc/tags
#
# Put the latest version first
VERSIONS := \
0.7.0 \
0.6.0  \
0.5.2

BASEDIR=$(shell pwd)
RUN_DIR=$(BASEDIR)/runs
RES_DIR=$(BASEDIR)/results

# Locations for the tabular data recording the results of the tests
INDINV_RESULTS := $(foreach v, $(VERSIONS), $(RES_DIR)/001indinv-apalache-$v.csv)
BMC_RESULTS := $(foreach v, $(VERSIONS), $(RES_DIR)/002bmc-apalache-$v.csv)

REPORTS=$(RES_DIR)/001indinv-report.md $(RES_DIR)/002bmc-report.md

report: $(REPORTS)

# Rule for generating the inductive invariant report
$(RES_DIR)/001indinv-report.md: $(INDINV_RESULTS)
	cd ./results && \
		$(BASEDIR)/scripts/mk-report.sh $(BASEDIR)/performance/001indinv-apalache.csv $^ >$@

# Rule for generating the bounded model checking report
$(RES_DIR)/002bmc-report.md: $(BMC_RESULTS)
	cd ./results && \
		$(BASEDIR)/scripts/mk-report.sh $(BASEDIR)/performance/002bmc-apalache.csv $^ >$@

experiments: $(INDINV_RESULTS) $(BMC_RESULTS)

# Rules for generating each csv of result data
# The automatic variable $* will look like
# (001indinv|002bmc)-apalache-<version>
$(RES_DIR)/%.csv: prepare # docker-pull
# PARAMS is the base name for the params file, obtained by stripping the
# version segent from the end of the filename.
# NOTE: The double $ in the sed command escapes the $ for make
	$(eval PARAMS := $(shell echo $* | sed "s/-[^-]*$$//"))
	$(BASEDIR)/scripts/mk-run.py \
		./performance/$(PARAMS).csv \
		latest \
		./performance $(RUN_DIR)/$*
	(cd $(RUN_DIR)/$* \
		&& ./run-parallel.sh\
		&& $(BASEDIR)/scripts/parse-logs.py . \
		&& cp results.csv $(RES_DIR)/$*.csv)

.PHONY: docker-pull prepare clean

docker-pull:
	$(BASEDIR)/scripts/pull-docker-images.sh $(VERSIONS)

prepare:
	mkdir -p $(RUN_DIR)
	mkdir -p $(RES_DIR)

clean:
	(test -d $(RUN_DIR) && rm -rf $(RUN_DIR)/*) || echo "no $(RUN_DIR)"
	(test -d $(RES_DIR) && rm -rf $(RES_DIR)/*) || echo "no $(RES_DIR)"

