//
//  ProductView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 15/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct ProductView: View {
    @Binding var product: Product
    var body: some View {
        VStack {
            Image(self.product.image)
                .resizable()
                .frame(width: 450, height: 400)
                .edgesIgnoringSafeArea(.top)
                .edgesIgnoringSafeArea(.horizontal)
            
            Text(self.product.name)
                .foregroundColor(Color.black)
                .font(.system(size: 32, weight: .heavy))
                .padding(.bottom, 120)
            
            ScrollView {
                HStack {
                    Button(action: {}){
                        Text("Producto 1")
                    }
                    Button(action: {}){
                        Text("Producto 2")
                    }
                    Button(action: {}){
                        Text("Producto 3")
                    }
                }
            }
        }
    }
}

struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProductView(product: .constant(Product(name: "Antoñito Perez lopez", description: "prueba de texto largo para ver como encajaría la descripción de un famoso", subtitle: "", image: "p1"))).previewDevice(PreviewDevice(rawValue: "iPhone 8"))
            
            ProductView(product: .constant(Product(name: "Antoñito Perez lopez", description: "prueba de texto largo para ver como encajaría la descripción de un famoso", subtitle: "", image: "p1"))).previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
            
            ProductView(product: .constant(Product(name: "Antoñito Perez lopez", description: "prueba de texto largo para ver como encajaría la descripción de un famoso", subtitle: "", image: "p1"))).previewDevice(PreviewDevice(rawValue: "iPad (7th generation)"))
        }
    }
}
