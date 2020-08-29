//
//  Product.swift
//  GetStars
//
//  Created by Alejandro Miranda on 17/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import Foundation
import SwiftUI

struct Product: Identifiable {
    var id = UUID()
    var price: Double
    var name: String
    var description: String
    var image: String
    var owner: Person
    
    let isDedicated: Bool
    
    init() {
        self.price = 0.0
        self.name = ""
        self.description = ""
        self.image = ""
        self.owner = Person()
        self.isDedicated = false
    }
    
    init(price: Double, name: String, description: String, image: URL, owner: Person, isDedicated: Bool) {
        self.price = price
        self.name = name
        self.description = description
        self.image = image.absoluteString
        self.owner = owner
        self.isDedicated = isDedicated
    }
    
    init(price: Double, name: String, description: String, image: String, owner: Person, isDedicated: Bool) {
        self.price = price
        self.name = name
        self.description = description
        self.image = image
        self.owner = owner
        self.isDedicated = isDedicated
    }
}
