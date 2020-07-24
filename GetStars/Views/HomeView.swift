//
//  HomeView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 22/07/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var session: SessionStore
    
    private func getData() {
        let recData = readFile()
        self.session.data = DataUser(data: recData)
    }
    
    var body: some View {
        VStack {
            Text("Hola \((self.session.data?.getName()) ?? "Error")")
            
            Button(action: { self.session.signOut() } ){
                Text("Cierra sesión")
            }
        }.onAppear(perform: self.getData)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
