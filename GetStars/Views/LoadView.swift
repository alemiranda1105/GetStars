//
//  LoadView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 17/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct LoadView: View {
    @State private var fillPoint = 0.0
    
    private var animation: Animation {
        Animation.easeIn(duration: 1.0).repeatForever(autoreverses: false)
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
            Text("Cargando GetStars").padding()
            
        }
    }
}
