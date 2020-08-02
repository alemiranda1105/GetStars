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

class DataBase: ObservableObject {
    private let dbCollection: String = "usuarios"
    private var dbRef: String = ""
    private let db = Firestore.firestore()
    private var datos: DataUser?
    
    func createUserDB(session: SessionStore) {
        let uid = session.session?.uid
        let dbData = (session.data?.getData())!
        
        db.collection(dbCollection).document(uid!).setData(dbData)
    }
    
    func readDataUser(session: SessionStore) {
        let uid = (session.session?.uid)!
        let documentRef = db.collection(dbCollection).document(uid)
        
        documentRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing: )) ?? "nil"
                
                self.datos = DataUser(nombre: document.data()!["nombre"] as! String,
                                        apellidos: document.data()!["apellidos"] as! String,
                                        sexo: document.data()!["sexo"] as! String,
                                        edad: document.data()!["edad"] as! Int,
                                        fechaNacimiento: document.data()!["fechaNacimiento"] as! String)
                
                createFile(usuario: self.datos!)
                
                let defaults = UserDefaults.standard
                defaults.set(document.data()!["nombre"] as! String, forKey: "name")
                defaults.set(document.data()!["apellidos"] as! String, forKey: "lastName")
                defaults.set(document.data()!["edad"] as! Int, forKey: "age")
                defaults.set(document.data()!["sexo"] as! String, forKey: "sex")
                defaults.set(document.data()!["fechaNacimiento"] as! String, forKey: "fechaNacimiento")
                defaults.synchronize()
                
                print("Document data: \(dataDescription)")
            } else {
                session.signOut()
                print("No existe el documento")
            }
        }
    }
    
    func readDataUser(session: SessionStore, dg: DispatchGroup) {
        dg.enter()
        let uid = (session.session?.uid)!
        let documentRef = db.collection(dbCollection).document(uid)
        
        documentRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing: )) ?? "nil"
                
                self.datos = DataUser(nombre: document.data()!["nombre"] as! String,
                                        apellidos: document.data()!["apellidos"] as! String,
                                        sexo: document.data()!["sexo"] as! String,
                                        edad: document.data()!["edad"] as! Int,
                                        fechaNacimiento: document.data()!["fechaNacimiento"] as! String)
                
                session.data = self.datos!
                session.signing = false
                
                createFile(usuario: self.datos!)
                
                print("Document data: \(dataDescription)")
            } else {
                session.signOut()
                print("No existe el documento")
            }
            dg.leave()
        }
    }

}
