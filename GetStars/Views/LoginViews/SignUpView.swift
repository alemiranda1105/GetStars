//
//  SignUpView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 07/07/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject private var dataBase: DataBase
    
    @State var name: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var pass2: String = ""
    @State var error: String = ""
    @State private var condiciones: Bool = false
    
    private var generos = ["🙎‍♂️Hombre", "🙎‍♀️Mujer", "🧒Otro", "No decirlo"]
    @State private var generoSeleccionado = 0
    
    @State private var birthDate: String = ""
    @State private var day: String = ""
    @State private var month: String = ""
    @State private var year: String = ""
    
    @State var completed: Bool = false
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    private func checkPass() -> Bool {
        if (pass2 == password){
            return true
        } else {
            self.error = "Las contraseñas no coinciden"
            return false
        }
    }
    
    private func checkDate() -> Bool {
        let actualY = Calendar.current.component(.year, from: Date())
        if (Int(year)! < 1900 || Int(year)! > actualY - 1) {
            self.error = "Fecha incorrecta"
            return false
        }
        switch Int(month)! {
        case 01,03,05,07,08,10,12:
            if (Int(day)! < 1 || Int(day)! > 31) {
                self.error = "Fecha incorrecta"
                return false
            }
            return true
        case 02:
            if esBisiesto() {
                if (Int(day)! < 1 || Int(day)! > 29) {
                    self.error = "Fecha incorrecta"
                    return false
                }
                return true
            } else {
                if (Int(day)! < 1 || Int(day)! > 28) {
                    self.error = "Fecha incorrecta"
                    return false
                }
                return true
            }
            
        case 04, 06, 09, 11:
            if (Int(day)! < 1 || Int(day)! > 30) {
                self.error = "Fecha incorrecta"
                return false
            }
            return true
            
        default:
            self.error = "Fecha incorrecta"
            return false
        }
    }
    
    private func esBisiesto() -> Bool {
        let y = Int(year)!
        if y % 4 == 0 {
            if y % 100 == 0{
                if y % 400 == 0 {
                    return true
                }
                return false
            }
            return true
        }
        return false
    }
    
    private func checkAge() -> Int {
        let actualY = Calendar.current.component(.year, from: Date())
        let actualM = Calendar.current.component(.month, from: Date())
        let actualD = Calendar.current.component(.day, from: Date())
        
        if actualY > Int(year)! {
            if actualM < Int(month)! {
                return actualY - Int(year)! - 1
            } else if actualM > Int(month)! {
                return actualY - Int(year)! - 1
            } else {
                if actualD > Int(day)! {
                    return actualY - Int(year)!
                } else {
                    return actualY - Int(year)! - 1
                }
            }
        }
        
        return 0
        
    }
    
    func signUp() {
        if (name == "" || lastName == "") {
            error = "Introduzca correctamente los datos"
            return
        }
        
        if !condiciones {
            error = "Acepte las condiciones antes de continuar"
            return
        }
        
        if !checkDate(){ return }
        
        self.birthDate = self.day + "/" +  self.month + "/" + self.year
        let age: Int = checkAge()
        
        if !checkPass(){ return }
        
        var sex: String = ""
        
        switch self.generoSeleccionado {
            case 0:
                sex = "hombre"
                break
            case 1:
                sex = "mujer"
            case 2:
                sex = "otro"
            case 3:
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
                self.completed = true
                
                // Datos del usuario
                self.session.data = DataUser(nombre: self.name, apellidos: self.lastName, sexo: sex, edad: age, fechaNacimiento: self.birthDate)
                self.session.db.createUserDB(session: self.session)
                createFile(usuario: self.session.data!)
            }
        }
    }
    
    var body: some View {
        VStack {
            if !completed{

                ScrollView{
                    
                    VStack(spacing: 8) {
                        
                        Text("Crea una cuenta")
                            .font(.system(size: 32, weight: .heavy)).padding(8)
                        
                        Picker(selection: $generoSeleccionado, label: Text("Género")) {
                            ForEach(0 ..< generos.count) {
                                Text(self.generos[$0])
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                        
                        TextField("Nombre", text: $name)
                        .font(.system(size: 14)).padding(12).background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color.black, lineWidth: 1))
                        
                        TextField("Apellidos", text: $lastName)
                        .font(.system(size: 14)).padding(12).background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color.black, lineWidth: 1))
                        
                        TextField("Email", text: $email)
                            .font(.system(size: 14)).padding(12).background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color.black, lineWidth: 1)).keyboardType(.emailAddress)
                        
                        Text("Fecha de nacimiento").font(.system(size: 12, weight: .light))
                        
                        HStack {
                            TextField("DD", text: $day)
                                .font(.system(size: 14)).padding(4).background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color.black, lineWidth: 1))
                                .keyboardType(.decimalPad)
                            
                            TextField("MM", text: $month)
                                .font(.system(size: 14)).padding(4).background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color.black, lineWidth: 1))
                                .keyboardType(.decimalPad)
                            
                            TextField("AAAA", text: $year)
                                .font(.system(size: 14)).padding(4).background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color.black, lineWidth: 1))
                                .keyboardType(.decimalPad)
                        }
                        
                        SecureField("Contraseña", text: $password)
                        .font(.system(size: 14)).padding(12).background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color.black, lineWidth: 1))
                        
                        SecureField("Repite la contraseña", text: $pass2)
                        .font(.system(size: 14)).padding(12).background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color.black, lineWidth: 1))
                        
                        Toggle(isOn: $condiciones){
                            Text("Aceptar condiciones")
                        }.padding()
                        
                    }.padding(.vertical, 8)
                    
                    Button(action: signUp){
                        Text("Registrarse")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [.blue, .blue]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(50)
                        .font(.system(size: 18, weight: .bold))
                    }.padding(.vertical, 16)
                    
                    if (error != ""){
                        Text(error)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.red)
                            .padding()
                        
                    }
                }
                
            } else {
                Text("Cuenta creada con éxito")
                    .font(.system(size: 32, weight: .heavy))
                
                Text("Bienvenido a GetStars")
                    .font(.system(size: 18, weight: .medium)).foregroundColor(.gray)
                
                Spacer()
                
                Button(action: { self.mode.wrappedValue.dismiss() }){
                    Text("Continuar")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [.blue, .gray]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(50)
                        .font(.system(size: 18, weight: .bold))
                }.padding(.vertical, 16)
            }
            }.padding(.horizontal, 8).frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
