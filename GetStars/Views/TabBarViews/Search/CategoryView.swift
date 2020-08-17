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
            NavigationLink(destination: DummyView(c: c.name)) {
                Text(c.name)
            }
        }.navigationBarTitle("Categorías")
    }
}

fileprivate struct DummyView: View {
    var c: String
    var body: some View {
        return GeometryReader { g in
            Group {
                ScrollView {
                    SubcategoryView(cat: self.c)
                        .frame(width: g.size.width)
                }
            }
        }
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
