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
    private let key: String
    var name:String
    var description:String
    var image:String
    
    init(name: String, description: String, image: String, key: String) {
        self.name = name
        self.description = description
        self.image = image
        self.key = key
    }
    
    func getKey() -> String {
        return self.key
    }
}
