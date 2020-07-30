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
    
    let names = ["Alejandro", "Pepe", "Paola",  "777", "9992", "kitty", "mario", "Alejandro", "Pepe", "Paola",  "777", "9992", "kitty", "mario","Alejandro", "Pepe", "Paola",  "777", "9992", "kitty", "mario"]
    
    private var imagesize = [180, 180]
    
    var body: some View {
        VStack {
            Circle()
                .fill(Color.init("navyBlue"))
                .frame(width: 180, height: 180)
            Text("Bienvenido \((session.data?.getName()) ?? "Dev")")
                .font(.system(size: 24, weight: .heavy))
            
            Button(action: {
                self.session.signOut()
            }) {
                Text("Cerrar sesion")
            }
                
            Spacer()
            
            GridStack(minCellWidth: 125, spacing: 20, numItems: self.names.count) {index,cellWidth in
                Button(action: {
                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                    impactMed.impactOccurred()
                }){
                    Text("\(self.names[index])")
                    .frame(width: cellWidth, height: cellWidth)
                    .background(RoundedRectangle(cornerRadius: 14).fill(Color.blue))
                        .foregroundColor(Color.white)
                }

            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject(SessionStore())
    }
}
