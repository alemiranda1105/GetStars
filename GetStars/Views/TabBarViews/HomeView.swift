//
//  HomeView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 27/07/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @State var data: [Product] = [
        Product(name: "Persona 1", description: "Futbolista", subtitle: "", image: "p1"),
        Product(name: "Persona 2", description: "Motorista", subtitle: "", image: "p2")]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Button(action: { }){
                        Text("¡PÁSATE AL PRO!")
                            .font(.system(size: 25, weight: .bold))
                        
                    }.frame(minWidth: 0, maxWidth: .infinity)
                        .padding(48)
                        .background(RoundedRectangle(cornerRadius: 16)
                        .fill(Color.init("gris")))
                        .foregroundColor(Color.black)
                    
                    ForEach(0..<self.data.count, id: \.self) { item in
                        ProductCard(item: self.$data[item])
                    }
                    
                }.padding(.top, 20).padding(.horizontal, 32)
            }.navigationBarTitle("Inicio")
        }
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView().previewDevice(PreviewDevice(rawValue: "iPhone 8"))
            HomeView().previewDevice(PreviewDevice(rawValue: "iPhone 11"))
        }
    }
}
#endif
