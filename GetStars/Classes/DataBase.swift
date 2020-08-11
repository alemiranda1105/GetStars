//
//  DataBase.swift
//  GetStars
//
//  Created by Alejandro Miranda on 05/07/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import UIKit
import Combine

import FirebaseCore
import FirebaseFirestore
import FirebaseStorage

class DataBase: ObservableObject {
    private let dbCollection: String = "usuarios"
    private var dbRef: String = ""
    private let db = Firestore.firestore()
    private var datos: UserData?
    
    func createUserDB(session: SessionStore) {
        let email = session.session?.email
        let dbData = (session.data?.getData())!
        
        db.collection(dbCollection).document(email!).setData(dbData)
    }
    
    func createUserDB(dbData: [String: Any], email: String) {
        let ref = db.collection(dbCollection).document(email)
        ref.getDocument { (document, error) in
            if document?.exists ?? false {
                print("ya existe el archivo")
                return
            } else {
                print("El archivo no existe, Creando...")
                self.db.collection(self.dbCollection).document(email).setData(dbData)
            }
        }
    }
    
    func readDataUser(session: SessionStore, dg: DispatchGroup) {
        dg.enter()
        let email = (session.session?.email)!
        let documentRef = db.collection(dbCollection).document(email)
        
        documentRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing: )) ?? "nil"
                
                self.datos = UserData(nombre: document.data()!["nombre"] as! String,
                                        apellidos: document.data()!["apellidos"] as! String,
                                        sexo: document.data()!["sexo"] as! String,
                                        edad: document.data()!["edad"] as! Int,
                                        fechaNacimiento: document.data()!["fechaNacimiento"] as! String,
                                        autMan: document.data()!["AutMan"] as! Int)
                
                let defaults = UserDefaults.standard
                defaults.set(document.data()!["nombre"] as! String, forKey: "name")
                defaults.set(document.data()!["apellidos"] as! String, forKey: "lastName")
                defaults.set(document.data()!["edad"] as! Int, forKey: "age")
                defaults.set(document.data()!["sexo"] as! String, forKey: "sex")
                defaults.set(document.data()!["fechaNacimiento"] as! String, forKey: "fechaNacimiento")
                defaults.synchronize()
                
                session.data = self.datos!
                session.signing = false
                
                print("Document data: \(dataDescription)")
            } else {
                session.signOut()
                print("No existe el documento")
            }
            dg.leave()
        }
    }
    
    func updateUserDataDB(session: SessionStore) {
        let email = session.session?.email
        let dbData = (session.data?.getData())!
        
        db.collection(dbCollection).document(email!).setData(dbData)
    }

}
