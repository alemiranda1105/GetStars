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
    private let langStr = Locale.current.languageCode
    
    let cats: [Category] = [Category(name: "Deportes"), Category(name: "Musica"), Category(name: "Televisión"), Category(name: "Cine")]
    
    let enCats: [Category] = [Category(name: "Sports"), Category(name: "Music"), Category(name: "Tv"), Category(name: "Movies")]
    
    var body: some View {
        List(self.langStr == "en" ? enCats: cats) { c in
            NavigationLink(destination: SubcategoryView(cat: c.name)) {
                Text("\(c.name)")
            }
        }.navigationBarTitle(Text("Categorías"))
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
