//
//  SyncWithView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 07/07/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import Google

struct SyncWithView: View {
    
    private func sycnWith() {
        
    }
    
    var body: some View {
        VStack {
            Text("¿Desea sincronizar su cuenta con alguno de los siguientes métodos?").font(.system(size: 32, weight: .heavy)).multilineTextAlignment(.center).padding()
            
            Spacer()
            
            VStack(spacing: 16){
                Button(action: sycnWith){
                    Text("Google")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [.gray, .gray]), startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .cornerRadius(50)
                    .font(.system(size: 18, weight: .bold))
                }
                
                Button(action: sycnWith){
                    Text("Facebook")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [.gray, .gray]), startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .cornerRadius(50)
                    .font(.system(size: 18, weight: .bold))
                }
                
                Button(action: sycnWith){
                    Text("Apple")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [.black, .black]), startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .cornerRadius(50)
                    .font(.system(size: 18, weight: .bold))
                }
                
            }.padding(8)
            
        }.padding()
    }
}

struct SyncWithView_Previews: PreviewProvider {
    static var previews: some View {
        SyncWithView()
    }
}
