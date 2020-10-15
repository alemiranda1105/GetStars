//
//  SearchView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 27/07/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var session: SessionStore
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var search: String = ""
    @State var oldSearch: String = ""
    @State var searching: Bool = false
    @State var resultadoBusqueda = [Person]()
    
    @State var loading = true
    
    private func busqueda() {
        self.loading = true
        
        let db = StarsDB()
        let st = StarsST()
        let dg = DispatchGroup()
        
        var imgUrl = [URL]()
        var url = URL(string: "")
        
        db.buscarUsuario(nombre: self.search, dg: dg)
        dg.notify(queue: DispatchQueue.global(qos: .background)) {
            print("Búsqueda terminada")
            
            self.oldSearch = self.search
            self.resultadoBusqueda.removeAll()
            
            let keys = db.getResultadoBusqueda()
            for i in keys {
                st.getProfileImage(key: i, dg: dg)
                dg.wait()
                
                imgUrl.append(st.getProfileImgUrl())
                url = st.getProfileImgUrl()
                db.readFamous(key: i, dg: dg)
                dg.wait()
                
                print("Famoso buscado leído")
                let name = db.getName()
                let desc = db.getDesc()
                self.resultadoBusqueda.append(Person(name: name, description: desc, image: url!, key: i))
            }
            self.loading = false
        }
        
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        TextField(LocalizedStringKey("Search"), text: $search)
                            .padding(7)
                            .padding(.horizontal, 25)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .overlay(
                                HStack{
                                    if self.search.count < 1 {
                                        Image(systemName: "magnifyingglass")
                                            .foregroundColor(.gray)
                                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                            .padding(.leading, 8)
                                    }
                                }
                            )
                            .padding(.horizontal, 10)
                        
                        if self.search.count >= 1 {
                            Spacer()
                            
                            Button(action: {
                                if self.searching && self.oldSearch == self.search {
                                    self.searching = false
                                } else {
                                    self.searching = true
                                }
                                if self.searching {
                                    self.busqueda()
                                } else {
                                    self.search = ""
                                }
                            }) {
                                if !self.searching {
                                    Image(systemName: "magnifyingglass")
                                        .resizable()
                                        .foregroundColor(.gray)
                                        .frame(width: 20, height: 20, alignment: .center)
                                        .padding(8)
                                } else if self.searching && self.oldSearch == self.search {
                                    Image(systemName: "x.circle.fill")
                                        .resizable()
                                        .foregroundColor(Color("gris"))
                                        .frame(width: 20, height: 20, alignment: .center)
                                        .padding(8)
                                } else {
                                    Image(systemName: "magnifyingglass")
                                        .resizable()
                                        .foregroundColor(.gray)
                                        .frame(width: 20, height: 20, alignment: .center)
                                        .padding(8)
                                }
                            }
                        }
                    }
                    
                    Spacer(minLength: 25)
                    
                    if !self.searching {
                        NavigationLink(destination: DestacadosView().environmentObject(self.session)){
                            Text("Highlights")
                                .fontWeight(.heavy)
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding(50)
                                .background(Color.init("naranja"))
                                .foregroundColor(.white)
                                .cornerRadius(16)
                                .font(.system(size: 18, weight: .bold))
                        }.shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                        
                        Spacer(minLength: 10)
                        
                        NavigationLink(destination: TrendingView().environmentObject(self.session)){
                            Text("Trending")
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding(50)
                                .background(Color.init(hex: "00b0ff"))
                                .foregroundColor(.white)
                                .cornerRadius(16)
                                .font(.system(size: 18, weight: .bold))
                        }.shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                        
                        Spacer(minLength: 10)
                        
                        NavigationLink(destination: NewsView().environmentObject(self.session)){
                            Text("New")
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding(50)
                                .background(Color.init(hex: "5e35b1"))
                                .foregroundColor(.white)
                                .cornerRadius(16)
                                .font(.system(size: 18, weight: .bold))
                        }.shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                        
                        Spacer(minLength: 10)
                        
                        NavigationLink(destination: CategoryView().environmentObject(self.session)){
                            Text("Categories")
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding(15)
                                .background(Color.init(hex: "4db6ac"))
                                .foregroundColor(.white)
                                .cornerRadius(16)
                                .font(.system(size: 18, weight: .bold))
                        }.shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                        
                        Spacer(minLength: 10)
                        
                        Banner()
                            .frame(width: 320, height: 50, alignment: .center)
                            .padding()
                        
                    } else {
                        ScrollView {
                            if self.loading {
                                ActivityIndicator(isAnimating: .constant(true), style: .large)
                            } else {
                                if self.resultadoBusqueda.count <= 0 {
                                    Text("Oh! The user you were searching may not exists")
                                        .font(.system(size: 22, weight: .thin))
                                        .multilineTextAlignment(.center)
                                } else {
                                    ForEach(0..<self.resultadoBusqueda.count, id: \.self) { item in
                                        PersonCard(person: self.$resultadoBusqueda[item]).environmentObject(self.session)
                                            .frame(width: UIScreen.main.bounds.width)
                                    }
                                }
                            }
                        }
                    }
                    
                }.padding(.horizontal, 8)
            }.navigationBarTitle(Text("Search"))
            .navigationBarItems(trailing:
                NavigationLink(destination: PaymentView(product: Product()).environmentObject(self.session)) {
                    Image(systemName: "cart").resizable().frame(width: 28.0, height: 28.0)
                }.foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
            )
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
