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
    private let apellidos: String
    private let sexo: String
    private let edad: Int
    private let fechaNacimiento: String
    private let data: [String: Any]
    
    // Articulos
    var autMan: Int
    
    init(nombre: String, apellidos: String, sexo: String, edad: Int, fechaNacimiento: String, autMan: Int) {
        self.nombre = nombre
        self.apellidos = apellidos
        self.sexo = sexo
        self.edad = edad
        self.fechaNacimiento = fechaNacimiento
        self.autMan = autMan
        self.data = [
            "nombre" : nombre,
            "apellidos" : apellidos,
            "edad" : edad,
            "sexo": sexo,
            "fechaNacimiento": fechaNacimiento,
            "AutMan": autMan]
    }
    
    init(data: [String: Any]) {
        self.nombre = data["nombre"] as! String
        self.apellidos = data["apellidos"] as! String
        self.sexo = data["sexo"] as! String
        self.edad = Int(data["edad"] as! String)!
        self.fechaNacimiento = data["fechaNacimiento"] as! String
        self.autMan = Int(data["AutMan"] as! String)!
        self.data = [
            "nombre" : nombre,
            "apellidos" : apellidos,
            "edad" : edad,
            "sexo": sexo,
            "fechaNacimiento": fechaNacimiento,
            "AutMan": autMan]
    }
    
    func getData() -> [String: Any]{
        return data
    }
    
    func getName() -> String {
        return self.nombre
    }
    
}
