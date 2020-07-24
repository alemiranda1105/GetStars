//
//  SyncWithView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 07/07/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct SyncWithView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    private func sycnWith() {
        
    }
    
    var body: some View {
        VStack {
            Text("Un último paso").font(.system(size: 32, weight: .heavy)).multilineTextAlignment(.center).padding()
            
            Text("¿Desea sincronizar su cuenta con alguno de los siguientes métodos?").font(.system(size: 24, weight: .medium)).multilineTextAlignment(.center)
            
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
            
            Spacer()
            
            Button(action: { self.mode.wrappedValue.dismiss() }){
                Text("No, prefiero hacerlo más adelante")
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [.blue, .blue]), startPoint: .leading, endPoint: .trailing))
                .foregroundColor(.white)
                .cornerRadius(50)
                .font(.system(size: 18, weight: .bold))
            }
            
        }.padding()
    }
}

struct SyncWithView_Previews: PreviewProvider {
    static var previews: some View {
        SyncWithView()
    }
}
