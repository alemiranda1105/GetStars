//
//  FamousItems.swift
//  GetStars
//
//  Created by Alejandro Miranda on 24/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct FamousItems: View {
    @Binding var item: String
    @Binding var person: Person
    
    private func getAutografo() {
        
    }
    
    private func getFoto() {
        
    }
    
    var body: some View {
        ScrollView {
            if self.item == "aut" {
                Group {
                    Text("Autógrafo de \(self.person.name)")
                }.onAppear(perform: self.getAutografo)
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

#if DEBUG
struct FamousItems_Previews: PreviewProvider {
    static var previews: some View {
        FamousItems(item: .constant("aut"), person: .constant(Person(name: "DEbug", description: "Debug", image: "")))
    }
}
#endif
