//
//  ProfileView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 27/07/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    private let langStr = Locale.current.languageCode
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var session: SessionStore
    
    private var cats = ["Purchases", "Dedicated", "Autographs"]
    @State var catSeleccionada = 0
    
    @State var visible: Bool = false
    @State var downloading: Bool = true
    @State var loading: Bool = true
    
    private func loadProfileData() {
        let group = DispatchGroup()
        print("Starting")
        
        self.session.db.readDataUser(session: self.session, dg: group)
        group.notify(queue: DispatchQueue.global(qos: .background)) {
            self.loading = false
            print("Terminado datos")
            let length = self.session.data?.autMan ?? 0
            for i in 0...length {
                self.session.st.downloadURL(session: self.session, type: "AutMan", index: i, dg: group)
                group.wait()
                print("Terminado autmam")
                DispatchQueue.main.async {
                    self.session.url = self.session.url.sorted {
                        $0.name.lowercased() < $1.name.lowercased()
                    }
                }
            }
            
            self.session.db.readRevisionesPendientes(session: self.session, type: "", dg: group)
            group.wait()
            print("Terminado revisiones")
            self.downloading = false
        }
        
    }
    
    var body: some View {
        Group {
            if self.loading {
                ActivityIndicator(isAnimating: .constant(true), style: .large)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
                    .onAppear(perform: self.loadProfileData)
            } else {
                if (self.session.data?.getIsStar()) ?? false {
                    StarProfileView().environmentObject(self.session)
                } else {
                    GeometryReader { g in
                        NavigationView {
                            VStack {
                                if self.visible {
                                    Image(systemName: self.colorScheme == .dark ? "person.crop.circle": "person.crop.circle.fill")
                                    .resizable()
                                    .scaledToFill()
                                        .frame(width: 80, height: 80)
                                        .padding()
                                    
                                    VStack {
                                        Text(self.session.data?.getName() ?? "Dev")
                                        .font(.system(size: 20, weight: .regular))
                                        Text(self.session.session?.email ?? "Dev")
                                        .font(.system(size: 18, weight: .thin))
                                    }
                                    
                                    HStack(alignment: .center) {
                                        Button(action: {
                                            let impactMed = UIImpactFeedbackGenerator(style: .light)
                                            impactMed.impactOccurred()
                                            self.visible = false
                                        }) {
                                            Image(systemName: "arrow.up").resizable().frame(width: 22.0, height: 22.0)
                                        }.foregroundColor(self.colorScheme == .dark ? Color.white: Color.black).padding()
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            let impactMed = UIImpactFeedbackGenerator(style: .light)
                                            impactMed.impactOccurred()
                                            self.loading = true
                                            self.loadProfileData()
                                        }) {
                                            Image(systemName: "arrow.counterclockwise").resizable().frame(width: 22.0, height: 22.0)
                                        }.foregroundColor(self.colorScheme == .dark ? Color.white: Color.black).padding()
                                    }
                                    
                                    Picker(selection: self.$catSeleccionada, label: Text("")) {
                                        ForEach(0 ..< self.cats.count) {
                                            Text(LocalizedStringKey(self.cats[$0]))
                                        }
                                    }.padding().pickerStyle(SegmentedPickerStyle())
                                        
            //                        Spacer()
                                    
                                } else {
                                    HStack {
                                        Button(action: {
                                            let impactMed = UIImpactFeedbackGenerator(style: .light)
                                            impactMed.impactOccurred()
                                            self.visible = true
                                        }) {
                                            Image(systemName: "arrow.down").resizable().frame(width: 22.0, height: 22.0)
                                        }.foregroundColor(self.colorScheme == .dark ? Color.white: Color.black).padding()
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            let impactMed = UIImpactFeedbackGenerator(style: .light)
                                            impactMed.impactOccurred()
                                            self.loading = true
                                            self.loadProfileData()
                                        }) {
                                            Image(systemName: "arrow.counterclockwise").resizable().frame(width: 22.0, height: 22.0)
                                        }.foregroundColor(self.colorScheme == .dark ? Color.white: Color.black).padding()
                                    }
                                    
                                    Picker(selection: self.$catSeleccionada, label: Text("")) {
                                        ForEach(0 ..< self.cats.count) {
                                            Text(LocalizedStringKey(self.cats[$0]))
                                        }
                                    }.padding().pickerStyle(SegmentedPickerStyle())
                                    
            //                        Spacer()
                                    
                                }
                                
                                GeometryReader { g1 in
                                    if self.downloading {
                                        ActivityIndicator(isAnimating: .constant(true), style: .large)
                                            .frame(width: g1.size.width, height: g1.size.height, alignment: .center)
                                    } else {
                                        if self.catSeleccionada == 0 {
                                            ScrollView {
                                                
                                                NavigationLink(destination: ArticleProfileView(type: .constant("autFot"), title: .constant("Photos"))) {
                                                    VStack {
                                                        HStack {
                                                            VStack {
                                                                Text("Photos")
                                                                    .font(.system(size: 22, weight: .bold))
                                                                Spacer()
                                                                Image(systemName: "camera")
                                                                    .resizable()
                                                                    .frame(width: 60, height: 60, alignment: .center)
                                                                    .scaledToFit()
                                                                Spacer()
                                                            }
                                                            Spacer()
                                                            
                                                            VStack {
                                                                if self.langStr == "es" {
                                                                    Text("Foto con autógrafo: \((self.session.data?.compras["autFot"]?.count) ?? 0)")
                                                                } else {
                                                                    Text("Photos with autograph: \((self.session.data?.compras["autFot"]?.count) ?? 0)")
                                                                }
                                                            }
                                                            
                                                        }.padding()
                                                        .background(RoundedRectangle(cornerRadius: 16).fill(Color("gris")))
                                                        .padding()
                                                    }
                                                }.foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                                                
//                                                NavigationLink(destination: ArticleProfileView(type: .constant("aut"), title: .constant("Autograph"))) {
//                                                    VStack {
//                                                        HStack {
//                                                            VStack {
//                                                                Text("Autograph")
//                                                                    .font(.system(size: 22, weight: .bold))
//                                                                Spacer()
//                                                                Image(systemName: "hand.draw")
//                                                                    .resizable()
//                                                                    .frame(width: 60, height: 60, alignment: .center)
//                                                                    .scaledToFit()
//                                                                Spacer()
//                                                            }
//                                                            Spacer()
//                                                            
//                                                            VStack {
//                                                                if self.langStr == "es" {
//                                                                    Text("Autógrafos: \((self.session.data?.compras["aut"]?.count) ?? 0)")
//                                                                } else {
//                                                                    Text("Autograph: \((self.session.data?.compras["aut"]?.count) ?? 0)")
//                                                                }
//                                                            }.multilineTextAlignment(.center)
//                                                            
//                                                        }.padding()
//                                                        .background(RoundedRectangle(cornerRadius: 16).fill(Color("gris")))
//                                                        .padding()
//                                                    }
//                                                }.foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                                                
                                                NavigationLink(destination: UserLiveList().environmentObject(self.session)) {
                                                    VStack {
                                                        HStack {
                                                            VStack {
                                                                Text("Live")
                                                                    .font(.system(size: 22, weight: .bold))
                                                                Spacer()
                                                                Image(systemName: "camera.on.rectangle")
                                                                    .resizable()
                                                                    .frame(width: 60, height: 60, alignment: .center)
                                                                    .scaledToFit()
                                                                Spacer()
                                                            }
                                                            Spacer()
                                                            
                                                            VStack {
                                                                Text("Received lives")
                                                            }.multilineTextAlignment(.center)
                                                            
                                                        }.padding()
                                                        .background(RoundedRectangle(cornerRadius: 16).fill(Color("gris")))
                                                        .padding()
                                                    }
                                                }.foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                                            }
                                            .frame(width: g1.size.width, height: g1.size.height, alignment: .center)
                                        } else if self.catSeleccionada == 1 {
                                            ScrollView {
                                                
                                                VStack {
                                                    Text("Articles with dedication pending review:")
                                                    Text("\(self.session.revisonesPendientes.count)")
                                                }.font(.system(size: 18, weight: .regular))
                                                    .foregroundColor(.primary)
                                                    .padding()
                                                
                                                NavigationLink(destination: ArticleProfileView(type: .constant("fotDed"), title: .constant("Dedicated photos"))) {
                                                    VStack {
                                                        HStack {
                                                            VStack {
                                                                Text("Photos")
                                                                    .font(.system(size: 22, weight: .bold))
                                                                Spacer()
                                                                Image(systemName: "camera")
                                                                    .resizable()
                                                                    .frame(width: 60, height: 60, alignment: .center)
                                                                    .scaledToFit()
                                                                Spacer()
                                                            }
                                                            Spacer()
                                                            
                                                            VStack {
                                                                if self.langStr == "es" {
                                                                    Text("Fotos dedicadas: \((self.session.data?.compras["fotDed"]?.count) ?? 0)")
                                                                } else {
                                                                    Text("Dedicated photos: \((self.session.data?.compras["fotDed"]?.count) ?? 0)")
                                                                }
                                                            }
                                                            
                                                        }.padding()
                                                        .background(RoundedRectangle(cornerRadius: 16).fill(Color("gris")))
                                                        .padding()
                                                    }
                                                }.foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                                                
                                                NavigationLink(destination: ArticleProfileView(type: .constant("autDed"), title: .constant("Aut. dedicados"))) {
                                                    VStack {
                                                        HStack {
                                                            VStack {
                                                                Text("Autograph")
                                                                    .font(.system(size: 22, weight: .bold))
                                                                Spacer()
                                                                Image(systemName: "hand.draw")
                                                                    .resizable()
                                                                    .frame(width: 60, height: 60, alignment: .center)
                                                                    .scaledToFit()
                                                                Spacer()
                                                            }
                                                            Spacer()
                                                            
                                                            VStack {
                                                                if self.langStr == "es" {
                                                                    Text("Autógrafo dedicado: \((self.session.data?.compras["autDed"]?.count) ?? 0)")
                                                                } else {
                                                                    Text("Dedicated autograph: \((self.session.data?.compras["autDed"]?.count) ?? 0)")
                                                                }
                                                            }.multilineTextAlignment(.center)
                                                            
                                                        }.padding()
                                                        .background(RoundedRectangle(cornerRadius: 16).fill(Color("gris")))
                                                        .padding()
                                                    }
                                                }.foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                                                
                                            }
                                            .frame(width: g1.size.width, height: g1.size.height, alignment: .center)
                                        } else {
                                            GridStack(minCellWidth: 125, spacing: 5, numItems: self.session.url.count){ i, width in
                                                NavigationLink(destination: AutographProfileView(url: self.session.url[i])) {
                                                    WebImage(url: self.session.url[i].url)
                                                    .resizable()
                                                    .placeholder(Image(systemName: "photo"))
                                                    .placeholder {
                                                        Rectangle().foregroundColor(.gray)
                                                    }
                                                    .indicator(.activity)
                                                    .transition(.fade(duration: 0.5))
                                                    .frame(width: width, height: width, alignment: .center)
                                                    .border(Color.black, width: 1)
                                                }.buttonStyle(PlainButtonStyle()).padding(.vertical, 5)
                                            }
                                            .frame(width: g1.size.width, height: g1.size.height, alignment: .center)
                                        }
                                    }
                                }
                                
                                
                                
            //                    Spacer()
                                
                            }.navigationBarTitle(Text("Profile"), displayMode: self.visible ? .automatic: .inline)
                            .navigationBarItems(trailing:
                                NavigationLink(destination: ConfigurationView().environmentObject(self.session)) {
                                    Image(systemName: "gear").resizable().frame(width: 28.0, height: 28.0)
                                }.foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                            )
                        }.navigationViewStyle(StackNavigationViewStyle())
                    }
                }
            }
        }
    }
}
