//
//  SelectPaymentMethodView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 30/09/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct SelectPaymentMethodView: View {
    @EnvironmentObject var session: SessionStore
    
    var body: some View {
        Group {
            NavigationLink(destination: CardPaymentView()) {
                Text("Pagar con tarjeta")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(8)
                    .background(Color("navyBlue"))
                    .foregroundColor(.white)
                    .cornerRadius(50)
                    .font(.system(size: 18, weight: .bold))
            }.padding()
            
            NavigationLink(destination: Text("Paypal")) {
                Text("Pagar con PayPal")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(8)
                    .background(Color.init(hex: "f2bf3f"))
                    .foregroundColor(Color.init(hex: "0f0fbd"))
                    .cornerRadius(50)
                    .font(.system(size: 18, weight: .bold))
            }.padding()
            
        }.navigationBarTitle(Text("Seleccione un método de pago"))
    }
}

struct SelectPaymentMethodView_Previews: PreviewProvider {
    static var previews: some View {
        SelectPaymentMethodView()
    }
}
