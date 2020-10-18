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
    
    @State var showCamera: Bool = false
    
    var body: some View {
        Group {
            if self.showCamera {
                CameraLiveView(message: self.$mensaje, email: self.$participante)
                    .navigationViewStyle(StackNavigationViewStyle())
                    .environmentObject(self.session)
            } else {
                VStack {
                    Text(self.participante)
                        .font(.system(size: 20, weight: .bold))
                    Text(self.mensaje)
                        .font(.system(size: 20, weight: .regular))
                    
                    Spacer()
                    
                    HStack {
//                        Button(action: {
//                            // Reportar mensaje ofensivo
//                            
//                        }) {
//                            HStack(spacing: 5) {
//                                Text("Report")
//                                Image(systemName: "exclamationmark.triangle")
//                            }
//                            .padding(14)
//                            .foregroundColor(.white)
//                            .background(Color.red)
//                            .cornerRadius(60)
//                        }
//                        
//                        Spacer()
                        
                        Button(action: {
                            // Muestra el menú de camara
                            self.showCamera.toggle()
                        }) {
                            Text("Create")
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding(14)
                                .background(Color("navyBlue"))
                                .foregroundColor(.white)
                                .cornerRadius(50)
                        }
                        
                    }.padding()
                }.navigationViewStyle(StackNavigationViewStyle())
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
