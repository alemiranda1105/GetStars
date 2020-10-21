////
////  BuyProView.swift
////  GetStars
////
////  Created by Alejandro Miranda on 24/09/2020.
////  Copyright © 2020 Marquelo S.L. All rights reserved.
////
//
//import SwiftUI
//
//struct BuyProView: View {
//    @EnvironmentObject var session: SessionStore
//
//    @Environment(\.colorScheme) var colorScheme
//    @Environment(\.presentationMode) var presentationMode
//
//    @State var loading = false
//    @State var suscrito = false
//
//    private func becomePro() {
//        let dg = DispatchGroup()
//        self.loading = true
//        self.session.db.startPro(email: (self.session.session?.email)!, dg: dg)
//        dg.notify(queue: DispatchQueue.global(qos: .background)) {
//            self.session.db.readDataUser(session: self.session, dg: dg)
//            dg.wait()
//            self.suscrito = true
//
//        }
//    }
//
//    var body: some View {
//        Group {
//            if self.loading {
//                ActivityIndicator(isAnimating: .constant(true), style: .large)
//                    .frame(alignment: .center)
//            } else {
//                VStack {
//
//                    Text("Siendo PRO obtendrás diversas ventajas:")
//                        .multilineTextAlignment(.center)
//                        .font(.system(size: 18, weight: .semibold))
//                        .padding()
//
//                    VStack {
//                        HStack {
//                            Image(systemName: "video.circle")
//                                .resizable()
//                                .frame(width: 30, height: 30, alignment: .center)
//                                .padding()
//                                .foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
//                            Text("La posibilidad de que tus famsosos favoritos graben vídeos para ti")
//                                .font(.system(size: 18, weight: .thin))
//                                .padding()
//                                .frame(width: UIScreen.main.bounds.width-90, alignment: .leading)
//                        }.frame(width: UIScreen.main.bounds.width-20)
//                        HStack {
//                            Image(systemName: "ticket")
//                                .resizable()
//                                .frame(width: 30, height: 30, alignment: .center)
//                                .padding()
//                                .foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
//                            Text("Acceso a sorteos y subastas de manera segura y con la confianza de que sean productos originales")
//                                .font(.system(size: 18, weight: .thin))
//                                .padding()
//                                .frame(width: UIScreen.main.bounds.width-90, alignment: .leading)
//                        }
//                        HStack {
//                            Image(systemName: "tv")
//                                .resizable()
//                                .frame(width: 30, height: 30, alignment: .center)
//                                .padding()
//                                .foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
//                            Text("Di adiós a los anuncios en toda la app")
//                                .font(.system(size: 18, weight: .thin))
//                                .padding()
//                                .frame(width: UIScreen.main.bounds.width-90, alignment: .leading)
//                        }
//                    }.frame(width: UIScreen.main.bounds.width-20)
//
//                    Text("Todo eso por 0,99€ al mes \n ¿Te lo vas a perder?")
//                        .multilineTextAlignment(.center)
//                        .font(.system(size: 18, weight: .bold))
//                        .padding()
//
//                    Button(action: {
//
//                        self.becomePro()
//
//                    }) {
//                        Text("Empezar")
//                            .frame(minWidth: 0, maxWidth: .infinity)
//                            .padding()
//                            .background(self.colorScheme == .dark ? Color("naranja"): Color("navyBlue"))
//                            .foregroundColor(.white)
//                            .cornerRadius(50)
//                            .font(.system(size: 18, weight: .bold))
//                    }
//                    .padding()
//                    .alert(isPresented: self.$suscrito) {
//                        Alert(title: Text("Completado"), message: Text("Bienvenido al PRO de GetStars"), dismissButton: .default(Text("Continuar")) {
//                            self.presentationMode.wrappedValue.dismiss()
//                        })
//                    }
//
//                }.navigationBarTitle(Text("¡PÁSATE AL PRO!"))
//            }
//        }
//    }
//}
//
//#if DEBUG
//struct BuyProView_Previews: PreviewProvider {
//    static var previews: some View {
//        BuyProView()
//            .previewDevice("iPhone 8")
//    }
//}
//#endif
