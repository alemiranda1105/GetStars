//
//  ContentView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 30/06/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var session: SessionStore
    private let def = UserDefaults.standard
    
    private func getUser() {
        self.session.listen()
    }
    
    var body: some View{
        Group {
            if self.session.session == nil {
                WelcomeView().environmentObject(self.session)
            } else if self.session.signing || def.bool(forKey: "sign") {
                LoadIndicatorView().environmentObject(self.session)
            } else {
                TabBarView().environmentObject(self.session)
            }
        }.onAppear {
            self.getUser()
        }
    }
}

struct LoadIndicatorView: View {
    @EnvironmentObject var session: SessionStore
    @State private var fillPoint = 0.0
    
    private var animation: Animation {
        Animation.easeOut(duration: 1.0).repeatForever(autoreverses: false)
    }
    
    private func loadData() {
        let group = DispatchGroup()
        print("Starting")
        self.session.db.readDataUser(session: self.session, dg: group)
        group.notify(queue: DispatchQueue.global(qos: .background)) {
            print("Terminado inicio")
        }
    }
    
    var body: some View {
        VStack{
            Ring(fillPoint: fillPoint).stroke(Color("naranja"), lineWidth: 10)
                .frame(width: 100, height: 100)
                .onAppear() {
                    withAnimation(self.animation) {
                        self.fillPoint = 1.0
                    }
            }
            Text("Cargando").padding()
            
        }.onAppear {
            self.loadData()
        }
    }
}

struct Ring: Shape {
    var fillPoint: Double
    var delayPoint: Double = 0.5
    
    var animatableData: Double {
        get {return fillPoint}
        set {fillPoint = newValue}
    }
    
    func path(in rect: CGRect) -> Path {
        var start: Double = 0
        let end = 360 * fillPoint
        
        if fillPoint > delayPoint {
            start = (2 * fillPoint) * 360
        } else {
            start = 0
        }
        
        var path = Path()
        path.addArc(center: CGPoint(x: rect.size.width/2, y: rect.size.height/2),
                    radius: rect.size.width/2, startAngle: .degrees(start),
                    endAngle: .degrees(end),
                    clockwise: false)
        
        return path
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            //ContentView().environmentObject(SessionStore())
            LoadIndicatorView().environmentObject(SessionStore())
        }
    }
}
#endif
