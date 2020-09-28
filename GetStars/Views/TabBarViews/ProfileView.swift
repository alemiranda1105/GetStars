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
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var session: SessionStore
    
    private var cats = ["Compras", "Dedicatorias", "Autógrafos"]
    @State var catSeleccionada = 0
    
    @State var visible: Bool = false
    @State var downloading: Bool = true
    
    private func loadProfileData() {
        let group = DispatchGroup()
        print("Starting")
        
        self.session.db.readDataUser(session: self.session, dg: group)
        group.notify(queue: DispatchQueue.global(qos: .background)) {
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
                                }
                                
                                Picker(selection: self.$catSeleccionada, label: Text("")) {
                                    ForEach(0 ..< self.cats.count) {
                                        Text(self.cats[$0])
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
                                }
                                
                                Picker(selection: self.$catSeleccionada, label: Text("")) {
                                    ForEach(0 ..< self.cats.count) {
                                        Text(self.cats[$0])
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
                                            if !(self.session.data?.getIsPro() ?? true) {
                                                NavigationLink(destination: BuyProView()){
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
                                            }
                                            
                                            NavigationLink(destination: ArticleProfileView(type: .constant("autFot"), title: .constant("Fotos"))) {
                                                VStack {
                                                    HStack {
                                                        VStack {
                                                            Text("Foto")
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
                                                            Text("Foto con autógrafo: \((self.session.data?.compras["autFot"]?.count) ?? 0)")
                                                        }
                                                        
                                                    }.padding()
                                                    .background(RoundedRectangle(cornerRadius: 16).fill(Color("gris")))
                                                    .padding()
                                                }
                                            }.foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                                            
                                            NavigationLink(destination: ArticleProfileView(type: .constant("aut"), title: .constant("Autógrafos"))) {
                                                VStack {
                                                    HStack {
                                                        VStack {
                                                            Text("Autógrafo")
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
                                                            Text("Autógrafo: \((self.session.data?.compras["aut"]?.count) ?? 0)")
                                                        }.multilineTextAlignment(.center)
                                                        
                                                    }.padding()
                                                    .background(RoundedRectangle(cornerRadius: 16).fill(Color("gris")))
                                                    .padding()
                                                }
                                            }.foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                                            
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
                                                            Text("Ver Lives recibidos")
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
                                            if !(self.session.data?.getIsPro() ?? false) {
                                                NavigationLink(destination: BuyProView()){
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
                                            }
                                            
                                            VStack {
                                                Text("Artículos con dedicatoria pendientes de revisión:")
                                                Text("\(self.session.revisonesPendientes.count)")
                                            }.font(.system(size: 18, weight: .regular))
                                                .foregroundColor(.primary)
                                                .padding()
                                            
                                            NavigationLink(destination: ArticleProfileView(type: .constant("fotDed"), title: .constant("Fotos dedicadas"))) {
                                                VStack {
                                                    HStack {
                                                        VStack {
                                                            Text("Foto")
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
                                                            Text("Foto dedicada: \((self.session.data?.compras["fotDed"]?.count) ?? 0)")
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
                                                            Text("Autógrafo")
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
                                                            Text("Autógrafo dedicado: \((self.session.data?.compras["autDed"]?.count) ?? 0)")
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
                            
                        }.navigationBarTitle(Text("Perfil"), displayMode: self.visible ? .automatic: .inline)
                        .navigationBarItems(trailing:
                            NavigationLink(destination: ConfigurationView().environmentObject(self.session)) {
                                Image(systemName: "gear").resizable().frame(width: 28.0, height: 28.0)
                            }.foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                        )
                    }.onAppear(perform: self.loadProfileData)
                    .navigationViewStyle(StackNavigationViewStyle())
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject(SessionStore())
    }
}
