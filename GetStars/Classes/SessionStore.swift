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

class SessionStore: ObservableObject {
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
            self.data = nil
            self.session = nil
            removeFile()
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
        let recData = readFile()
        self.data = DataUser(data: recData)
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
