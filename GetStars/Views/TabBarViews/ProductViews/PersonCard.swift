//
//  ProductCard.swift
//  GetStars
//
//  Created by Alejandro Miranda on 14/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase

struct PersonCard: View {
    @Binding var person: Person
    
    var body: some View {
        VStack {
            NavigationLink(destination: PersonView(person: self.$person)){
                ZStack {
                    
//                    Image(self.person.image).resizable().scaledToFill()
//                        .frame(minWidth: 0, maxWidth: .infinity)
//                        .frame(width: 350, height: 350)
//                        .cornerRadius(16)
//                        .overlay(RoundedRectangle(cornerRadius: 15)
//                            .stroke(Color.clear, lineWidth: 1))
                    WebImage(url: self.person.image).resizable()
                    .placeholder(Image(systemName: "photo"))
                    .placeholder {
                        Rectangle().foregroundColor(.gray)
                    }
                    .indicator(.activity)
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(width: 350, height: 350)
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.clear, lineWidth: 1))
                    
                    
                    VStack {
                        HStack(alignment: .lastTextBaseline) {
                            Text("\(self.person.name)")
                                .foregroundColor(Color.white)
                                .cornerRadius(16)
                                .font(.system(size: 32, weight: .bold))
                        }.shadow(color: Color.black.opacity(0.9), radius: 5, x: 2, y: 0)
                            .padding(.top, 280)
                    }
                }
                
            }.shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                .buttonStyle(PlainButtonStyle())
            
            Spacer(minLength: 16)
        }
    }
}

fileprivate struct DummyView: View {
    @Binding var item: Person
    var body: some View {
        return GeometryReader { g in
            Group {
                ScrollView {
                    PersonView(person: self.$item).frame(width: g.size.width)
                }
            }
        }
    }
}

#if DEBUG
struct ProductCard_Previews: PreviewProvider {
    static var previews: some View {
        PersonCard(person: .constant(Person(name: "Antoñito Perez lopez", description: "prueba", image: "p1")))
    }
}
#endif
