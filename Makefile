VERSION := $(shell /usr/libexec/PlistBuddy -c 'Print CFBundleVersion' shorrt/shorrt-Info.plist)

default: compile

compile:
	xcodebuild CONFIGURATION_BUILD_DIR=Release > /dev/null

install: compile
	rm -rf /Applications/shorrt.app
	mv Release/shorrt.app /Applications/shorrt.app
