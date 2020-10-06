//
//  UserData.swift
//  GetStars
//
//  Created by Alejandro Miranda on 05/07/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import UIKit

struct UserData {
    private let nombre: String
    private let sexo: String
    private let edad: Int
    private let fechaNacimiento: String
    private let data: [String: Any]
    
    // Monedas
    private var coins: StarsCoins
    
    // Pro
    private let isPro: Bool
    
    // Articulos
    var autMan: Int
    var compras: [String: [String]]
    
    // Famoso
    private let isStar: Bool
    private let key: String
    var ventas = [String: Int]()
    
    init(nombre: String, sexo: String, edad: Int, fechaNacimiento: String, autMan: Int, isPro: Bool, coinsAmount: Int) {
        self.nombre = nombre
        self.sexo = sexo
        self.edad = edad
        self.fechaNacimiento = fechaNacimiento
        
        // Monedas
        self.coins = StarsCoins(amount: coinsAmount)
        
        // Articulos
        self.autMan = autMan
        self.compras = ["aut": [String](), "autFot": [String](), "fot": [String](), "fotDed": [String](), "live": [String]()]
        
        // Famoso
        self.isStar = false
        self.key = ""
        
        // Pro
        self.isPro = isPro
        
        self.data = [
            "nombre" : nombre,
            "edad" : edad,
            "sexo": sexo,
            "fechaNacimiento": fechaNacimiento,
            "AutMan": autMan,
            "isStar": false,
            "key": self.key,
            "compras": self.compras,
            "isPro": isPro]
    }
    
    // Usuarios famosos
    init(nombre: String, sexo: String, edad: Int, fechaNacimiento: String, autMan: Int, compras: [String: [String]], isStar: Bool, key: String, isPro: Bool, coinsAmount: Int) {
        self.nombre = nombre
        self.sexo = sexo
        self.edad = edad
        self.fechaNacimiento = fechaNacimiento
        
        // Monedas
        self.coins = StarsCoins(amount: coinsAmount)
        
        // Artículos
        self.autMan = autMan
        self.compras = compras
        
        // Famoso
        self.isStar = isStar
        self.key = key
        
        // Pro
        self.isPro = isPro
        
        self.data = [
            "nombre" : nombre,
            "edad" : edad,
            "sexo": sexo,
            "fechaNacimiento": fechaNacimiento,
            "AutMan": autMan,
            "isStar": isStar,
            "key": key,
            "isPro": isPro]
    }
    
    func getData() -> [String: Any]{
        return self.data
    }
    
    func getName() -> String {
        return self.nombre
    }
    
    func getIsStar() -> Bool {
        return self.isStar
    }
    
    func getIsPro() -> Bool {
        // return self.isPro
        return true
    }
    
    func getUserKey() -> String {
        return self.key
    }
    
    // Monedas
    func addCoins(amount: Int) {
        self.coins.add(amount: amount)
    }
    
    func removeCoins(amount: Int) {
        self.coins.remove(amount: amount)
    }
    
    func getCoinsAmount() -> Int {
        return self.coins.getAmount()
    }
    
}
