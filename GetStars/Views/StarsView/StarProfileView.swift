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
    private let langStr = Locale.current.languageCode
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var session: SessionStore
    
    private var cats = [Text("Products"), Text("Raffles"), Text("Sales")]
    @State var catSeleccionada = 0
    
    @State var loading = true
    @State private var angle: Double = 0
    
    @State var showProductDetail = false
    @State var product = ""
    @State var imgProduct = ""
    @State var url: URL = URL(string: "https://firebasestorage.googleapis.com/v0/b/getstars-a36bb.appspot.com/o/creadores%2F93cnbY5xxelS73sSsWnm%2FautFot.jpg?alt=media&token=16d5706c-73f9-40e7-b21d-d2a4b1c66e8a")!
    @State var showImagePicker = false
    @State var image: UIImage = UIImage()
    
    @State var priceUpdateMenu = false
    @State var price: Double = 0.0
    @State var newPrice: Double = 0.0
    @State var priceString = ""
    
    private func getData() {
        let group = DispatchGroup()
        let db = StarsDB()
        
        self.session.db.readDataUser(session: self.session, dg: group)
        group.notify(queue: DispatchQueue.global(qos: .background)) {
            print("Terminado")
            
            db.readVentas(session: self.session, dg: group)
            group.wait()
            print("Terminada lectura ventas")
            self.loading = false
        }
    }
    
    private func loadProduct() {
        let st = StarsST()
        let dg = DispatchGroup()
        
        if self.product == "autFot" || self.product == "fotDed"{
            st.getAutPhoto(key: self.session.data?.getUserKey() ?? "", dg: dg)
            dg.notify(queue: DispatchQueue.global(qos: .background)) {
                print("foto cargada")
                self.url = st.getPhoUrl()
                self.imgProduct = "autFot"
            }
        } else if self.product == "aut" || self.product == "autDed"{
            st.getAut(key: self.session.data?.getUserKey() ?? "", dg: dg)
            dg.notify(queue: DispatchQueue.global(qos: .background)) {
                print("autógrafo cargado")
                self.url = st.getAutUrl()
                self.imgProduct = "aut"
            }
        }
    }
    
    private func changePrice() {
        let db = StarsDB()
        db.updatePrice(price: self.newPrice, article: self.product, key: self.session.data?.getUserKey() ?? "")
        self.newPrice = 0.0
    }
    
    private func readPrice() {
        let db = StarsDB()
        let dg = DispatchGroup()
        
        db.getProductPrice(product: self.product, key: self.session.data?.getUserKey() ?? "", dg: dg)
        dg.notify(queue: DispatchQueue.global(qos: .background)) {
            print("Precio leído")
            self.price = db.getPrice()
        }
    }
    
    var body: some View {
        GeometryReader { g in
            NavigationView {
                Group {
                    if self.loading {
                        ActivityIndicator(isAnimating: .constant(true), style: .large)
                            .frame(width: g.size.width, height: g.size.height, alignment: .center)
                    } else {
                        ScrollView {
                            Picker(selection: self.$catSeleccionada, label: Text("")) {
                                ForEach(0 ..< self.cats.count) {
//                                    Text(self.cats[$0])
                                    self.cats[$0]
                                }
                            }.padding().pickerStyle(SegmentedPickerStyle())
                            
                            if self.catSeleccionada == 0 {
                                HStack {
                                    Text("Products")
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
                                            self.loadProduct()
                                            self.showProductDetail = true
                                        }) {
                                            VStack {
                                                Text("Photo")
                                                    .font(.system(size: 12, weight: .bold))
                                                Spacer()
                                                Image(systemName: "camera")
                                                    .resizable()
                                                    .frame(width: 45, height: 45, alignment: .center)
                                                    .scaledToFit()
                                                Spacer()
                                                if self.langStr == "es" {
                                                    Text("Fotos: \(self.session.data?.ventas["autFot"] ?? 0)")
                                                } else {
                                                    Text("Photos: \(self.session.data?.ventas["autFot"] ?? 0)")
                                                }
                                            }
                                        }.frame(width: 125, height: 125)
                                        .padding()
                                        .background(RoundedRectangle(cornerRadius: 16).fill(Color("gris")))
                                        .padding()
                                        
//                                        Button(action: {
//                                            self.product = "aut"
//                                            self.loadProduct()
//                                            self.showProductDetail = true
//                                        }) {
//                                            VStack {
//                                                Text("Autograph")
//                                                    .font(.system(size: 22, weight: .bold))
//                                                Spacer()
//                                                Image(systemName: "hand.draw")
//                                                    .resizable()
//                                                    .frame(width: 45, height: 45, alignment: .center)
//                                                    .scaledToFit()
//                                                Spacer()
//                                                if self.langStr == "es" {
//                                                    Text("Autógrafos: \(self.session.data?.ventas["aut"] ?? 0)")
//                                                } else {
//                                                    Text("Autograph: \(self.session.data?.ventas["aut"] ?? 0)")
//                                                }
//                                            }
//                                        }.frame(width: 125, height: 125)
//                                        .padding()
//                                        .background(RoundedRectangle(cornerRadius: 16).fill(Color("gris")))
//                                        .padding()
                                        
                                    }.foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                                }
                                
                                HStack {
                                    Text("Dedicated products")
                                    .font(.system(size: 18, weight: .bold))
                                    .padding()
                                    Spacer()
                                }
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        Button(action: {
                                            self.product = "fotDed"
                                            self.loadProduct()
                                            self.showProductDetail = true
                                        }) {
                                            VStack {
                                                Text("Dedicated photos")
                                                    .font(.system(size: 12, weight: .bold))
                                                Spacer()
                                                Image(systemName: "camera")
                                                    .resizable()
                                                    .frame(width: 45, height: 45, alignment: .center)
                                                    .scaledToFit()
                                                Spacer()
                                                Text("Photo: \(self.session.data?.ventas["fotDed"] ?? 0)")
                                            }
                                        }.frame(width: 125, height: 125)
                                        .padding()
                                        .background(RoundedRectangle(cornerRadius: 16).fill(Color("gris")))
                                        .padding()
                                        
                                        Button(action: {
                                            self.product = "fotDed"
                                            self.loadProduct()
                                            self.showProductDetail = true
                                        }) {
                                            VStack {
                                                Text("Dedicated photos")
                                                    .font(.system(size: 12, weight: .bold))
                                                Spacer()
                                                Image(systemName: "camera")
                                                    .resizable()
                                                    .frame(width: 45, height: 45, alignment: .center)
                                                    .scaledToFit()
                                                Spacer()
                                                Text("Photo: \(self.session.data?.ventas["fotCus"] ?? 0)")
                                            }
                                        }.frame(width: 125, height: 125)
                                        .padding()
                                        .background(RoundedRectangle(cornerRadius: 16).fill(Color("gris")))
                                        .padding()
                                        
                                        Button(action: {
                                            self.product = "autDed"
                                            self.loadProduct()
                                            self.showProductDetail = true
                                        }) {
                                            VStack {
                                                Text("Dedicated aut.")
                                                    .font(.system(size: 12, weight: .bold))
                                                Spacer()
                                                Image(systemName: "hand.draw")
                                                    .resizable()
                                                    .frame(width: 45, height: 45, alignment: .center)
                                                    .scaledToFit()
                                                Spacer()
                                                if self.langStr == "es" {
                                                    Text("Autógrafos: \(self.session.data?.ventas["autDed"] ?? 0)")
                                                } else {
                                                    Text("Autographs: \(self.session.data?.ventas["autDed"] ?? 0)")
                                                }
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
                                
                                NavigationLink(destination: ManageLiveView().environmentObject(self.session)) {
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
                                                Text("Lives: \(self.session.data?.ventas["live"] ?? 0)")
                                            }.multilineTextAlignment(.center)
                                            
                                        }.padding()
                                        .background(RoundedRectangle(cornerRadius: 16).fill(Color("gris")))
                                        .padding()
                                    }
                                }.foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                                
                            } else if self.catSeleccionada == 1 {
                                NavigationLink(destination: AddSorteoView().environmentObject(self.session)) {
                                    Text("Create a new raffle")
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                        .padding()
                                        .background(Color.init(hex: "00b0ff"))
                                        .foregroundColor(.white)
                                        .cornerRadius(50)
                                        .font(.system(size: 18, weight: .bold))
                                }.padding()
                                
                                NavigationLink(destination: SorteosView().environmentObject(self.session)){
                                    Text("Take a look of all raffles")
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                        .padding(50)
                                        .background(Color("gris"))
                                        .foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                                        .cornerRadius(16)
                                        .font(.system(size: 18, weight: .bold))
                                }.padding()
                                
                            } else {
                                NavigationLink(destination: AddSubastaView().environmentObject(self.session)) {
                                    Text("Create a new sale")
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                        .padding()
                                        .background(Color("naranja"))
                                        .foregroundColor(.white)
                                        .cornerRadius(50)
                                        .font(.system(size: 18, weight: .bold))
                                }.padding()
                                
                                NavigationLink(destination: SubastaView().environmentObject(self.session)){
                                    Text("Take a look of all sales")
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                        .padding(50)
                                        .background(Color("gris"))
                                        .foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                                        .cornerRadius(16)
                                        .font(.system(size: 18, weight: .bold))
                                }.padding()
                            }
                        }.navigationBarTitle("Profile")
                        .navigationBarItems(trailing:
                            NavigationLink(destination: ConfigurationView().environmentObject(self.session)) {
                                Image(systemName: "gear").resizable().frame(width: 28.0, height: 28.0)
                            }.foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                        )
                    }
                }.onAppear(perform: self.getData)
                .navigationViewStyle(StackNavigationViewStyle())
                .sheet(isPresented: self.$showProductDetail) {
                    Group {
                        if self.showImagePicker {
                            ChangeProductImageView(goBack: self.$showImagePicker, product: self.$imgProduct, image: self.$image).environmentObject(self.session)
                        } else {
                            GeometryReader { g in
                                VStack {
                                    HStack {
                                        Spacer()
                                        
                                        Button(action: {
                                            self.showProductDetail = false
                                        }) {
                                            Text("Cancel")
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
                                        self.showImagePicker.toggle()
                                        
                                    }) {
                                        Text("Edit image")
                                            .frame(minWidth: 0, maxWidth: .infinity)
                                            .padding(14)
                                            .background(Color("navyBlue"))
                                            .foregroundColor(.white)
                                            .cornerRadius(50)
                                    }.padding(8)
                                    
                                }.frame(width: g.size.width, height: g.size.height, alignment: .center)
                            }
                        }
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


