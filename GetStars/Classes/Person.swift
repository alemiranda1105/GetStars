//
//  Product.swift
//  GetStars
//
//  Created by Alejandro Miranda on 16/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import Foundation
import SwiftUI

class Person: Identifiable {
    var id = UUID()
    var name: String
    var description: String
    var image: URL
    private let key: String
    
    init() {
        self.name = ""
        self.description = ""
        self.image = URL(string: "") ?? URL(fileURLWithPath: "")
        self.key = ""
    }
    
    init(name: String, description: String, image: String, key: String) {
        self.name = name
        self.description = description
        self.image = URL(string: image)!
        self.key = key
    }
    
    init(name: String, description: String, image: URL, key: String) {
        self.name = name
        self.description = description
        self.image = image
        self.key = key
    }
    
    func getKey() -> String {
        return self.key
    }
    
    func isContained(array: [Person]) -> Bool {
        for p in array {
            if self.key == p.getKey() {
                return true
            }
        }
        return false
    }

}
