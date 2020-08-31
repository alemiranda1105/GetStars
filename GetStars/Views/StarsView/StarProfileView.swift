//
//  StarProfileView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 31/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct StarProfileView: View {
    private var cats = ["Productos", "Sorteos", "Pujas"]
    @State var catSeleccionada = 0
    
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
                }
            }
        }
    }
}

struct StarProfileView_Previews: PreviewProvider {
    static var previews: some View {
        StarProfileView().previewDevice("iPhone 11")
    }
}
