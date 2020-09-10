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
    
    private var cats = ["Compras", "Autógrafos manuales"]
    @State var catSeleccionada = 0
    
    @State var visible: Bool = false
    @State var downloading: Bool = true
    
    private func loadImage() {
        let group = DispatchGroup()
        print("Starting")
        let length = self.session.data?.autMan ?? 0
        for i in 0...length {
            self.session.st.downloadURL(session: self.session, type: "AutMan", index: i, dg: group)
            group.notify(queue: DispatchQueue.global(qos: .background)) {
                print("Terminado")
            }
            self.session.url = self.session.url.sorted {
                $0.name.lowercased() < $1.name.lowercased()
            }
        }
        self.downloading = false
    }
    
    private func getCompras() {
        //let group = DispatchGroup()
        
    }
    
    var body: some View {
        GeometryReader { g in
            NavigationView {
                Group {
                    if self.visible {
                        Image(systemName: self.colorScheme == .dark ? "person.crop.circle": "person.crop.circle.fill")
                        .resizable()
                        .scaledToFill()
                            .frame(width: 80, height: 80)
                            .padding()
                        
                        Text(self.session.data?.getName() ?? "Dev")
                            .font(.system(size: 20, weight: .thin))
                        
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
                            
                        Spacer()
                        
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
                        
                        Spacer()
                        
                    }
                    
                    
                    
                    if self.downloading {
                        Text("Cargando...").font(.system(size: 32, weight: .heavy)).multilineTextAlignment(.center).padding()
                    } else {
                        if self.catSeleccionada == 0 {
                            ScrollView {
                                NavigationLink(destination: Text("Foto")) {
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
                                                Text("Foto dedicada: 18")
                                                Text("Foto: 25")
                                            }
                                            
                                        }.padding()
                                        .background(RoundedRectangle(cornerRadius: 16).fill(Color("gris")))
                                        .padding()
                                    }
                                }.foregroundColor(.black)
                                
                                NavigationLink(destination: Text("Autógrafo")) {
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
                                                Text("Autógrafo dedicado: 30")
                                                Text("Autógrafo: 25")
                                            }.multilineTextAlignment(.center)
                                            
                                        }.padding()
                                        .background(RoundedRectangle(cornerRadius: 16).fill(Color("gris")))
                                        .padding()
                                    }
                                }.foregroundColor(.black)
                                
                                NavigationLink(destination: Text("Live")) {
                                    VStack {
                                        HStack {
                                            VStack {
                                                Text("Live")
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
                                                Text("Videos dedicados: 12")
                                            }.multilineTextAlignment(.center)
                                            
                                        }.padding()
                                        .background(RoundedRectangle(cornerRadius: 16).fill(Color("gris")))
                                        .padding()
                                    }
                                }.foregroundColor(.black)
                            }.onAppear(perform: self.getCompras)
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
                        }
                    }
                    
                    Spacer()
                    
                }.navigationBarTitle(Text("Perfil"), displayMode: self.visible ? .automatic: .inline)
                .navigationBarItems(trailing:
                    NavigationLink(destination: ConfigurationView().environmentObject(self.session)) {
                        Image(systemName: "gear").resizable().frame(width: 28.0, height: 28.0)
                    }.foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                )
            }.onAppear(perform: self.loadImage)
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject(SessionStore())
    }
}
