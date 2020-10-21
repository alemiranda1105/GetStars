//
//  LiveCard.swift
//  GetStars
//
//  Created by Alejandro Miranda on 08/09/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct LiveCard: View {
    private let langStr = Locale.current.languageCode
    @EnvironmentObject var session: SessionStore
    
    @Binding var person: Person
    
    @State var nParticipantes = 0
    
    private func getLiveData() {
        let db = StarsDB()
        let dg = DispatchGroup()
        let key = self.person.getKey()
        
        db.readListaLive(key: key, dg: dg)
        dg.notify(queue: DispatchQueue.global(qos: .background)) {
            self.nParticipantes = db.getNParticipantesLive()
        }
    }
    
    var body: some View {
        VStack {
            NavigationLink(destination: CreateLiveView(person: self.$person).environmentObject(self.session)){
                ZStack {
                    
                    WebImage(url: self.person.image).resizable()
                    .placeholder(Image(systemName: "photo"))
                    .placeholder {
                        Rectangle().foregroundColor(.gray)
                    }
                    .indicator(.activity)
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(width: 350, height: 350)
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.clear, lineWidth: 1))
                    
                    VStack {
                        VStack(alignment: .center) {
                            Text("\(self.person.name)")
                                .foregroundColor(Color.white)
                                .cornerRadius(16)
                                .font(.system(size: 32, weight: .bold))
                                .lineLimit(1)
                                .frame(width: 350)
                            if self.langStr == "es" {
                                Text("Participantes: \(self.nParticipantes) de 1000")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24, weight: .bold))
                            } else {
                                Text("Participants: \(self.nParticipantes) of 1000")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24, weight: .bold))
                            }
                        }.shadow(color: Color.black.opacity(0.9), radius: 5, x: 2, y: 0)
                            .padding(.top, 280)
                    }
                }
                
            }.shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                .buttonStyle(PlainButtonStyle())
            
            Spacer(minLength: 16)
        }.onAppear(perform: self.getLiveData)
    }
}

