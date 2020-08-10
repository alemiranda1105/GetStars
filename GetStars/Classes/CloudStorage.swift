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
    
    func downloadAllFiles(session: SessionStore, type: String, dg: DispatchGroup){
        dg.enter()
        let art = session.articles[type]!
        let dg2 = DispatchGroup()
        for i in 0...art {
            dg2.enter()
            let path = "usuarios/" + (session.session?.email)! + "/" + type + "/" + "\(i)" + ".jpg"
            let storageRef = storage.reference()
            let imgRef =  storageRef.child(path)
            imgRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if error != nil {
                    print("Error en la descarga")
                } else {
                    let imgData = data.flatMap(UIImage.init)
                    let img = ImageLoader(image: imgData!, id: i)
                    
                    if img.isContained(array: session.autMan, img: img) {
                        print("Ya descargado")
                        
                    } else {
                        session.autMan.append(img)
                        print("Descargado")
                    }
                }
                dg2.leave()
            }
        }
        dg2.notify(queue: DispatchQueue.global(qos: .background)) {
            print("DESCARGA TERMINADA")
            dg.leave()
        }
    }
}

struct ImageLoader: Identifiable {
    var id: Int
    var image: UIImage
    init(image: UIImage, id: Int) {
        self.image = image
        self.id = id
    }
    
    func isContained(array: [ImageLoader], img: ImageLoader) -> Bool {
        for i in array {
            if i.id == img.id {
                return true
            }
        }
        return false
    }
}
