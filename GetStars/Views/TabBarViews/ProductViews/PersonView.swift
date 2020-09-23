//
//  ProductView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 15/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct PersonView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var session: SessionStore
    
    @Binding var person: Person
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                ZStack {
                    GeometryReader { g in
                        WebImage(url: self.person.image).resizable()
                        .placeholder(Image(systemName: "photo"))
                        .placeholder {
                            Rectangle().foregroundColor(.gray)
                        }
                        .indicator(.activity)
                        .scaledToFill()
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
                    
                }.offset(x: 0, y: -180)
                .edgesIgnoringSafeArea(.top)
                .edgesIgnoringSafeArea(.horizontal)
                
                Text(self.person.description)
                    .font(.system(size: 16, weight: .regular))
                    .padding()
                    .padding(.top, -100)
                    .frame(width: UIScreen.main.bounds.width, height: 180)
                    .multilineTextAlignment(.leading)
                
                Text("Productos")
                    .cornerRadius(16)
                    .font(.system(size: 32, weight: .bold))
                    .padding(.top, -100)
                
                VStack(spacing: 8) {
                    NavigationLink(destination: FamousItems(item: .constant("aut"), person: self.$person)
                                    .navigationBarTitle("Autógrafo")
                                    .navigationBarHidden(false)
                                    .environmentObject(self.session)
                    ){
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
                    
                    
                    NavigationLink(destination: FamousItems(item: .constant("foto"), person: self.$person)
                                    .navigationBarTitle("Foto")
                                    .navigationBarHidden(false)
                                    .environmentObject(self.session)
                    ){
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
                    
                    
                    NavigationLink(destination: CreateLiveView(person: self.$person)
                                    .navigationBarTitle("Live")
                                    .navigationBarHidden(false)
                                    .environmentObject(self.session)
                    ){
                        HStack {
                            Image(systemName: self.colorScheme == .dark ? "camera.on.rectangle": "camera.on.rectangle.fill")
                            
                            Text("Live")
                                .font(.system(size: 18, weight: .bold))
                        }
                        
                    }.frame(minWidth: 0, maxWidth: .infinity)
                    .padding(15)
                    .background(Color("gris"))
                    .foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                    .cornerRadius(8)
                    
                }.padding(16)
                .padding(.top, -100)
                
            }
        }.navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "multiply.circle.fill").resizable().frame(width: 28.0, height: 28.0)
                        .foregroundColor(Color("gris"))
                }.shadow(color: Color.black.opacity(0.5), radius: 2, x: 0, y: 0)
        )
        
        
    }
}

#if DEBUG
struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PersonView(person: .constant(Person(name: "Antoñito Perez lopez", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec faucibus elit in viverra vehicula. Integer mattis turpis vitae suscipit placerat. Etiam sit amet risus blandit lectus vehicula luctus. Aliquam at rutrum tortor. Vivamus dictum id lorem eget rutrum. Pellentesque ullamcorper nibh sit amet dui auctor sodales. Cras ante ipsum, mollis vel rutrum eu, suscipit efficitur lacus. Curabitur interdum mi augue, id congue dui viverra ut. Vivamus erat tellus, euismod at pretium id, feugiat ac neque. Aliquam mollis, velit a volutpat.", image: "p1", key: ""))).environmentObject(SessionStore()).previewDevice(PreviewDevice(rawValue: "iPhone 8"))
            
            PersonView(person: .constant(Person(name: "Antoñito Perez lopez", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec faucibus elit in viverra vehicula. Integer mattis turpis vitae suscipit placerat. Etiam sit amet risus blandit lectus vehicula luctus. Aliquam at rutrum tortor. Vivamus dictum id lorem eget rutrum. Pellentesque ullamcorper nibh sit amet dui auctor sodales. Cras ante ipsum, mollis vel rutrum eu, suscipit efficitur lacus. Curabitur interdum mi augue, id congue dui viverra ut. Vivamus erat tellus, euismod at pretium id, feugiat ac neque. Aliquam mollis, velit a volutpat.", image: "p1", key: ""))).environmentObject(SessionStore()).previewDevice(PreviewDevice(rawValue: "iPhone 11"))
        }
    }
}
#endif
