//
//  UserLiveList.swift
//  GetStars
//
//  Created by Alejandro Miranda on 22/09/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI


private struct Famoso: Identifiable {
    let name: String
    let key: String
    let id = UUID()
    
    func isContained(array: [Famoso]) -> Bool {
        for i in array {
            if i.key == self.key {
                return true
            }
        }
        return false
    }
}

struct UserLiveList: View {
    @EnvironmentObject var session: SessionStore
    
    @State private var datos = [Famoso]()
    
    @State var loading = true
    
    // Errores
    @State var error = ""
    
    private func contains(i: String, array: [String]) -> Bool {
        for s in array {
            if i == s {
                print("Contenida")
                return true
            }
        }
        print("Nope")
        return false
    }
    
    private func getLives() {
        let liveList = self.session.data?.compras["live"] ?? [String]()
        if liveList.count <= 0 {
            self.error = "No se ha adquirido ningún live, acuda a nuestra tienda para descubrir una nueva experiencia"
            self.loading = false
            return
        }
        let db = StarsDB()
        let dg = DispatchGroup()
        db.readKeys(dg: dg)
        dg.notify(queue: DispatchQueue.global(qos: .userInitiated)) {
            let keys = db.getKeys()
            for i in keys {
                if contains(i: i, array: liveList) {
                    db.readFamous(key: i, dg: dg)
                    dg.wait()
                    
                    print("Famoso LiveList leído")
                    let name = db.getName()
                    let f = Famoso(name: name, key: i)
                    if !f.isContained(array: self.datos) {
                        self.datos.append(f)
                    }
                    self.loading = false
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            if self.loading {
                ActivityIndicator(isAnimating: .constant(true), style: .large)
            } else {
                if self.error != "" {
                    Text(LocalizedStringKey(self.error))
                        .multilineTextAlignment(.center)
                        .font(.system(size: 22, weight: .thin))
                        .padding()
                } else {
                    List(self.datos) { famous in
                        NavigationLink(destination: UserLivePreview(famous: .constant(famous.key))) {
                            Text(famous.name)
                        }
                    }
                }
            }
        }.navigationBarTitle(Text("Live"), displayMode: .automatic)
        .onAppear(perform: self.getLives)
    }
}

struct UserLivePreview: View {
    @EnvironmentObject var session: SessionStore
    
    @Binding var famous: String
    @State var loading = true
    
    @State var urls = [UrlLoader]()
    
    func getAllLives() {
        self.urls.removeAll()
        let dg = DispatchGroup()
        self.session.st.getAllLives(email: self.session.session?.email ?? "", key: self.famous, dg: dg)
        dg.notify(queue: DispatchQueue.global(qos: .userInitiated)) {
            print("Lives obtenidos en livepreview")
            self.urls = self.session.st.getItemsUrl()
            self.loading = false
        }
    }
    
    var body: some View {
        VStack {
            if self.loading {
                ActivityIndicator(isAnimating: .constant(true), style: .large)
            } else {
                if self.urls.count <= 0 {
                    Text("No tiene ningún live de este famoso o ha ocurrido un error, reinténtelo de nuevo")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 22, weight: .thin))
                        .padding()
                } else {
                    List(self.urls) { video in
                        NavigationLink(destination: UserLivePlayerView(video: .constant(video.url))){
                            Text("Live de \(self.famous) \(video.id)")
                        }
                    }
                }
            }
        }.onAppear(perform: self.getAllLives)
    }
}
