//
//  ManageLiveView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 20/09/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct ManageLiveView: View {
    @EnvironmentObject var session: SessionStore
    
    @State var loading = true
    
    @State var participantes = [String]()
    
    private func readParticipantes() {
        let dg = DispatchGroup()
        let db = StarsDB()
        
        db.readListaLive(key: self.session.data?.getUserKey() ?? "", dg: dg)
        dg.notify(queue: DispatchQueue.global(qos: .background)) {
            self.participantes = db.getListaParticipantesLive()
            self.loading = false
        }
    }
    
    var body: some View {
        Group {
            if self.loading {
                ActivityIndicator(isAnimating: .constant(true), style: .large).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
                    .onAppear(perform: self.readParticipantes)
            } else {
                HStack {
                    Button(action: {
                        // Cambiar precio
                        
                    }) {
                        Text("Cambiar precio")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding(14)
                            .background(Color("naranja"))
                            .foregroundColor(.white)
                            .cornerRadius(50)
                    }
                }.padding()
                
                List(self.participantes, id: \.self) { participante in
                    NavigationLink(destination: LiveUserView(participante: .constant(participante), mensaje: .constant("Hola saludos a todos"))
                                    .navigationViewStyle(StackNavigationViewStyle())
                    ) {
                        Text(participante)
                    }
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ManageLiveView_Previews: PreviewProvider {
    static var previews: some View {
        ManageLiveView()
    }
}
