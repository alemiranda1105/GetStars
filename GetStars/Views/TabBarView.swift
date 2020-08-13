//
//  HomeView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 22/07/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct TabBarView: View {
    @EnvironmentObject var session: SessionStore
    
    @State var index = 0
    
    private func getData() {
        let def = UserDefaults.standard
        let name = def.string(forKey: "name")
        let age = def.integer(forKey: "age")
        let sex = def.string(forKey: "sex")
        let fecha = def.string(forKey: "fechaNacimiento")
        
        let autMan = def.integer(forKey: "AutMan")
        
        def.synchronize()
        self.session.articles["AutMan"] = autMan
        self.session.data = UserData(nombre: name!, sexo: sex!, edad: age, fechaNacimiento: fecha!, autMan: autMan)
    }
    
    var body: some View {
        VStack {
            
            ZStack {
                
                if self.index == 0 {
                    HomeView()
                    
                } else if self.index == 1 {
                    SearchView()
                    
                } else if self.index == 2 {
                    BuyDrawView()
                    
                } else if self.index == 3 {
                    ProfileView().environmentObject(self.session)
                    
                } else {
                    CreateAutograph().environmentObject(self.session)
                    
                }
            }
            
            Spacer()
            
            BarraNavegacionView(index: self.$index)
            
        }.onAppear(perform: self.getData)
    }
}

struct BarraNavegacionView: View {
    @Binding var index: Int
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        HStack {
            
            // Inicio
            Button(action: {
                self.index = 0
            }) {
                Image(systemName: "house").resizable().frame(width: 32.0, height: 32.0)
                
            }.foregroundColor(colorScheme == .dark ? Color.white.opacity(self.index == 0 ? 1 : 0.35): Color.black.opacity(self.index == 0 ? 1 : 0.2))
            
            Spacer(minLength: 0)
            
            
            // Busqueda
            Button(action: {
                self.index = 1
            }) {
                Image(systemName: "magnifyingglass").resizable().frame(width: 32.0, height: 32.0)
                
            }.foregroundColor(colorScheme == .dark ? Color.white.opacity(self.index == 1 ? 1 : 0.35): Color.black.opacity(self.index == 1 ? 1 : 0.2))
            
            Spacer(minLength: 0)
            
            
            // Crear autografo
            Button(action: {
                self.index = 4
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            }) {
                Image(systemName: "hand.draw").resizable().frame(width: 32.0, height: 32.0)
                
            }.padding(14)
                .background(RoundedRectangle(cornerRadius: 16)
                    .fill(colorScheme == .dark ? Color.init(hex: "383838"): Color("gris")))
                .foregroundColor(Color.init("naranja").opacity(self.index == 4 ? 1 : 0.35))
            
            Spacer(minLength: 0)
            
            
            // Menu de compra
            Button(action: {
                self.index = 2
            }) {
                Image(systemName: "cart").resizable().frame(width: 32.0, height: 32.0)
                
            }.foregroundColor(colorScheme == .dark ? Color.white.opacity(self.index == 2 ? 1 : 0.35): Color.black.opacity(self.index == 2 ? 1 : 0.2))
            
            Spacer(minLength: 0)
            
            
            // Perfil
            Button(action: {
                self.index = 3
            }) {
                Image(systemName: "person").resizable().frame(width: 32.0, height: 32.0)
                
            }.foregroundColor(colorScheme == .dark ? Color.white.opacity(self.index == 3 ? 1 : 0.35): Color.black.opacity(self.index == 3 ? 1 : 0.2))
        }
        .padding(.horizontal, 16)
        .background(colorScheme == .dark ? Color.black: Color.white)
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView().environmentObject(SessionStore())
    }
}
