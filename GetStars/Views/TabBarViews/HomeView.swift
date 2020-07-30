//
//  HomeView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 27/07/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Button(action: { }){
                Text("¡PÁSATE AL PRO!")
                    .font(.system(size: 28, weight: .bold))
                    .padding(32)
                    .multilineTextAlignment(.center)
                
            }.frame(minWidth: 0, maxWidth: .infinity)
                .padding(14)
                .background(RoundedRectangle(cornerRadius: 16)
                .fill(Color.init("gris")))
                .foregroundColor(Color.black)
            Spacer()
            
        }.padding(.top, 20).padding(.horizontal, 32)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
