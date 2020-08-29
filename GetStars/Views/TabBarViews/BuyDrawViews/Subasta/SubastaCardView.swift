//
//  SubastaCardView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 17/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct SubastaCardView: View {
    @Binding var product: Product
    
    var body: some View {
        VStack {
            NavigationLink(destination: SubastaProductView(product: self.$product)){
                ZStack {
                    
                    Image(self.product.image).resizable().scaledToFill()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(width: 350, height: 350)
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.clear, lineWidth: 1))
                    
                    VStack {
                        HStack(alignment: .lastTextBaseline) {
                            Text("\(self.product.name)")
                                .foregroundColor(Color.white)
                                .cornerRadius(16)
                                .font(.system(size: 32, weight: .bold))
                            Text("\(self.product.price.dollarString) €")
                                .foregroundColor(.white)
                                .font(.system(size: 24, weight: .bold))
                        }.shadow(color: Color.black.opacity(0.9), radius: 5, x: 2, y: 0)
                            .padding(.top, 280)
                    }
                }
                
            }.shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                .buttonStyle(PlainButtonStyle())
            
            Spacer(minLength: 16)
        }
    }
}

struct SubastaCardView_Previews: PreviewProvider {
    static var previews: some View {
        SubastaCardView(product: .constant(Product(price: 99.99, name: "Test", description: "Esto es una descripción de prueba para la carta", image: "pr2", owner: Person(name: "Persona 1", description: "Esto es una descripción para el dueño del producto", image: "p1", key: ""), isDedicated: false)))
    }
}
