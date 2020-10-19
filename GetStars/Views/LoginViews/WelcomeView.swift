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
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Text("Welcome to GetStars").font(.system(size: 32, weight: .heavy))
                    
                    Text("The place where stars join").font(.system(size: 18, weight: .medium)).foregroundColor(.gray)
                    
                    Spacer(minLength: 150)
                
                    VStack(spacing: 18){
                        NavigationLink(destination: SignInView().environmentObject(self.session)){
                            Text("Sign In")
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding()
                                .background(Color("navyBlue"))
                                .foregroundColor(.white)
                                .cornerRadius(50)
                                .font(.system(size: 18, weight: .bold))
                        }
                        
                        NavigationLink(destination: SignUpView().environmentObject(self.session)){
                            Text("Sign Up")
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color("naranja"), lineWidth: 4))
                                .background(colorScheme == .dark ? Color("navyBlue").opacity(0.8) : Color.white)
                                .foregroundColor(Color("naranja"))
                                .border(Color("naranja"))
                                .cornerRadius(50)
                                .font(.system(size: 18, weight: .bold))
                        }
                        
                        Spacer(minLength: 40)
                        
                        /*HStack(spacing: 16){
                            NavigationLink(destination: LoginMethodsView().environmentObject(self.session)){
                                Text("Other ways...")
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .padding()
                                    .background(Color.init("naranja").opacity(colorScheme == .dark ? 1 : 0.8))
                                    .foregroundColor(.white)
                                    .cornerRadius(50)
                                    .font(.system(size: 18, weight: .bold))
                            }
                            
                        }.padding(8)*/
            
                    }.padding(.vertical, 8).padding(.horizontal, 8)
                    
                }.padding(.vertical, 64).padding(.bottom, -70)
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct LoginMethodsView: View {
    @EnvironmentObject var session: SessionStore
    var body: some View {
        VStack {
            Text("If this is the first time using the app, we recommend to sign up using email/password for a better experience")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
            
            NavigationLink(destination: TermsView()) {
                Text("Press here to read the terms and our privacy policy, please")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            }.buttonStyle(PlainButtonStyle())
            .padding()
            
            Spacer()
            
            GoogleLoginView().environmentObject(self.session)
                .frame(width: 312, height: 48, alignment: .center)
            
            Spacer()
            
        }.padding(8)
    }
}

#if DEBUG
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WelcomeView().environmentObject(SessionStore()).environment(\.colorScheme, .dark)
            
            WelcomeView().environmentObject(SessionStore()).environment(\.colorScheme, .light)
        }
    }
}
#endif
