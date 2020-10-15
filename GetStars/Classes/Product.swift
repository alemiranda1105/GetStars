//
//  Product.swift
//  GetStars
//
//  Created by Alejandro Miranda on 17/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import Foundation
import SwiftUI
import StoreKit

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
        case fotoDedicada
        case fotoDedicadaCustom
        case fotoConAutografo
        case live
        case subasta
        case sorteo
    }
    
    // Datos dedicatoria
    var posicion: [CGFloat] = [0.0, 0.0]
    var color: Color = Color("naranja")
    var uiColor: UIColor = UIColor.orange
    var size: CGFloat = 12
    
    // Tipo de producto
    var skproduct: SKProduct = SKProduct()
    
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
    
    func setDatosDedicatoria(pos: [CGFloat], color: UIColor, size: CGFloat) {
        self.posicion = pos
        self.color = Color(color)
        self.uiColor = color
        self.size = size
    }
    
    func setSkProduct(sk: SKProduct) {
        self.skproduct = sk
    }
    
    func addProductToAccount(session: SessionStore) {
        if self.isDedicated && self.productType != .live {
            print("Producto dedicado ----- Subiendo a la nube para revisión")
            let dg = DispatchGroup()
            let documentID = generateDocumentId(length: 21)
            session.db.uploadDedicatoria(documentID: documentID, key: self.owner.getKey(), email: session.session?.email ?? "", mensaje: self.message, color: self.uiColor, size: self.size, posicion: self.posicion, tipo: self.getCatString(), dg: dg)
            dg.notify(queue: DispatchQueue.global(qos: .background)) {
                print("Dedicatoria subida a la nube correctamente")
                
                session.db.addDedicatoriaToUser(email: session.session?.email ?? "", dedicatoria: documentID, dg: dg)
                dg.wait()
                
                print("Dedicatoria en revision")
            }
        } else if self.productType == .live {
            print("Live ------ Subiendo a la cola de lives")
            let db = StarsDB()
            let dg = DispatchGroup()
            db.añadirAlLive(key: self.owner.getKey(), email: (session.session?.email)!, mensaje: self.message, dg: dg)
            dg.notify(queue: DispatchQueue.global(qos: .background)) {
                print("Añadido a la cola de lives de \(self.owner.getKey())")
            }
        } else {
            print("Producto no dedicado ------ Añadiendo compra al usuario")
            let dg = DispatchGroup()
            session.db.addCompraToUserDB(email: session.session?.email ?? "", compra: self.getCatString(), url: self.image, dg: dg)
            dg.notify(queue: DispatchQueue.global(qos: .background)) {
                print("Compra de \(self.getCatString()) añadida")
            }
        }
        StarsDB().addVenta(product: self.getCatString(), key: self.owner.getKey())
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
    
    private func getCatString() -> String {
        var cat = ""
        switch self.productType {
            case .autografoManual:
                break
            case .autografo:
                cat = "aut"
                break
            case .autografoDedicado:
                cat = "autDed"
                break
            case .fotoDedicada:
                cat = "fotDed"
                break
            case .fotoConAutografo:
                cat = "autFot"
                break
            case .live:
                cat = "live"
                break
            case .subasta:
                break
            case .sorteo:
                break
            case .fotoDedicadaCustom:
                cat = "fotDed"
                break
        }
        return cat
    }
}
