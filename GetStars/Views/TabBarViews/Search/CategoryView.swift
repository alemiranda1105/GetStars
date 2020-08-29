//
//  CategoryView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 03/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct CategoryView: View {
    @EnvironmentObject var session: SessionStore
    
    @Environment(\.colorScheme) var colorScheme
    private let langStr = Locale.current.languageCode
    
    let cats: [Category] = [Category(name: "Deportes"), Category(name: "Musica"), Category(name: "Televisión"), Category(name: "Cine")]
    
    let enCats: [Category] = [Category(name: "Sports"), Category(name: "Music"), Category(name: "Tv"), Category(name: "Movies")]
    
    var body: some View {
        List(self.langStr == "en" ? enCats: cats) { c in
            NavigationLink(destination: SubcategoryView(cat: c.name).environmentObject(self.session)) {
                Text("\(c.name)")
            }
        }.navigationBarTitle(Text("Categorías"))
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
