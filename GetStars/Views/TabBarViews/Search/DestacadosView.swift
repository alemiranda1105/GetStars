//
//  DestacadosView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 03/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct DestacadosView: View {
    @EnvironmentObject var session: SessionStore
    
    @Environment(\.colorScheme) var colorScheme
    @State var data: [Person] = [Person]()
    @State var loading = true
    
    private func getFamous() {
        let st = StarsST()
        let db = StarsDB()
        var imgUrl = [URL]()
        var url = URL(string: "")
        let dg = DispatchGroup()
        db.readSpecialKey(cat: "destacados", dg: dg)
        dg.notify(queue: DispatchQueue.global(qos: .background)) {
            let keys = db.getSpecialKey(cat: "destacados")
            for i in keys {
                st.getImage(key: i, dg: dg)
                dg.wait()
                
                imgUrl.append(st.getImgUrl())
                url = st.getImgUrl()
                db.readFamous(key: i, dg: dg)
                dg.wait()
                
                print("Famoso destacado leído")
                let name = db.getName()
                let desc = db.getDesc()
                self.data.append(Person(name: name, description: desc, image: url!))
                self.loading = false
            }
        }
    }
    
    var body: some View {
        GeometryReader { g in
            Group {
                if self.loading {
                    ActivityIndicator(isAnimating: .constant(true), style: .medium).onAppear(perform: self.getFamous)
                } else {
                    ScrollView {
                        ForEach(0..<self.data.count, id: \.self) { item in
                            PersonCard(person: self.$data[item])
                                .frame(width: g.size.width)
                        }
                    }.navigationBarTitle("Destacados")
                    .navigationViewStyle(StackNavigationViewStyle())
                }
                
            }
        }
    }
}

struct DestacadosView_Previews: PreviewProvider {
    static var previews: some View {
        DestacadosView()
    }
}
