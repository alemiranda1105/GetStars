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
        if self.data.count >= 1 {
            self.data = [Person]()
        }
        let st = StarsST()
        let db = StarsDB()
        var url = URL(string: "")
        let dg = DispatchGroup()
        db.readKeys(dg: dg)
        dg.notify(queue: DispatchQueue.global(qos: .userInitiated)) {
            let keys = db.getKeys()
            for i in keys {
                st.getProfileImage(key: i, dg: dg)
                dg.wait()
                
                url = st.getProfileImgUrl()
                db.readFamous(key: i, dg: dg)
                dg.wait()
                
                print("Famoso HOME leído")
                let name = db.getName()
                let desc = db.getDesc()
                self.data.append(Person(name: name, description: desc, image: url!, key: i))
                self.loading = false
            }
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
                                PersonCard(person: self.$data[item]).environmentObject(self.session)
                                    .frame(width: g.size.width)
                            }
                            
                        }
                    }.frame(width: g.size.width)
                    .navigationBarTitle(Text("Inicio"))
                    .navigationBarItems(trailing:
                        NavigationLink(destination: PaymentView(product: Product()).environmentObject(self.session)) {
                            Image(systemName: "cart").resizable().frame(width: 28.0, height: 28.0)
                        }.foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                    )
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
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
