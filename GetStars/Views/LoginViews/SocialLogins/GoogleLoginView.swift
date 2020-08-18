//
//  GoogleLoginView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 06/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import GoogleSignIn
import Firebase
import FirebaseAuth


struct GoogleLoginView: UIViewRepresentable {
    @EnvironmentObject var session: SessionStore
    
    func makeCoordinator() -> GoogleLoginView.Coordinator {
        return GoogleLoginView.Coordinator()
    }
    
    class Coordinator: NSObject, GIDSignInDelegate {
        private var data: [String]?
        
        func getData() -> [String] {
            return self.data!
        }
        
        func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
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
            } else {
                print("signIn result: " + authResult!.user.email!)
                print("Hola")
                let email: String = (authResult?.user.email)!
                let name: String = (authResult?.user.displayName)!
                let def = UserDefaults.standard
                def.set(name, forKey: "name")
                def.set(email, forKey: "email")
                def.set("Google", forKey: "sex")
                def.set(100, forKey: "age")
                def.set("Google", forKey: "fechaNacimiento")
                def.set(true, forKey: "sign")
                def.synchronize()
                let db = DataBase()
                let dbData = ["nombre": name, "edad": 100, "fechaNacimiento": "Google", "sexo": "Google", "AutMan": 0] as [String : Any]
                
                db.createUserDB(dbData: dbData, email: email)
            }
          }
        }
    }
    
    func makeUIView(context: UIViewRepresentableContext<GoogleLoginView>) -> GIDSignInButton {
        let button = GIDSignInButton()
        button.style = .wide
        GIDSignIn.sharedInstance().delegate = context.coordinator
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.first?.rootViewController
        return button
    }
    
    func updateUIView(_ uiView: GIDSignInButton, context: UIViewRepresentableContext<GoogleLoginView>) { }
    
}
