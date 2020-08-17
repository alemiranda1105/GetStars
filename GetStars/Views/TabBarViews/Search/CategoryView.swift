//
//  CategoryView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 03/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct CategoryView: View {
    @Environment(\.colorScheme) var colorScheme
    
    let cats: [Category] = [Category(name: "Deportes"), Category(name: "Musica"), Category(name: "Televisión"), Category(name: "Cine")]
    
    var body: some View {
        List(cats) { c in
            NavigationLink(destination: SubcategoryView(cat: c.name)) {
                Text(c.name)
            }
        }.navigationBarTitle("Categorías")
    }
}

struct ShowMoreButton: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var show: Bool
    
    var body: some View {
        Button(action: {
            self.show.toggle()
        }) {
            Text(self.show ? "Ver menos": "Ver más")
        }.frame(width: 250, height: 40)
        .padding(4)
        .background(Color("gris"))
        .foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
        .cornerRadius(8)
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView()
    }
}

struct Category: Identifiable {
    var id = UUID()
    var name: String
}
