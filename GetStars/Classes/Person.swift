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
    private let key: String = "prueba"
    
    init(name: String, description: String, image: String) {
        self.name = name
        self.description = description
        self.image = URL(string: image)!
    }
    
    init(name: String, description: String, image: URL) {
        self.name = name
        self.description = description
        self.image = image
    }

}
