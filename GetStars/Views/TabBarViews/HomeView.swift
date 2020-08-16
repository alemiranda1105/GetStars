//
//  HomeView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 27/07/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var data: [Product] = [
        Product(name: "Persona 1", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec faucibus elit in viverra vehicula. Integer mattis turpis vitae suscipit placerat. Etiam sit amet risus blandit lectus vehicula luctus. Aliquam at rutrum tortor. Vivamus dictum id lorem eget rutrum. Pellentesque ullamcorper nibh sit amet dui auctor sodales. Cras ante ipsum, mollis vel rutrum eu, suscipit efficitur lacus. Curabitur interdum mi augue, id congue dui viverra ut. Vivamus erat tellus, euismod at pretium id, feugiat ac neque. Aliquam mollis, velit a volutpat.", subtitle: "", image: "p1"),
        Product(name: "Persona 2", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec faucibus elit in viverra vehicula. Integer mattis turpis vitae suscipit placerat. Etiam sit amet risus blandit lectus vehicula luctus. Aliquam at rutrum tortor. Vivamus dictum id lorem eget rutrum. Pellentesque ullamcorper nibh sit amet dui auctor sodales. Cras ante ipsum, mollis vel rutrum eu, suscipit efficitur lacus. Curabitur interdum mi augue, id congue dui viverra ut. Vivamus erat tellus, euismod at pretium id, feugiat ac neque. Aliquam mollis, velit a volutpat.", subtitle: "", image: "p2")]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Button(action: { }){
                        Text("¡PÁSATE AL PRO!")
                            .font(.system(size: 25, weight: .bold))
                        
                    }.frame(minWidth: 0, maxWidth: .infinity)
                        .padding(48)
                        .background(RoundedRectangle(cornerRadius: 16)
                        .fill(Color.init("gris")))
                        .foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                    
                    ForEach(0..<self.data.count, id: \.self) { item in
                        ProductCard(item: self.$data[item])
                    }
                    
                }.padding(.top, 20).padding(.horizontal, 32)
            }.navigationBarTitle("Inicio")
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView().previewDevice(PreviewDevice(rawValue: "iPhone 8"))
            HomeView().previewDevice(PreviewDevice(rawValue: "iPhone 11"))
        }
    }
}
#endif
