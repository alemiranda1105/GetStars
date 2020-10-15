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
    
    @State var showModify: Bool = true
    
    func getProvider() {
        self.showModify = !(self.session.getAuthProvider() == "google" || self.self.session.getAuthProvider() == "facebook")
    }
    
    var body: some View {
        Form {
            Section(header: Text("Datos personales")) {
                NavigationLink(destination: ModifyDataView().environmentObject(self.session)) {
                    Text("Editar datos personales")
                }
                if self.showModify {
                    NavigationLink(destination: ModifyAuthDataView().environmentObject(self.session)) {
                        Text("Editar email y contraseña")
                    }
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
                    .sheet(isPresented: self.$eliminarDatos) {
                        DeleteUser(eliminarDatos: self.$eliminarDatos).environmentObject(self.session)
                    }
                    
                    Spacer()
                }
            }
        }
        .onAppear(perform: self.getProvider)
        .navigationBarTitle("Ajustes")
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
                sex = "otro"
            default:
                sex = "otro"
        }
        data["sexo"] = sex
        self.session.db.updateData(data: data, email: self.session.session?.email ?? "")
        self.session.db.readDataUser(session: self.session, dg: DispatchGroup())
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        Form {
            Section(header: Text("Information")) {
                HStack {
                    Text("Name:")
                    Spacer()
                    TextField("Name", text: self.$nombre)
                }
                HStack {
                    DatePicker(selection: self.$fechaNacimiento, in: self.closedRange, displayedComponents: .date) {
                        Text("Date:")
                    }.padding(10)
                    /*NavigationLink(destination: (
                        DatePicker(selection: self.$fechaNacimiento, in: self.closedRange, displayedComponents: .date) {
                            Text("Fecha:")
                        }.padding(10)
                    )) {
                        Text("Fecha de nacimiento")
                            .font(.system(size: 16, weight: .semibold))
                    }*/
                }
                VStack {
                    Text("Género")
                    Picker(selection: $generoSeleccionado, label: Text("Genre")) {
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
                    Text("Save changes").fontWeight(.bold)
                    Spacer()
                }
            }
        }.onAppear(perform: self.loadData)
    }
}

private struct ModifyAuthDataView: View {
    @EnvironmentObject var session: SessionStore
    @Environment(\.presentationMode) var presentationMode
    
    @State private var email: String = ""
    @State private var oldPassword: String = ""
    @State private var password: String = ""
    @State private var show: Bool = false
    
    @State private var error: String = ""
    
    private func loadData() {
        self.email = (self.session.session?.email)!
    }
    
    var body: some View {
        Form {
            Section {
                VStack {
                    Text("In order to update your data we need the current password")
                        .font(.system(size: 16, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                    Text("NOTE: In case of not remembering the password, you should contact the app support")
                        .font(.system(size: 14, weight: .thin))
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                }
                SecureField(LocalizedStringKey("Old password"), text: self.$password)
                    .font(.system(size: 14))
                    .autocapitalization(.none)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(8)
            }
            
            if self.error != "" {
                Text(LocalizedStringKey(self.error))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.red)
                    .padding()
            }
            
            Section(header: Text("Email")) {
                TextField("email", text: self.$email)
                Button(action: {
                    if self.email == (self.session.session?.email)! {
                        return
                    } else if !validateEmail(enteredEmail: self.email) {
                        self.error = "Write a valid email"
                    } else {
                        self.session.updateEmail(email: self.email, password: self.oldPassword)
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Update email")
                }
            }
            Section(header: Text("Password")) {
                Text("Password's length must be grater than 6 characters")
                    .font(.system(size: 16, weight: .semibold))
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                HStack {
                    if self.show {
                        TextField(LocalizedStringKey("New password"), text: self.$password)
                            .font(.system(size: 14))
                            .autocapitalization(.none)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .padding(8)
                        
                        Button(action: {
                            self.show.toggle()
                        }) {
                            Image(systemName: "eye.slash")
                        }
                    } else {
                        SecureField(LocalizedStringKey("New password"), text: self.$password)
                            .font(.system(size: 14))
                            .autocapitalization(.none)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .padding(8)
                        
                        Button(action: {
                            self.show.toggle()
                        }) {
                            Image(systemName: "eye")
                            
                        }
                    }
                }
                Button(action: {
                    if self.password.count < 6 {
                        self.error = "Password's length must be grater than 6 characters"
                    } else {
                        self.session.updatePassword(password: self.password)
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Update password")
                }
            }
        }.onAppear(perform: self.loadData)
    }
}

private struct DeleteUser: View {
    @EnvironmentObject var session: SessionStore
    @Binding var eliminarDatos: Bool
    @State private var password: String = ""
    @State private var show: Bool = false
    var body: some View {
        VStack {
            Text("You are about to delete your account!")
                .font(.system(size: 22, weight: .bold))
                .multilineTextAlignment(.center)
                .padding()
            
            Text("That means you will immediately lose all your purchases unless you have downloaded and stored them correctly")
                .font(.system(size: 18, weight: .thin))
                .multilineTextAlignment(.center)
                .padding()
            
            Text("Password")
                .font(.system(size: 14, weight: .bold))
                .multilineTextAlignment(.leading)
                .padding()
            
            HStack {
                if self.show {
                    TextField(LocalizedStringKey("Password"), text: self.$password)
                        .font(.system(size: 14))
                        .autocapitalization(.none)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(8)
                    
                    Button(action: {
                        self.show.toggle()
                    }) {
                        Image(systemName: "eye.slash")
                    }
                } else {
                    SecureField(LocalizedStringKey("Password"), text: self.$password)
                        .font(.system(size: 14))
                        .autocapitalization(.none)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(8)
                    
                    Button(action: {
                        self.show.toggle()
                    }) {
                        Image(systemName: "eye")
                        
                    }
                }
            }
            
            Spacer()
            
            Button(action: {
                self.session.deleteAccount(password: self.password)
                self.password = ""
                self.eliminarDatos = false
            }) {
                Text("Eliminar cuenta")
                    .font(.system(size: 16, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
        }.padding().accentColor(Color("tabbarColor"))
    }
}

#if DEBUG
struct ConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        // ConfigurationView().environmentObject(SessionStore())
        ModifyDataView().environmentObject(SessionStore())
    }
}
#endif
