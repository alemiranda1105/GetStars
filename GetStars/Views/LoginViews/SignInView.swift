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
    
    private func signInGoogle() {
        
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 18) {
                TextField("Email", text: $email)
                    .font(.system(size: 14))
                    .padding(4)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress).autocapitalization(.none)
                
                SecureField("Contraseña", text: $password)
                    .font(.system(size: 14))
                    .padding(4)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
            }.padding(.vertical, 64)
            
            if (error != ""){
                Text(error)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.red)
                    .padding()
            }
            
            Button(action: signIn){
                Text("Iniciar Sesión")
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [.blue, .blue]), startPoint: .leading, endPoint: .trailing))
                .foregroundColor(.white)
                .cornerRadius(50)
                .font(.system(size: 18, weight: .bold))
            }
            
            Spacer()
            
            HStack(spacing: 16){
                GoogleLoginView()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [.gray, .gray]), startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .cornerRadius(50)
                    .font(.system(size: 18, weight: .bold))
                
                
                Button(action: signInGoogle){
                    Text("Facebook")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [.gray, .gray]), startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .cornerRadius(50)
                    .font(.system(size: 18, weight: .bold))
                }
                
                Button(action: signInGoogle){
                    Text("Apple")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [.black, .black]), startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .cornerRadius(50)
                    .font(.system(size: 18, weight: .bold))
                }
            }.padding(8)

        }
        .padding(.horizontal, 8)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .navigationBarTitle("Bienvenido de nuevo")
        .onAppear(perform: { self.session.signing = true })
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView().environmentObject(SessionStore())
    }
}
