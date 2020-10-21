//
//  SubastaCardView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 17/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase

struct SubastaCardView: View {
    @EnvironmentObject var session: SessionStore
    @Binding var product: Product
    
    private func readPrice() {
        let db = Firestore.firestore()
        db.collection("subastas").document("prueba").getDocument { document, error in
            if error != nil {
                print("Error leyendo el precio")
                print(error?.localizedDescription ?? "")
            } else {
                self.product.setPrice(newPrice: document?.data()!["precio"] as! Double)
            }
        }
    }
    
    var body: some View {
        VStack {
            NavigationLink(destination: SubastaProductView(product: self.$product).environmentObject(self.session)){
                ZStack {
                    
                    WebImage(url: URL(string: self.product.image)).resizable()
                    .placeholder(Image(systemName: "photo"))
                    .placeholder {
                        Rectangle().foregroundColor(.gray)
                    }
                    .indicator(.activity)
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(width: 350, height: 350)
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.clear, lineWidth: 1))
                    
                    VStack {
                        VStack(alignment: .center) {
                            Text("\(self.product.name)")
                                .foregroundColor(Color.white)
                                .cornerRadius(16)
                                .font(.system(size: 32, weight: .bold))
                                .lineLimit(1)
                                .frame(width: 350)
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
        }.onAppear(perform: self.readPrice)
    }
}

#if DEBUG
struct SubastaCardView_Previews: PreviewProvider {
    static var previews: some View {
        SubastaCardView(product: .constant(Product(price: 99.99, name: "Casco", description: "Esto es una descripción de prueba para la carta", image: "pr2", owner: Person(name: "Persona 1", description: "Esto es una descripción para el dueño del producto", image: "p1", key: ""), isDedicated: false)))
    }
}
#endif
