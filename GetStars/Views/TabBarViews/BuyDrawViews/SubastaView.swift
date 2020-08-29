//
//  SubastaView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 17/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct SubastaView: View {
    @State var subastas: [Product] = [
        Product(price: 100.0, name: "Casco", description: "Este casco fue usado durante mi participación en una importante carrerar en Francia", image: "pr2", owner: Person(name: "Piloto 1", description: "Piloto de competicón", image: "d5", key: ""), isDedicated: false),
        Product(price: 25.99, name: "Botas", description: "El precio de venta de estas botas será integramente donado a una ONG", image: "pr1", owner: Person(name: "Futbolista 1", description: "Jugadora en equipo de primera división", image: "n5", key: ""), isDedicated: false)]
    
    var body: some View {
        GeometryReader { g in
            Group {
                ScrollView {
                    ForEach(0..<self.subastas.count) { p in
                        SubastaCardView(product: self.$subastas[p])
                            .frame(width: g.size.width)
                    }
                }.navigationBarTitle("Subastas")
            }
        }
    }
}

struct SubastaView_Previews: PreviewProvider {
    static var previews: some View {
        SubastaView()
    }
}
