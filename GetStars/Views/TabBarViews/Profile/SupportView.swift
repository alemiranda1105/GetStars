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
            Section(header: Text("Support")) {
                Button(action: {
                    self.sendEmail(email: "soportegetstars@gmail.com")
                }) {
                    Text("Contact support")
                }
            }
            Section(header: Text("Suggestions")) {
                Button(action: {
                    self.sendEmail(email: "marquelodev@gmail.com")
                }) {
                    Text("Send us any suggestions")
                }
            }
            Section(header: Text("Marquelo Solutions")) {
                Button(action: {
                    self.sendEmail(email: "marquelodev@gmail.com")
                }) {
                    Text("Get in touch with us")
                }
            }
        }.navigationBarTitle(Text("Support"))
    }
}
