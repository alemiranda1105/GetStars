//
//  HomeView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 22/07/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct newTabBarView: View {
    @EnvironmentObject var session: SessionStore
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var index = 1
    
    var body: some View {
        TabView(selection: self.$index) {
            HomeView().environmentObject(self.session)
                .tabItem {
                    Image(systemName: "house")
                }.tag(1)
            
            SearchView().environmentObject(self.session)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }.tag(2)
            
            CreateAutograph().environmentObject(self.session)
                .tabItem {
                    Image(systemName: "hand.draw")
                }.tag(3)
            
            BuyDrawView().environmentObject(self.session)
                .tabItem {
                    Image(systemName: "bag")
                }.tag(4)
            
            ProfileView().environmentObject(self.session)
                .tabItem {
                    Image(systemName: "person")
                }.tag(5)
            
            /*if (self.session.data?.getIsStar()) ?? false {
                StarProfileView().environmentObject(self.session)
                    .tabItem {
                        Image(systemName: "person")
                    }.tag(5)
            } else {
                ProfileView().environmentObject(self.session)
                    .tabItem {
                        Image(systemName: "person")
                    }.tag(5)
            }*/
            
        }
        .accentColor(Color("tabbarColor"))
    }
}

/*struct TabBarView: View {
    @EnvironmentObject var session: SessionStore
    
    @State var index = 0
    
    var body: some View {
        VStack {
            
            ZStack(alignment: .bottom) {
                
                if self.index == 0 {
                    HomeView().environmentObject(self.session)
                    
                } else if self.index == 1 {
                    SearchView().environmentObject(self.session)
                    
                } else if self.index == 2 {
                    BuyDrawView().environmentObject(self.session)
                    
                } else if self.index == 3 {
                    
                    if (self.session.data?.getIsStar())! {
                        StarProfileView().environmentObject(self.session)
                    } else {
                        ProfileView().environmentObject(self.session)
                    }
                    
                } else {
                    CreateAutograph().environmentObject(self.session)
                }
                
                BarraNavegacionView(index: self.$index).zIndex(200000)
            }
            
        }.onAppear(perform: {
            self.session.restoreUser()
        })
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
                Image(systemName: "house").resizable().frame(width: 28.0, height: 28)
                
            }.foregroundColor(colorScheme == .dark ? Color.white.opacity(self.index == 0 ? 1 : 0.35): Color.black.opacity(self.index == 0 ? 1 : 0.2))
            
            Spacer(minLength: 0)
            
            
            // Busqueda
            Button(action: {
                self.index = 1
            }) {
                Image(systemName: "magnifyingglass").resizable().frame(width: 28.0, height: 28.0)
                
            }.foregroundColor(colorScheme == .dark ? Color.white.opacity(self.index == 1 ? 1 : 0.35): Color.black.opacity(self.index == 1 ? 1 : 0.2))
            
            Spacer(minLength: 0)
            
            
            // Crear autografo
            Button(action: {
                self.index = 4
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            }) {
                Image(systemName: "hand.draw").resizable().frame(width: 28.0, height: 28.0)
                
            }.padding(10)
                .background(RoundedRectangle(cornerRadius: 16)
                    .fill(Color("gris")))
                .foregroundColor(Color.init("naranja").opacity(self.index == 4 ? 1 : 0.35))
            
            Spacer(minLength: 0)
            
            
            // Menu de compra
            Button(action: {
                self.index = 2
            }) {
                Image(systemName: "bag").resizable().frame(width: 28.0, height: 28.0)
                
            }.foregroundColor(colorScheme == .dark ? Color.white.opacity(self.index == 2 ? 1 : 0.35): Color.black.opacity(self.index == 2 ? 1 : 0.2))
            
            Spacer(minLength: 0)
            
            
            // Perfil
            Button(action: {
                self.index = 3
            }) {
                Image(systemName: "person").resizable().frame(width: 28.0, height: 28.0)
                
            }.foregroundColor(colorScheme == .dark ? Color.white.opacity(self.index == 3 ? 1 : 0.35): Color.black.opacity(self.index == 3 ? 1 : 0.2))
        }
        .frame(minWidth: 0, maxWidth: UIScreen.main.bounds.width-10)
        .padding(8)
        .overlay(
            RoundedRectangle(cornerRadius: 50)
                .stroke(colorScheme == .dark ? Color.white: Color.black, lineWidth: 1))
        .background(colorScheme == .dark ? Color.black: Color.white)
        .border(Color.clear)
        .cornerRadius(50)
        .padding()
//        .padding(.horizontal, 16)
//        .background(colorScheme == .dark ? Color.black: Color.white)
    }
}*/

#if DEBUG
struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        newTabBarView().environmentObject(SessionStore())
    }
}
#endif
