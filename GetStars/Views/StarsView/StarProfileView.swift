//
//  StarProfileView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 31/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct StarProfileView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var session: SessionStore
    
    private var cats = ["Productos", "Sorteos", "Pujas"]
    @State var catSeleccionada = 0
    
    private func getData() {
        let group = DispatchGroup()
        
        self.session.db.readDataUser(session: self.session, dg: group)
        group.notify(queue: DispatchQueue.global(qos: .background)) {
            print("Terminado")
        }
    }
    
    var body: some View {
        GeometryReader { g in
            NavigationView {
                Group {
                    ScrollView {
                        Picker(selection: self.$catSeleccionada, label: Text("")) {
                            ForEach(0 ..< self.cats.count) {
                                Text(self.cats[$0])
                            }
                        }.padding().pickerStyle(SegmentedPickerStyle())
                        if self.catSeleccionada == 0 {
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
                }.onAppear(perform: self.getData)
            }
        }
    }
}

struct StarProfileView_Previews: PreviewProvider {
    static var previews: some View {
        StarProfileView().previewDevice("iPhone 11")
    }
}
