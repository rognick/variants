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
    
    @Argument(help: "'ios' or 'android'")
    var platform: Platform
    
    @Option()
    var variant: String = "default"
    
    @Option(name: .shortAndLong, help: "Use a different yaml configuration spec")
    var spec: String = "variants.yml"
    
    @Flag(name: .shortAndLong, help: "Is verbose")
    var verbose = false
    
    mutating func run() throws {
        let logger = Logger(verbose: verbose)
        logger.logSection("$ ", item: "variants switch \(platform) \(variant)", color: platform.color)
        
        do {
            let configurationHelper = ConfigurationHelper(verbose: verbose)
            guard let configuration = try configurationHelper
                    .loadConfiguration(spec, platform: platform) else {
                throw RuntimeError("Unable to load specs '\(spec)'")
            }
            
            try process(configuration)
            
        } catch let error as ConfigurationParserError {
            throw RuntimeError(error.message)
        } catch {
            throw RuntimeError.unableToSwitchVariants
        }
    }
    
    // MARK: - Private
    
    private func process(_ configuration: Configuration) throws {
        try switchTo(configuration)
    }
    
    private func switchTo(_ configuration: Configuration) throws {
        switch self.platform {
        case .ios:
            guard let iOSConfiguration = configuration.ios else {
                throw ConfigurationParserError.platformNotFound(platform)
            }
            
            guard let desiredVariant = iOSConfiguration.variants
                    .first(where: { $0.name.lowercased() == self.variant.lowercased() }) else {
                throw ConfigurationParserError.variantNotFound(variant, platform: platform)
            }
            Logger.shared.logInfo(item: "Found variant: \(desiredVariant.configIdSuffix)")
            
            let factory = XCConfigFactory()
            let configPath = Path(spec).absolute().parent()
            
            configuration.ios?
                .targets.map { (key: $0.key, value: $0.value)}
                .forEach {
                    factory.createConfig(with: $0,
                                         variant: desiredVariant,
                                         xcodeProj: configuration.ios?.xcodeproj,
                                         configPath: configPath,
                                         addToXcodeProj: false)
                }
        case .android:
            guard let AndroidConfiguration = configuration.android else {
                throw ConfigurationParserError.platformNotFound(platform)
            }
            
            guard let desiredVariant = AndroidConfiguration.variants
                    .first(where: { $0.name.lowercased() == self.variant.lowercased() }) else {
                throw ConfigurationParserError.variantNotFound(variant, platform: platform)
            }
            Logger.shared.logInfo(item: "Found variant: \(desiredVariant.name)")

            let factory = GradleScriptFactory()
            
            factory.createScript(with: configuration.android!,
                                 variant: desiredVariant)
        case .unknown:
            return
        }
    }
}
