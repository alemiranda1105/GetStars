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
    @State var sorteos: [Product] = [Product]()
    
    @State var loading: Bool = true
    
    func readSorteos() {
        let db = Firestore.firestore()
        let documentRef = db.collection("sorteos")
        documentRef.getDocuments() { (querySnapshot, error) in
            if error != nil {
                print("error obteniendo los sorteos")
            } else {
                for document in querySnapshot!.documents {
                    let name = document.data()["nombre"] as! String
                    let desc = document.data()["descripcion"] as! String
                    let fecha = document.data()["fechaFinal"] as! String
                    let _ = document.data()["participantes"] as! [String]
                    
                    let dg = DispatchGroup()
                    let ownerKey = document.data()["dueño"] as! String
                    let dbStars = StarsDB()
                    let stStars = StarsST()
                    dbStars.readFamous(key: ownerKey, dg: dg)
                    dg.notify(queue: DispatchQueue.global(qos: .userInitiated)) {
                        stStars.getProfileImage(key: ownerKey, dg: dg)
                        stStars.readSorteoImage(key: ownerKey, name: name, dg: dg)
                        dg.wait()
                        
                        let owner = Person(name: dbStars.getName(), description: dbStars.getDesc(), image: stStars.getProfileImgUrl(), key: ownerKey)
                        let p = Product(price: 0.0, name: name, description: desc, image: stStars.getFotoSorteo(), owner: owner, isDedicated: false)
                        p.setFecha(fecha: fecha)
                        
                        if !self.isContained(p: p) {
                            self.sorteos.append(p)
                        }
                        self.loading = false
                    }
                }
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
                            SorteoCardView(product: self.$sorteos[p])
                                .frame(width: g.size.width)
                        }
                    }
                }.navigationBarTitle("Sorteos")
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
