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
            
        }
        .accentColor(Color("tabbarColor"))
    }
}

#if DEBUG
struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        newTabBarView().environmentObject(SessionStore())
    }
}
#endif
