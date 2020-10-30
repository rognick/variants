import XCTest
import class Foundation.Bundle

final class VariantsTests: XCTestCase {
    func testUsage_noCommands() throws {
        let arguments: [String] = []
        
        let expectedOutput =
            """
            OVERVIEW: A command-line tool to setup deployment variants and working CI/CD
            setup

            USAGE: variants <subcommand>

            OPTIONS:
              --version               Show the version.
              -h, --help              Show help information.

            SUBCOMMANDS:
              init                    Generate spec file - variants.yml
              setup                   Setup deployment variants (alongside Fastlane)
              switch                  Switch variants

              See \'variants help <subcommand>\' for detailed help.

            """

        let output = try run(with: arguments)
        XCTAssertEqual(output, expectedOutput)
    }
    
    func testInit_unknownArgument() throws {
        
        let arguments = ["init",
                         "unknown-argument"]
        
        let expectedOutput =
            """
            Error: Unexpected argument \'unknown-argument\'
            Usage: variants init [--platform <platform>] [--verbose]
              See \'variants init --help\' for more information.

            """
        
        let output = try run(with: arguments)
        XCTAssertEqual(output, expectedOutput)
    }
    
    
    /// Execute Variants with given arguments
    func run(with arguments: [String]) throws -> String? {
        // Some of the APIs that we use below are available in macOS 10.13 and above.
        guard #available(macOS 10.13, *) else {
            return nil
        }

        let fooBinary = productsDirectory.appendingPathComponent("Variants")

        let process = Process()
        process.executableURL = fooBinary

        let pipe = Pipe()
        process.arguments = arguments
        process.standardOutput = pipe
        process.standardError = pipe

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)
        return output
    }
    
    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }

    static var allTests = [
        ("testUsage_noCommands", testUsage_noCommands),
        ("testInit_unknownArgument", testInit_unknownArgument)
    ]
}
