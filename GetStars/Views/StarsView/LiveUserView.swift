//
//  LiveUserView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 20/09/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct LiveUserView: View {
    @EnvironmentObject var session: SessionStore
    
    @Binding var participante: String
    @Binding var mensaje: String
    
    var body: some View {
        Group {
            VStack {
                Text(participante)
                    .font(.system(size: 20, weight: .bold))
                Text(mensaje)
                    .font(.system(size: 20, weight: .regular))
                
                Spacer()
                
                HStack {
                    Button(action: {
                        // Reportar mensaje ofensivo
                        
                    }) {
                        HStack(spacing: 5) {
                            Text("Reportar")
                            Image(systemName: "exclamationmark.triangle")
                        }
                        .padding(14)
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(60)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: CameraLiveView()) {
                        Text("Crear")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding(14)
                        .background(Color("navyBlue"))
                        .foregroundColor(.white)
                        .cornerRadius(50)
                    }
                }.padding()
            }
        }
    }
}

#if DEBUG
struct LiveUserView_Previews: PreviewProvider {
    static var previews: some View {
        LiveUserView(participante: .constant(""), mensaje: .constant(""))
    }
}
#endif
