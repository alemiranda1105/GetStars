//
//  StarsManager.swift
//  GetStars
//
//  Created by Alejandro Miranda on 21/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import Combine
import Firebase

class StarsDB: DataBase {
    private let dbCollection = "famosos"
    private let db = Firestore.firestore()
    private var keys: [String] = [""]
    
    func readKeys() -> [String]{
        let documentRef = db.collection("keys").document("key")
        let dg = DispatchGroup()
        documentRef.getDocument { (document, error) in
            dg.enter()
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.keys = document!.data()!["key"] as! [String]
            }
            dg.leave()
        }
        return self.keys
    }
}

class StarsST: CloudStorage {
    private let storage = Storage.storage()
    private var imgUrl = ""
    
    func getImage(key: String) {
        let dg = DispatchGroup()
        dg.enter()
        let path = "creadores/" + key + "/" + "profileImage.jpg"
        let storageRef = storage.reference()
        let imgRef =  storageRef.child(path)
        imgRef.downloadURL { url, error in
            if error != nil {
                print("Error en la obtención de la imagen del famoso")
                
            } else {
                print("imagen obtenida")
                self.imgUrl = ""
            }
            dg.leave()
        }
    }
    
}
