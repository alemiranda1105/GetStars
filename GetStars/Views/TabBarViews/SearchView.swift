//
//  SearchView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 27/07/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    @State var selection: Int? = nil
    @State var search: String = ""
    
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
                    
                    Spacer(minLength: 25)
                    
                    NavigationLink(destination: Text("Test"), tag: 1, selection: $selection){
                        Button(action: {}) {
                            Text("Destacados")
                                .fontWeight(.heavy)
                                .frame(minWidth: 0, maxWidth: .infinity)
                            .padding(50)
                                .background(Color.init("naranja"))
                            .foregroundColor(.white)
                            .cornerRadius(16)
                            .font(.system(size: 18, weight: .bold))
                        }.shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                    }
                    
                    Spacer(minLength: 10)
                    
                    NavigationLink(destination: Text("Test"), tag: 1, selection: $selection){
                        Button(action: {}) {
                            Text("Populares")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding(50)
                                .background(Color.init(hex: "00b0ff"))
                            .foregroundColor(.white)
                            .cornerRadius(16)
                            .font(.system(size: 18, weight: .bold))
                        }.shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                    }
                    
                    Spacer(minLength: 10)
                    
                    NavigationLink(destination: Text("Test"), tag: 1, selection: $selection){
                        Button(action: {}) {
                            Text("Novedades")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding(50)
                                .background(Color.init(hex: "5e35b1"))
                            .foregroundColor(.white)
                            .cornerRadius(16)
                            .font(.system(size: 18, weight: .bold))
                        }.shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                    }
                    
                    Spacer(minLength: 10)
                    
                    NavigationLink(destination: Text("Test"), tag: 1, selection: $selection){
                        Button(action: {}) {
                            Text("Categorías")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding(15)
                                .background(Color.init(hex: "4db6ac"))
                            .foregroundColor(.white)
                            .cornerRadius(16)
                            .font(.system(size: 18, weight: .bold))
                        }.shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                    }
                }.padding(.horizontal, 8)
            }.navigationBarTitle("Buscar")
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
