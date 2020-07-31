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
    
    @State private var completed: Bool = false
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    private func signIn() {
        session.signIn(email: email, password: password) { (result, error) in
            if let error = error {
                self.error = error.localizedDescription
            } else {
                self.email = ""
                self.password = ""
                self.completed = true
                
                // Indica que se está iniciando sesion
                // self.session.signing = true

            }
        }
    }
    
    private func signInGoogle() {
        
    }
    
    var body: some View {
        VStack {
            
            if !completed {
                Text("Bienvenido de nuevo")
                    .font(.system(size: 32, weight: .heavy))
                
                Text("Inicia sesión para continuar")
                    .font(.system(size: 18, weight: .medium)).foregroundColor(.gray)
                
                VStack(spacing: 18) {
                    TextField("Email", text: $email)
                        .font(.system(size: 14)).padding(12).background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color.black, lineWidth: 1)).keyboardType(.emailAddress)
                    
                    SecureField("Contraseña", text: $password)
                    .font(.system(size: 14)).padding(12).background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color.black, lineWidth: 1))
                    
                }.padding(.vertical, 64)
                
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
                    // google().frame(width: 120, height: 120)
                    Button(action: google.attemptLoginGoogle){
                        Text("Google")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [.gray, .gray]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(50)
                        .font(.system(size: 18, weight: .bold))
                    }
                    
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
                
                
                if (error != ""){
                    Text(error)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.red)
                        .padding()
                }
                
            } else {
                Text("Sesión iniciada con éxito")
                    .font(.system(size: 32, weight: .heavy))
                
                Text("Bienvenido de nuevo a GetStars")
                    .font(.system(size: 18, weight: .medium)).foregroundColor(.gray)
                
                Spacer()
                
                Button(action: { self.mode.wrappedValue.dismiss() }){
                    Text("Continuar")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [.blue, .gray]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(50)
                        .font(.system(size: 18, weight: .bold))
                }.padding(.vertical, 16)
            }

        }.padding(.horizontal, 8).frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            .onAppear(perform: { self.session.signing = true })
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView().environmentObject(SessionStore())
    }
}


struct google: UIViewRepresentable {
    
    /*func makeUIView(context: UIViewRepresentableContext<google>) -> GIDSignInButton {
        
        let button = GIDSignInButton()
        button.colorScheme = .light
        button.style = .wide
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
        return button
    }
    
    func updateUIView(_ uiView: GIDSignInButton, context: UIViewRepresentableContext<google>) {
        
    }*/
    func makeUIView(context: UIViewRepresentableContext<google>) -> UIView {
        return UIView()
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<google>) {
    }

    static func attemptLoginGoogle(){
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
        GIDSignIn.sharedInstance()?.signIn()
    }
    
}
