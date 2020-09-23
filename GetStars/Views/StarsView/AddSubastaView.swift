//
//  AddSubastaView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 23/09/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct AddSubastaView: View {
    @EnvironmentObject var session: SessionStore
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    // Datos subasta
    @State var image = UIImage()
    @State var desc = ""
    @State var name = ""
    @State var date = Date()
    @State var price: Double = 0.0
    
    // Manejo pantallas
    @State var subido = false
    @State var showImagePicker = false
    
    // Manejo de errores
    @State var error = ""
    @State var showError = false
    
    private func uploadSubasta() {
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
        
        self.price = Double(round(1000 * self.price) / 1000)
        print(self.price)
        
        let datos: [String: Any] = ["descripcion": self.desc,
                                    "dueño": key,
                                    "fechaFinal": format.string(from: self.date),
                                    "nombre": self.name,
                                    "precio": self.price,
                                    "ultimoParticipante": ""]
        
        let dg = DispatchGroup()
        let db = StarsDB()
        let st = StarsST()
        db.uploadSubasta(datos: datos, dg: dg)
        dg.notify(queue: DispatchQueue.global(qos: .background)) {
            print("Subasta subida a la base de datos")
            let subastaName = db.getSorteoName()
            st.uploadFotoSubasta(image: self.image, key: key, name: subastaName, dg: dg)
            dg.wait()
            print("Imagen del sorteo subida")
            self.subido = true
        }
        
    }
    
    var body: some View {
        Group {
            if self.subido {
                VStack {
                    Text("La subasta ha sido subida correctamente")
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
                        .padding()
                    }
                    
                    Section(header: Text("Datos de la subasta:")) {
                        TextField("Nombre de la subasta", text: self.$name)
                        
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
                    
                    Section(header: Text("Precio inicial")) {
                        Stepper("\(self.price.dollarString)€", onIncrement: {
                            self.price += 0.1
                        }, onDecrement: {
                            if (self.price - 0.1) > 0 {
                                self.price -= 0.1
                            }
                        })
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
                        self.uploadSubasta()
                    }) {
                        Text("Subir subasta")
                    }
                    .padding()
                    .alert(isPresented: self.$showError) {
                        Alert(title: Text("Error"), message: Text(LocalizedStringKey(self.error)), dismissButton: .default(Text("OK")))
                    }
                    
                }
                .navigationBarTitle(Text("Nueva subasta"))
                .sheet(isPresented: self.$showImagePicker) {
                    ImagePickerView(sourceType: .photoLibrary) { image in
                        self.image = image
                    }
                }
            }
        }
    }
}

struct AddSubastaView_Previews: PreviewProvider {
    static var previews: some View {
        AddSubastaView()
    }
}
