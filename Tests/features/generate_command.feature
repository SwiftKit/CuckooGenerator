Feature: Generate command
	Scenario: in file
		When I run `runcuckoo generate --no-timestamp --output Actual.swift ../SourceFiles/TestedClass.swift ../SourceFiles/TestedProtocol.swift`
		Then the file "../SourceFiles/Expected/GeneratedMocks.swift" should be equal to file "Actual.swift"
	Scenario: in directory
		When I run `runcuckoo generate --no-timestamp --output . ../SourceFiles/TestedClass.swift ../SourceFiles/TestedProtocol.swift`
		Then the file "../SourceFiles/Expected/TestedClass.swift" should be equal to file "TestedClass.swift"
		And the file "../SourceFiles/Expected/TestedProtocol.swift" should be equal to file "TestedProtocol.swift"
	Scenario: output not specified
		When I run `runcuckoo generate --no-timestamp ../SourceFiles/TestedClass.swift ../SourceFiles/TestedProtocol.swift`
		Then the file "../SourceFiles/Expected/GeneratedMocks.swift" should be equal to file "GeneratedMocks.swift"
	Scenario: with testableFrameworks
		When I run `runcuckoo generate --no-timestamp --testable "Cuckoo,A b,A-c,A.d" --output Actual.swift ../SourceFiles/TestedEmptyClass.swift`
		Then the file "../SourceFiles/Expected/TestableFrameworks.swift" should be equal to file "Actual.swift"
	Scenario: non existing input file
		When I run `runcuckoo generate non_existing_file.swift`
		Then the output should contain:
		"""
		Could not read contents of `non_existing_file.swift`
		"""
	Scenario: with --no-header option
		When I run `runcuckoo generate --no-header --output Actual.swift ../SourceFiles/TestedEmptyClass.swift`
		Then the file "../SourceFiles/Expected/NoHeader.swift" should be equal to file "Actual.swift"
	Scenario: multiple classes in one file
		When I run `runcuckoo generate  --no-timestamp --output Actual.swift ../SourceFiles/MultipleClasses.swift`
		Then the file "../SourceFiles/Expected/MultipleClasses.swift" should be equal to file "Actual.swift"
	Scenario: class with attributes
		When I run `runcuckoo generate --no-timestamp --output Actual.swift ../SourceFiles/ClassWithAttributes.swift`
		Then the file "../SourceFiles/Expected/ClassWithAttributes.swift" should be equal to file "Actual.swift"
	Scenario: file with imports
		When I run `runcuckoo generate --no-timestamp --output Actual.swift ../SourceFiles/Imports.swift`
		Then the file "../SourceFiles/Expected/Imports.swift" should be equal to file "Actual.swift"