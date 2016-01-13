TEMPORARY_FOLDER?=/tmp/MockeryGenerator.dst
PREFIX?=/usr/local
BUILD_TOOL?=xcodebuild

XCODEFLAGS=-project 'MockeryGenerator.xcodeproj' -scheme 'MockeryGenerator' DSTROOT=$(TEMPORARY_FOLDER)

BUILT_BUNDLE=$(TEMPORARY_FOLDER)/Applications/mockery.app
MOCKERYGENERATOR_FRAMEWORK_BUNDLE=$(BUILT_BUNDLE)/Contents/Frameworks/MockeryGeneratorFramework.framework
MOCKERYGENERATOR_EXECUTABLE=$(BUILT_BUNDLE)/Contents/MacOS/mockery

FRAMEWORKS_FOLDER=$(PREFIX)/Frameworks
BINARIES_FOLDER=$(PREFIX)/bin

OUTPUT_PACKAGE=MockeryGenerator.pkg
VERSION_STRING=$(shell agvtool what-marketing-version -terse1)
COMPONENTS_PLIST=Source/Components.plist

.PHONY: all bootstrap clean install package test uninstall

all: bootstrap
	$(BUILD_TOOL) $(XCODEFLAGS) build

bootstrap:
	carthage bootstrap --platform mac

test: clean bootstrap
	$(BUILD_TOOL) $(XCODEFLAGS) test

clean:
	rm -f "$(OUTPUT_PACKAGE)"
	rm -rf "$(TEMPORARY_FOLDER)"
	$(BUILD_TOOL) $(XCODEFLAGS) clean

install: package
	sudo installer -pkg MockeryGenerator.pkg -target /

uninstall:
	rm -rf "$(FRAMEWORKS_FOLDER)/MockeryGeneratorFramework.framework"
	rm -f "$(BINARIES_FOLDER)/mockery"

installables: clean bootstrap
	$(BUILD_TOOL) $(XCODEFLAGS) install

	mkdir -p "$(TEMPORARY_FOLDER)$(FRAMEWORKS_FOLDER)" "$(TEMPORARY_FOLDER)$(BINARIES_FOLDER)"
	mv -f "$(MOCKERYGENERATOR_FRAMEWORK_BUNDLE)" "$(TEMPORARY_FOLDER)$(FRAMEWORKS_FOLDER)/MockeryGeneratorFramework.framework"
	mv -f "$(MOCKERYGENERATOR_EXECUTABLE)" "$(TEMPORARY_FOLDER)$(BINARIES_FOLDER)/mockery"
	rm -rf "$(BUILT_BUNDLE)"

prefix_install: installables
	mkdir -p "$(FRAMEWORKS_FOLDER)" "$(BINARIES_FOLDER)"
	cp -Rf "$(TEMPORARY_FOLDER)$(FRAMEWORKS_FOLDER)/MockeryGeneratorFramework.framework" "$(FRAMEWORKS_FOLDER)"
	cp -f "$(TEMPORARY_FOLDER)$(BINARIES_FOLDER)/mockery" "$(BINARIES_FOLDER)/"

package: installables
	pkgbuild \
		--component-plist "$(COMPONENTS_PLIST)" \
		--identifier "org.brightify.MockeryGenerator" \
		--install-location "/" \
		--root "$(TEMPORARY_FOLDER)" \
		--version "$(VERSION_STRING)" \
		"$(OUTPUT_PACKAGE)"

archive:
	carthage build --no-skip-current --platform mac
	carthage archive MockeryGeneratorFramework

release: package archive
