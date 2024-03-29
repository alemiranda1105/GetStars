//
//  DataBase.swift
//  GetStars
//
//  Created by Alejandro Miranda on 05/07/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
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
    
    private var check = false
    
    func createUserDB(session: SessionStore) {
        let email = session.session?.email
        var dbData = (session.data?.getData())!
        dbData["revisionesPendientes"] = [String]()
        
        db.collection(dbCollection).document(email!).setData(dbData)
    }
    
    func createUserDB(dbData: [String: Any], email: String) {
        let ref = db.collection(dbCollection).document(email)
        ref.getDocument { (document, error) in
            if document?.exists ?? false {
                print("ya existe el archivo")
                UserDefaults.standard.set(true, forKey: "sign")
                return
            } else {
                print("El archivo no existe, Creando...")
                UserDefaults.standard.set(true, forKey: "sign")
                self.db.collection(self.dbCollection).document(email).setData(dbData)
            }
        }
    }
    
    func updateData(data: [String: Any], email: String) {
        let ref = db.collection(dbCollection).document(email)
        ref.updateData(data)
    }
    
    func readDataUser(session: SessionStore, dg: DispatchGroup) {
        dg.enter()
        let email = (session.session?.email) ?? ""
        if email == "" {
            print("Error obteniendo el email del usuario ---- readDataUser() -> DB")
            return
        }
        let documentRef = db.collection(dbCollection).document(email)
        
        documentRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing: )) ?? "nil"
                
                self.datos = UserData(nombre: document.data()!["nombre"] as! String,
                                        sexo: document.data()!["sexo"] as! String,
                                        edad: document.data()!["edad"] as! Int,
                                        fechaNacimiento: document.data()!["fechaNacimiento"] as! String,
                                        autMan: document.data()!["AutMan"] as! Int,
                                        compras: document.data()!["compras"] as! [String : [String]],
                                        isStar: document.data()!["isStar"] as! Bool,
                                        key: document.data()!["key"] as! String,
                                        isPro: document.data()!["isPro"] as! Bool)
                
                let defaults = UserDefaults.standard
                defaults.set(document.data()!["nombre"] as! String, forKey: "name")
                defaults.set(document.data()!["edad"] as! Int, forKey: "age")
                defaults.set(document.data()!["sexo"] as! String, forKey: "sex")
                defaults.set(document.data()!["fechaNacimiento"] as! String, forKey: "fechaNacimiento")
                defaults.set(document.data()!["AutMan"] as! Int, forKey: "AutMan")
                defaults.set(document.data()!["isStar"] as! Bool, forKey: "isStar")
                defaults.set(document.data()!["key"] as! String, forKey: "key")
                defaults.synchronize()
                
                session.data = self.datos!
                //session.articles["AutMan"] = (document.data()!["AutMan"] as! Int)
                session.signing = false
                UserDefaults.standard.set(false, forKey: "sign")
                
                print("Document data: \(dataDescription)")
            } else {
                session.signOut()
                print("No existe el documento")
            }
            dg.leave()
        }
    }
    
    func uploadDedicatoria(documentID: String, key: String, email: String, mensaje: String, color: UIColor, size: CGFloat, posicion: [CGFloat], tipo: String, dg: DispatchGroup) {
        dg.enter()
        
        // Procesamiento datos
        let colorDesc = hexToString(color: color)
        let posDesc = "\(posicion[0]), \(posicion[1])"
        let sizeDesc = "\(size)"
        
        let data: [String: String] = ["key": key, "email": email, "mensaje": mensaje, "color": colorDesc, "posicion": posDesc, "tamañoFuente": sizeDesc, "tipo": tipo]
        
        let docRef = db.collection("revision").document(documentID)
        docRef.getDocument { (document, error) in
            
            if let document = document, document.exists {
                print("El documento ya existe")
                let newDocumentId = generateDocumentId(length: 21)
                self.db.collection("revision").document(newDocumentId).setData(data)
            } else {
                print("Document does not exist")
                self.db.collection("revision").document(documentID).setData(data)
            }
            dg.leave()
            
        }
    }
    
    func addDedicatoriaToUser(email: String, dedicatoria: String, dg: DispatchGroup) {
        dg.enter()
        db.collection(dbCollection).document(email).updateData([
            "revisionesPendientes": FieldValue.arrayUnion([dedicatoria])
        ]) { error in
            if error != nil {
                print("Error añadiendo la revision")
                print(error?.localizedDescription ?? "")
            }
            dg.leave()
        }
    }
    
    func addCompraToUserDB(email: String, compra: String, url: String, dg: DispatchGroup) {
        dg.enter()
        db.collection(dbCollection).document(email).updateData([
            "compras.\(compra)": FieldValue.arrayUnion([url])
        ])
        dg.leave()
    }
    
    func updateAutManDB(session: SessionStore) {
        let email = session.session?.email
        
        db.collection(dbCollection).document(email!).updateData(["AutMan": session.data?.autMan as Any]) { err in
            if err != nil {
                print("Error actualizando")
            } else {
                print("Base de datos actualizada")
            }
        }
    }
    
    func readCompras(session: SessionStore, dg: DispatchGroup) {
        dg.enter()
        let email = session.session?.email ?? ""
        let documentRef = db.collection(dbCollection).document(email)
        
        documentRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
            } else {
                print(error?.localizedDescription ?? "")
                print("Error obteniendo los datos de compra")
            }
            dg.leave()
        }
    }
    
    func readRevisionesPendientes(session: SessionStore, type: String, dg: DispatchGroup) {
        dg.enter()
        let email = session.session?.email ?? ""
        let documentRef = db.collection(dbCollection).document(email)
        
        documentRef.getDocument { document, error in
            if let document = document, document.exists {
                session.revisonesPendientes = document.data()?["revisionesPendientes"] as! [String]
            } else {
                print(error?.localizedDescription ?? "")
                print("Error obteniendo las revisiones pendientes")
            }
            dg.leave()
        }
        
    }
    
    func startPro(email: String, dg: DispatchGroup) {
        dg.enter()
        let documentRef = db.collection(dbCollection).document(email)
        documentRef.updateData(["isPro": true])
        dg.leave()
    }
    
    func finishPro(email: String, dg: DispatchGroup) {
        dg.enter()
        let documentRef = db.collection(dbCollection).document(email)
        documentRef.updateData(["isPro": false])
        dg.leave()
    }
    
    func deleteDB(session: SessionStore) {
        let email = session.session?.email
        
        db.collection(dbCollection).document(email!).delete() { err in
            if let err = err {
                print(err.localizedDescription)
                print("error eliminando la base de datos")
            } else {
                print("Base de datos eliminada")
            }
        }
    }
}
