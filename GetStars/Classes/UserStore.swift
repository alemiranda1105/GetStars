//
//  UserStore.swift
//  GetStars
//
//  Created by Alejandro Miranda on 30/07/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import UIKit
import Combine

// Firebase
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class UserStore: ObservableObject {
    // Datos usuario
    @Published var data: UserDefaults = UserDefaults.standard
    let db: DataBase = DataBase()
    
    //Inidica si el usuario esta iniciando sesion
    @Published var signing: Bool = false
    
    func deleteData() {
        data.removeObject(forKey: "nombre")
        data.removeObject(forKey: "apellidos")
        data.removeObject(forKey: "edad")
        data.removeObject(forKey: "sexo")
        data.removeObject(forKey: "fechaNacimiento")
        
        data.synchronize()
    }
}
