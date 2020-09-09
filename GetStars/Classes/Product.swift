//
//  Product.swift
//  GetStars
//
//  Created by Alejandro Miranda on 17/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import Foundation
import SwiftUI

class Product: Identifiable {
    var id = UUID()
    var price: Double
    var name: String
    var description: String
    var image: String
    var owner: Person
    
    // Productos dedicados
    let isDedicated: Bool
    var message: String = ""
    
    //Sorteos y subastas
    var productID = ""
    var fecha = ""
    var participantes = [String]()
    
    //Tipo de producto
    let productType: ProductType
    enum ProductType {
        case autografoManual
        case autografo
        case autografoDedicado
        case foto
        case fotoDedicada
        case fotoConAutografo
        case live
    }
    
    init() {
        self.price = 0.0
        self.name = ""
        self.description = ""
        self.image = ""
        self.owner = Person()
        self.isDedicated = false
        self.productType = .autografo
    }
    
    init(price: Double, name: String, description: String, image: URL, owner: Person, isDedicated: Bool) {
        self.price = price
        self.name = name
        self.description = description
        self.image = image.absoluteString
        self.owner = owner
        self.isDedicated = isDedicated
        self.productType = .autografo
    }
    
    init(price: Double, name: String, description: String, image: URL, owner: Person, isDedicated: Bool, productType: ProductType) {
        self.price = price
        self.name = name
        self.description = description
        self.image = image.absoluteString
        self.owner = owner
        self.isDedicated = isDedicated
        self.productType = productType
    }
    
    init(price: Double, name: String, description: String, image: String, owner: Person, isDedicated: Bool) {
        self.price = price
        self.name = name
        self.description = description
        self.image = image
        self.owner = owner
        self.isDedicated = isDedicated
        self.productType = .autografo
    }
    
    func setMessage(newMessage: String) {
        self.message = newMessage
    }
    
    func setFecha(fecha: String) {
        self.fecha = fecha
    }
    
    func setPrice(newPrice: Double) {
        self.price = newPrice
    }
    
    func setParticipantes(lista: [String]) {
        self.participantes = lista
    }
    
    func comprobarParticipacion(email: String) -> Bool {
        for i in self.participantes {
            if i == email {
                return true
            }
        }
        return false
    }
    
    func setProductID(id: String) {
        self.productID = id
    }
    
    func equals(product: Product) -> Bool {
        if self.name == product.name {
            if self.price == product.price {
                if self.description == product.description {
                    if self.owner.getKey() == product.owner.getKey() {
                        if self.message == product.message {
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
}
