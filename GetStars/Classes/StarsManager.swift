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
    
    // Sorteos
    private var sorteos = [String]()
    private var datosSorteo = [String: Any]()
    
    // Subastas
    private var subastas = [String]()
    private var datosSubastas = [String: Any]()
    
    // Lives
    private var nParticipantesLive: Int = 0
    private var listaParticipantesLive: [String] = [String]()
    
    
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
    
    func readSorteos(dg: DispatchGroup) {
        dg.enter()
        db.collection("sorteos").getDocuments() { query, error in
            if error != nil {
                print("Error obteniendo los sorteos")
            } else {
                for document in query!.documents {
                    self.sorteos.append(document.documentID)
                }
            }
            dg.leave()
        }
    }
    
    func readDatosSorteos(name: String, dg: DispatchGroup) {
        dg.enter()
        db.collection("sorteos").document(name).getDocument { (document, error) in
            if error != nil {
                print("error leyendo el sorteo")
            } else {
                print("Sorteo obtenido")
                self.datosSorteo["descripcion"] = document!.data()!["descripcion"] as! String
                self.datosSorteo["dueño"] = document!.data()!["dueño"] as! String
                self.datosSorteo["fechaFinal"] = document!.data()!["fechaFinal"] as! String
                self.datosSorteo["nombre"] = document!.data()!["nombre"] as! String
                self.datosSorteo["participantes"] = document!.data()!["participantes"] as! [String]
            }
            dg.leave()
        }
    }
    
    func readSubastas(dg: DispatchGroup) {
        dg.enter()
        db.collection("subastas").getDocuments() { query, error in
            if error != nil {
                print("Error obteniendo las subastas")
            } else {
                for document in query!.documents {
                    self.subastas.append(document.documentID)
                }
            }
            dg.leave()
        }
    }
    
    func readDatosSubastas(name: String, dg: DispatchGroup) {
        dg.enter()
        db.collection("subastas").document(name).getDocument { (document, error) in
            if error != nil {
                print("error leyendo la subasta")
            } else {
                print("Subasta obtenida")
                self.datosSubastas["descripcion"] = document!.data()!["descripcion"] as! String
                self.datosSubastas["dueño"] = document!.data()!["dueño"] as! String
                self.datosSubastas["fechaFinal"] = document!.data()!["fechaFinal"] as! String
                self.datosSubastas["nombre"] = document!.data()!["nombre"] as! String
                self.datosSubastas["precio"] = document!.data()!["precio"] as! Double
            }
            dg.leave()
        }
    }
    
    func readListaLive(key: String, dg: DispatchGroup) {
        dg.enter()
        db.collection("lives").document(key).getDocument { (document, error) in
            if error != nil {
                print("Error leyendo los datos del live")
            } else {
                print("Obteniendo datos del live")
                self.nParticipantesLive = document!.data()!["numeroParticipantes"] as! Int
                self.listaParticipantesLive = document!.data()!["listaParticipantes"] as! [String]
                print("Datos del live obtenidos")
            }
            dg.leave()
        }
    }
    
    func añadirAlLive(key: String, email: String, dg: DispatchGroup) {
        dg.enter()
        let documentRef = db.collection("lives").document(key)
        documentRef.updateData([
            "listaParticipantes": FieldValue.arrayUnion([email as Any]),
            "numeroParticipantes": FieldValue.increment(1.0)
        ])
        dg.leave()
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
    
    func getSorteos() -> [String] {
        return self.sorteos
    }
    
    func getDatosSorteo() -> [String: Any] {
        return self.datosSorteo
    }
    
    func getSubastas() -> [String] {
        return self.subastas
    }
    
    func getDatosSubasta() -> [String: Any] {
        return self.datosSubastas
    }
    
    func getNParticipantesLive() -> Int {
        return self.nParticipantesLive
    }
    
    func getListaParticipantesLive() -> [String] {
        return self.listaParticipantesLive
    }
    
}

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
