//
//  ProductView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 15/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct PersonView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @Binding var person: Person
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                ZStack {
                    HStack {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "multiply.circle.fill").resizable().frame(width: 28.0, height: 28.0)
                                .foregroundColor(Color.gray)
                        }.padding(16)
                            .padding(.bottom, 16)
                        Spacer()
                    }.zIndex(1000)
                    
                    GeometryReader { g in
                        Image(self.person.image).resizable().scaledToFill()
                            .frame(width: g.size.width, height: (g.size.height+165), alignment: .center)
                            .cornerRadius(16)
                            .overlay(RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.clear, lineWidth: 1))
                    }.padding(.bottom, 16)
                        
                    VStack {
                        HStack(alignment: .lastTextBaseline) {
                            Text("\(self.person.name)")
                                .foregroundColor(Color.white)
                                .cornerRadius(16)
                                .font(.system(size: 32, weight: .bold))
                        }.shadow(color: Color.black.opacity(0.9), radius: 5, x: 2, y: 0)
                            .padding(.top, 280)
                    }
                    
                }.padding(.top, -140)
                .edgesIgnoringSafeArea(.top)
                .edgesIgnoringSafeArea(.horizontal)
                
                Text(self.person.description)
                    .font(.system(size: 16, weight: .regular))
                    .padding()
                    .padding(.top, 100)
                    .frame(width: 400, height: 300)
                    .multilineTextAlignment(.leading)
                
                Text("Productos")
                    .cornerRadius(16)
                    .font(.system(size: 32, weight: .bold))
                
                VStack(spacing: 8) {
                    Button(action: {}){
                        HStack {
                            Image(systemName: "pencil.and.outline")
                            
                            Text("Autógrafo")
                                .font(.system(size: 18, weight: .bold))
                        }
                        
                    }.frame(minWidth: 0, maxWidth: .infinity)
                    .padding(15)
                    .background(Color("gris"))
                    .foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                    .cornerRadius(8)
                    
                    
                    Button(action: {}){
                        HStack {
                            Image(systemName: self.colorScheme == .dark ? "camera": "camera.fill")
                            
                            Text("Fotos")
                                .font(.system(size: 18, weight: .bold))
                        }
                        
                    }.frame(minWidth: 0, maxWidth: .infinity)
                    .padding(15)
                    .background(Color("gris"))
                    .foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                    .cornerRadius(8)
                    
                    
                    Button(action: {}){
                        HStack {
                            Image(systemName: self.colorScheme == .dark ? "camera.on.rectangle": "camera.on.rectangle.fill")
                            
                            Text("Selfie")
                                .font(.system(size: 18, weight: .bold))
                        }
                        
                    }.frame(minWidth: 0, maxWidth: .infinity)
                    .padding(15)
                    .background(Color("gris"))
                    .foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                    .cornerRadius(8)
                    
                }.padding(16)
                
            }
        }.navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

#if DEBUG
struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PersonView(person: .constant(Person(name: "Antoñito Perez lopez", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec faucibus elit in viverra vehicula. Integer mattis turpis vitae suscipit placerat. Etiam sit amet risus blandit lectus vehicula luctus. Aliquam at rutrum tortor. Vivamus dictum id lorem eget rutrum. Pellentesque ullamcorper nibh sit amet dui auctor sodales. Cras ante ipsum, mollis vel rutrum eu, suscipit efficitur lacus. Curabitur interdum mi augue, id congue dui viverra ut. Vivamus erat tellus, euismod at pretium id, feugiat ac neque. Aliquam mollis, velit a volutpat.", image: "p1"))).previewDevice(PreviewDevice(rawValue: "iPhone 8"))
            
            PersonView(person: .constant(Person(name: "Antoñito Perez lopez", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec faucibus elit in viverra vehicula. Integer mattis turpis vitae suscipit placerat. Etiam sit amet risus blandit lectus vehicula luctus. Aliquam at rutrum tortor. Vivamus dictum id lorem eget rutrum. Pellentesque ullamcorper nibh sit amet dui auctor sodales. Cras ante ipsum, mollis vel rutrum eu, suscipit efficitur lacus. Curabitur interdum mi augue, id congue dui viverra ut. Vivamus erat tellus, euismod at pretium id, feugiat ac neque. Aliquam mollis, velit a volutpat.", image: "p1"))).previewDevice(PreviewDevice(rawValue: "iPhone 11"))
            
            PersonView(person: .constant(Person(name: "Antoñito Perez lopez", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec faucibus elit in viverra vehicula. Integer mattis turpis vitae suscipit placerat. Etiam sit amet risus blandit lectus vehicula luctus. Aliquam at rutrum tortor. Vivamus dictum id lorem eget rutrum. Pellentesque ullamcorper nibh sit amet dui auctor sodales. Cras ante ipsum, mollis vel rutrum eu, suscipit efficitur lacus. Curabitur interdum mi augue, id congue dui viverra ut. Vivamus erat tellus, euismod at pretium id, feugiat ac neque. Aliquam mollis, velit a volutpat.", image: "p1"))).previewDevice(PreviewDevice(rawValue: "iPad Air (3rd generation)"))
        }
    }
}
#endif
