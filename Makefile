# The main makefile to run all experiments in different configurations.
#
# Igor Konnov, 2020

BASEDIR=$(shell pwd)

# Where we store the apalache binary
APALACHE_DIR=$(BASEDIR)/_apalache
# Where we run experiments
RUN_DIR=$(BASEDIR)/runs
# Where we save results
RES_DIR=$(BASEDIR)/results

# REPORTS=$(RES_DIR)/002bmc-report.md $(RES_DIR)/001indinv-report.md

# report: $(REPORTS)

# TODO record machine architecture and specs in reports

results := $(wildcard $(RES_DIR)/*.*.*.csv)

strategies := 001indinv 002bmd

help:
	@echo "To run benchmarks for version 'l.m.n' using strategy 's' run"
	@echo
	@echo "    make report version=l.m.n strat=s"
	@echo
	@echo "where"
	@echo
	@echo "  - 's' is one of $(strategies)"
	@echo "  - 'l.m.n' is >= 0.7.3"

report: $(RES_DIR)/$(strat)-report.md verify-vars

# Our deps are just those results that include start as a substring
$(RES_DIR)/$(strat)-report.md: $(foreach r,$(results),$(if $(findstring $(strat),$(r)),$(r),))
	@echo ">> Building $(@F) from: $^"
	cd ./results && \
	 	$(BASEDIR)/scripts/mk-report.sh $(BASEDIR)/performance/$(strat)-apalache.csv $^ >$@

# $(RES_DIR)/001indinv-report.md: $(indinv_reports)
# 	cd ./results && \
# 		$(BASEDIR)/scripts/mk-report.sh $(BASEDIR)/performance/001indinv-apalache.csv $^ >$@

# $(RES_DIR)/002bmc-report.md: \
# 		$(RES_DIR)/002bmc-apalache-0.7.0.csv \
# 		$(RES_DIR)/002bmc-apalache-0.6.0.csv \
# 		$(RES_DIR)/002bmc-apalache-0.5.2.csv
# 	cd ./results && \
# 		$(BASEDIR)/scripts/mk-report.sh $(BASEDIR)/performance/002bmc-apalache.csv $^ >$@

# can we avoid duplication between 02bmc-apalache and 01indinv-apalache?
$(RES_DIR)/$(strat)-apalache-$(version).csv: prepare apalache-v$(version) strat-is-defined
	$(eval $@_NAME=$(strat)-apalache-$(version)) # set the temporary variable
	$(BASEDIR)/scripts/mk-run.py ./performance/$(strat)-apalache.csv \
		$(APALACHE_DIR)/apalache-$(version) ./performance $(RUN_DIR)/$($@_NAME)
	(cd $(RUN_DIR)/$($@_NAME) && ./run-parallel.sh && \
		$(BASEDIR)/scripts/parse-logs.py . && \
		cp results.csv $(RES_DIR)/$($@_NAME).csv)

# can we avoid duplication between 02bmc-apalache and 01indinv-apalache?
# $(RES_DIR)/001indinv-apalache-%.csv: # prepare apalache-%
# 	echo "YEP"
	# $(eval $@_NAME=001indinv-apalache-$*) # set the temporary variable
	# $(BASEDIR)/scripts/mk-run.py ./performance/001indinv-apalache.csv \
	# 	$(BUILDS_DIR)/apalache-$* ./performance $(RUN_DIR)/$($@_NAME)
	# (cd $(RUN_DIR)/$($@_NAME) && ./run-parallel.sh && \
	# 	$(BASEDIR)/scripts/parse-logs.py . && \
	# 	cp results.csv $(RES_DIR)/$($@_NAME).csv)

# can we avoid duplication between 02bmc-apalache and 01indinv-apalache?
# $(RES_DIR)/002bmc-apalache-%.csv: prepare apalache-%
# 	$(eval $@_NAME=002bmc-apalache-$*) # set the temporary variable
# 	$(BASEDIR)/scripts/mk-run.py ./performance/002bmc-apalache.csv \
# 		$(APALCHE_DIR)/apalache-$* ./performance $(RUN_DIR)/$($@_NAME)
# 	(cd $(RUN_DIR)/$($@_NAME) && ./run-parallel.sh && \
# 		$(BASEDIR)/scripts/parse-logs.py . && \
# 		cp results.csv $(RES_DIR)/$($@_NAME).csv)

.PHONY: apalache
# invoke as `make apalache version=0.9.0`
apalache: $(APALACHE_DIR)/apalache-$(version) version-is-defined

$(APALACHE_DIR)/apalache-$(version):
	@echo ">> Fetching $(@F)"
	VERSION=$(version) $(BASEDIR)/scripts/get-apalache.sh

apalache-$(version):
prepare:
	mkdir -p $(APALACHE_DIR)
	mkdir -p $(RUN_DIR)
	mkdir -p $(RES_DIR)

version-is-defined:
	@test $(version) || \
		( echo "error: variable 'version' is undefined" ;\
			echo "run 'make help' for usage." ;\
			exit 1)

strat-is-defined:
	@test $(strat) || \
		( echo "error: variable 'strat' is undefined" ;\
			echo "run 'make help' for usage." ;\
			exit 1)

verify-vars: version-is-defined strat-is-defined

clean:
	(test -d $(RUN_DIR) && rm -rf $(RUN_DIR)/*) || echo "no $(RUN_DIR)"
	(test -d $(RES_DIR) && rm -rf $(RES_DIR)/*) || echo "no $(RES_DIR)"
	(test -d $(APALACHE_DIR) && rm -rf $(APALACHE_DIR)/*) || echo "no $(APALACHE_DIR)"

