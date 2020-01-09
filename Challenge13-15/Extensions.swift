//
//  Extensions.swift
//  Challenge13-15
//
//  Created by Thai Nguyen on 12/31/19.
//  Copyright © 2019 Thai Nguyen. All rights reserved.
//

import Foundation

extension FileManager {
    static func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
}

