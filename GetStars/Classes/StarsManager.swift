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
    private var cat: String = ""
    
    // Search keys
    private var destacados = [String]()
    private var novedades = [String]()
    private var populares = [String]()
    
    // Categories keys
    private var catID = [String]()
    
    // Price
    private var price: Double = 0.0
    
    
    func readKeys(dg: DispatchGroup) {
        dg.enter()
        let documentRef = db.collection("keys").document("key")
        documentRef.getDocument { (document, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Keys obtenidas")
                self.keys.append(contentsOf: document!.data()!["key"] as! [String])
            }
            dg.leave()
        }
    }
    
    func readSpecialKey(cat: String, dg: DispatchGroup) {
        dg.enter()
        let documentRef = db.collection("keys").document(cat)
        documentRef.getDocument { (document, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Keys de \(cat) obtenidas")
                switch cat {
                case "destacados":
                    self.destacados.append(contentsOf: document!.data()!["destacados"] as! [String])
                case "novedades":
                    self.novedades.append(contentsOf: document!.data()!["novedades"] as! [String])
                case "populares":
                    self.populares.append(contentsOf: document!.data()!["populares"] as! [String])
                default:
                    print("Error buscando las claves especiales")
                }
            }
            dg.leave()
        }
    }
    
    func getKeys() -> [String] {
        return self.keys
    }
    
    func getSpecialKey(cat: String) -> [String] {
        switch cat {
        case "destacados":
            return self.destacados
        case "novedades":
            return self.novedades
        case "populares":
            return self.populares
        default:
            print("Error devolviendo las claves especiales")
            return self.destacados
        }
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
    
    func readFamousByCategory(cat: String, dg: DispatchGroup) {
        dg.enter()
        db.collection(self.dbCollection).whereField("cat", isEqualTo: cat).getDocuments { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                print("Error al encontrar famosos de la categoría")
            } else {
                for document in querySnapshot!.documents {
                    self.catID.append(document.documentID)
                    print(document.documentID)
                }
                print("Obtenidos los famsosos \(cat)")
            }
            dg.leave()
        }
        
    }
    
    func getCatId() -> [String] {
        return self.catID
    }
    
    func getCat() -> String {
        return self.cat
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getDesc() -> String {
        return self.descr
    }
    
    func getProductPrice(product: String, key: String, dg: DispatchGroup) {
        dg.enter()
        let documentRef = db.collection(self.dbCollection).document(key)
        documentRef.getDocument { (document, error) in
            if error != nil {
                print("Error buscando el precio de \(product)")
            } else {
                let map = document?.data()!["prod"] as! [String : Double]
                self.price = map[product]!
            }
            dg.leave()
        }
    }
    
    func getPrice() -> Double {
        return self.price
    }
    
}

class StarsST: CloudStorage {
    private let storage = Storage.storage()
    private var imgUrl = URL(string: "")
    private var autUrl = URL(string: "")
    private var phoUrl = URL(string: "")
    
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
    
    func getAut(key: String, dg: DispatchGroup) {
        dg.enter()
        let path = "creadores/" + key + "/" + "aut.jpg"
        let storageRef = storage.reference()
        let imgRef =  storageRef.child(path)
        
        imgRef.downloadURL { url, error in
            if error != nil {
                print("Error obteniendo el autográfo")
            } else {
                self.autUrl = url
                print("URL de autógrafo obtenida")
            }
            dg.leave()
        }
    }
    
    func getAutUrl() -> URL {
        return self.autUrl!
    }
    
    func getPhoto(key: String, dg: DispatchGroup) {
        dg.enter()
        let path = "creadores/" + key + "/" + "photo.jpg"
        let storageRef = storage.reference()
        let imgRef =  storageRef.child(path)
        
        imgRef.downloadURL { url, error in
            if error != nil {
                print("Error obteniendo la foto")
            } else {
                self.phoUrl = url
                print("URL de foto obtenida")
            }
            dg.leave()
        }
    }
    
    func getPhoUrl() -> URL {
        return self.phoUrl!
    }
    
}
