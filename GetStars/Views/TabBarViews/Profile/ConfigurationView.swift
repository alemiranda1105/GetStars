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
                        self.session.signOut()
                    }) {
                        Text("Cerrar sesión").foregroundColor(.red)
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
