//
//  ManageLiveView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 20/09/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

private struct Participante: Identifiable {
    let email: String
    let mensaje: String
    let id = UUID()
}

struct ManageLiveView: View {
    @EnvironmentObject var session: SessionStore
    
    @State var loading = true
    
    @State var participantes = [[String: String]]()
    
    @State private var listaParticipantes = [Participante]()
    
    private func readParticipantes() {
        let dg = DispatchGroup()
        let db = StarsDB()
        
        db.readListaLive(key: self.session.data?.getUserKey() ?? "", dg: dg)
        dg.notify(queue: DispatchQueue.global(qos: .background)) {
            self.participantes = db.getListaParticipantesLive()
            self.loading = false
            
            for i in self.participantes {
                for j in i {
                    let p = Participante(email: j.key, mensaje: j.value)
                    self.listaParticipantes.append(p)
                }
            }
            
        }
    }
    
    var body: some View {
        Group {
            if self.loading {
                ActivityIndicator(isAnimating: .constant(true), style: .large).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
                    .onAppear(perform: self.readParticipantes)
            } else {
                
                if self.listaParticipantes.count <= 0 {
                    Text("Por ahora no hay ningún participante pendiente")
                        .font(.system(size: 22, weight: .thin))
                        .padding()
                        .multilineTextAlignment(.center)
                } else {
                    List(self.listaParticipantes) { participante in
                        NavigationLink(destination: LiveUserView(participante: .constant(participante.email), mensaje: .constant(participante.mensaje))
                                        .navigationViewStyle(StackNavigationViewStyle())
                        ) {
                            Text(participante.email)
                        }
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
