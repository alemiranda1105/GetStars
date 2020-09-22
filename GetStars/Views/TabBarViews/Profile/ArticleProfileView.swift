//
//  ArticleProfileView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 13/09/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct ArticleProfileView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var session: SessionStore
    
    @Binding var type: String
    @Binding var title: String
    
    @State var urls: [UrlLoader] = [UrlLoader]()
    @State var loading = false
    @State var error = ""
    
    var body: some View {
        VStack {
            if self.loading {
                ActivityIndicator(isAnimating: .constant(true), style: .large)
            } else {
                
                if self.error != "" {
                    Text(LocalizedStringKey(self.error))
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.primary)
                    .padding()
                    .multilineTextAlignment(.center)
                }
                
                GridStack(minCellWidth: 125, spacing: 5, numItems: (self.session.data?.compras[type]?.count) ?? 0){ i, width in
                    ZStack {
                        Image("watermark")
                            .resizable()
                            .scaledToFit()
                            .opacity(0.35)
                            .frame(width: width, height: width, alignment: .center)
                            .zIndex(1000)
                        NavigationLink(destination: DetailedArticleView(url: self.session.data?.compras[self.type]?[i] ?? "")) {
                            WebImage(url: URL(string: self.session.data?.compras[self.type]?[i] ?? "")!)
                            .resizable()
                            .placeholder(Image(systemName: "photo"))
                            .placeholder {
                                Rectangle().foregroundColor(.gray)
                            }
                            .indicator(.activity)
                            .transition(.fade(duration: 0.5))
                            .frame(width: width, height: width, alignment: .center)
                            .border(Color.black, width: 1)
                        }.buttonStyle(PlainButtonStyle()).padding(.vertical, 5)
                    }
                }
            }
        }.navigationBarTitle(Text(LocalizedStringKey(self.title)), displayMode: .large)
    }
}

struct ArticleProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleProfileView(type: .constant("debug"), title: .constant("DEBUG"))
    }
}
