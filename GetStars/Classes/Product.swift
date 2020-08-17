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
}
