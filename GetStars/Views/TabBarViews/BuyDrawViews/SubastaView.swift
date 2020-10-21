//
//  SubastaView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 17/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct SubastaView: View {
    @EnvironmentObject var session: SessionStore
    
    @State var subastas: [Product] = [Product]()
    
    @State var loading: Bool = true
    
    private func readSubastas() {
        let db = StarsDB()
        let st = StarsST()
        let dg = DispatchGroup()
        
        db.readSubastas(dg: dg)
        dg.notify(queue: DispatchQueue.global(qos: .background)) {
            let subastas = db.getSubastas()
            if subastas.count <= 0 {
                self.loading = false
                return
            }
            for i in subastas {
                db.readDatosSubastas(name: i, dg: dg)
                dg.wait()
                
                let datos = db.getDatosSubasta()
                
                st.readSubastaImage(key: datos["dueño"] as! String, name: datos["nombre"] as! String, dg: dg)
                dg.wait()
                
                let sorteoImg = st.getFotoSubasta()
                
                db.readFamous(key: datos["dueño"] as! String, dg: dg)
                dg.wait()
                
                st.getProfileImage(key: datos["dueño"] as! String, dg: dg)
                dg.wait()
                
                let owner = Person(name: db.getName(), description: db.getDesc(), image: st.getProfileImgUrl(), key: datos["dueño"] as! String)
                
                let p = Product(price: datos["precio"] as! Double, name: datos["nombre"] as! String, description: datos["descripcion"] as! String, image: sorteoImg, owner: owner, isDedicated: false, productType: .subasta)
                p.setFecha(fecha: datos["fechaFinal"] as! String)
                p.setProductID(id: i)
                
                if owner.getKey() != "prueba" {
                    if self.isContained(p: p) {
                        for j in 0..<self.subastas.count {
                            if self.subastas[j].equals(product: p) {
                                self.subastas[j] = p
                            }
                        }
                    } else {
                       self.subastas.append(p)
                    }
                }
            }
            self.loading = false
        }
    }
    
    private func isContained(p: Product) -> Bool{
        for i in self.subastas {
            if i.equals(product: p) {
                return true
            }
        }
        return false
    }
    
    var body: some View {
        GeometryReader { g in
            Group {
                if self.subastas.count <= 0 {
                    Text("For the moment, this is empty but we are working to bring here the best stars")
                        .font(.system(size: 28, weight: .thin))
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    ScrollView {
                        if self.loading {
                            ActivityIndicator(isAnimating: .constant(true), style: .medium)
                                .frame(width: g.size.width, height: g.size.height, alignment: .center)
                        } else {
                            ForEach(0..<self.subastas.count, id: \.self) { p in
                                SubastaCardView(product: self.$subastas[p]).environmentObject(self.session)
                                    .frame(width: g.size.width)
                            }
                        }
                    }
                }
            }.navigationBarTitle(Text("Sale"))
            .onAppear(perform: self.readSubastas)
        }
    }
}
