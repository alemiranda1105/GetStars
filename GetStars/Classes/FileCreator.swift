//
//  FileCreator.swift
//  GetStars
//
//  Created by Alejandro Miranda on 14/07/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import UIKit

// Contador de errores
private var e: Int = 0

private let fileName = "usdat.txt"
private var filePath = ""

// Directorios en el dispositivo
private let dirs: [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                         FileManager.SearchPathDomainMask.allDomainsMask, true)

func createFile(usuario: DataUser) {
    let data: String = usuario.toString()
    
    if dirs.count > 0 {
        let dir = dirs[0]
        filePath = dir.appending("/" + fileName)
    } else {
        print("No se pudo encontrar un directorio")
        return
    }
    
    do {
        try data.write(toFile: filePath, atomically: false, encoding: String.Encoding.utf8)
        
    } catch let error as NSError {
        print("Error al escribir el archivo: \(error)")
    }
    
}

func readFile() -> [String: Any]{
    
    if dirs.count > 0 {
        let dir = dirs[0]
        filePath = dir.appending("/" + fileName)
        
    } else {
        print("No se pudo encontrar un directorio")
        return ["": 0]
    }
    
    do {
        // Convierte a un array de string para poder cargar los datos de los usuarios
        let recData = try NSString(contentsOfFile: filePath, encoding: String.Encoding.utf8.rawValue)
        let str = recData.components(separatedBy: ", ")
        let name = str[0].components(separatedBy: ": ")
        let surname = str[1].components(separatedBy: ": ")
        let age = str[2].components(separatedBy: ": ")
        let sex = str[3].components(separatedBy: ": ")
        let birth = str[4].components(separatedBy: ": ")
        
        let data: [String: Any] = [
            "nombre": name[1],
            "apellidos" : surname[1],
            "edad" : age[1],
            "sexo": sex[1],
            "fechaNacimiento": birth[1]]
        
        return data
        
    } catch let error as NSError {
        print("Error al leer el archivo: \(error)")
        e+=1
        if e >= 30 {
            return ["": 0]
        }
        return readFile()
    }
}

func removeFile() {
    var path = Array<String>()
    if dirs.count > 0 {
        let dir = dirs[0]
        
        dirs.forEach({
            path.append($0.appending("/" + fileName))
        })
        
        filePath = dir.appending("/" + fileName)
        
    } else {
        print("No se pudo encontrar un directorio")
        return
    }
    
    for i in (0...path.count-1) {
        do {
            try FileManager.default.removeItem(atPath: path[i])
        } catch let error as NSError {
            print("Error al borrar el archivo: \(error)")
            continue
        }
    }
}
