//
//  DataUser.swift
//  GetStars
//
//  Created by Alejandro Miranda on 05/07/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import UIKit

struct DataUser {
    private let nombre: String
    private let apellidos: String
    private let sexo: String
    private let edad: Int
    private let fechaNacimiento: String
    private let data: [String: Any]
    
    
    init(nombre: String, apellidos: String, sexo: String, edad: Int, fechaNacimiento: String) {
        self.nombre = nombre
        self.apellidos = apellidos
        self.sexo = sexo
        self.edad = edad
        self.fechaNacimiento = fechaNacimiento
        self.data = [
            "nombre" : nombre,
            "apellidos" : apellidos,
            "edad" : edad,
            "sexo": sexo,
            "fechaNacimiento": fechaNacimiento]
    }
    
    init(data: [String: Any]) {
        self.nombre = data["nombre"] as! String
        self.apellidos = data["apellidos"] as! String
        self.sexo = data["sexo"] as! String
        self.edad = Int(data["edad"] as! String)!
        self.fechaNacimiento = data["fechaNacimiento"] as! String
        self.data = [
            "nombre" : nombre,
            "apellidos" : apellidos,
            "edad" : edad,
            "sexo": sexo,
            "fechaNacimiento": fechaNacimiento]
    }
    
    func getData() -> [String: Any]{
        return data
    }
    
    func getName() -> String {
        return self.nombre
    }
    
    func toString() -> String {
        return "nombre" + ": " + self.nombre + ", " + "apellidos" + ": " + self.apellidos + ", " +  "edad" + ": " + String(self.edad) + ", " +  "sexo" + ": " + self.sexo + ", " +  "fechaNacimiento" + ": " + self.fechaNacimiento
    }
}
