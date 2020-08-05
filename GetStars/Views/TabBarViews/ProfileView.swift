//
//  ProfileView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 27/07/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var session: SessionStore
    
    @State var visible: Bool = true
    
    let names = ["Alejandro", "Pepe", "Paola",  "777", "9992", "kitty", "mario", "Alejandro", "Pepe", "Paola",  "777", "9992", "kitty", "mario","Alejandro", "Pepe", "Paola",  "777", "9992", "kitty", "mario"]
    
    private var imagesize = [180, 180]
    
    var body: some View {
        NavigationView {
            VStack {
                if self.visible {
                    Circle()
                        .fill(Color.init("navyBlue"))
                        .frame(width: 120, height: 120)
                        .padding()
                    
                    HStack {
                        Button(action: {
                            let impactMed = UIImpactFeedbackGenerator(style: .light)
                            impactMed.impactOccurred()
                            self.visible = false
                        }) {
                            Image(systemName: "arrow.up").resizable().frame(width: 28.0, height: 28.0)
                        }.foregroundColor(Color.black).padding()
                        
                        Spacer()
                        
                        NavigationLink(destination: ConfigurationView().environmentObject(self.session)) {
                            Image(systemName: "gear").resizable().frame(width: 28.0, height: 28.0)
                            }.foregroundColor(Color.black).padding()
                    }
                        
                    Spacer()
                    
                } else {
                    Button(action: {
                        let impactMed = UIImpactFeedbackGenerator(style: .light)
                        impactMed.impactOccurred()
                        self.visible = true
                    }) {
                        Image(systemName: "arrow.down").resizable().frame(width: 28.0, height: 28.0)
                    }.foregroundColor(Color.black).padding()
                    
                    Spacer()
                    
                }
                
                GridStack(minCellWidth: 125, spacing: 15, numItems: self.names.count) {index,cellWidth in
                    Button(action: {
                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                        impactMed.impactOccurred()
                    }){
                        Text("\(self.names[index])")
                        .frame(width: cellWidth, height: cellWidth)
                        .background(RoundedRectangle(cornerRadius: 16).fill(Color.blue))
                            .foregroundColor(Color.white)
                    }
                }
            }.navigationBarTitle("\((self.session.data?.getName()) ?? "Dev")")
        }.navigationViewStyle(StackNavigationViewStyle())
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject(SessionStore())
    }
}
