//
//  CreateLiveView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 08/09/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import StoreKit

struct CreateLiveView: View {
    private let langStr = Locale.current.languageCode
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var session: SessionStore
    
    @State var loading = true
    
    @Binding var person: Person
    @State var precio: Double = 0.0
    @State var skproduct = SKProduct()
    
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
        self.getSkProducts()
        let db = StarsDB()
        let dg = DispatchGroup()
        let key = self.person.getKey()
        
        db.readListaLive(key: key, dg: dg)
        dg.notify(queue: DispatchQueue.global(qos: .background)) {
            self.participantes = db.getListaParticipantesLive()
            self.nParticipantes = db.getNParticipantesLive()
            self.comprobarParticipacion()
            
//            db.getProductPrice(product: "live", key: self.person.getKey(), dg: dg)
//            dg.wait()
//            print("Precio obtenido")
//            self.precio = db.getPrice()
            self.precio = Double(truncating: self.skproduct.price)
            self.loading = false
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
            self.error = "Write a message, please"
            self.showError = true
            return false
        }
        
        //Longitud del mensaje
        if self.mensaje.count >= 80 {
            self.error = "The message exceeds 80 characters"
            self.showError = true
            return false
        }
        
        // Filtro de palabras ofensivas
        let array = self.mensaje.split(separator: " ")
        for m in array {
            for p in self.filtro {
                if m.lowercased() == p.lowercased() {
                    self.error = "Do not enter offensive words"
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
            // self.session.cart.append(product)
            product.addProductToAccount(session: self.session)
            self.participando = true
        }
    }
    
    private func purchase(product: SKProduct) {
        if self.checkMensaje() {
            if !IAPManager.shared.canMakePayments() {
                return
            } else {
                IAPManager.shared.buy(product: product) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(_):
                            print("Comprado")
                            self.uploadDedicatoria()
                        case .failure(let error):
                            print(error.localizedDescription)
                            self.error = "The puchase has not been completed, please try again"
                        }
                    }
                }
            }
        }
    }
    
    private func getSkProducts() {
        DispatchQueue.main.async {
            IAPManager.shared.getProducts { result in
                DispatchQueue.main.sync {
                    switch result {
                    case.success(let products):
                        for i in products {
                            let name = i.productIdentifier
                            if name == "live.video" {
                                self.skproduct = i
                                return
                            }
                        }
                    case.failure(let error):
                        print(error.localizedDescription)
                        // self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            if self.loading {
                ActivityIndicator(isAnimating: .constant(true), style: .large)
            } else {
                if self.participando {
                    Text("Congratulations, you live have been correctly added")
                        .font(.system(size: 22, weight: .bold))
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Go back")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .background(Color("navyBlue"))
                            .foregroundColor(.white)
                            .cornerRadius(50)
                            .font(.system(size: 18, weight: .bold))
                    }.padding()
                    
                } else {
                    
                    Text("\(self.skproduct.localizedDescription == "" ? "A dedicated video from the famous to you": self.skproduct.localizedDescription):\n \(self.precio.dollarString == "0.00" ? "59.99": self.precio.dollarString)€")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 18, weight: .semibold))
                    
                    Spacer()
                    
                    if self.langStr != "es" {
                        Text("\(80 - self.mensaje.count) characters remaining")
                            .font(.system(size: 17, weight: .regular))
                    } else {
                        Text("\(80 - self.mensaje.count) caracteres restantes")
                            .font(.system(size: 17, weight: .regular))
                    }
                    
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
                        self.purchase(product: self.skproduct)
                    }) {
                        if self.langStr != "es" {
                            Text("Join: \(1000 - self.nParticipantes) participants left")
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding()
                                .background(Color("naranja"))
                                .foregroundColor(.white)
                                .cornerRadius(50)
                                .font(.system(size: 18, weight: .bold))
                        } else {
                            Text("Añadirme: Quedan \(1000 - self.nParticipantes) puestos")
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding()
                                .background(Color("naranja"))
                                .foregroundColor(.white)
                                .cornerRadius(50)
                                .font(.system(size: 18, weight: .bold))
                        }
                    }.padding()
                    
                    .alert(isPresented: self.$showError) {
                        Alert(title: Text("Error"), message: Text(LocalizedStringKey(self.error)), dismissButton: .default(Text("OK")))
                    }
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
        CreateLiveView(person: .constant(Person(name: "Live", description: "Live description hehe", image: "", key: "")))
            .previewDevice("iPhone 11").environmentObject(SessionStore())
    }
}
#endif
