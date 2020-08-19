//
//  ConfigurationView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 05/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct ConfigurationView: View {
    @EnvironmentObject var session: SessionStore
    @Environment(\.colorScheme) var colorScheme
    
    @State var showAlert: Bool = false
    @State var showAlert2: Bool = false
    @State var eliminarDatos: Bool = false
    
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        Form {
            if !eliminarDatos {
                Section {
                    NavigationLink(destination: SyncWithView())  {
                        Text("Sincronizar cuenta con...")
                    }
                }
                Section(header: Text("Datos personales")) {
                    Text("Editar datos personales")
                    Text("Cambiar suscripción")
                }
                Section(header: Text("Información")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("0.1")
                    }
                }
                Section {
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            self.showAlert = true
                        }) {
                            Text("Cerrar sesión").foregroundColor(Color("naranja"))
                        }.alert(isPresented: $showAlert) {
                            Alert(title: Text("Aviso"), message: Text("¿Seguro que desea cerrar sesión?"), primaryButton: .destructive(Text("Cerrar sesión")){
                                    self.session.signOut()
                                }, secondaryButton: .cancel(Text("Cancelar")))
                        }
                        
                        Spacer()
                    }
                }
                
                Section {
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            self.showAlert2 = true
                        }) {
                            Text("Eliminar cuenta").foregroundColor(.red).fontWeight(.bold)
                        }.alert(isPresented: $showAlert2) {
                            Alert(title: Text("Aviso"), message: Text("Está a punto de eliminar su cuenta, ¿Desea continuar?"), primaryButton: .destructive(Text("Eliminar")){
                                    self.eliminarDatos = true
                                }, secondaryButton: .cancel(Text("Cancelar")))
                        }
                        
                        Spacer()
                    }
                }
            } else {
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
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                          .strokeBorder(colorScheme == .dark ? Color("naranja"): Color("navyBlue"), lineWidth: 1))
                }
                
                Button(action: {
                    let dg = DispatchGroup()
                    self.session.reAuth(email: self.email, pass: self.password, dg: dg)
                    
                    dg.notify(queue: DispatchQueue.global(qos: .background)) {
                        self.session.deleteAccount()
                    }
                    self.email = ""
                    self.password = ""
                }){
                    Text("Borrar cuenta")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(Color("naranja"))
                    .foregroundColor(.white)
                    .cornerRadius(50)
                    .font(.system(size: 18, weight: .bold))
                }.padding(.bottom, 16)
            }
            
        }.navigationBarTitle("Ajustes")
    }
}

struct ConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurationView().environmentObject(SessionStore())
    }
}
