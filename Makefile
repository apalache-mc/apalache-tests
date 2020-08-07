# The main makefile to run all experiments in different configurations.
#
# Igor Konnov, Shon Feder, 2020


##################
# BASIC ELEMENTS #
##################

# These are the fundamental elements determining what benchmarks are run

# The versions of apalache to benchmark
#
# A version should correspond to a docker tag for an image available on
# https://hub.docker.com/r/apalache/mc/tags
#
# Put the latest version first
VERSIONS := \
0.7.0 \
0.6.1

# The strategies to run experiments for
#
# A strategy should correspond to a parameter file
# like ./performance/<strategy>-apalache.csv, e.g.,
#
# 	- ./performance/001indinv-apalache.csv
# 	- ./performance/002bmc-apalache.csv
#
# NOTE: Currently, only param files from the ./performance directory are
# supported.
STRATEGIES := \
001indinv \
002bmc


#####################
# DIRECTORY ALIASES #
#####################

BASEDIR=$(shell pwd)
RUN_DIR=$(BASEDIR)/runs
RES_DIR=$(BASEDIR)/results

##########
# MACROS #
##########

# $(call strategy_results,strat) is a sequence of csv targets to collect
# data for each version. E.g.,
# if
# 	$(VERSIONS) == 0.0.1 0.0.2
# then
# 	$(call strategy_results,002bmc) == ./results/02bmc-apalache-0.0.1.csv ./results/02bmc-apalache-0.0.2.csv
define strategy_results
$(foreach v, $(VERSIONS), $(RES_DIR)/$(1)-apalache-$(v).csv)
endef

# $(call experiment-strat-version,s,v) is a rule to build the experiment for
# version v and strategy s. E.g.,
#
# 	$(call exp-version,001indinv,0.7.0) == $(RES_DIR)/001indinv-apalache-0.7.0.csv $(RES_DIR)/002bmc-apalache-0.7.0.csv
define experiment-strat-version
.PHONY: experiment-$(1)-$(2)
experiment-$(1)-$(2): $(RES_DIR)/$(1)-apalache-$(2).csv
endef

define experiment-strat-version-serial
.PHONY: experiment-$(1)-$(2)-serial
experiment-$(1)-$(2)-serial: docker-pull results $(RUN_DIR)/$(1)-apalache-$(2)
	@echo
	@echo "======> Running experiments for" experiment-$(1)-$(2)-serial
	@echo
	(cd $(RUN_DIR)/$(1)-apalache-$(2) \
		&& ./run-all.sh\
		&& $(BASEDIR)/scripts/parse-logs.py . \
		&& cp results.csv $(RES_DIR)/$(1)-apalache-$(2).csv)
endef

#################
# PHONY TARGETS #
#################

.PHONY: reports reports-only experiments docker-pull clean

###########
# REPORTS #
###########

# Reports aggregate data from all the benchmark data into human readible
# summaries

reports: $(foreach s, $(STRATEGIES), $(RES_DIR)/$(s)-report.md)

$(RES_DIR)/%-report.md: $(call strategy_results,%)
	cd ./results && \
		$(BASEDIR)/scripts/mk-report.sh $(BASEDIR)/performance/$*-apalache.csv $^ >$@

# Generate the reports but don't run any of the tests
# Used in the CI pipeline
reports-only:
	cd ./results \
	$(foreach s, $(STRATEGIES), \
		&& \
		$(BASEDIR)/scripts/mk-report.sh \
			$(BASEDIR)/performance/$(s)-apalache.csv \
			$(call strategy_results,$(s)) \
			> $(RES_DIR)/$(s)-report.md \
	)


###############
# EXPERIMENTS #
###############

# experiment-<strategy>-<version>:
#
# For each specified strategy and version, this loop generates a target
# experiment-<strategy>-<version> to run the designated experiments.
#
# E.g., to run inductive invariant experiments for version 0.7.0 execute
#
# 	make experiment-001indinv-0.7.0
$(foreach s, $(STRATEGIES), \
$(foreach v, $(VERSIONS), \
$(eval $(call experiment-strat-version,$(s),$(v)))))

# experiment-<strategy>-<version>-serial:
#
# Like the above, but executes the experiments serially instead of in parallel
#
# E.g., to run inductive invariant experiments for version 0.7.0 in sequence, execute
#
#	make experiment-001indinv-0.7.0-serial
$(foreach s, $(STRATEGIES), \
$(foreach v, $(VERSIONS), \
$(eval $(call experiment-strat-version-serial,$(s),$(v)))))

# Run all experiments for all versions
experiments: $(foreach s, $(STRATEGIES), $(foreach v, $(VERSIONS), experiment-$(s)-$(v)))

# Run all experiments for all versions, but serially
experiments-serial: $(foreach s, $(STRATEGIES), $(foreach v, $(VERSIONS), experiment-$(s)-$(v)-serial))

# Rules for generating the csv of result data by running the experiments
#
# The pattern % will look like <strategy>-apalache-<version>
# for the given STRATEGY and VERSION
$(RES_DIR)/%.csv: docker-pull results $(RUN_DIR)/%
	@echo
	@echo "======> Running experiments for" $*
	@echo
	(cd $(RUN_DIR)/$* \
		&& ./run-parallel.sh\
		&& $(BASEDIR)/scripts/parse-logs.py . \
		&& cp results.csv $(RES_DIR)/$*.csv)

# Rules for generating the runner scripts for a particular set of experiments
#
# The pattern % will look like <strategy>-apalache-<version>
# for the given STRATEGY and VERSION
$(RUN_DIR)/%: runs
	@echo
	@echo "======> Generating runner scripts for" $*
	@echo
# PARAMS is the base name for the params file, obtained by stripping the
# version segment from the end of the filename.
# NOTE: The double $ in the sed command escapes the $ for make
	$(eval PARAMS := $(shell echo $* | sed "s/-[^-]*$$//"))
	$(eval VERSION := $(shell echo $* | sed 's/.*-\(.*\)$$/\1/'))
	$(BASEDIR)/scripts/mk-run.py \
		./performance/$(PARAMS).csv \
		$(VERSION) \
		./performance \
		$(RUN_DIR)/$*


#########
# SETUP #
#########

docker-pull:
	$(BASEDIR)/scripts/pull-docker-images.sh $(VERSIONS)

runs:
	mkdir -p $(RUN_DIR)

results:
	mkdir -p $(RES_DIR)


###########
# CLEANUP #
###########

clean:
	(test -d $(RUN_DIR) && rm -rf $(RUN_DIR)/*) || echo "no $(RUN_DIR)"
	(test -d $(RES_DIR) && rm -rf $(RES_DIR)/*) || echo "no $(RES_DIR)"
