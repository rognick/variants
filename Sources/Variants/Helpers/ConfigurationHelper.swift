//
//  Variants
//
//  Copyright (c) Backbase B.V. - https://www.backbase.com
//  Created by Arthur Alves
//

import Foundation
import SwiftCLI
import PathKit

struct ConfigurationHelper: YamlParser {
    func loadConfiguration(_ path: String?, platform: Platform) throws -> Configuration? {
        guard let path = path else {
            throw CLI.Error(message: "Error: Use '-s' to specify the configuration file")
        }
        
        let configurationPath = Path(path)
        guard !configurationPath.isDirectory else {
            throw CLI.Error(message: "Error: \(configurationPath) is a directory path")
        }
        
        let configuration = decode(configuration: path, platform: platform)
        return configuration
    }
    
    func decode(configuration: String, platform: Platform) -> Configuration? {
        return extractConfiguration(from: configuration, platform: platform)
    }
}