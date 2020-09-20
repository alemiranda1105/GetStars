//
//  ChangeProductImageView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 18/09/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct ChangeProductImageView: View {
    @EnvironmentObject var session: SessionStore
    
    @Binding var goBack: Bool
    @Binding var product: String
    
    @Binding var image: UIImage
    @State var showImagePicker = true
    
    private func uploadImage() {
        let st = StarsST()
        let dg = DispatchGroup()
        
        let img = self.image.jpegData(compressionQuality: 0.8)
        
        if img == nil {
            self.goBack = false
            return
        }
        
        st.uploadNewImage(key: self.session.data?.getUserKey() ?? "", type: self.product, data: img!, dg: dg)
        dg.notify(queue: DispatchQueue.global(qos: .background)) {
            print("Subida terminada")
            self.goBack = false
        }
    }
    
    var body: some View {
        GeometryReader { g in
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        
                        self.goBack = false
                
                    }) {
                        Text("Cancelar")
                    }
                }.padding()
                
                Image(uiImage: self.image)
                    .resizable()
                    .cornerRadius(15)
                    .overlay(RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.clear, lineWidth: 1))
                    .scaledToFit()
                    .frame(width: g.size.width, height: g.size.height/2, alignment: .center)
                
                Spacer()
                
                Button(action: {
                    // Editar imagen
                    self.showImagePicker.toggle()
                    
                }) {
                    Text("Reelegir imagen")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding(14)
                        .background(Color("navyBlue"))
                        .foregroundColor(.white)
                        .cornerRadius(50)
                }.padding(8)
                
                Button(action: {
                    // Subir imagen
                    self.uploadImage()
                    
                }) {
                    Text("Subir imagen")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding(14)
                        .background(Color("naranja"))
                        .foregroundColor(.white)
                        .cornerRadius(50)
                }.padding(8)
                
            }.sheet(isPresented: self.$showImagePicker) {
                ImagePickerView(sourceType: .photoLibrary) { image in
                    self.image = image
                }
            }
        }
    }
}

struct ChangeProductImageView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeProductImageView(goBack: .constant(false), product: .constant(""), image: .constant(UIImage()))
    }
}
