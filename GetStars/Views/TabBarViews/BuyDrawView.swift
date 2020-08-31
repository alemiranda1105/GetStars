//
//  BuyDrawView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 27/07/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct BuyDrawView: View {
    @EnvironmentObject var session: SessionStore
    
    @State var search: String = ""
    
    @Environment(\.colorScheme) var colorScheme
    
     var body: some View {
           NavigationView {
               ScrollView {
                   VStack {
                       TextField("Buscar", text: $search)
                           .padding(7)
                           .padding(.horizontal, 25)
                           .background(Color(.systemGray6))
                           .cornerRadius(8)
                           .overlay(
                               HStack{
                                   Image(systemName: "magnifyingglass")
                                       .foregroundColor(.gray)
                                       .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                       .padding(.leading, 8)
                               }
                           )
                           .padding(.horizontal, 10)
                       
                       Spacer(minLength: 35)
                       
                       NavigationLink(destination: SubastaView()){
                           Text("Subastas")
                               .fontWeight(.heavy)
                               .frame(minWidth: 0, maxWidth: .infinity)
                               .padding(50)
                               .background(Color.init("naranja"))
                               .foregroundColor(.white)
                               .cornerRadius(16)
                               .font(.system(size: 18, weight: .bold))
                       }.shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                       
                       Spacer(minLength: 20)
                       
                       NavigationLink(destination: SorteosView()){
                           Text("Sorteos")
                               .frame(minWidth: 0, maxWidth: .infinity)
                               .padding(50)
                               .background(Color.init(hex: "00b0ff"))
                               .foregroundColor(.white)
                               .cornerRadius(16)
                               .font(.system(size: 18, weight: .bold))
                       }.shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                       
                       Spacer(minLength: 20)
                       
                       NavigationLink(destination: LiveView()){
                           Text("Live")
                               .frame(minWidth: 0, maxWidth: .infinity)
                               .padding(50)
                               .background(Color.init(hex: "5e35b1"))
                               .foregroundColor(.white)
                               .cornerRadius(16)
                               .font(.system(size: 18, weight: .bold))
                       }.shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                       
                   }.padding(.horizontal, 8)
               }.navigationBarTitle("Subastas y sorteos")
           }.navigationViewStyle(StackNavigationViewStyle())
       }
}

struct BuyDrawView_Previews: PreviewProvider {
    static var previews: some View {
        BuyDrawView()
    }
}
