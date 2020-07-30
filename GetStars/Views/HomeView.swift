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
        let recData = readFile()
        self.session.data = DataUser(data: recData)
    }
    
    var body: some View {
        VStack {
            
            ZStack {
                
                if self.index == 0 {
                    VStack {
                        Button(action: { }){
                            Text("¡PÁSATE AL PRO").font(.system(size: 18, weight: .bold))
                            
                        }.frame(minWidth: 0, maxWidth: .infinity)
                            .padding(14)
                            .background(RoundedRectangle(cornerRadius: 16)
                            .fill(Color.init("gris"))
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5))
                            .foregroundColor(Color.black)
                        Spacer()
                        
                    }.padding(.top, 20).padding(.horizontal, 32)//.border(Color.black.opacity(0.75), width: 0.25)
                    
                } else if self.index == 1 {
                    VStack {
                        Text("Búsqueda")
                    }
                } else if self.index == 2 {
                    VStack {
                        Text("Compra y sorteos")
                    }
                } else if self.index == 3 {
                    VStack {
                        Text("Perfil")
                        Text("Hola \((self.session.data?.getName()) ?? "Error")")
                        
                        Button(action: { self.session.signOut() } ){
                            Text("Cierra sesión")
                        }
                    }
                } else {
                    VStack {
                        CreateAutograph()
                    }
                }
                
            }.padding(.bottom, -8)
            
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
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5))
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
        .padding(.horizontal, 16).padding(.vertical, 8)
        .background(Color.white)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView().environmentObject(SessionStore())
    }
}
