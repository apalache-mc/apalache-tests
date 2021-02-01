# The main makefile to run all experiments in different configurations.
#
# Igor Konnov, 2020

BASEDIR=$(shell pwd)

# Where we store the apalache binary
APALCHE_DIR=$(BASEDIR)/_apalache
# Where we run experiments
RUN_DIR=$(BASEDIR)/runs
# Where we save results
RES_DIR=$(BASEDIR)/results

# REPORTS=$(RES_DIR)/002bmc-report.md $(RES_DIR)/001indinv-report.md

# report: $(REPORTS)

# TODO record machine architecture and specs in reports

results := $(wildcard $(RES_DIR)/*.*.*.csv)

run: 
	echo "RESULTS"
	echo $(results)
	echo ">>>>>>>>"
	echo $(RES_DIR)
	echo $(indinv_reports)

report: $(RES_DIR)/$(strat)-report.md
	echo "Finished generating report for $(strat) with apalache $(version)"

# Our deps are just those results that include start as a substring
$(RES_DIR)/$(strat)-report.md: $(foreach r,$(results),$(if $(findstring $(strat),$(r)),$(r),))
	echo "building $(strat)-report.md from: $^"
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
$(RES_DIR)/001indinv-apalache-%.csv: # prepare apalache-%
	echo "YEP"
	# $(eval $@_NAME=001indinv-apalache-$*) # set the temporary variable
	# $(BASEDIR)/scripts/mk-run.py ./performance/001indinv-apalache.csv \
	# 	$(BUILDS_DIR)/apalache-$* ./performance $(RUN_DIR)/$($@_NAME)
	# (cd $(RUN_DIR)/$($@_NAME) && ./run-parallel.sh && \
	# 	$(BASEDIR)/scripts/parse-logs.py . && \
	# 	cp results.csv $(RES_DIR)/$($@_NAME).csv)

# can we avoid duplication between 02bmc-apalache and 01indinv-apalache?
$(RES_DIR)/002bmc-apalache-%.csv: prepare apalache-%
	$(eval $@_NAME=002bmc-apalache-$*) # set the temporary variable
	$(BASEDIR)/scripts/mk-run.py ./performance/002bmc-apalache.csv \
		$(BUILDS_DIR)/apalache-$* ./performance $(RUN_DIR)/$($@_NAME)
	(cd $(RUN_DIR)/$($@_NAME) && ./run-parallel.sh && \
		$(BASEDIR)/scripts/parse-logs.py . && \
		cp results.csv $(RES_DIR)/$($@_NAME).csv)

# build: apalache-0.5.2 apalache-0.6.0 apalache-0.7.0

# apalache-0.5.2:
# 	make -C $(BUILDS_DIR)/apalache-0.5.2

# apalache-0.6.0:
# 	make -C $(BUILDS_DIR)/apalache-0.6.0

# apalache-0.7.0:
# 	make -C $(BUILDS_DIR)/apalache-0.7.0

apalache-$(version):
prepare:
	mkdir -p $(RUN_DIR)
	mkdir -p $(RUN_DIR)
	mkdir -p $(RES_DIR)

clean:
	(test -d $(RUN_DIR) && rm -rf $(RUN_DIR)/*) || echo "no $(RUN_DIR)"
	(test -d $(RES_DIR) && rm -rf $(RES_DIR)/*) || echo "no $(RES_DIR)"

