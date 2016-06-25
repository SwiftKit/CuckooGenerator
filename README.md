# Cuckoo generator
## Generator of Mocks for [Cuckoo](https://github.com/SwiftKit/Cuckoo).

[![CI Status](http://img.shields.io/travis/SwiftKit/Cuckoo.svg?style=flat)](https://travis-ci.org/SwiftKit/CuckooGenerator)
[![License](https://img.shields.io/github/license/mashape/apistatus.svg)
[![Slack Status](http://swiftkit.tmspark.com/badge.svg)](http://swiftkit.tmspark.com)


## Introduction

Cuckoo generator is a second part to [Cuckoo](https://github.com/SwiftKit/Cuckoo) (Swift mocking framework).

To have a chat, [join our Slack team](http://swiftkit.tmspark.com)!

## How does it work

We take the source file, parse it and according to them generate mocks. They work based on inheritance and protocol adoption. This means that only overridable things can be mocked. We currently support all features which fulfill this rule except for things listed in TODO. Due to the complexity of Swift it is not easy to check for all edge cases so if you find some unexpected behavior please report it in issues.  

## TODO

We are still missing support for some important features like:
* static properties
* static methods
* generics

We are planning to fix this as soon as possible.

## What will not be supported

Due to the limitations mentioned above, basically all things which don't allow overriding cannot be supported. This includes:
* `struct` - workaround is to use a common protocol
* everything with `final` or `private` modifier
* global constants and functions

## Installation

For normal use you can skip this because [run script](https://github.com/SwiftKit/Cuckoo/blob/master/run) in [Cuckoo](https://github.com/SwiftKit/Cuckoo) downloads and builds correct version of the generator automatically.

### Homebrew

Simply run `brew install cuckoo` and you are ready to go.

### Custom

This is more complicated path. You need to clone this repository and build it yourself. You can look in the [run script](https://github.com/SwiftKit/Cuckoo/blob/master/run) for more inspiration.

## Usage

Generator can be called through a terminal. Each call consists of command, options and arguments. Options and arguments depends on used command. Options can have additional parameters. Names of all of them are case sensitive. The order goes like this:

```Bash
cuckoo command options arguments
```

### `generate` command

Generates mock files.

This command accepts arguments, in this case list (separated by spaces) of files for which you want to generate mocks. Also more options can be used to adjust behavior, these are listed below.

#### `--output` (string)

Where to put the generated mocks.

If a path to a directory is supplied, each input file will have a respective output file with mocks.

If a path to a Swift file is supplied, all mocks will be in a single file.

Default value is `GeneratedMocks.swift`.

#### `--testable` (string)

A comma separated list of frameworks that should be imported as @testable in the mock files.

#### `--no-header`

Do not generate file headers.

#### `--no-timestamp`

Do not generate timestamp.

### `version` command

Prints the version of this generator.

### `help` command

Display general or command-specific help.

After the `help` you can write name of another command for displaying a command-specific help.

## Author

Tadeas Kriz, tadeas@brightify.org

## License

CuckooGenerator is available under the [MIT License](LICENSE).

## Used libraries

* [Commandant](https://github.com/Carthage/Commandant)
* [Result](https://github.com/antitypical/Result)
* [FileKit](https://github.com/nvzqz/FileKit)
* [SourceKitten](https://github.com/jpsim/SourceKitten)
