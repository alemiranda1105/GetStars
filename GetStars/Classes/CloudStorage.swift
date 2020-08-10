//
//  CloudStorage.swift
//  GetStars
//
//  Created by Alejandro Miranda on 05/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import UIKit
import Combine

import FirebaseCore
import FirebaseStorage

class CloudStorage: ObservableObject {
    private let storage = Storage.storage()
    // private var path: String = "usuarios/"
    
    func uploadFile(session: SessionStore, img: UIImage, type: String) {
        if session.session?.email == nil {
            return
        }
        let n: String! = String(session.articles[type]!)
        let path = "usuarios/" + (session.session?.email)! + "/" + type + "/" + n + ".jpg"
        let storageRef = storage.reference()
        let imgRef =  storageRef.child(path)
        
        // Subida
        let data = img.jpegData(compressionQuality: 0.8)!
        _ = imgRef.putData(data, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                print(error?.localizedDescription as Any)
                return
            }
        }
    }
    
    func downloadAllFiles(session: SessionStore, type: String) {
        if session.session?.email == nil {
            return
        }
        let art = session.articles[type]!
        
        for i in 0...art {
            let path = "usuarios/" + (session.session?.email)! + "/" + type + "/" + "\(i)" + ".jpg"
            let storageRef = storage.reference()
            let imgRef =  storageRef.child(path)
            imgRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if error != nil {
                    print("Error en la descarga")
                } else {
                    print("Descargado")
                }
            }
        }
        
    }
}
