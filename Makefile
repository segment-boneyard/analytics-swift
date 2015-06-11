#
# Targets.
#

clean:
	@xcodebuild clean

test:
	@xctool -scheme AnalyticsSwift test

build:
	@xcodebuild

#
# Phonies.
#

.PHONY: clean
.PHONY: test
.PHONY: build

