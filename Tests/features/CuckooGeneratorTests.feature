Feature: CuckooGeneratorTests
	Scenario: Generating test mocks
		Given I run `xcodebuild -project '../../../CuckooGenerator.xcodeproj' -scheme 'CuckooGenerator' -configuration 'Release' CONFIGURATION_BUILD_DIR=Tests/tmp/aruba clean build`
		When I run `cuckoo.app/Contents/MacOS/cuckoo generate --no-header --output actual.swift ../../res/source/TestedClass.swift ../../res/source/TestedProtocol.swift`
		Then the file "../../res/expected.swift" should be equal to file "actual.swift"