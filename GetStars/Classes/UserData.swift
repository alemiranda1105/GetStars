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
    
    // Articulos
    var autMan: Int
    var compras: [String: Int]
//    var aut: Int
//    var autFot: Int
//    var fotDed: Int
//    var fot: Int
//    var live: Int
    
    // Famoso
    private let isStar: Bool
    private let key: String
    
    init(nombre: String, sexo: String, edad: Int, fechaNacimiento: String, autMan: Int) {
        self.nombre = nombre
        self.sexo = sexo
        self.edad = edad
        self.fechaNacimiento = fechaNacimiento
        
        // Articulos
        self.autMan = autMan
        self.compras = ["aut": 0, "autFot": 0, "fot": 0, "fotDed": 0, "live": 0]
        
        // Famoso
        self.isStar = false
        self.key = ""
        
        self.data = [
            "nombre" : nombre,
            "edad" : edad,
            "sexo": sexo,
            "fechaNacimiento": fechaNacimiento,
            "AutMan": autMan,
            "isStar": false,
            "key": self.key]
    }
    
//    init(data: [String: Any]) {
//        self.nombre = data["nombre"] as! String
//        self.sexo = data["sexo"] as! String
//        self.edad = Int(data["edad"] as! String)!
//        self.fechaNacimiento = data["fechaNacimiento"] as! String
//        self.autMan = Int(data["AutMan"] as! String)!
//
//        // Famoso
//        self.isStar = false
//        self.key = ""
//
//        self.data = [
//            "nombre" : nombre,
//            "edad" : edad,
//            "sexo": sexo,
//            "fechaNacimiento": fechaNacimiento,
//            "AutMan": autMan,
//            "isStar": false,
//            "key": self.key]
//    }
    
    // Usuarios famosos
    init(nombre: String, sexo: String, edad: Int, fechaNacimiento: String, autMan: Int, compras: [String: Int], isStar: Bool, key: String) {
        self.nombre = nombre
        self.sexo = sexo
        self.edad = edad
        self.fechaNacimiento = fechaNacimiento
        
        // Artículos
        self.autMan = autMan
        self.compras = compras
        
        // Famoso
        self.isStar = isStar
        self.key = key
        
        self.data = [
            "nombre" : nombre,
            "edad" : edad,
            "sexo": sexo,
            "fechaNacimiento": fechaNacimiento,
            "AutMan": autMan,
            "isStar": isStar,
            "key": key]
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
    
}
