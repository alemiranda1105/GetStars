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
    
    let cats: [Category] = [Category(name: "Sports"), Category(name: "Music"), Category(name: "Tv"), Category(name: "Movies")]
    
    var body: some View {
        List(self.cats) { c in
            NavigationLink(destination: SubcategoryView(cat: c.name).environmentObject(self.session)) {
                Text(LocalizedStringKey(c.name))
            }
        }.navigationBarTitle(Text("Categories"))
        .navigationBarItems(trailing:
            NavigationLink(destination: PaymentView(product: Product()).environmentObject(self.session)) {
                Image(systemName: "cart").resizable().frame(width: 28.0, height: 28.0)
            }.foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
        )
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#if DEBUG
struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView()
    }
}
#endif

struct Category: Identifiable {
    var id = UUID()
    var name: String
}
