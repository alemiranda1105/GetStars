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
    @State var data: [Person] = [Person(name: "Debug debug", description: "Debugging the app", image: URL(string: "https://firebasestorage.googleapis.com/v0/b/getstars-a36bb.appspot.com/o/creadores%2F93cnbY5xxelS73sSsWnm%2FprofileImage.jpg?alt=media&token=3391460d-5bc0-4975-bc3a-6b7cd4c39348")!)]
    
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
            GeometryReader { g in
                ScrollView {
                    Group {
                        NavigationLink(destination: Text("¡PÁSATE AL PRO!")){
                            ZStack {
                                Text("¡PÁSATE AL PRO!")
                                    .font(.system(size: 25, weight: .bold))
                                    .foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                                    .scaledToFill()
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .frame(width: 350, height: 120)
                                    .background(Color("gris"))
                                    .cornerRadius(16)
                                    .overlay(RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.clear, lineWidth: 1))
                            }
                            
                        }.buttonStyle(PlainButtonStyle())
                        
                        
                        ForEach(0..<self.data.count, id: \.self) { item in
                            PersonCard(person: self.$data[item]).frame(width: g.size.width)
                        }
                        
                    }
                }.frame(width: g.size.width)
                .navigationBarTitle(Text("Inicio"))
            }
        }.navigationViewStyle(StackNavigationViewStyle())
        .onAppear { self.getFamous()}
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView().previewDevice(PreviewDevice(rawValue: "iPhone 8"))
        }
    }
}
#endif
