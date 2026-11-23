PLAN ?= All
DESTINATION ?= platform=iOS Simulator,name=iPhone 16 Pro,OS=18.2
PARALLEL ?= NO
RESULT_DIR ?= build/test-results
RESULT_PATH ?= $(RESULT_DIR)/$(PLAN)-$(shell date +%Y%m%d-%H%M%S)-$(shell uuidgen).xcresult

.PHONY: test smoke lifecycle

test:
	@mkdir -p "$(RESULT_DIR)"
	xcodebuild test -project WDIODemoAutomation.xcodeproj -scheme WDIODemoAutomation \
		-testPlan "$(PLAN)" -destination "$(DESTINATION)" \
		-parallel-testing-enabled "$(PARALLEL)" -resultBundlePath "$(RESULT_PATH)"

smoke:
	@$(MAKE) test PLAN=Smoke

lifecycle:
	@$(MAKE) test PLAN=Lifecycle
