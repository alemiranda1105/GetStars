//
//  StarsCoins.swift
//  GetStars
//
//  Created by Alejandro Miranda on 06/10/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import Foundation

// Clase para las monedas
class StarsCoins {
    private var amount: Int
    
    init() {
        self.amount = 0
    }
    
    init(amount: Int) {
        self.amount = amount
    }
    
    func add(amount: Int) {
        self.amount += amount
    }
    
    func remove(amount: Int) {
        self.amount -= amount
    }
    
    func getAmount() -> Int {
        return self.amount
    }
    
}
