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
    
    @State var loading = true
    
    private func getFamous() {
        let dg = DispatchGroup()
        let hd = HomeData(session: self.session, group: dg)
        dg.notify(queue: DispatchQueue.global(qos: .background)) {
            self.data = hd.data
            self.loading = false
        }
//        self.data = [Person]()
//
//        let st = StarsST()
//        let db = StarsDB()
//        var url = URL(string: "")
//        let dg = DispatchGroup()
//        db.readKeys(dg: dg)
//        dg.notify(queue: DispatchQueue.global(qos: .userInitiated)) {
//            let keys = db.getKeys()
//            self.session.db.readDataUser(session: self.session, dg: dg)
//            dg.wait()
//            print("DATOS USUARIOS LEIDOS HOME")
//            for i in keys {
//                st.getProfileImage(key: i, dg: dg)
//                dg.wait()
//
//                url = st.getProfileImgUrl()
//                db.readFamous(key: i, dg: dg)
//                dg.wait()
//
//                print("Famoso HOME leído")
//                let name = db.getName()
//                let desc = db.getDesc()
//                let p = Person(name: name, description: desc, image: url!, key: i)
//                if !p.isContained(array: self.data) {
//                    self.data.append(p)
//                }
//
//            }
//            self.loading = false
//        }
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { g in
                if self.loading {
                    ActivityIndicator(isAnimating: .constant(true), style: .medium)
                        .frame(width: g.size.width, height: g.size.height, alignment: .center)
                        .onAppear(perform: self.getFamous)
                } else {
                    ScrollView {
                        Group {
                            if !(self.session.data?.getIsPro() ?? true) {
                                NavigationLink(destination: BuyProView()){
                                    ZStack {
                                        Text("BECOME A PRO!")
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
                            }
                            
                            ForEach(0..<self.data.count, id: \.self) { item in
                                VStack {
                                    PersonCard(person: self.$data[item]).environmentObject(self.session)
                                        .frame(width: g.size.width)
                                    
                                    if (item + 1) % 3 == 0 {
                                        BannerCardView()
                                            .frame(width: g.size.width, alignment: .center)
                                            .padding()
                                    }
                                }
                            }
                            
                        }
                    }.frame(width: g.size.width)
                    .navigationBarTitle(Text("Home"))
                    .navigationBarItems(trailing:
                        NavigationLink(destination: PaymentView(product: Product()).environmentObject(self.session)) {
                            Image(systemName: "cart").resizable().frame(width: 28.0, height: 28.0)
                        }.foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                    )
                }
            }
        }
    }
}

fileprivate class HomeData: ObservableObject {
    var data: [Person]
    var loading: Bool = true
    
    init(session: SessionStore, group: DispatchGroup) {
        group.enter()
        self.data = [Person]()
        let dg = DispatchGroup()
        let st = StarsST()
        let db = StarsDB()
        var url = URL(string: "")
        db.readKeys(dg: dg)
        dg.notify(queue: DispatchQueue.global(qos: .userInitiated)) {
            let keys = db.getKeys()
            session.db.readDataUser(session: session, dg: dg)
            dg.wait()
            print("DATOS USUARIOS LEIDOS HOME")
            for i in keys {
                st.getProfileImage(key: i, dg: dg)
                dg.wait()
                
                url = st.getProfileImgUrl()
                db.readFamous(key: i, dg: dg)
                dg.wait()
                
                print("Famoso HOME leído")
                let name = db.getName()
                let desc = db.getDesc()
                let p = Person(name: name, description: desc, image: url!, key: i)
                if !p.isContained(array: self.data) {
                    self.data.append(p)
                }
                
            }
            group.leave()
        }
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
