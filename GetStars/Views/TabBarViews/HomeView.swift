//
//  HomeView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 27/07/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var session: SessionStore
    
    @Environment(\.colorScheme) var colorScheme
    @State var data: [Person] = [Person]()
    
    private func getFamous() {
        let st = StarsST()
        let db = StarsDB()
        var imgUrl = [URL]()
        let dg = DispatchGroup()
        db.readKeys(dg: dg)
        dg.notify(queue: DispatchQueue.global(qos: .background)) {
            let keys = db.getKeys()
            for i in keys {
                st.getImage(key: i, dg: dg)
                dg.wait()
                dg.notify(queue: DispatchQueue.global(qos: .background)) {
                    imgUrl.append(st.getImgUrl())
                    let url = st.getImgUrl()
                    
                    db.readFamous(key: i, dg: dg)
                    dg.wait()
                    dg.notify(queue: DispatchQueue.global(qos: .background)) {
                        print("Famoso leído")
                        let name = db.getName()
                        let desc = db.getDesc()
                        self.data.append(Person(name: name, description: desc, image: url))
                    }
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Button(action: { }){
                        Text("¡PÁSATE AL PRO!")
                            .font(.system(size: 25, weight: .bold))
                        
                    }.frame(minWidth: 0, maxWidth: .infinity)
                        .padding(48)
                        .background(RoundedRectangle(cornerRadius: 16)
                        .fill(Color.init("gris")))
                        .foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                    
                    ForEach(0..<self.data.count, id: \.self) { item in
                        PersonCard(person: self.$data[item])
                    }
                    
                }.padding(.top, 20).padding(.horizontal, 32)
            }.navigationBarTitle(Text("Inicio"))
        }.navigationViewStyle(StackNavigationViewStyle())
        .onAppear { self.getFamous()}
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView().previewDevice(PreviewDevice(rawValue: "iPhone 8"))
            HomeView().previewDevice(PreviewDevice(rawValue: "iPhone 11"))
        }
    }
}
#endif
