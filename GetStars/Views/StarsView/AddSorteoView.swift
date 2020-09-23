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
            self.error = "Por favor, introduzca un nombre"
            self.showError = true
            return
        }
        if self.desc == "" {
            self.error = "Por favor, introduzca una descripción"
            self.showError = true
            return
        }
        let today = format.string(from: Date())
        if today == format.string(from: self.date) {
            self.error = "La fecha debe ser a partir de mañana"
            self.showError = true
            return
        }
        
        let imgData = self.image.jpegData(compressionQuality: 0.5)
        if imgData == nil {
            self.error = "Debe subir una imagen"
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
                    Text("El sorteo ha sido subido correctamente")
                        .font(.system(size: 22, weight: .bold))
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Volver")
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
                    Section (header: Text("Imagen")){
                        Button(action: {
                            self.showImagePicker.toggle()
                        }) {
                            VStack(spacing: 2) {
                                Image(uiImage: self.image)
                                    .resizable()
                                    .scaledToFit()
                                
                                Text("Seleccionar imagen")
                                    .font(.system(size: 16, weight: .regular))
                            }.frame(alignment: .center)
                        }
                        .foregroundColor(.black)
                        .padding()
                    }
                    
                    Section(header: Text("Datos del sorteo:")) {
                        TextField("Nombre del sorteo", text: self.$name)
                        
                        if #available(iOS 14.0, *) {
                            NavigationLink(destination: (
                                VStack {
                                    Text("Escriba la descripción")
                                    TextEditor(text: self.$desc)
                                        .border(Color.black)
                                }.frame(height: 200, alignment: .center)
                                .padding(10)
                            )) {
                                Text("Descripción")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            
                        } else {
                            // Fallback on earlier versions
                            NavigationLink(destination: (
                                VStack {
                                    Text("Escriba la descripción")
                                    TextView(text: self.$desc)
                                        .border(Color.black)
                                }.frame(height: 200, alignment: .center)
                                .padding(10)
                            )) {
                                Text("Descripción")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            
                        }
                    }
                    
                    Section(header: Text("Fecha de finalización")) {
                        NavigationLink(destination: (
                            DatePicker(selection: self.$date, displayedComponents: .date) {
                                Text("Fecha:")
                            }.padding(10)
                        )) {
                            Text("Fecha")
                                .font(.system(size: 16, weight: .semibold))
                        }
                    }
                    
                    
                    Button(action: {
                        self.uploadSorteo()
                    }) {
                        Text("Subir sorteo")
                    }
                    .padding()
                    .alert(isPresented: self.$showError) {
                        Alert(title: Text("Error"), message: Text(LocalizedStringKey(self.error)), dismissButton: .default(Text("OK")))
                    }
                    
                }
                .navigationBarTitle(Text("Nuevo sorteo"))
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
