//
//  SignUpView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 07/07/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var session: SessionStore
    
    @State var name: String = ""
    @State var email: String = ""
    
    @State var password: String = ""
    @State var secure: Bool = true
    
    @State var error: String = ""
    @State private var condiciones: Bool = false
    
    private var generos = [Text("🙎‍♂️Hombre"), Text("🙎‍♀️Mujer"), Text("No decirlo")]
    @State private var generoSeleccionado = 0
    
    @State private var birthDate: String = ""
    @State var fechaNacimiento = Date()
    var closedRange: ClosedRange<Date> {
        let start = Calendar.current.date(byAdding: .year, value: -120, to: Date())!
        let end = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
            
        return start...end
    }
    
    func signUp() {
        if (name == "") {
            error = "Introduzca correctamente los datos"
            return
        }
        
        if !condiciones {
            error = "Acepte las condiciones antes de continuar"
            return
        }
        
        let format = DateFormatter()
        format.dateFormat = "d/MM/y"
        self.birthDate = format.string(from: self.fechaNacimiento)
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: self.fechaNacimiento, to: Date())
        let age: Int = ageComponents.year!
        
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
                self.error = "Reintentelo de nuevo"
        }
        
        session.signUp(email: email, password: password) { (result, error) in
            if let error = error {
                self.error = error.localizedDescription
            } else {
                self.email = ""
                self.password = ""
                
                // Datos del usuario
                self.session.data = UserData(nombre: self.name, sexo: sex, edad: age, fechaNacimiento: self.birthDate, autMan: 0, isPro: false, coinsAmount: 0)
                self.session.db.createUserDB(session: self.session)
                
                let defaults = UserDefaults.standard
                defaults.set(self.name, forKey: "name")
                defaults.set(age, forKey: "age")
                defaults.set(sex, forKey: "sex")
                defaults.set(self.birthDate, forKey: "fechaNacimiento")
                
                defaults.set(self.session.data?.autMan, forKey: "AutMan")
                
                defaults.synchronize()
            }
        }
    }
    
    var body: some View {
        /*VStack {
            ScrollView{
                VStack(spacing: 8) {
                    Picker(selection: $generoSeleccionado, label: Text("Género")) {
                        ForEach(0 ..< generos.count) {
                            //Text(self.generos[$0])
                            self.generos[$0]
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    TextField("Nombre completo", text: $name)
                        .font(.system(size: 14))
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .strokeBorder(colorScheme == .dark ? Color("naranja"): Color("navyBlue"), lineWidth: 1))
                    
                    TextField("Email", text: $email)
                        .font(.system(size: 14))
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .strokeBorder(colorScheme == .dark ? Color("naranja"): Color("navyBlue"), lineWidth: 1))
                        .keyboardType(.emailAddress).autocapitalization(.none)
                    
                    Text("Fecha de nacimiento").font(.system(size: 12, weight: .light))
                    
                    HStack {
                        TextField("DD", text: $day)
                            .font(.system(size: 14))
                            .padding(6)
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .strokeBorder(colorScheme == .dark ? Color("naranja"): Color("navyBlue"), lineWidth: 1))
                            .keyboardType(.decimalPad)
                        
                        TextField("MM", text: $month)
                            .font(.system(size: 14))
                            .padding(6)
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .strokeBorder(colorScheme == .dark ? Color("naranja"): Color("navyBlue"), lineWidth: 1))
                            .keyboardType(.decimalPad)
                        
                        TextField("AAAA", text: $year)
                            .font(.system(size: 14))
                            .padding(6)
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .strokeBorder(colorScheme == .dark ? Color("naranja"): Color("navyBlue"), lineWidth: 1))
                            .keyboardType(.decimalPad)
                    }
                    
                    HStack {
                        if secure {
                            SecureField("Contraseña", text: $password)
                                .font(.system(size: 14))
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 5)
                                        .strokeBorder(colorScheme == .dark ? Color("naranja"): Color("navyBlue"), lineWidth: 1))
                        } else {
                            TextField("Contraseña", text: $password)
                                .font(.system(size: 14))
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 5)
                                        .strokeBorder(colorScheme == .dark ? Color("naranja"): Color("navyBlue"), lineWidth: 1))
                        }
                        Button(action: {
                            self.secure.toggle()
                        }) {
                            if secure {
                                Image(systemName: "eye.slash")
                            } else {
                                Image(systemName: "eye")
                            }
                        }.foregroundColor(colorScheme == .dark ? Color.white : Color.blue)
                    }
                    
                    Toggle(isOn: $condiciones){
                        Text("Aceptar condiciones")
                            .font(.system(size: 16))
                    }.padding()
                    
                }.padding(.vertical, 8)
            
                if (error != ""){
                    Text(error)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.red)
                        .padding()
                }
                
                Button(action: signUp){
                    Text("Registrarse")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                        .stroke(Color("naranja"), lineWidth: 4))
                    .background(colorScheme == .dark ? Color("navyBlue").opacity(0.8) : Color.white)
                    .foregroundColor(Color("naranja"))
                    .border(Color("naranja"))
                    .cornerRadius(50)
                    .font(.system(size: 18, weight: .bold))
                }.padding(.vertical, 16)
            }
        }*/
        Form {
            Section(header: Text("Género")) {
                Picker(selection: $generoSeleccionado, label: Text("Género")) {
                    ForEach(0 ..< generos.count) {
                        //Text(self.generos[$0])
                        self.generos[$0]
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
            
            Section(header: Text("Datos personales")) {
                TextField("Nombre completo", text: $name)
                    .font(.system(size: 14))
                    .padding(8)
                
                NavigationLink(destination: (
                    DatePicker(selection: self.$fechaNacimiento, in: self.closedRange, displayedComponents: .date) {
                        Text("Fecha:")
                    }.padding(10)
                )) {
                    Text("Fecha de nacimiento")
                        .font(.system(size: 16, weight: .semibold))
                }
                
                
                TextField("Email", text: $email)
                    .font(.system(size: 14))
                    .padding(8)
                    .keyboardType(.emailAddress).autocapitalization(.none)
            }
            
            Section(header: Text("Contraseña")) {
                HStack {
                    if secure {
                        SecureField("Contraseña", text: $password)
                            .font(.system(size: 14))
                            .autocapitalization(.none)
                            .padding(8)
                    } else {
                        TextField("Contraseña", text: $password)
                            .font(.system(size: 14))
                            .autocapitalization(.none)
                            .padding(8)
                    }
                    Button(action: {
                        self.secure.toggle()
                    }) {
                        if secure {
                            Image(systemName: "eye.slash")
                        } else {
                            Image(systemName: "eye")
                        }
                    }.foregroundColor(colorScheme == .dark ? Color.white : Color.blue)
                }
            }
            
            Section(header: Text("Condiciones de uso")) {
                Toggle(isOn: $condiciones){
                    Text("Aceptar condiciones")
                        .font(.system(size: 16))
                }.padding()
            }
            
            if (error != ""){
                Text(error)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.red)
                    .padding()
            }
            
            Button(action: signUp){
                Text("Registrarse")
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(Color("naranja"))
                .font(.system(size: 18, weight: .bold))
            }
        }.navigationBarTitle(Text("Crea una cuenta"))
    }
}

#if DEBUG
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignUpView().previewDevice("iPhone 8")
            SignUpView().previewDevice("iPhone Xs")
        }
    }
}
#endif
