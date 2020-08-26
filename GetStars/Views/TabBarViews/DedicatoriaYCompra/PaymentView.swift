//
//  PaymentView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 26/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct PaymentView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        Group {
            NavigationLink(destination: DedicatoriaView()) {
                Text("Pagar")
            }
            
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Cancelar pago")
            }
        }
    }
}

struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentView()
    }
}
