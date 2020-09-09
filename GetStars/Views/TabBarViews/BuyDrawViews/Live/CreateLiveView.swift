//
//  CreateLiveView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 08/09/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct CreateLiveView: View {
    @EnvironmentObject var session: SessionStore
    
    @Binding var person: Person
    
    @State var participantes = [String]()
    @State var nParticipantes = 0
    
    @State var participando = false
    
    private func getLiveData() {
        let db = StarsDB()
        let dg = DispatchGroup()
        let key = self.person.getKey()
        
        db.readListaLive(key: key, dg: dg)
        dg.notify(queue: DispatchQueue.global(qos: .background)) {
            self.participantes = db.getListaParticipantesLive()
            self.nParticipantes = db.getNParticipantesLive()
            self.comprobarParticipacion()
        }
    }
    
    private func comprobarParticipacion() {
        for i in self.participantes {
            if i == self.session.session?.email {
                self.participando = true
                return
            }
        }
        self.participando = false
    }
    
    var body: some View {
        VStack {
            if self.participando {
                Text("Enhorabuena, dentro de poco recibirás tu video")
                Text("\(1000 - self.nParticipantes)")
            } else {
                Text(person.name)
                Text("\(self.nParticipantes)")
                List(self.participantes, id: \.self) { participante in
                    Text(participante)
                }
                Button(action: {
                    print("GHolalalasjkdpasjd")
                    let db = StarsDB()
                    let dg = DispatchGroup()
                    db.añadirAlLive(key: self.person.getKey(), email: (self.session.session?.email)!, dg: dg)
                    dg.notify(queue: DispatchQueue.global(qos: .background)) {
                        self.getLiveData()
                    }
                }) {
                    Text("Añadirme al live: Quedan \(1000 - self.nParticipantes) puestos")
                }
            }
        }.onAppear(perform: self.getLiveData)
    }
}

struct CreateLiveView_Previews: PreviewProvider {
    static var previews: some View {
        CreateLiveView(person: .constant(Person(name: "DEbug", description: "Debug", image: "", key: "")))
    }
}
