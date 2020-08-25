//
//  FamousItems.swift
//  GetStars
//
//  Created by Alejandro Miranda on 24/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI


struct FamousItems: View {
    @Binding var item: String
    @Binding var person: Person
    
    @State var product: Product = Product()
    @State var url = URL(string: "https://google.com/")!
    
    private func getAutografo() {
        let st = StarsST()
        let dg = DispatchGroup()
        st.getAut(key: self.person.getKey(), dg: dg)
        dg.notify(queue: DispatchQueue.global(qos: .userInitiated)) {
            let url = st.getAutUrl()
            self.url = url
            self.product = Product(price: 2.99, name: "Autografo", description: "Autografo de prueba", image: url, owner: self.person)
        }
    }
    
    private func getFoto() {
        
    }
    
    var body: some View {
        Group {
            if self.item == "aut" {
                AutView(url: self.$url, product: self.$product).onAppear(perform: self.getAutografo)
            } else if self.item == "foto" {
                Group {
                    Text("Fotos de \(self.person.name)")
                }.onAppear(perform: self.getFoto)
            } else {
                VStack {
                    Text("Próximamente")
                        .padding()
                        .font(.system(size: 32, weight: .bold))
                    Text("Estamos trabajando para que puedas conectar con las estrellas de una manera en la que nunca lo habías hecho")
                        .padding()
                        .font(.system(size: 24, weight: .thin))
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
}

private struct AutView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var url: URL
    @Binding var product: Product
    
    var body: some View {
        GeometryReader { g in
            Group {
                ScrollView {
                    Spacer(minLength: 12)
                    
                    WebImage(url: self.url)
                        .resizable()
                        .placeholder(Image(systemName: "photo"))
                        .placeholder {
                            Rectangle().foregroundColor(Color("gris"))
                        }
                        .indicator(.activity)
                        .transition(.fade(duration: 0.5))
                        .scaledToFit()
                    .frame(width: g.size.width/2, height: g.size.height/2, alignment: .center)
                    
                    Spacer(minLength: 32)
                    
                    Button(action: {
                        // Añadir código para descargar la imagen
                        
                    }){
                        HStack {
                            Image(systemName: self.colorScheme == .dark ? "hand.draw": "hand.draw.fill")
                            
                            Text("Autógrafo normal: \(self.product.price.dollarString)€")
                                .font(.system(size: 18, weight: .bold))
                        }.padding(15)
                        
                    }.frame(width: g.size.width-15)
                        .background(Color("gris"))
                        .foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                        .cornerRadius(8)
                    
                    Spacer(minLength: 8)
                    
                    Button(action: {
                        // Añadir código para descargar la imagen
                        
                    }){
                        HStack {
                            Image(systemName: self.colorScheme == .dark ? "gift": "gift.fill")
                            
                            Text("Autógrafo dedicado: \((self.product.price + 1.20).dollarString)€")
                                .font(.system(size: 18, weight: .bold))
                        }.padding(15)
                        
                    }.frame(width: g.size.width-15)
                        .background(Color("gris"))
                        .foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                        .cornerRadius(8)
                }
            }
        }
    }
}


#if DEBUG
struct FamousItems_Previews: PreviewProvider {
    static var previews: some View {
        FamousItems(item: .constant("aut"), person: .constant(Person(name: "DEbug", description: "Debug", image: "")))
    }
}
#endif
