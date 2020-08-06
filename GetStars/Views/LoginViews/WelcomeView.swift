//
//  WelcomeView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 29/06/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import LocalAuthentication

import FirebaseAuth
import GoogleSignIn

struct WelcomeView: View {
    @EnvironmentObject var session: SessionStore
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Text("Bienvenido a GetStars").font(.system(size: 32, weight: .heavy))
                    
                    Text("El lugar donde se juntan las estrellas").font(.system(size: 18, weight: .medium)).foregroundColor(.gray)
                    
                    Spacer()
                
                    VStack(spacing: 18){
                        NavigationLink(destination: SignInView().environmentObject(session)){
                            Text("Inicia sesión")
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding()
                                .background(LinearGradient(gradient: Gradient(colors: [.red, .blue]), startPoint: .leading, endPoint: .trailing))
                                .foregroundColor(.white)
                                .cornerRadius(50)
                                .font(.system(size: 18, weight: .bold))
                        }
                        
                        NavigationLink(destination: SignUpView().environmentObject(session)){
                            Text("Registro")
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding()
                                .background(LinearGradient(gradient: Gradient(colors: [.blue, .gray]), startPoint: .leading, endPoint: .trailing))
                                .foregroundColor(.white)
                                .cornerRadius(50)
                                .font(.system(size: 18, weight: .bold))
                        }
                        
                        HStack(spacing: 16){
                            NavigationLink(destination: LoginMethodsView()){
                                Text("Otros métodos...")
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .padding()
                                    .background(Color.init("naranja").opacity(0.8))
                                    .foregroundColor(.white)
                                    .cornerRadius(50)
                                    .font(.system(size: 18, weight: .bold))
                            }
                            
                        }.padding(8)
            
                    }.padding(.vertical, 32).padding(.horizontal, 8)
                    
                }.padding(.vertical, 64)
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct LoginMethodsView: View {
    var body: some View {
        VStack {
            Text("Si es la primera vez que entras en la app, recomendamos registrarse de manera manual para una mejor experiencia")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
            
            Spacer()
            
            GoogleLoginView()
                .frame(width: 312, height: 48, alignment: .center)
            
            Spacer()
            
        }.padding(8)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView().environmentObject(SessionStore())
    }
}
