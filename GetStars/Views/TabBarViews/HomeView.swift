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
    @State var showTutorial: Bool = UserDefaults.standard.bool(forKey: "tutorial")
    
    private func getFamous() {
        let dg = DispatchGroup()
        let hd = HomeData(session: self.session, group: dg)
        dg.notify(queue: DispatchQueue.global(qos: .background)) {
            if self.data.count <= 0 {
                self.data.append(contentsOf: hd.data)
            } else {
                if hd.data.count <= 0 {
                    self.loading = false
                    return
                }
                for i in hd.data {
                    if !i.isContained(array: self.data) {
                        print("Famoso home no contenido")
                        self.data.append(i)
                    }
                }
            }
            self.loading = false
        }
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
                            if self.data.count <= 0 {
                                Text("For the moment, this is empty but we are working to bring here the best stars")
                                    .font(.system(size: 28, weight: .thin))
                                    .multilineTextAlignment(.center)
                                    .padding()
                            } else {
                                ForEach(0..<self.data.count, id: \.self) { item in
                                    VStack {
                                        PersonCard(person: self.$data[item]).environmentObject(self.session)
                                            .frame(width: g.size.width)
                                        
                                        if (item + 1) % 3 == 0 {
                                            BannerCardView()
                                                .frame(width: g.size.width, alignment: .center)
                                                .padding()
                                        }
                                        
                                        #if DEBUG
                                        BannerCardView()
                                            .frame(width: g.size.width, alignment: .center)
                                            .padding()
                                        #endif
                                    }
                                }
                            }
                        }.sheet(isPresented: self.$showTutorial, content: {TutorialView(show: self.$showTutorial)})
                    }.frame(width: g.size.width)
                    .navigationBarTitle(Text("Home"))
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
                if !p.isContained(array: self.data) && i != "prueba" {
                    self.data.append(p)
                }
                // For test products (ONLY TEST)
                #if DEBUG
                if !p.isContained(array: self.data) {
                    self.data.append(p)
                }
                #endif
                
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
