//
//  NewsView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 03/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct NewsView: View {
    @Environment(\.colorScheme) var colorScheme
    
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
            if keys.count <= 0 {
                self.loading = false
                return
            }
            for i in keys {
                st.getProfileImage(key: i, dg: dg)
                dg.wait()
                
                imgUrl.append(st.getProfileImgUrl())
                url = st.getProfileImgUrl()
                db.readFamous(key: i, dg: dg)
                dg.wait()
                
                print("Famoso novedad leído")
                let name = db.getName()
                let desc = db.getDesc()
                let p = Person(name: name, description: desc, image: url!, key: i)
                if !p.isContained(array: self.data) && i != "prueba" {
                    self.data.append(p)
                }
            }
            self.loading = false
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
                    if self.data.count <= 0 {
                        Text("For the moment, this is empty but we are working to bring here the best stars")
                            .font(.system(size: 28, weight: .thin))
                            .multilineTextAlignment(.center)
                            .padding()
                    } else {
                        ScrollView {
                            ForEach(0..<self.data.count, id: \.self) { product in
                                PersonCard(person: self.$data[product]).environmentObject(self.session)
                                    .frame(width: g.size.width)
                            }
                        }.navigationBarTitle("New")
    //                    .navigationBarItems(trailing:
    //                        NavigationLink(destination: PaymentView(product: Product()).environmentObject(self.session)) {
    //                            Image(systemName: "cart").resizable().frame(width: 28.0, height: 28.0)
    //                        }.foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
    //                    )
                        .navigationViewStyle(StackNavigationViewStyle())
                    }
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
