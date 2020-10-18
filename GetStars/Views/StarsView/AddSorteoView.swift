//
//  AddSorteoView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 23/09/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct AddSorteoView: View {
    @EnvironmentObject var session: SessionStore
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @State var image = UIImage()
    @State var showImagePicker = false
    
    @State var name = ""
    @State var desc = ""
    @State var fecha = ""
    
    @State private var date = Date()
    
    @State var subido = false
    
    // Manejo de errores
    @State var error = ""
    @State var showError = false
    
    private func uploadSorteo() {
        let key: String = (self.session.data?.getUserKey())!
        let format = DateFormatter()
        format.dateFormat = "d/MM/y"
        
        if self.name == "" {
            self.error = "Write a name, please"
            self.showError = true
            return
        }
        if self.desc == "" {
            self.error = "Set a description, please"
            self.showError = true
            return
        }
        let today = format.string(from: Date())
        if today == format.string(from: self.date) {
            self.error = "The date cannot be the same as today"
            self.showError = true
            return
        }
        
        let imgData = self.image.jpegData(compressionQuality: 0.5)
        if imgData == nil {
            self.error = "An image must be upload"
            self.showError = true
            return
        }
        
        let datos: [String: String] = ["dueño": key,
                                       "nombre": self.name,
                                       "descripcion": self.desc,
                                       "fechaFinal": format.string(from: self.date)]
        
        let dg = DispatchGroup()
        let db = StarsDB()
        let st = StarsST()
        db.uploadSorteo(datos: datos, dg: dg)
        dg.notify(queue: DispatchQueue.global(qos: .background)) {
            print("Sorteo subido a la base de datos")
            let sorteoName = db.getSorteoName()
            st.uploadFotoSorteo(image: self.image, key: key, name: sorteoName, dg: dg)
            dg.wait()
            print("Imagen del sorteo subida")
            self.subido = true
        }
        
    }
    
    
    var body: some View {
        Group {
            if self.subido {
                VStack {
                    Text("The raffle have been uploaded correctly")
                        .font(.system(size: 22, weight: .bold))
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Go back")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .background(Color("naranja"))
                            .foregroundColor(.white)
                            .cornerRadius(50)
                            .font(.system(size: 18, weight: .bold))
                    }
                }
            } else {
                Form {
                    Section (header: Text("Image")){
                        Button(action: {
                            self.showImagePicker.toggle()
                        }) {
                            VStack(spacing: 2) {
                                Image(uiImage: self.image)
                                    .resizable()
                                    .scaledToFit()
                                
                                Text("Choose an image")
                                    .font(.system(size: 16, weight: .regular))
                            }.frame(alignment: .center)
                        }
                        .padding()
                    }
                    
                    Section(header: Text("Raffle's information:")) {
                        TextField(LocalizedStringKey("Name"), text: self.$name)
                        
                        if #available(iOS 14.0, *) {
                            NavigationLink(destination: (
                                VStack {
                                    Text("Description")
                                    TextEditor(text: self.$desc)
                                        .border(Color.black)
                                }.frame(height: 200, alignment: .center)
                                .padding(10)
                            )) {
                                Text("Description")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            
                        } else {
                            // Fallback on earlier versions
                            NavigationLink(destination: (
                                VStack {
                                    Text("Description")
                                    TextView(text: self.$desc)
                                        .border(Color.black)
                                }.frame(height: 200, alignment: .center)
                                .padding(10)
                            )) {
                                Text("Description")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            
                        }
                    }
                    
                    Section(header: Text("Finish date")) {
                        NavigationLink(destination: (
                            DatePicker(selection: self.$date, displayedComponents: .date) {
                                Text("Date:")
                            }.padding(10)
                        )) {
                            Text("Date")
                                .font(.system(size: 16, weight: .semibold))
                        }
                    }
                    
                    
                    Button(action: {
                        self.uploadSorteo()
                    }) {
                        Text("Upload raffle")
                    }
                    .padding()
                    .alert(isPresented: self.$showError) {
                        Alert(title: Text("Error"), message: Text(LocalizedStringKey(self.error)), dismissButton: .default(Text("OK")))
                    }
                    
                }
                .navigationBarTitle(Text("New raffle"))
                .sheet(isPresented: self.$showImagePicker) {
                    ImagePickerView(sourceType: .photoLibrary) { image in
                        self.image = image
                    }
                }
            }
        }
    }
}

struct AddSorteoView_Previews: PreviewProvider {
    static var previews: some View {
        AddSorteoView()
    }
}
