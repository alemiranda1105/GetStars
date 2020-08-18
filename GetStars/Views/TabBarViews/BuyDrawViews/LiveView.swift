//
//  LiveView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 18/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct LiveView: View {
    var body: some View {
        VStack {
            Text("Proximamente")
                .padding()
                .font(.system(size: 32, weight: .bold))
            Text("Estamos trabajando para que puedas conectar con las estrellas de una manera en la que nunca lo habías hecho")
                .padding()
                .font(.system(size: 24, weight: .thin))
                .multilineTextAlignment(.center)
        }
    }
}

struct LiveView_Previews: PreviewProvider {
    static var previews: some View {
        LiveView()
    }
}
