//
//  SessionStore.swift
//  GetStars
//
//  Created by Alejandro Miranda on 29/06/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import UIKit
import Combine

// Firebase
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class SessionStore:NSObject, ObservableObject, GIDSignInDelegate {
    var didChange = PassthroughSubject<SessionStore, Never>()
    @Published var session: User? {didSet {self.didChange.send(self)}}
    var handle: AuthStateDidChangeListenerHandle?
    
    // Datos usuario
    @Published var data: UserData?
    public let db: DataBase = DataBase()
    public let st: CloudStorage = CloudStorage()
    
    // Numero de articulos que tiene
    // @Published var articles: [String: Int] = ["AutMan": 0, "AutDed": 0, "AutFot": 0, "Foto": 0, "FotoDed":0, "Live": 0]
    @Published var url = [UrlLoader]()
    
    // Carrito de articulos
    @Published var cart = [Product]()
    
    //Inidica si el usuario esta iniciando sesion
    @Published var signing: Bool = false
    
    
    func listen(dg: DispatchGroup){
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            dg.enter()
            if let user = user {
                self.session = User(uid: user.uid, email: user.email)
            } else {
                self.session = nil
            }
            dg.leave()
        })
    }
    
    func signUp(email: String, password: String, handler: @escaping AuthDataResultCallback){
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }
    
    func signIn(email: String, password: String, handler: @escaping AuthDataResultCallback){
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    func signOut(){
        do {
            try Auth.auth().signOut()
            let def = UserDefaults.standard
            self.data?.getData().forEach { d in
                def.removeObject(forKey: d.key)
            }
            def.removeObject(forKey: "sign")
            def.removeObject(forKey: "SESSION")
            self.url.removeAll()
            // self.articles.removeAll()
            self.data = nil
            self.session = nil
        } catch {
            print("ERROR SIGNING OUT")
        }
    }
    
    func reAuth(email: String, pass: String, dg: DispatchGroup) {
        let user = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail: email, password: pass)
        
        user?.reauthenticate(with: credential, completion: { (res, error) -> Void in
            dg.enter()
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Reaunteticado")
            }
            dg.leave()
        })
        
    }
    
    func deleteAccount() {
        let user = Auth.auth().currentUser
        self.db.deleteDB(session: self)
        self.st.deleteSt(session: self)
        user?.delete { error in
            if let error = error {
                print(error.localizedDescription)
                print("error eliminando la cuenta")
            } else {
                print("Cuenta eliminada")
            }
        }
    }
    
    func unbind() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    deinit {
        unbind()
    }
    
    func restoreUser() {
        let dg = DispatchGroup()
        self.db.readDataUser(session: self, dg: dg)
        dg.notify(queue: DispatchQueue.global(qos: .background)) {
            print("Carga de datos terminada")
        }
//        let def = UserDefaults.standard
//        let name = def.string(forKey: "name")
//        let age = def.integer(forKey: "age")
//        let sex = def.string(forKey: "sex")
//        let fecha = def.string(forKey: "fechaNacimiento")
//        let autMan = def.integer(forKey: "AutMan")
//        let isStar = def.bool(forKey: "isStar")
//        let key = def.string(forKey: "key")
//        def.synchronize()
//
//        let dg = DispatchGroup()
//
//        if name == nil || sex == nil || fecha == nil || key == nil {
//            print("Error leyendo userDefaults, probando a cargar desde la base de datos")
//            self.db.readDataUser(session: self, dg: dg)
//            dg.notify(queue: DispatchQueue.global(qos: .background)) {
//                print("Carga de datos terminada")
//            }
//
//        } else {
//            self.data = UserData(nombre: name!, sexo: sex!, edad: age, fechaNacimiento: fecha!, autMan: autMan, isStar: isStar, key: key!)
//        }
        
    }
    
    func getCart() -> [Product]{
        return self.cart
    }
    
    // Metodos GoogleLogin
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
      // ...
      if let error = error {
        print(error.localizedDescription)
        return
      }

      guard let authentication = user.authentication else { return }
      let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                        accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print("SignIn result: " + authResult!.user.email!)
            print("Heyyyy")
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
}

struct User {
    let uid: String
    let email: String?
    
    init(uid: String, email: String?){
        self.uid = uid
        self.email = email
    }
    
}
