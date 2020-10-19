//
//  LiveView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 18/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct LiveView: View {
    @EnvironmentObject var session: SessionStore
    
    @Environment(\.colorScheme) var colorScheme

    @State var data: [Person] = [Person]()
    
    @State var loading = true
    
    private func getFamous() {
        let st = StarsST()
        let db = StarsDB()
        var url = URL(string: "")
        let dg = DispatchGroup()
        db.readKeys(dg: dg)
        dg.notify(queue: DispatchQueue.global(qos: .userInitiated)) {
            let keys = db.getKeys()
            if keys.count <= 0 {
                self.loading = false
                return
            }
            for i in keys {
                st.getProfileImage(key: i, dg: dg)
                dg.wait()
                
                url = st.getProfileImgUrl()
                db.readFamous(key: i, dg: dg)
                dg.wait()
                
                print("Famoso LIVE leído")
                let name = db.getName()
                let desc = db.getDesc()
                let p = Person(name: name, description: desc, image: url!, key: i)
                if !p.isContained(array: self.data) && i != "prueba" {
                    self.data.append(Person(name: name, description: desc, image: url!, key: i))
                }
            }
            self.loading = false
        }
    }
    
    var body: some View {
        GeometryReader { g in
            Group {
                if self.data.count <= 0 {
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
                            ForEach(0 ..< self.data.count, id: \.self) { p in
                                LiveCard(person: self.$data[p]).environmentObject(self.session)
                                    .frame(width: g.size.width)
                            }
                        }
                    }
                }
            }.navigationBarTitle("Live")
            .onAppear(perform: self.getFamous)
        }
    }
}

struct LiveView_Previews: PreviewProvider {
    static var previews: some View {
        LiveView()
    }
}
