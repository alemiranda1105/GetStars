//
//  SorteoProductView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 18/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase

struct SorteoProductView: View {
    @EnvironmentObject var session: SessionStore
    
    private let langStr = Locale.current.languageCode
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var product: Product
    
    @State var expanded: Bool = false
    
    @State var participantes: [Product] = []
    @State var participando: Bool = false
    
    private func checkParticipacion() {
        self.participando = product.comprobarParticipacion(email: (self.session.session?.email!)!)
    }
    
    private func participarSorteo() {
        let db = Firestore.firestore()
        let documentRef = db.collection("sorteos").document("prueba")
        documentRef.updateData([
            "participantes": FieldValue.arrayUnion([self.session.session?.email as Any])
        ])
    }
    
    private func salirDelSorteo() {
        let db = Firestore.firestore()
        let documentRef = db.collection("sorteos").document("prueba")
        documentRef.updateData([
            "participantes": FieldValue.arrayRemove([self.session.session?.email as Any])
        ])
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                ZStack {
                    HStack {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "multiply.circle.fill").resizable().frame(width: 28.0, height: 28.0)
                                .foregroundColor(Color.gray)
                        }.padding(16)
                            .padding(.bottom, 16)
                        Spacer()
                    }.zIndex(1000)
                    
                    GeometryReader { g in
                        WebImage(url: URL(string: self.product.image)).resizable()
                        .placeholder(Image(systemName: "photo"))
                        .placeholder {
                            Rectangle().foregroundColor(.gray)
                        }
                        .indicator(.activity)
                        .scaledToFill()
                        .frame(width: g.size.width, height: (g.size.height+165), alignment: .center)
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.clear, lineWidth: 1))
                    }.padding(.bottom, 16)
                        
                    VStack {
                        HStack(alignment: .lastTextBaseline) {
                            Text("\(self.product.name)")
                                .foregroundColor(Color.white)
                                .cornerRadius(16)
                                .font(.system(size: 32, weight: .bold))
                        }.shadow(color: Color.black.opacity(0.9), radius: 5, x: 2, y: 0)
                            .padding(.top, 280)
                    }
                    
                }.padding(.top, -140)
                .edgesIgnoringSafeArea(.top)
                .edgesIgnoringSafeArea(.horizontal)
                
                Text(self.product.description)
                    .font(.system(size: 16, weight: .regular))
                    .padding()
                    .padding(.top, 100)
                    .frame(width: 400, height: 300)
                    .multilineTextAlignment(.leading)
                
                
                Text(self.langStr == "en" ? "Until: \(self.product.fecha)": "Hasta: \(self.product.fecha)")
                    .cornerRadius(15)
                    .font(.system(size: 32, weight: .medium))
                
                if self.participando {
                    Text("Ya estás participando en este sorteo")
                        .font(.system(size: 14, weight: .semibold))
                        .padding()
                }
                
                
                VStack(spacing: 8) {
                    if self.participando {
                        Button(action: {
                            self.salirDelSorteo()
                            self.participando = false
                        }){
                            HStack {
                                Image(systemName: self.colorScheme == .dark ? "x.circle": "x.circle.fill")
                                
                                Text("Salir del sorteo")
                                    .font(.system(size: 18, weight: .bold))
                            }
                            
                        }.frame(minWidth: 0, maxWidth: .infinity)
                        .padding(15)
                        .background(Color("gris"))
                        .foregroundColor(Color.red)
                        .cornerRadius(8)

                    } else {
                        Button(action: {
                            self.participarSorteo()
                            self.participando = true
                        }){
                            HStack {
                                Image(systemName: self.colorScheme == .dark ? "plus.app": "plus.app.fill")
                                
                                Text("Participar")
                                    .font(.system(size: 18, weight: .bold))
                            }
                            
                        }.frame(minWidth: 0, maxWidth: .infinity)
                        .padding(15)
                        .background(Color("gris"))
                        .foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                        .cornerRadius(8)

                    }
                    NavigationLink(destination: PersonView(person: self.$product.owner)){
                        HStack {
                            Image(systemName: self.colorScheme == .dark ? "person.crop.circle": "person.crop.circle.fill")
                            Text("Ver perfil de \(self.product.owner.name)")
                                .font(.system(size: 18, weight: .bold))
                        }
                        
                    }.frame(minWidth: 0, maxWidth: .infinity)
                    .padding(15)
                    .background(Color("gris"))
                    .foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                    .cornerRadius(8)
                    
                }.padding(16)
                
            }
        }.navigationBarTitle("")
        .navigationBarHidden(true)
        .onAppear(perform: self.checkParticipacion)
    }
}

struct SorteoProductView_Previews: PreviewProvider {
    static var previews: some View {
        SorteoProductView(product: .constant(Product(price: 99, name: "Test", description: "Casco usado por un piloto de carreras en una carrera en la que corrieron muchos corredores", image: "pr2", owner: Person(name: "Piloto 1", description: "Piloto de carreras", image: "p1", key: ""), isDedicated: false)))
    }
}
