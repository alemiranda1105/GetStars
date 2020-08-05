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
    @State var showAlert: Bool = false
    
    var body: some View {
        Form {
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
                        Text("Cerrar sesión").foregroundColor(.red)
                    }.alert(isPresented: $showAlert) {
                        Alert(title: Text("Aviso"), message: Text("¿Seguro que desea cerrar sesión?"), primaryButton: .destructive(Text("Cerrar sesión")){
                                self.session.signOut()
                            }, secondaryButton: .cancel(Text("Cancelar")))
                    }
                    
                    Spacer()
                }
            }
        }.navigationBarTitle("Ajustes")
    }
}

struct ConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurationView().environmentObject(SessionStore())
    }
}
