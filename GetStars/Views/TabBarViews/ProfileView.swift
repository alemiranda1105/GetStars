//
//  ProfileView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 27/07/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var session: SessionStore
    @State var autMan: [UIImage] = []
    
    @State var visible: Bool = true
    @State var downloading: Bool = true
    
    let names = ["Alejandro", "Pepe", "Paola",  "777", "9992", "kitty", "mario", "Alejandro", "Pepe", "Paola",  "777", "9992", "kitty", "mario","Alejandro", "Pepe", "Paola",  "777", "9992", "kitty", "mario"]
    
    private var imagesize = [180, 180]
    
    private func loadImage() {
        let group = DispatchGroup()
        print("Starting")
        let df = UserDefaults.standard
        let length = df.integer(forKey: "AutMan")
        for i in 0...length {
            self.session.st.downloadFile(session: self.session, type: "AutMan", index: i, dg: group)
            group.notify(queue: DispatchQueue.global(qos: .background)) {
                print("Terminado")
            }
        }
        self.downloading = false
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if self.visible {
                    Circle()
                        .fill(Color.init("navyBlue"))
                        .frame(width: 120, height: 120)
                        .padding()
                    
                    HStack {
                        Button(action: {
                            let impactMed = UIImpactFeedbackGenerator(style: .light)
                            impactMed.impactOccurred()
                            self.visible = false
                        }) {
                            Image(systemName: "arrow.up").resizable().frame(width: 28.0, height: 28.0)
                        }.foregroundColor(Color.black).padding()
                        
                        Spacer()
                        
                        NavigationLink(destination: ConfigurationView().environmentObject(self.session)) {
                            Image(systemName: "gear").resizable().frame(width: 28.0, height: 28.0)
                            }.foregroundColor(Color.black).padding()
                    }
                        
                    Spacer()
                    
                } else {
                    Button(action: {
                        let impactMed = UIImpactFeedbackGenerator(style: .light)
                        impactMed.impactOccurred()
                        self.visible = true
                    }) {
                        Image(systemName: "arrow.down").resizable().frame(width: 28.0, height: 28.0)
                    }.foregroundColor(Color.black).padding()
                    
                    Spacer()
                    
                }
                
                if self.downloading {
                    Text("Cargando...").font(.system(size: 32, weight: .heavy)).multilineTextAlignment(.center).padding()
                } else {
                    List(self.session.autMan) { img in
                        NavigationLink(destination: Text("Hola")) {
                            Image(uiImage: img.image).resizable().frame(width: 200, height: 200)
                        }
                    }
                }
                
            }.navigationBarTitle("\((self.session.data?.getName()) ?? "Dev")")
        }.onAppear(perform: self.loadImage)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject(SessionStore())
    }
}
