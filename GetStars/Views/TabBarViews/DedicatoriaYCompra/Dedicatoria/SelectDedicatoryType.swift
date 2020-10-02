//
//  SelectDedicatoryType.swift
//  GetStars
//
//  Created by Alejandro Miranda on 02/10/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct SelectDedicatoryType: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var session: SessionStore
    @State var product: Product
    
    private let types: [String] = ["cumpleaños", "enfermedad", "fan"]
    private let typesText: [String] = ["Dedicatoria para un cumpleaños", "Dedicatoria para alguien enfermo", "Dedicatoria para un fan"]
    @State var selectedType = ""
    
    @State var message = ""
    
    private func loadMessage(type: String) {
        // Leer mensaje predeterminado para ese tipo en la base de datos
        let db = StarsDB()
        let dg = DispatchGroup()
        
        db.readDefaultMessage(key: self.product.owner.getKey(), type: type, dg: dg)
        dg.notify(queue: DispatchQueue.global(qos: .background)) {
            print("Mensaje predeterminado leído")
            let m = db.getDefaultMessage()
            self.message = m.replacingOccurrences(of: "[name]", with: (self.session.data?.getName())!)
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            ForEach(0 ..< self.typesText.count, id: \.self) { index in
                Button(action: {
                    self.selectedType = self.types[index]
                    self.loadMessage(type: self.selectedType)
                }) {
                    if self.selectedType == self.types[index] {
                        Image(systemName: "checkmark.circle")
                    }
                    Text(self.typesText[index])
                        .font(.system(size: 20, weight: .thin))
                }
            }.padding()
            
            Spacer()
            
            if self.selectedType != "" && self.message != "" {
                NavigationLink(destination: DedicatoriaView(product: self.product, mensajePred: self.message).environmentObject(self.session)) {
                    Text("Continuar")
                        .font(.system(size: 20, weight: .semibold))
                }.padding()
            }
        }
    }
}
