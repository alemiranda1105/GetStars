//
//  StarProfileView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 31/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct StarProfileView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var session: SessionStore
    
    private var cats = ["Productos", "Sorteos", "Pujas"]
    @State var catSeleccionada = 0
    
    @State var loading = true
    @State private var angle: Double = 0
    
    @State var showProductDetail = false
    @State var product = ""
    @State var url: URL = URL(string: "https://firebasestorage.googleapis.com/v0/b/getstars-a36bb.appspot.com/o/creadores%2F93cnbY5xxelS73sSsWnm%2FautFot.jpg?alt=media&token=16d5706c-73f9-40e7-b21d-d2a4b1c66e8a")!
    
    private func getData() {
        let group = DispatchGroup()
        let db = StarsDB()
        
        self.session.db.readDataUser(session: self.session, dg: group)
        group.notify(queue: DispatchQueue.global(qos: .background)) {
            print("Terminado")
        }
        
        db.readVentas(session: self.session, dg: group)
        self.session.db.readDataUser(session: self.session, dg: group)
        group.notify(queue: DispatchQueue.global(qos: .background)) {
            print("Terminada lectura ventas")
            self.loading = false
        }
    }
    
    private func loadProduct() {
        // let db = StarsDB()
        // let st = StarsST()
        
        if self.product == "autFot" {
            
        } else if self.product == "fotDed" {
            
        } else if self.product == "aut" {
            
        } else if self.product == "autDed" {
            
        }
        
    }
    
    var body: some View {
        GeometryReader { g in
            NavigationView {
                VStack {
                    if self.loading {
                        ActivityIndicator(isAnimating: .constant(true), style: .large)
                            .frame(width: g.size.width, height: g.size.height, alignment: .center)
                    } else {
                        ScrollView {
                            Picker(selection: self.$catSeleccionada, label: Text("")) {
                                ForEach(0 ..< self.cats.count) {
                                    Text(self.cats[$0])
                                }
                            }.padding().pickerStyle(SegmentedPickerStyle())
                            
                            if self.catSeleccionada == 0 {
                                HStack {
                                    Text("Productos")
                                        .font(.system(size: 18, weight: .bold))
                                        .padding()
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        self.loading = true
                                        self.getData()
                                    }) {
                                        Image(systemName: "arrow.counterclockwise")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 18, height: 18, alignment: .center)
                                        .foregroundColor(self.colorScheme == .dark ? .white: .black)
                                    }.padding()
                                    
                                }
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        Button(action: {
                                            self.product = "autFot"
                                            self.showProductDetail = true
                                        }) {
                                            VStack {
                                                Text("Foto")
                                                    .font(.system(size: 22, weight: .bold))
                                                Spacer()
                                                Image(systemName: "camera")
                                                    .resizable()
                                                    .frame(width: 45, height: 45, alignment: .center)
                                                    .scaledToFit()
                                                Spacer()
                                                Text("Foto: \(self.session.data?.ventas["autFot"] ?? 0)")
                                            }
                                        }.frame(width: 125, height: 125)
                                        .padding()
                                        .background(RoundedRectangle(cornerRadius: 16).fill(Color("gris")))
                                        .padding()
                                        
                                        Button(action: {
                                            self.product = "aut"
                                            self.showProductDetail = true
                                        }) {
                                            VStack {
                                                Text("Autógrafo")
                                                    .font(.system(size: 22, weight: .bold))
                                                Spacer()
                                                Image(systemName: "hand.draw")
                                                    .resizable()
                                                    .frame(width: 45, height: 45, alignment: .center)
                                                    .scaledToFit()
                                                Spacer()
                                                Text("Autógrafo: \(self.session.data?.ventas["aut"] ?? 0)")
                                            }
                                        }.frame(width: 125, height: 125)
                                        .padding()
                                        .background(RoundedRectangle(cornerRadius: 16).fill(Color("gris")))
                                        .padding()
                                        
                                    }.foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                                }
                                
                                HStack {
                                    Text("Productos dedicados")
                                    .font(.system(size: 18, weight: .bold))
                                    .padding()
                                    Spacer()
                                }
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        Button(action: {
                                            self.product = "fotDed"
                                            self.showProductDetail = true
                                        }) {
                                            VStack {
                                                Text("Foto dedicada")
                                                    .font(.system(size: 22, weight: .bold))
                                                Spacer()
                                                Image(systemName: "camera")
                                                    .resizable()
                                                    .frame(width: 45, height: 45, alignment: .center)
                                                    .scaledToFit()
                                                Spacer()
                                                Text("Foto: \(self.session.data?.ventas["fotDed"] ?? 0)")
                                            }
                                        }.frame(width: 125, height: 125)
                                        .padding()
                                        .background(RoundedRectangle(cornerRadius: 16).fill(Color("gris")))
                                        .padding()
                                        
                                        Button(action: {
                                            self.product = "autDed"
                                            self.showProductDetail = true
                                        }) {
                                            VStack {
                                                Text("Aut. dedicado")
                                                    .font(.system(size: 22, weight: .bold))
                                                Spacer()
                                                Image(systemName: "hand.draw")
                                                    .resizable()
                                                    .frame(width: 45, height: 45, alignment: .center)
                                                    .scaledToFit()
                                                Spacer()
                                                Text("Autógrafo: \(self.session.data?.ventas["autDed"] ?? 0)")
                                            }
                                        }.frame(width: 125, height: 125)
                                        .padding()
                                        .background(RoundedRectangle(cornerRadius: 16).fill(Color("gris")))
                                        .padding()
                                        
                                    }.foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                                }
                                
                                HStack {
                                    Text("Live")
                                    .font(.system(size: 18, weight: .bold))
                                    .padding()
                                    Spacer()
                                }
                                
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
                                                Text("Videos dedicados: \(self.session.data?.ventas["live"] ?? 0)")
                                            }.multilineTextAlignment(.center)
                                            
                                        }.padding()
                                        .background(RoundedRectangle(cornerRadius: 16).fill(Color("gris")))
                                        .padding()
                                    }
                                }.foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                                
                            } else if self.catSeleccionada == 1 {
                                VStack {
                                    Text("Sorteos")
                                        .font(.system(size: 32, weight: .bold))
                                }
                            } else {
                                VStack {
                                    Text("Pujas")
                                        .font(.system(size: 32, weight: .bold))
                                }
                            }
                        }.navigationBarTitle("Profile")
                        .navigationBarItems(trailing:
                            NavigationLink(destination: ConfigurationView().environmentObject(self.session)) {
                                Image(systemName: "gear").resizable().frame(width: 28.0, height: 28.0)
                            }.foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                        )
                    }
                }.onAppear(perform: self.getData)
                .sheet(isPresented: self.$showProductDetail) {
                    GeometryReader { g in
                        VStack {
                            
                            HStack {
                                Spacer()
                                
                                Button(action: {
                                    self.showProductDetail = false
                                }) {
                                    Text("Cancelar")
                                }
                            }.padding()
                            
                            WebImage(url: self.url)
                                .resizable()
                                .placeholder(Image(systemName: "photo"))
                                .placeholder {
                                    Rectangle().foregroundColor(Color("gris"))
                                }
                                .indicator(.activity)
                                .transition(.fade(duration: 0.5))
                                .cornerRadius(15)
                                .overlay(RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.clear, lineWidth: 1))
                                .scaledToFit()
                                .frame(width: g.size.width, height: g.size.height/2, alignment: .center)
                            
                            Spacer()
                            
                            Button(action: {
                                // Editar imagen
                                
                            }) {
                                Text("Editar imagen")
                            }
                            
                            Button(action: {
                                // Cambiar precio
                                
                            }) {
                                Text("Cambiar precio")
                            }
                        }.onAppear(perform: self.loadProduct)
                        .frame(width: g.size.width, height: g.size.height, alignment: .center)
                    }
                }
            }
        }
    }
}

#if DEBUG
struct StarProfileView_Previews: PreviewProvider {
    static var previews: some View {
        StarProfileView().previewDevice("iPhone 11")
    }
}
#endif
