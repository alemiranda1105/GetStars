//
//  TrendingView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 03/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct TrendingView: View {
    @State var data: [Product] = [
    Product(name: "Popular 1", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec faucibus elit in viverra vehicula. Integer mattis turpis vitae suscipit placerat. Etiam sit amet risus blandit lectus vehicula luctus. Aliquam at rutrum tortor. Vivamus dictum id lorem eget rutrum. Pellentesque ullamcorper nibh sit amet dui auctor sodales. Cras ante ipsum, mollis vel rutrum eu, suscipit efficitur lacus. Curabitur interdum mi augue, id congue dui viverra ut. Vivamus erat tellus, euismod at pretium id, feugiat ac neque. Aliquam mollis, velit a volutpat.", image: "t1"),
    Product(name: "Popular 2", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec faucibus elit in viverra vehicula. Integer mattis turpis vitae suscipit placerat. Etiam sit amet risus blandit lectus vehicula luctus. Aliquam at rutrum tortor. Vivamus dictum id lorem eget rutrum. Pellentesque ullamcorper nibh sit amet dui auctor sodales. Cras ante ipsum, mollis vel rutrum eu, suscipit efficitur lacus. Curabitur interdum mi augue, id congue dui viverra ut. Vivamus erat tellus, euismod at pretium id, feugiat ac neque. Aliquam mollis, velit a volutpat.", image: "t2"),
    Product(name: "Popular 3", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec faucibus elit in viverra vehicula. Integer mattis turpis vitae suscipit placerat. Etiam sit amet risus blandit lectus vehicula luctus. Aliquam at rutrum tortor. Vivamus dictum id lorem eget rutrum. Pellentesque ullamcorper nibh sit amet dui auctor sodales. Cras ante ipsum, mollis vel rutrum eu, suscipit efficitur lacus. Curabitur interdum mi augue, id congue dui viverra ut. Vivamus erat tellus, euismod at pretium id, feugiat ac neque. Aliquam mollis, velit a volutpat.", image: "t3"),
    Product(name: "Popular 4", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec faucibus elit in viverra vehicula. Integer mattis turpis vitae suscipit placerat. Etiam sit amet risus blandit lectus vehicula luctus. Aliquam at rutrum tortor. Vivamus dictum id lorem eget rutrum. Pellentesque ullamcorper nibh sit amet dui auctor sodales. Cras ante ipsum, mollis vel rutrum eu, suscipit efficitur lacus. Curabitur interdum mi augue, id congue dui viverra ut. Vivamus erat tellus, euismod at pretium id, feugiat ac neque. Aliquam mollis, velit a volutpat.", image: "t4"),
    Product(name: "Popular 5", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec faucibus elit in viverra vehicula. Integer mattis turpis vitae suscipit placerat. Etiam sit amet risus blandit lectus vehicula luctus. Aliquam at rutrum tortor. Vivamus dictum id lorem eget rutrum. Pellentesque ullamcorper nibh sit amet dui auctor sodales. Cras ante ipsum, mollis vel rutrum eu, suscipit efficitur lacus. Curabitur interdum mi augue, id congue dui viverra ut. Vivamus erat tellus, euismod at pretium id, feugiat ac neque. Aliquam mollis, velit a volutpat.", image: "t5")]
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(0..<self.data.count) { product in
                    ProductCard(item: self.$data[product])
                }
            }
        }.navigationBarTitle("Populares")
    }
}

struct TrendingView_Previews: PreviewProvider {
    static var previews: some View {
        TrendingView()
    }
}
