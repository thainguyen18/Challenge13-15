//
//  User.swift
//  Challenge13-15
//
//  Created by Thai Nguyen on 12/31/19.
//  Copyright © 2019 Thai Nguyen. All rights reserved.
//

import Foundation
import UIKit

struct User: Codable, Comparable, Identifiable {
    static func < (lhs: User, rhs: User) -> Bool {
        return lhs.name < rhs.name
    }
    
    var id = UUID()
    
    var name: String
    
    var imageUrl: String
    
    func userImage() -> UIImage? {
        guard let url = URL(string: imageUrl) else { return nil }
        guard let imageData = try? Data(contentsOf: url) else { return nil }
        
        return UIImage(data: imageData)
    }
    
    var annotation: CodableMKPointAnnotation
}
