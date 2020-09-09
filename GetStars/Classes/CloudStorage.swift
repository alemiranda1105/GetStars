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
    private var downloadImg = UIImage()
    
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
    
    func downloadFile(session: SessionStore, type: String, index: String, dg: DispatchGroup) {
        dg.enter()
        let path = "usuarios/" + (session.session?.email)! + "/" + type + "/" + "\(index)" + ".jpg"
        let storageRef = storage.reference()
        let imgRef =  storageRef.child(path)
        imgRef.getData(maxSize: 1 * 512 * 512) { data, error in
            if error != nil {
                print("Error en la descarga")
            } else {
                self.downloadImg = data.flatMap(UIImage.init)!
                print("Imagen descargada")
            }
            dg.leave()
        }
    }
    
    func getDownloadImg() -> UIImage {
        return self.downloadImg
    }
    
    func downloadURL(session: SessionStore, type: String, index: Int, dg: DispatchGroup) {
        dg.enter()
        let path = "usuarios/" + (session.session?.email)! + "/" + type + "/" + "\(index)" + ".jpg"
        let storageRef = storage.reference()
        let imgRef =  storageRef.child(path)
        imgRef.downloadURL { url, error in
            if error != nil {
                print("Error en la obtención de una url")
                
            } else {
                print("URL Obtenida")
                let urlLoader = UrlLoader(url: url!, id: index)
                urlLoader.setName(name: "\(index)")
                if urlLoader.isContained(array: session.url, url: urlLoader) {
                    print("Ya descargado")
                } else {
                    session.url.append(urlLoader)
                }
            }
            dg.leave()
        }
    }
    
    func deleteFile(userType: String, email: String, name: String, type: String) {
        let path = "\(userType)/\(email)/\(type)/\(name)"
        let imgRef = storage.reference().child(path)
        imgRef.delete { error in
            if error != nil {
                print("Errror eliminando el archivo \(name)")
                print(error?.localizedDescription ?? "")
            }
        }
    }
    
    func deleteSt(session: SessionStore) {
        let path = "usuarios/" + (session.session?.email)!
        let storageRef = storage.reference()
        let ref = storageRef.child(path)
        
        ref.delete { error in
            if let error = error {
                print(error.localizedDescription)
                print("Error eliminando la nube")
            } else {
                print("Nube eliminada")
            }
        }
    }
    
}
