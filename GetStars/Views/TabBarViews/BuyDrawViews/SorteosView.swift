//
//  SorteosView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 18/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import Firebase

struct SorteosView: View {
    @EnvironmentObject var session: SessionStore
    
    @State var sorteos: [Product] = [Product]()
    
    @State var loading: Bool = true
    
    private func readSorteos() {
        self.loading = false
        let db = StarsDB()
        let st = StarsST()
        let dg = DispatchGroup()
        
        db.readSorteos(dg: dg)
        dg.notify(queue: DispatchQueue.global(qos: .background)) {
            let lista = db.getSorteos()
            for i in lista {
                db.readDatosSorteos(name: i, dg: dg)
                dg.wait()
                
                let datos = db.getDatosSorteo()
                
                st.readSorteoImage(key: datos["dueño"] as! String, name: datos["nombre"] as! String, dg: dg)
                dg.wait()
                
                let sorteoImg = st.getFotoSorteo()
                
                db.readFamous(key: datos["dueño"] as! String, dg: dg)
                dg.wait()
                
                st.getProfileImage(key: datos["dueño"] as! String, dg: dg)
                dg.wait()
                
                let owner = Person(name: db.getName(), description: db.getDesc(), image: st.getProfileImgUrl(), key: datos["dueño"] as! String)
                
                let p = Product(price: 0.0, name: datos["nombre"] as! String, description: datos["descripcion"] as! String, image: sorteoImg, owner: owner, isDedicated: false, productType: .sorteo)
                p.setFecha(fecha: datos["fechaFinal"] as! String)
                p.setParticipantes(lista: datos["participantes"] as! [String])
                p.setProductID(id: i)
                
                if self.isContained(p: p) {
                    for j in 0..<self.sorteos.count {
                        if self.sorteos[j].equals(product: p) {
                            self.sorteos[j] = p
                        }
                    }
                } else {
                   self.sorteos.append(p)
                }
                
                self.loading = false
            }
        }
    }
    
    private func isContained(p: Product) -> Bool{
        for i in self.sorteos {
            if i.equals(product: p) {
                return true
            }
        }
        return false
    }
    
    var body: some View {
        GeometryReader { g in
            Group {
                ScrollView {
                    if self.loading {
                        ActivityIndicator(isAnimating: .constant(true), style: .medium)
                            .frame(width: g.size.width, height: g.size.height, alignment: .center)
                    } else {
                        ForEach(0..<self.sorteos.count, id: \.self) { p in
                            SorteoCardView(product: self.$sorteos[p]).environmentObject(self.session)
                                .frame(width: g.size.width)
                        }
                    }
                }.navigationBarTitle(Text("Raffle"))
                .onAppear(perform: self.readSorteos)
            }
        }
    }
}

struct SorteosView_Previews: PreviewProvider {
    static var previews: some View {
        SorteosView()
    }
}
