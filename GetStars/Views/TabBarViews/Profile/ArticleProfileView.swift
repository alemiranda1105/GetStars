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
    @State var urls: [UrlLoader] = [UrlLoader]()
    @State var loading = true
    
    private func loadItems() {
        let dg = DispatchGroup()
        self.session.st.downloadAllFiles(session: self.session, type: self.type, dg: dg)
        dg.notify(queue: DispatchQueue.global(qos: .background)) {
            self.urls = self.session.st.getItemsUrl()
            self.loading = false
        }
    }
    
    var body: some View {
        VStack {
            if self.loading {
                ActivityIndicator(isAnimating: .constant(true), style: .large)
            } else {
                Text(self.type)
                Text("\(self.urls.count)")
                GridStack(minCellWidth: 125, spacing: 5, numItems: self.urls.count){ i, width in
                    NavigationLink(destination: AutographProfileView(url: self.urls[i])) {
                        WebImage(url: self.urls[i].url)
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
        }.onAppear(perform: self.loadItems)
    }
}

struct ArticleProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleProfileView(type: .constant("debug"))
    }
}
