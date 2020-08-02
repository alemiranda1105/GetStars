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
    @Published var data: DataUser?
    @Published var db: DataBase = DataBase()
    
    //Inidica si el usuario esta iniciando sesion
    @Published var signing: Bool = false
    
    
    func listen(){
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let user = user {
                self.session = User(uid: user.uid, email: user.email)
            } else {
                self.session = nil
            }
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
            self.data = nil
            self.session = nil
        } catch {
            print("ERROR SIGNING OUT")
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
        let def = UserDefaults.standard
        let name = def.string(forKey: "name")
        let lastName = def.string(forKey: "lastName")
        let age = def.integer(forKey: "age")
        let sex = def.string(forKey: "sex")
        let fecha = def.string(forKey: "fechaNacimiento")
        def.synchronize()
        self.data = DataUser(nombre: name!, apellidos: lastName!, sexo: sex!, edad: age, fechaNacimiento: fecha!)
    }
    
    // Metodos Google
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
      // ...
        Auth.auth().signIn(with: credential) { (res, err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            print("Sesion iniciada")
            let user = GIDSignIn.sharedInstance()!.currentUser
            self.data = DataUser(nombre: (user?.profile.givenName)!, apellidos: (user?.profile.familyName)!, sexo: "google", edad: 20, fechaNacimiento: "99/99/9999")
            
            self.session = User(uid: (user?.userID)!, email: user?.profile.email)
            self.signing = true
            self.db.createUserDB(session: self)
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        self.signOut()
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
