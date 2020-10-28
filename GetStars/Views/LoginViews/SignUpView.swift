//
//  SignUpView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 07/07/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

import FirebaseCore
import FirebaseFirestore
import FirebaseStorage

struct SignUpView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var session: SessionStore
    
    @State var invitacion: String = ""
    
    @State var name: String = ""
    @State var email: String = ""
    
    @State var password: String = ""
    @State var secure: Bool = true
    
    @State var error: String = ""
    @State private var condiciones: Bool = false
    
    private var generos = [Text("🙎‍♂️Man"), Text("🙎‍♀️Women"), Text("Not say it")]
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
            error = "Introduce valid information"
            return
        }
        
        if !condiciones {
            error = "Accept conditions before continue"
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
        
        // Comprobación código de invitación
        let db = Firestore.firestore()
        let ref = db.collection("keyInvitaciones").document("key")
        ref.getDocument { doc, err in
            if err != nil {
                self.error = "Error, please try again"
                print(err?.localizedDescription ?? "")
                print("ERROR CODIGO INVITACION")
                return
            } else {
                let keys: [String] = doc?.data()!["key"] as! [String]
                for i in keys {
                    print(i)
                    if self.invitacion == i {
                        session.signUp(email: email, password: password) { (result, error) in
                            if let error = error {
                                self.error = error.localizedDescription
                            } else {
                                db.collection("keyInvitaciones").document("key")
                                    .updateData(["key": FieldValue.arrayRemove([i])])
                                self.email = ""
                                self.password = ""
                                
                                // Datos del usuario
                                self.session.data = UserData(nombre: self.name, sexo: sex, edad: age, fechaNacimiento: self.birthDate, autMan: 0, isPro: false)
                                self.session.db.createUserDB(session: self.session)
                                
                                let defaults = UserDefaults.standard
                                defaults.set(self.name, forKey: "name")
                                defaults.set(age, forKey: "age")
                                defaults.set(sex, forKey: "sex")
                                defaults.set(self.birthDate, forKey: "fechaNacimiento")
                                
                                defaults.set(self.session.data?.autMan, forKey: "AutMan")
                                
                                // Tutorial
                                defaults.set(true, forKey: "tutorial")
                                
                                defaults.synchronize()
                                return
                            }
                        }
                    }
                }
                self.error = "The code is not valid, please try again"
                return
            }
        }
    }
    
    var body: some View {
        Form {
            Section(header: Text("Genre")) {
                Picker(selection: $generoSeleccionado, label: Text("Genre")) {
                    ForEach(0 ..< generos.count) {
                        self.generos[$0]
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
            
            Section(header: Text("Invitation")) {
                Text("In order to sign up with us, you need an invitation code")
                    .font(.system(size: 18, weight: .thin))
                    .multilineTextAlignment(.center)
                TextField( "Invitation code", text: self.$invitacion)
                    .autocapitalization(.none)
            }
            
            Section(header: Text("Personal Information")) {
                TextField("Full name", text: $name)
                    .font(.system(size: 14))
                    .padding(8)
                
                NavigationLink(destination: (
                    DatePicker(selection: self.$fechaNacimiento, in: self.closedRange, displayedComponents: .date) {
                        Text("Date:")
                    }.frame(width: UIScreen.main.bounds.width, alignment: .center)
                    .padding(10)
                )) {
                    Text("Birthday (Optional)")
                        .font(.system(size: 16, weight: .regular))
                }
                
                
                TextField(LocalizedStringKey("Email"), text: $email)
                    .font(.system(size: 14))
                    .padding(8)
                    .keyboardType(.emailAddress).autocapitalization(.none)
            }
            
            Section(header: Text("Password")) {
                HStack {
                    if secure {
                        SecureField(LocalizedStringKey("Password"), text: $password)
                            .font(.system(size: 14))
                            .autocapitalization(.none)
                            .padding(8)
                    } else {
                        TextField(LocalizedStringKey("Password"), text: $password)
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
            
            Section(header: Text("Terms of use")) {
                NavigationLink(destination: TermsView()) {
                    Text("Read terms")
                }
                Toggle(isOn: $condiciones){
                    Text("Accept terms")
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
                Text("Sign up")
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(Color("naranja"))
                .font(.system(size: 18, weight: .bold))
            }
        }.navigationBarTitle(Text("Create an account"))
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
