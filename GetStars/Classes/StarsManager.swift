//
//  StarsManager.swift
//  GetStars
//
//  Created by Alejandro Miranda on 21/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import Combine
import Firebase

struct Stars: Identifiable {
    var id = UUID()
    var url: URL
}

class StarsDB: DataBase {
    private let dbCollection = "famosos"
    private let db = Firestore.firestore()
    private var keys: [String] = [String]()
    private var descr: String = ""
    private var name: String = ""
    
    
    func readKeys(dg: DispatchGroup) {
        dg.enter()
        let documentRef = db.collection("keys").document("key")
        documentRef.getDocument { (document, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.keys.append(contentsOf: document!.data()!["key"] as! [String])
            }
            dg.leave()
        }
    }
    
    func getKeys() -> [String] {
        return self.keys
    }
    
    func readFamous(key: String,dg: DispatchGroup) {
        dg.enter()
        let documentRef = db.collection(self.dbCollection).document(key)
        documentRef.getDocument { (document, error) in
            if let error = error {
                print(error.localizedDescription)
                print("Error obteniendo al famoso")
            } else {
                print("Cargando datos del famoso...")
                self.descr = document!.data()!["Descripcion"] as! String
                self.name = document!.data()!["Nombre"] as! String
            }
            dg.leave()
        }
    }
    
    func readFamous(key: String, session: SessionStore, dg: DispatchGroup) {
        dg.enter()
        let documentRef = db.collection(self.dbCollection).document(key)
        documentRef.getDocument { (document, error) in
            if let error = error {
                print(error.localizedDescription)
                print("Error obteniendo al famoso")
            } else {
                print("Cargando datos del famoso...")
                self.descr = document!.data()!["Descripcion"] as! String
                self.name = document!.data()!["Nombre"] as! String
            }
            dg.leave()
        }
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getDesc() -> String {
        return self.descr
    }
}

class StarsST: CloudStorage {
    private let storage = Storage.storage()
    private var imgUrl = URL(string: "")
    
    func getImage(key: String, dg: DispatchGroup) {
        dg.enter()
        let path = "creadores/" + key + "/" + "profileImage.jpg"
        let storageRef = storage.reference()
        let imgRef =  storageRef.child(path)
        imgRef.downloadURL { url, error in
            if error != nil {
                print("Error en la obtención de la imagen del famoso")
                
            } else {
                print("imagen obtenida")
                self.imgUrl = url
            }
            dg.leave()
        }
    }
    
    func getImgUrl() -> URL {
        return self.imgUrl!
    }
    
}
