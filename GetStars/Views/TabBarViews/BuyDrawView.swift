//
//  BuyDrawView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 27/07/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct BuyDrawView: View {
    @State var selection: Int? = nil
    
     var body: some View {
           NavigationView {
               ScrollView {
                   VStack {
                       Spacer(minLength: 30)
                    
                       NavigationLink(destination: Text("Test"), tag: 1, selection: $selection){
                           Button(action: {}) {
                               Text("Destacados")
                                   .fontWeight(.heavy)
                                   .frame(minWidth: 0, maxWidth: .infinity)
                               .padding(70)
                                   .background(Color.init("naranja"))
                               .foregroundColor(.white)
                               .cornerRadius(16)
                               .font(.system(size: 18, weight: .bold))
                           }.shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                       }
                       
                       Spacer(minLength: 15)
                       
                       NavigationLink(destination: Text("Test"), tag: 1, selection: $selection){
                           Button(action: {}) {
                               Text("Populares")
                               .frame(minWidth: 0, maxWidth: .infinity)
                               .padding(70)
                                   .background(Color.init(hex: "00b0ff"))
                               .foregroundColor(.white)
                               .cornerRadius(16)
                               .font(.system(size: 18, weight: .bold))
                           }.shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                       }
                       
                       Spacer(minLength: 15)
                       
                       NavigationLink(destination: Text("Test"), tag: 1, selection: $selection){
                           Button(action: {}) {
                               Text("Novedades")
                               .frame(minWidth: 0, maxWidth: .infinity)
                               .padding(70)
                                   .background(Color.init(hex: "5e35b1"))
                               .foregroundColor(.white)
                               .cornerRadius(16)
                               .font(.system(size: 18, weight: .bold))
                           }.shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                       }
                    
                   }.padding(.horizontal, 8)
               }.navigationBarTitle("Compras y sorteos")
               
           }
       }
}

struct BuyDrawView_Previews: PreviewProvider {
    static var previews: some View {
        BuyDrawView()
    }
}
