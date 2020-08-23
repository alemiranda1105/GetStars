//
//  NewsView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 03/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct NewsView: View {
    @EnvironmentObject var session: SessionStore
    
    @State var data: [Person] = [Person]()
    @State var loading = true
    
    private func getFamous() {
        let st = StarsST()
        let db = StarsDB()
        var imgUrl = [URL]()
        var url = URL(string: "")
        let dg = DispatchGroup()
        db.readSpecialKey(cat: "novedades", dg: dg)
        dg.notify(queue: DispatchQueue.global(qos: .background)) {
            let keys = db.getSpecialKey(cat: "novedades")
            for i in keys {
                st.getImage(key: i, dg: dg)
                dg.wait()
                
                imgUrl.append(st.getImgUrl())
                url = st.getImgUrl()
                db.readFamous(key: i, dg: dg)
                dg.wait()
                
                print("Famoso novedad leído")
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
                    ActivityIndicator(isAnimating: .constant(true), style: .medium)
                    .frame(width: g.size.width, height: g.size.height, alignment: .center)
                    .onAppear(perform: self.getFamous)
                } else {
                    ScrollView {
                        ForEach(0..<self.data.count, id: \.self) { product in
                            PersonCard(person: self.$data[product])
                                .frame(width: g.size.width)
                        }
                    }.navigationBarTitle("Novedades")
                    .navigationViewStyle(StackNavigationViewStyle())
                }
            }
        }
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
    }
}
