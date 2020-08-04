//
//  CategoryView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 03/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct CategoryView: View {
    let cats: [Category] = [Category(name: "Deportes"), Category(name: "Musica"), Category(name: "Televisión"), Category(name: "Cine")]
    
    var body: some View {
        List(cats) { c in
            NavigationLink(destination: Text(c.name)) {
                HStack {
                    Text("\(c.name)")
                }
            }.navigationBarTitle("Categorías")
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
