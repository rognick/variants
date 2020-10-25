//
//  Variants
//
//  Copyright (c) Backbase B.V. - https://www.backbase.com
//  Created by Arthur Alves
//

import Foundation
import ArgumentParser
import PathKit

struct Switch: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "switch",
        abstract: "Switch variants"
    )
    
    // --------------
    // MARK: Configuration Properties
    
    @Argument()
    var variant: String
    
    @Option(name: .shortAndLong, help: "'ios' or 'android'")
    var platform: String = ""
    
    @Option(name: .shortAndLong, help: "Use a different yaml configuration spec")
    var spec: String = "variants.yml"
    
    @Flag(name: .shortAndLong)
    var verbose = false
    
    mutating func run() throws {
        let logger = Logger(verbose: verbose)
        logger.logSection("$ ", item: "variants switch \(variant)", color: .ios)

        let detectedPlatform = try PlatformDetector.detect(fromArgument: platform)
        let project = ProjectFactory.from(platform: detectedPlatform)
        try project.switch(to: variant, spec: spec, verbose: verbose)
    }
}

