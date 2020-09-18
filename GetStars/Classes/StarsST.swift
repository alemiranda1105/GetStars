//
//  StarsST.swift
//  GetStars
//
//  Created by Alejandro Miranda on 17/09/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import Combine
import Firebase

class StarsST: CloudStorage {
    private let storage = Storage.storage()
    private var imgUrl = URL(string: "")
    private var autUrl = URL(string: "")
    private var phoUrl = URL(string: "")
    private var img = UIImage()
    
    // Sorteo y subasta
    private var imagenSorteo = URL(string: "")
    private var imagenSubasta = URL(string: "")
    
    // Live
    private var urlLive = URL(string: "")
    
    // Compras
    private var urlCompras = [URL]()
    private var compra = URL(string: "")
    
    func readUrlCompra(type: String, key: String, dg: DispatchGroup) {
        dg.enter()
        compra = URL(string: "")
        let path = "creadores/\(key)/\(type).jpg"
        let storageRef = storage.reference()
        let imgRef =  storageRef.child(path)
        imgRef.downloadURL { url, error in
            if error != nil {
                print("error obteniendo el enlace de esta compra")
                print(error?.localizedDescription ?? "")
            } else {
                self.compra = url
            }
            dg.leave()
        }
    }
    
    func getUrlCompra() -> URL {
        return self.compra!
    }
    
    func downloadFile(key: String, dg: DispatchGroup) {
        dg.enter()
        let path = "creadores/" + "93cnbY5xxelS73sSsWnm" + "/profileImage.jpg"
        let storageRef = storage.reference()
        let imgRef =  storageRef.child(path)
        imgRef.getData(maxSize: 1 * 512 * 512) { data, error in
            if error != nil {
                print(error?.localizedDescription ?? "")
                print("Error en la descarga")
            } else {
                self.img = UIImage(data: data!)!
            }
            dg.leave()
        }
    }
    
    func getImageFile() -> UIImage {
        return self.img
    }
    
    func getProfileImage(key: String, dg: DispatchGroup) {
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
    
    func getProfileImgUrl() -> URL {
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
                self.urlCompras.append(url!)
                print("URL de autógrafo de \(key) obtenida")
            }
            dg.leave()
        }
    }
    
    func getAutUrl() -> URL {
        return self.autUrl!
    }
    
    func getUrlCompras() -> [URL] {
        return self.urlCompras
    }
    
    func getAutPhoto(key: String, dg: DispatchGroup) {
        dg.enter()
        let path = "creadores/" + key + "/" + "autFot.jpg"
        let storageRef = storage.reference()
        let imgRef =  storageRef.child(path)
        
        imgRef.downloadURL { url, error in
            if error != nil {
                print("Error obteniendo la foto")
            } else {
                self.phoUrl = url
                self.urlCompras.append(url!)
                print("URL de foto obtenida")
            }
            dg.leave()
        }
    }
    
    func getPhoUrl() -> URL {
        return self.phoUrl!
    }
    
    func readSorteoImage(key: String, name: String, dg: DispatchGroup) {
        dg.enter()
        let path = "creadores/" + key + "/sorteos/" + name.replacingOccurrences(of: " ", with: "") + ".jpg"
        let storageRef = storage.reference()
        let imgRef = storageRef.child(path)
        imgRef.downloadURL { url, error in
            if error != nil {
                print("error obteniendo la imagen del sorteo")
                print(error?.localizedDescription ?? "")
                self.imagenSorteo = URL(string: "")
            } else {
                self.imagenSorteo = url
                print("URL foto sorteo obtenido")
            }
            dg.leave()
        }
    }
    
    func getFotoSorteo() -> URL {
        return self.imagenSorteo!
    }
    
    func readSubastaImage(key: String, name: String, dg: DispatchGroup) {
        dg.enter()
        let path = "creadores/" + key + "/subastas/" + name.replacingOccurrences(of: " ", with: "") + ".jpg"
        let storageRef = storage.reference()
        let imgRef = storageRef.child(path)
        imgRef.downloadURL { url, error in
            if error != nil {
                print("error obteniendo la imagen de la subasta")
                print(error?.localizedDescription ?? "")
                self.imagenSorteo = URL(string: "")
            } else {
                self.imagenSubasta = url
                print("URL foto subasta obtenido")
            }
            dg.leave()
        }
    }
    
    func getFotoSubasta() -> URL {
        return self.imagenSubasta!
    }
    
    func uploadLiveToUser(key: String, email: String, url: URL, dg: DispatchGroup) {
        dg.enter()
        let path = "usuarios/" + email + "/live/" + key
        let storageRef = storage.reference()
        let liveRef = storageRef.child(path)
        
        liveRef.putFile(from: url, metadata: nil) { metadata, error in
            if error != nil {
                print(error?.localizedDescription ?? "")
                print("Error subiendo el live bro")
            } else {
                print("----- LIVE SUBIDO -----")
            }
            dg.leave()
        }
    }
    
    func uploadTempLive(key: String, url: URL, dg: DispatchGroup) {
        dg.enter()
        let path = "creadores/" + key + "/live/temp"
        let storageRef = storage.reference()
        let liveRef = storageRef.child(path)
        
        liveRef.putFile(from: url, metadata: nil) { metadata, error in
            if error != nil {
                print(error?.localizedDescription ?? "")
                print("Error subiendo el live temporal bro")
            } else {
                print("----- LIVE TEMPORAL SUBIDO -----")
            }
            dg.leave()
        }
    }
    
    func downloadTempLive(key: String, url: URL, dg: DispatchGroup) {
        dg.enter()
        let path = "creadores/" + key + "/live/temp"
        let storageRef = storage.reference()
        let liveRef = storageRef.child(path)
        
        liveRef.getData(maxSize: 1*512*512) { data, error in
            if error != nil {
                print(error?.localizedDescription ?? "")
                print("Error descargando el video temporal")
            } else {
                print("Video temporal descargado")
            }
        }
    }
    
    func downloadLiveURL(key: String, email: String, dg: DispatchGroup) {
        dg.enter()
        let path = "usuarios/" + email + "/live/" + key
        let storageRef = storage.reference()
        let liveRef = storageRef.child(path)
        liveRef.downloadURL { (url, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
                print("Error descargando la url del video")
            } else {
                self.urlLive = url!
            }
            dg.leave()
        }
    }
    
    func getLiveURL() -> URL {
        return self.urlLive!
    }
    
    private func getDate() -> String {
        var res = ""
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        res += formatter.string(from: now)
        return res
    }
    
}
