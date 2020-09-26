//
//  SupportVire.swift
//  GetStars
//
//  Created by Alejandro Miranda on 26/09/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct SupportView: View {
    
    private func sendEmail(email: String) {
        let myUrl = "mailto:\(email)"
            if let url = URL(string: "\(myUrl)"), !url.absoluteString.isEmpty {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
    }
    
    var body: some View {
        Form {
            Section(header: Text("Soporte")) {
                Button(action: {
                    self.sendEmail(email: "amiranda110500@gmail.com")
                }) {
                    Text("Contacta con soporte")
                }
            }
            Section(header: Text("Sugerencias")) {
                Button(action: {
                    self.sendEmail(email: "amiranda110500@gmail.com")
                }) {
                    Text("Envía cualquier sugerencia")
                }
            }
            Section(header: Text("Marquelo Solutions")) {
                Button(action: {
                    self.sendEmail(email: "amiranda110500@gmail.com")
                }) {
                    Text("Contacta directamente con nosotros")
                }
            }
        }.navigationBarTitle(Text("Soporte"))
    }
}

struct SupportVire_Previews: PreviewProvider {
    static var previews: some View {
        SupportView()
    }
}
