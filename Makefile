VERSION := $(shell /usr/libexec/PlistBuddy -c 'Print CFBundleVersion' shorrt/shorrt-Info.plist)

default: $(addprefix Release/,shorrt.app shorrt.zip)

Release/shorrt.app: $(shell find shorrt shorrt.xcodeproj -type f)
	xcodebuild CONFIGURATION_BUILD_DIR=Release -scheme shorrt -target shorrt -configuration Release build > /dev/null

Release/shorrt.zip: Release/shorrt.app
	rm -f $@
	cd $(@D) && zip -r $(@F) $(<F)

install: Release/shorrt.app
	rm -rf /Applications/shorrt.app
	mv Release/shorrt.app /Applications/shorrt.app
