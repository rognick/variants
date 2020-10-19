//
//  Variants
//
//  Copyright (c) Backbase B.V. - https://www.backbase.com
//  Created by Giuseppe Deraco
//

import Foundation

public class Printer {
    static let shared = Printer()
    private var stdoutTextOutputStream = StandardOutputStream()
    
    func print(item: String) {
        Swift.print(item, to: &stdoutTextOutputStream)
    }
}

fileprivate struct StandardOutputStream: TextOutputStream {
    let stdoud = FileHandle.standardOutput

    func write(_ string: String) {
        guard let data = string.data(using: .utf8) else {
            return
        }
        stdoud.write(data)
    }
}