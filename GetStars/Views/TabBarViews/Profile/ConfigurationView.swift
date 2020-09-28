//
//  ConfigurationView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 05/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct ConfigurationView: View {
    @EnvironmentObject var session: SessionStore
    @Environment(\.colorScheme) var colorScheme
    
    private let appVersion = UIApplication.appVersion
    
    @State var showAlert: Bool = false
    @State var showAlert2: Bool = false
    @State var eliminarDatos: Bool = false
    
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        Form {
            Section(header: Text("Datos personales")) {
                NavigationLink(destination: ModifyDataView().environmentObject(self.session)) {
                    Text("Editar datos personales")
                }
                NavigationLink(destination: Text("Cambiar suscripción")) {
                    Text("Cambiar suscripción")
                }
            }
            Section(header: Text("Información")) {
                HStack {
                    Text("Version")
                    Spacer()
                    Text(self.appVersion ?? "1.0")
                }
                NavigationLink(destination: SupportView()) {
                    Text("Soporte")
                }
            }
            Section {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        self.showAlert = true
                    }) {
                        Text("Cerrar sesión").foregroundColor(Color("naranja"))
                    }.alert(isPresented: $showAlert) {
                        Alert(title: Text("Aviso"), message: Text("¿Seguro que desea cerrar sesión?"), primaryButton: .destructive(Text("Cerrar sesión")){
                                self.session.signOut()
                            }, secondaryButton: .cancel(Text("Cancelar")))
                    }
                    
                    Spacer()
                }
            }
            
            Section {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        self.showAlert2 = true
                    }) {
                        HStack {
                            Image(systemName: "trash").foregroundColor(.red)
                            Text("Eliminar cuenta").foregroundColor(.red).fontWeight(.bold)
                        }
                    }.alert(isPresented: $showAlert2) {
                        Alert(title: Text("Aviso"), message: Text("Está a punto de eliminar su cuenta, ¿Desea continuar?"), primaryButton: .destructive(Text("Eliminar")){
                                self.eliminarDatos = true
                            }, secondaryButton: .cancel(Text("Cancelar")))
                    }
                    
                    Spacer()
                }
            }
        }.navigationBarTitle("Ajustes")
    }
}

private struct ModifyDataView: View {
    @EnvironmentObject var session: SessionStore
    @Environment(\.presentationMode) var presentationMode
    
    @State var nombre = ""
    
    @State var fechaNacimiento = Date()
    var closedRange: ClosedRange<Date> {
        let start = Calendar.current.date(byAdding: .year, value: -120, to: Date())!
        let end = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
            
        return start...end
    }
    
    @State var gen = ""
    private var generos = [Text("🙎‍♂️Hombre"), Text("🙎‍♀️Mujer"), Text("No decirlo")]
    @State private var generoSeleccionado = 0
    
    private func loadData() {
        let datos: [String: Any] = (self.session.data?.getData())!
        
        // Nombre
        self.nombre = datos["nombre"] as! String
        
        // Fecha
        let format = DateFormatter()
        format.dateFormat = "d/MM/y"
        self.fechaNacimiento = format.date(from: datos["fechaNacimiento"] as! String) ?? Date()
        
        // Genero
        let gen = datos["sexo"] as! String
        switch gen {
        case "hombre":
            self.generoSeleccionado = 0
            break
        case "mujer":
            self.generoSeleccionado = 1
            break
        case "null":
            self.generoSeleccionado = 2
            break
        case "Google":
            self.generoSeleccionado = 2
            break
        default:
            self.generoSeleccionado = 2
            break
        }
        
    }
    
    private func saveChanges() {
        var data = [String: Any]()
        
        data["nombre"] = self.nombre
        
        let format = DateFormatter()
        format.dateFormat = "d/MM/y"
        let fecha = format.string(from: self.fechaNacimiento)
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: self.fechaNacimiento, to: Date())
        let age: Int = ageComponents.year!
        print("fecha: " + fecha)
        print("edad: \(age)")
        
        data["fechaNacimiento"] = fecha
        data["edad"] = age
        
        var sex: String = ""
        switch self.generoSeleccionado {
            case 0:
                sex = "hombre"
                break
            case 1:
                sex = "mujer"
            case 2:
                sex = "null"
            default:
                sex = "null"
        }
        data["sexo"] = sex
        /*self.session.db.updateData(data: data, email: self.session.session?.email ?? "")
        self.session.db.readDataUser(session: self.session, dg: DispatchGroup())
        self.presentationMode.wrappedValue.dismiss()*/
    }
    
    var body: some View {
        Form {
            Section(header: Text("Datos")) {
                HStack {
                    Text("Nombre")
                    Spacer()
                    TextField("Nombre", text: self.$nombre)
                }
                HStack {
                    NavigationLink(destination: (
                        DatePicker(selection: self.$fechaNacimiento, in: self.closedRange, displayedComponents: .date) {
                            Text("Fecha:")
                        }.padding(10)
                    )) {
                        Text("Fecha de nacimiento")
                            .font(.system(size: 16, weight: .semibold))
                    }
                }
                VStack {
                    Text("Género")
                    Picker(selection: $generoSeleccionado, label: Text("Género")) {
                        ForEach(0 ..< generos.count) {
                            //Text(self.generos[$0])
                            self.generos[$0]
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
            }
            Button(action: {
                self.saveChanges()
            }) {
                HStack {
                    Spacer()
                    Image(systemName: "square.and.arrow.down")
                    Text("Guardar cambios").fontWeight(.bold)
                    Spacer()
                }
            }
        }.onAppear(perform: self.loadData)
    }
}

struct ConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        // ConfigurationView().environmentObject(SessionStore())
        ModifyDataView().environmentObject(SessionStore())
    }
}
