//
//  CreateLiveView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 08/09/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct CreateLiveView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var session: SessionStore
    
    @Binding var person: Person
    @State var precio: Double = 0.0
    
    @State var participantes = [[String: String]]()
    @State var nParticipantes = 0
    
    @State var mensaje = ""
    
    @State var participando = false
    
    // Manejo de errores
    @State var error = ""
    @State var showError = false
    
    // Filtro palabras
    private let filtro: [String] = ["cabrón", "cabron", "puta", "putón", "puton", "zorro", "mierda", "desgraciado", "hostias", "subnormal", "inútil", "inutil", "puto", "pene"]
    
    private func getLiveData() {
        let db = StarsDB()
        let dg = DispatchGroup()
        let key = self.person.getKey()
        
        db.readListaLive(key: key, dg: dg)
        dg.notify(queue: DispatchQueue.global(qos: .background)) {
            self.participantes = db.getListaParticipantesLive()
            self.nParticipantes = db.getNParticipantesLive()
            self.comprobarParticipacion()
            
            db.getProductPrice(product: "live", key: self.person.getKey(), dg: dg)
            dg.wait()
            print("Precio obtenido")
            self.precio = db.getPrice()
            
        }
    }
    
    private func comprobarParticipacion() {
        for j in self.participantes {
            for i in j {
                print(i.key)
                if i.key == self.session.session?.email {
                    self.participando = true
                    return
                }
            }
        }
        self.participando = false
    }
    
    private func checkMensaje() -> Bool {
        self.showError = false
        self.error = ""
        
        // Mensaje vacío
        if self.mensaje.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.error = "Escriba un mensaje, por favor"
            self.showError = true
            return false
        }
        
        //Longitud del mensaje
        if self.mensaje.count >= 80 {
            self.error = "El mensaje supera los 80 caracteres"
            self.showError = true
            return false
        }
        
        // Filtro de palabras ofensivas
        let array = self.mensaje.split(separator: " ")
        for m in array {
            for p in self.filtro {
                if m.lowercased() == p.lowercased() {
                    self.error = "No introduzca palabras ofensivas"
                    self.showError = true
                    return false
                }
            }
        }
        return true
    }
    
    private func uploadDedicatoria() {
        if checkMensaje() {
            let product = Product(price: self.precio, name: "Live", description: "Live de \(self.person.name)", image: URL(fileURLWithPath: ""), owner: self.person, isDedicated: true, productType: .live)
            product.message = self.mensaje
            self.session.cart.append(product)
            self.participando = true
        }
    }
    
    var body: some View {
        VStack {
            if self.participando {
                Text("Enhorabuena, tu video ha sido añadido a la cesta")
                    .font(.system(size: 22, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Volver atrás")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color("navyBlue"))
                        .foregroundColor(.white)
                        .cornerRadius(50)
                        .font(.system(size: 18, weight: .bold))
                }.padding()
                
            } else {
                
                Text("Aviso: el precio de este producto es de \(self.precio.dollarString)€")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 150, height: 80, alignment: .center)
                
                Spacer()
                
                Text("Su mensaje: \(80 - self.mensaje.count) caracteres restantes")
                    .font(.system(size: 17, weight: .regular))
                
                if #available(iOS 14.0, *) {
                    TextEditor(text: self.$mensaje)
                        .border(colorScheme == .dark ? Color("naranja"): Color("navyBlue"))
                        .padding()
                        .frame(width: UIScreen.main.bounds.width-10.0, height: 200, alignment: .center)
                    
                } else {
                    // Fallback on earlier versions
                    TextView(text: self.$mensaje)
                        .border(colorScheme == .dark ? Color("naranja"): Color("navyBlue"))
                        .padding()
                        .frame(width: UIScreen.main.bounds.width-10.0, height: 200, alignment: .center)
                    
                }
                
                Spacer()
                
                Button(action: {
                    self.uploadDedicatoria()
                }) {
                    Text("Añadirme: Quedan \(1000 - self.nParticipantes) puestos")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color("naranja"))
                        .foregroundColor(.white)
                        .cornerRadius(50)
                        .font(.system(size: 18, weight: .bold))
                }.padding()
                
                .alert(isPresented: self.$showError) {
                    Alert(title: Text("Error"), message: Text(LocalizedStringKey(self.error)), dismissButton: .default(Text("OK")))
                }
            }
        }.onAppear(perform: self.getLiveData)
    }
}

struct TextView: UIViewRepresentable {
    @Binding var text: String

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextView {

        let myTextView = UITextView()
        myTextView.delegate = context.coordinator

        myTextView.font = .systemFont(ofSize: 16)
        myTextView.isScrollEnabled = true
        myTextView.isEditable = true
        myTextView.isUserInteractionEnabled = true
        myTextView.backgroundColor = Color(hex: "FFFFFF").uiColor()

        return myTextView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }

    class Coordinator : NSObject, UITextViewDelegate {

        var parent: TextView

        init(_ uiTextView: TextView) {
            self.parent = uiTextView
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return true
        }

        func textViewDidChange(_ textView: UITextView) {
            print("text now: \(String(describing: textView.text!))")
            self.parent.text = textView.text
        }
    }
}

#if DEBUG
struct CreateLiveView_Previews: PreviewProvider {
    static var previews: some View {
        CreateLiveView(person: .constant(Person(name: "DEbug", description: "Debug", image: "", key: "")))
            .previewDevice("iPhone 11").environmentObject(SessionStore())
    }
}
#endif
