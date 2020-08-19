//
//  ProfileView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 27/07/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var session: SessionStore
    
    @State var visible: Bool = true
    @State var downloading: Bool = true
    
    private func loadImage() {
        let group = DispatchGroup()
        print("Starting")
        let df = UserDefaults.standard
        let length = df.integer(forKey: "AutMan")
        for i in 0...length {
            self.session.st.downloadURL(session: self.session, type: "AutMan", index: i, dg: group)
            group.notify(queue: DispatchQueue.global(qos: .background)) {
                print("Terminado")
            }
        }
        self.session.autMan.sort {
            $0.id < $1.id
        }
        self.downloading = false
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if self.visible {
                    Image(systemName: colorScheme == .dark ? "person.crop.circle": "person.crop.circle.fill")
                    .resizable()
                    .scaledToFill()
                        .frame(width: 120, height: 120)
                        .padding()
                    
                    Text(self.session.data?.getName() ?? "Dev")
                        .font(.system(size: 20, weight: .thin))
                    
                    HStack(alignment: .center) {
                        Button(action: {
                            let impactMed = UIImpactFeedbackGenerator(style: .light)
                            impactMed.impactOccurred()
                            self.visible = false
                        }) {
                            Image(systemName: "arrow.up").resizable().frame(width: 22.0, height: 22.0)
                        }.foregroundColor(colorScheme == .dark ? Color.white: Color.black).padding()
                    }
                        
                    Spacer()
                    
                } else {
                    HStack {
                        Button(action: {
                            let impactMed = UIImpactFeedbackGenerator(style: .light)
                            impactMed.impactOccurred()
                            self.visible = true
                        }) {
                            Image(systemName: "arrow.down").resizable().frame(width: 22.0, height: 22.0)
                        }.foregroundColor(colorScheme == .dark ? Color.white: Color.black).padding()
                    }
                    
                    Spacer()
                    
                }
                
                if self.downloading {
                    Text("Cargando...").font(.system(size: 32, weight: .heavy)).multilineTextAlignment(.center).padding()
                } else {
                    GridStack(minCellWidth: 125, spacing: 5, numItems: self.session.url.count){ i, width in
                        NavigationLink(destination: AutographProfileView(url: self.session.url[i])) {
                            WebImage(url: self.session.url[i].url)
                            .resizable()
                            .placeholder(Image(systemName: "photo"))
                            .placeholder {
                                Rectangle().foregroundColor(.gray)
                            }
                            .indicator(.activity)
                            .transition(.fade(duration: 0.5))
                            .frame(width: width, height: width, alignment: .center)
                            .border(Color.black, width: 1)
                        }.buttonStyle(PlainButtonStyle()).padding(.vertical, 5)
                    }
                }
                
            }.navigationBarTitle(Text("Perfil"), displayMode: self.visible ? .automatic: .inline)
            .navigationBarItems(trailing:
                NavigationLink(destination: ConfigurationView().environmentObject(self.session)) {
                    Image(systemName: "gear").resizable().frame(width: 28.0, height: 28.0)
                }.foregroundColor(colorScheme == .dark ? Color.white: Color.black)
            )
        }.onAppear(perform: self.loadImage)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject(SessionStore())
    }
}
