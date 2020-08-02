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
        // User Defaults
        let def = UserDefaults.standard
        let name = def.string(forKey: "name")
        let lastName = def.string(forKey: "lastName")
        let age = def.integer(forKey: "age")
        let sex = def.string(forKey: "sex")
        let fecha = def.string(forKey: "fechaNacimiento")
        def.synchronize()
        self.session.data = DataUser(nombre: name!, apellidos: lastName!, sexo: sex!, edad: age, fechaNacimiento: fecha!)
        
        //let recData = readFile()
        //self.session.data = DataUser(data: recData)
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
                    CreateAutograph()
                    
                }
            }
            
            Spacer()
            
            BarraNavegacionView(index: self.$index)
            
        }.onAppear(perform: self.getData)
    }
}

struct BarraNavegacionView: View {
    @Binding var index: Int
    
    var body: some View {
        
        HStack {
            
            // Inicio
            Button(action: {
                self.index = 0
            }) {
                Image(systemName: "house").resizable().frame(width: 32.0, height: 32.0)
                
            }.foregroundColor(Color.black.opacity(self.index == 0 ? 1 : 0.2))
            
            Spacer(minLength: 0)
            
            
            // Busqueda
            Button(action: {
                self.index = 1
            }) {
                Image(systemName: "magnifyingglass").resizable().frame(width: 32.0, height: 32.0)
                
            }.foregroundColor(Color.black.opacity(self.index == 1 ? 1 : 0.2))
            
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
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 10, y: 10)
                .shadow(color: Color.white.opacity(0.7), radius: 5, x: -5, y: -5))
                .foregroundColor(Color.init("naranja").opacity(self.index == 4 ? 1 : 0.2))
            
            Spacer(minLength: 0)
            
            
            // Menu de compra
            Button(action: {
                self.index = 2
            }) {
                Image(systemName: "cart").resizable().frame(width: 32.0, height: 32.0)
                
            }.foregroundColor(Color.black.opacity(self.index == 2 ? 1 : 0.2))
            
            Spacer(minLength: 0)
            
            
            // Perfil
            Button(action: {
                self.index = 3
            }) {
                Image(systemName: "person").resizable().frame(width: 32.0, height: 32.0)
                
            }.foregroundColor(Color.black.opacity(self.index == 3 ? 1 : 0.2))
        }
        .padding(.horizontal, 16)
        .background(Color.white)
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView().environmentObject(SessionStore())
    }
}

extension Color {
    static let neuBackground = Color(hex: "f0f0f3")
    static let dropShadow = Color(hex: "aeaec0").opacity(0.4)
    static let dropLight = Color(hex: "ffffff")
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        // scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff

        self.init(red: Double(r) / 0xff, green: Double(g) / 0xff, blue: Double(b) / 0xff)
    }
}
