Feature: Generate command
	Scenario: in file
		When I run `runcuckoo generate --no-header --output Actual.swift ../SourceFiles/TestedClass.swift ../SourceFiles/TestedProtocol.swift`
		Then the file "../SourceFiles/Expected/Expected.swift" should be equal to file "Actual.swift"
	Scenario: in directory
		When I run `runcuckoo generate --no-header --output . ../SourceFiles/TestedClass.swift ../SourceFiles/TestedProtocol.swift`
		Then the file "../SourceFiles/Expected/TestedClass.swift" should be equal to file "TestedClass.swift"
		And the file "../SourceFiles/Expected/TestedProtocol.swift" should be equal to file "TestedProtocol.swift"
	Scenario: output not specified
		When I run `runcuckoo generate --no-header ../SourceFiles/TestedClass.swift ../SourceFiles/TestedProtocol.swift`
		Then the file "../SourceFiles/Expected/Expected.swift" should be equal to file "GeneratedMocks.swift"
	Scenario: with testableFrameworks
		When I run `runcuckoo generate --no-header --testable Cuckoo --output Actual.swift ../SourceFiles/TestedEmptyClass.swift`
		Then the file "../SourceFiles/Expected/TestableFrameworks.swift" should be equal to file "Actual.swift"
	Scenario: non existing input file
		When I run `runcuckoo generate non_existing_file.swift`
		Then the output should contain:
		"""
		Could not read contents of `non_existing_file.swift`
		"""