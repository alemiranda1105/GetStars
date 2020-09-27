//
//  SignInView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 07/07/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn

struct SignInView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var session: SessionStore
    @State var email: String = ""
    @State var password: String = ""
    @State var error: String = ""
    
    private func signIn() {
        session.signIn(email: email, password: password) { (result, error) in
            if let error = error {
                self.error = error.localizedDescription
            } else {
                self.email = ""
                self.password = ""
            }
        }
    }
    
    private func restorePassword() {
        Auth.auth().sendPasswordReset(withEmail: self.email) { error in
            self.error = error?.localizedDescription ?? "Error al recuperar su contraseña"
            print(error?.localizedDescription ?? "")
        }
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 18) {
                VStack(alignment: .leading) {
                    Text("Email")
                        .font(.callout)
                        .bold()
                    
                    TextField("Email", text: $email)
                    .font(.system(size: 14))
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .strokeBorder(colorScheme == .dark ? Color("naranja"): Color("navyBlue"), lineWidth: 1))
                    .keyboardType(.emailAddress).autocapitalization(.none)
                }
                
                VStack(alignment: .leading) {
                    Text("Contraseña")
                        .font(.callout)
                        .bold()
                    
                    SecureField("Contraseña", text: $password)
                        .font(.system(size: 14))
                        .padding(10)
                        .autocapitalization(.none)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .strokeBorder(colorScheme == .dark ? Color("naranja"): Color("navyBlue"), lineWidth: 1))
                    
                    Button(action: {
                        self.restorePassword()
                    }) {
                        Text("Recuperar contraseña")
                            .foregroundColor(colorScheme == .dark ? Color("naranja"): Color("navyBlue"))
                    }
                }
                
            }.padding(.vertical, 64)
            
            if (error != ""){
                Text(error)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
            
            Button(action: signIn){
                Text("Iniciar Sesión")
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .background(Color("navyBlue"))
                .foregroundColor(.white)
                .cornerRadius(50)
                .font(.system(size: 18, weight: .bold))
            }.padding(.bottom, 16)
        }
        .padding(.horizontal, 8)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .navigationBarTitle(Text("Bienvenido de nuevo"))
        .onAppear(perform: { self.session.signing = true })
    }
}

#if DEBUG
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignInView().environmentObject(SessionStore()).environment(\.colorScheme, .dark)
            
            SignInView().environmentObject(SessionStore()).environment(\.colorScheme, .light)
        }
    }
}
#endif
