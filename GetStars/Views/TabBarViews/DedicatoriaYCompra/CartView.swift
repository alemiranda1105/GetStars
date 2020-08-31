//
//  CartView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 30/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct CartView: View {
    @EnvironmentObject var session: SessionStore
    
    var body: some View {
        List(self.session.cart) { product in
            HStack {
                HStack {
                    VStack(spacing: 10) {
                        Text(product.name)
                            .font(.system(size: 16, weight: .regular))
                            .multilineTextAlignment(.center)
                        Text(product.owner.name)
                            .font(.system(size: 12, weight: .light))
                    }.frame(width: 150, height: 50)
                    
                    Spacer()

                    WebImage(url: URL(string: product.image))
                        .resizable()
                        .placeholder(Image(systemName: "photo"))
                        .placeholder {
                            Rectangle().foregroundColor(.gray)
                        }
                        .indicator(.activity)
                        .transition(.fade(duration: 0.5))
                        .frame(width: 48, height: 48, alignment: .center)
                }

                Spacer()

                Text(product.price.dollarString + "€")
                    .padding()
                    .font(.system(size: 18, weight: .regular))
            }
        }
    }
    
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
    }
}
