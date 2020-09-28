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
    private var keys: [String] = [String]()
    private var descr: String = ""
    private var name: String = ""
    private var cat: String = ""
    
    // Search keys
    private var destacados = [String]()
    private var novedades = [String]()
    private var populares = [String]()
    private var resultadoBusqueda = [String]()
    
    // Categories keys
    private var catID = [String]()
    
    // Price
    private var price: Double = 0.0
    
    // Sorteos
    private var sorteos = [String]()
    private var datosSorteo = [String: Any]()
    private var sorteoName = ""
    
    // Subastas
    private var subastas = [String]()
    private var datosSubastas = [String: Any]()
    
    // Lives
    private var nParticipantesLive: Int = 0
    private var listaParticipantesLive: [[String: String]] = [[String: String]]()
    
    func updatePrice(price: Double, article: String, key: String) {
        print("Actualizando el precio de \(article) de \(key)")
        print(price.dollarString)
        db.collection(self.dbCollection).document(key).updateData([
            "prod.\(article)": price
        ]) { error in
            if error != nil {
                print("Error actualizando el precio")
                print(error?.localizedDescription ?? "")
            } else {
                print("Precio actualizado")
            }
        }
    }
    
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
    
    func uploadSorteo(datos: [String: String], dg: DispatchGroup) {
        dg.enter()
        let documentRef = db.collection("sorteos").document(datos["nombre"]!)
        var dat: [String: Any] = datos as [String: Any]
        dat["participantes"] = [String]()
        
        documentRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("El sorteo existe, cambiándole el nombre")
                return self.uploadSorteo(datos: dat, dg: dg, n: 1)
            } else {
                print("El sorteo no existe, creando...")
                self.sorteoName = dat["nombre"] as! String
                documentRef.setData(datos)
            }
            dg.leave()
        }
    }
    
    private func uploadSorteo(datos: [String: Any], dg: DispatchGroup, n: Int) {
        dg.enter()
        let documentRef = db.collection("sorteos").document(datos["nombre"] as! String + "\(n)")
        
        documentRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("El sorteo existe, cambiándole el nombre")
                return self.uploadSorteo(datos: datos, dg: dg, n: n+1)
            } else {
                print("El sorteo no existe, creando...")
                self.sorteoName = datos["nombre"] as! String + "\(n)"
                documentRef.setData(datos)
            }
            dg.leave()
        }
    }
    
    // Usado para el nombre de la subasta
    func getSorteoName() -> String {
        return self.sorteoName
    }
    
    func uploadSubasta(datos: [String: Any], dg: DispatchGroup) {
        dg.enter()
        let documentRef = db.collection("subastas").document(datos["nombre"] as! String)
        
        documentRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("La subasta existe, cambiándole el nombre")
                return self.uploadSubasta(datos: datos, dg: dg, n: 1)
            } else {
                print("La subasta no existe, creando...")
                self.sorteoName = datos["nombre"] as! String
                documentRef.setData(datos)
            }
            dg.leave()
        }
    }
    
    private func uploadSubasta(datos: [String: Any], dg: DispatchGroup, n: Int) {
        dg.enter()
        let documentRef = db.collection("subastas").document(datos["nombre"] as! String + "\(n)")
        
        documentRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("La subasta existe, cambiándole el nombre")
                return self.uploadSorteo(datos: datos, dg: dg, n: n+1)
            } else {
                print("La subasta no existe, creando...")
                self.sorteoName = datos["nombre"] as! String + "\(n)"
                documentRef.setData(datos)
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
        self.listaParticipantesLive.removeAll()
        db.collection("lives").document(key).getDocument { (document, error) in
            if error != nil {
                print("Error leyendo los datos del live")
            } else {
                print("Obteniendo datos del live")
                self.nParticipantesLive = document!.data()!["numeroParticipantes"] as! Int
                self.listaParticipantesLive = document!.data()!["listaParticipantes"] as! [[String: String]]
                print("Datos del live obtenidos")
            }
            dg.leave()
        }
    }
    
    func añadirAlLive(key: String, email: String, mensaje: String, dg: DispatchGroup) {
        dg.enter()
        let documentRef = db.collection("lives").document(key)
        documentRef.updateData([
            "listaParticipantes": FieldValue.arrayUnion([[email: mensaje]]),
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
    
    func addVenta(product: String, key: String) {
        let documentRef = db.collection(self.dbCollection).document(key)
        documentRef.updateData([
            "ventas.\(product)": FieldValue.increment(1.0)
        ])
    }
    
    func readVentas(session: SessionStore, dg: DispatchGroup) {
        dg.enter()
        let documentRef = db.collection(self.dbCollection).document(session.data?.getUserKey() ?? "")
        documentRef.getDocument { (document, error) in
            if error != nil {
                print("Error obteniendos las ventas del usuario")
                print(error?.localizedDescription ?? "")
            } else {
                session.data?.ventas = document?.data()!["ventas"] as! [String: Int]
            }
            dg.leave()
        }
    }
    
    func eliminarUsuarioLive(key: String, email: String, mensaje: String) {
        let documentRef = db.collection("lives").document(key)
        
        documentRef.updateData([
            "listaParticipantes": FieldValue.arrayRemove([[email: mensaje]]),
            "numeroParticipantes": FieldValue.increment(-1.0)
        ])
    }
    
    func añadirLiveSubido(key: String, email: String) {
        let documentRef = db.collection("usuarios").document(email)
        
        documentRef.updateData(["compras.live": FieldValue.arrayUnion([key])])
    }
    
    func buscarUsuario(nombre: String, dg: DispatchGroup) {
        dg.enter()
        db.collection("famosos").whereField("Nombre", isEqualTo: nombre).getDocuments() { result, error in
            if error != nil {
                print("Error buscando el usuario")
                print(error?.localizedDescription ?? "")
            } else {
                for doc in result!.documents {
                    self.resultadoBusqueda.append(doc.documentID)
                }
            }
            dg.leave()
        }
    }
    
    func getResultadoBusqueda() -> [String] {
        return self.resultadoBusqueda
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
    
    func getListaParticipantesLive() -> [[String: String]] {
        return self.listaParticipantesLive
    }
    
}
