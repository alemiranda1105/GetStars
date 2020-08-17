//
//  CategoryView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 03/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct CategoryView: View {
    @Environment(\.colorScheme) var colorScheme
    
    let cats: [Category] = [Category(name: "Deportes"), Category(name: "Musica"), Category(name: "Televisión"), Category(name: "Cine")]
    
    @State var deportes: [Product] = [
        Product(name: "Deportista 1", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec faucibus elit in viverra vehicula. Integer mattis turpis vitae suscipit placerat. Etiam sit amet risus blandit lectus vehicula luctus. Aliquam at rutrum tortor. Vivamus dictum id lorem eget rutrum. Pellentesque ullamcorper nibh sit amet dui auctor sodales. Cras ante ipsum, mollis vel rutrum eu, suscipit efficitur lacus. Curabitur interdum mi augue, id congue dui viverra ut. Vivamus erat tellus, euismod at pretium id, feugiat ac neque. Aliquam mollis, velit a volutpat.", image: "sp1"),
        Product(name: "Deportista 2", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec faucibus elit in viverra vehicula. Integer mattis turpis vitae suscipit placerat. Etiam sit amet risus blandit lectus vehicula luctus. Aliquam at rutrum tortor. Vivamus dictum id lorem eget rutrum. Pellentesque ullamcorper nibh sit amet dui auctor sodales. Cras ante ipsum, mollis vel rutrum eu, suscipit efficitur lacus. Curabitur interdum mi augue, id congue dui viverra ut. Vivamus erat tellus, euismod at pretium id, feugiat ac neque. Aliquam mollis, velit a volutpat.", image: "sp2"),
        Product(name: "Deportista 3", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec faucibus elit in viverra vehicula. Integer mattis turpis vitae suscipit placerat. Etiam sit amet risus blandit lectus vehicula luctus. Aliquam at rutrum tortor. Vivamus dictum id lorem eget rutrum. Pellentesque ullamcorper nibh sit amet dui auctor sodales. Cras ante ipsum, mollis vel rutrum eu, suscipit efficitur lacus. Curabitur interdum mi augue, id congue dui viverra ut. Vivamus erat tellus, euismod at pretium id, feugiat ac neque. Aliquam mollis, velit a volutpat.", image: "sp3"),
        Product(name: "Deportista 4", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec faucibus elit in viverra vehicula. Integer mattis turpis vitae suscipit placerat. Etiam sit amet risus blandit lectus vehicula luctus. Aliquam at rutrum tortor. Vivamus dictum id lorem eget rutrum. Pellentesque ullamcorper nibh sit amet dui auctor sodales. Cras ante ipsum, mollis vel rutrum eu, suscipit efficitur lacus. Curabitur interdum mi augue, id congue dui viverra ut. Vivamus erat tellus, euismod at pretium id, feugiat ac neque. Aliquam mollis, velit a volutpat.", image: "sp4"),
        Product(name: "Deportista 5", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec faucibus elit in viverra vehicula. Integer mattis turpis vitae suscipit placerat. Etiam sit amet risus blandit lectus vehicula luctus. Aliquam at rutrum tortor. Vivamus dictum id lorem eget rutrum. Pellentesque ullamcorper nibh sit amet dui auctor sodales. Cras ante ipsum, mollis vel rutrum eu, suscipit efficitur lacus. Curabitur interdum mi augue, id congue dui viverra ut. Vivamus erat tellus, euismod at pretium id, feugiat ac neque. Aliquam mollis, velit a volutpat.", image: "sp5")]
    
    @State var musica: [Product] = [
        Product(name: "Musico 1", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec faucibus elit in viverra vehicula. Integer mattis turpis vitae suscipit placerat. Etiam sit amet risus blandit lectus vehicula luctus. Aliquam at rutrum tortor. Vivamus dictum id lorem eget rutrum. Pellentesque ullamcorper nibh sit amet dui auctor sodales. Cras ante ipsum, mollis vel rutrum eu, suscipit efficitur lacus. Curabitur interdum mi augue, id congue dui viverra ut. Vivamus erat tellus, euismod at pretium id, feugiat ac neque. Aliquam mollis, velit a volutpat.", image: "ms1"),
        Product(name: "Musico 2", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec faucibus elit in viverra vehicula. Integer mattis turpis vitae suscipit placerat. Etiam sit amet risus blandit lectus vehicula luctus. Aliquam at rutrum tortor. Vivamus dictum id lorem eget rutrum. Pellentesque ullamcorper nibh sit amet dui auctor sodales. Cras ante ipsum, mollis vel rutrum eu, suscipit efficitur lacus. Curabitur interdum mi augue, id congue dui viverra ut. Vivamus erat tellus, euismod at pretium id, feugiat ac neque. Aliquam mollis, velit a volutpat.", image: "ms2"),
        Product(name: "Musico 3", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec faucibus elit in viverra vehicula. Integer mattis turpis vitae suscipit placerat. Etiam sit amet risus blandit lectus vehicula luctus. Aliquam at rutrum tortor. Vivamus dictum id lorem eget rutrum. Pellentesque ullamcorper nibh sit amet dui auctor sodales. Cras ante ipsum, mollis vel rutrum eu, suscipit efficitur lacus. Curabitur interdum mi augue, id congue dui viverra ut. Vivamus erat tellus, euismod at pretium id, feugiat ac neque. Aliquam mollis, velit a volutpat.", image: "ms3"),
        Product(name: "Musico 4", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec faucibus elit in viverra vehicula. Integer mattis turpis vitae suscipit placerat. Etiam sit amet risus blandit lectus vehicula luctus. Aliquam at rutrum tortor. Vivamus dictum id lorem eget rutrum. Pellentesque ullamcorper nibh sit amet dui auctor sodales. Cras ante ipsum, mollis vel rutrum eu, suscipit efficitur lacus. Curabitur interdum mi augue, id congue dui viverra ut. Vivamus erat tellus, euismod at pretium id, feugiat ac neque. Aliquam mollis, velit a volutpat.", image: "ms4"),
        Product(name: "Musico 5", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec faucibus elit in viverra vehicula. Integer mattis turpis vitae suscipit placerat. Etiam sit amet risus blandit lectus vehicula luctus. Aliquam at rutrum tortor. Vivamus dictum id lorem eget rutrum. Pellentesque ullamcorper nibh sit amet dui auctor sodales. Cras ante ipsum, mollis vel rutrum eu, suscipit efficitur lacus. Curabitur interdum mi augue, id congue dui viverra ut. Vivamus erat tellus, euismod at pretium id, feugiat ac neque. Aliquam mollis, velit a volutpat.", image: "ms5")]
    
    @State var tv: [Product] = [
        Product(name: "Actor 1", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec faucibus elit in viverra vehicula. Integer mattis turpis vitae suscipit placerat. Etiam sit amet risus blandit lectus vehicula luctus. Aliquam at rutrum tortor. Vivamus dictum id lorem eget rutrum. Pellentesque ullamcorper nibh sit amet dui auctor sodales. Cras ante ipsum, mollis vel rutrum eu, suscipit efficitur lacus. Curabitur interdum mi augue, id congue dui viverra ut. Vivamus erat tellus, euismod at pretium id, feugiat ac neque. Aliquam mollis, velit a volutpat.", image: "ac1"),
        Product(name: "Actor 2", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec faucibus elit in viverra vehicula. Integer mattis turpis vitae suscipit placerat. Etiam sit amet risus blandit lectus vehicula luctus. Aliquam at rutrum tortor. Vivamus dictum id lorem eget rutrum. Pellentesque ullamcorper nibh sit amet dui auctor sodales. Cras ante ipsum, mollis vel rutrum eu, suscipit efficitur lacus. Curabitur interdum mi augue, id congue dui viverra ut. Vivamus erat tellus, euismod at pretium id, feugiat ac neque. Aliquam mollis, velit a volutpat.", image: "ac2"),
        Product(name: "Actor 3", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec faucibus elit in viverra vehicula. Integer mattis turpis vitae suscipit placerat. Etiam sit amet risus blandit lectus vehicula luctus. Aliquam at rutrum tortor. Vivamus dictum id lorem eget rutrum. Pellentesque ullamcorper nibh sit amet dui auctor sodales. Cras ante ipsum, mollis vel rutrum eu, suscipit efficitur lacus. Curabitur interdum mi augue, id congue dui viverra ut. Vivamus erat tellus, euismod at pretium id, feugiat ac neque. Aliquam mollis, velit a volutpat.", image: "ac3"),
        Product(name: "Actor 4", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec faucibus elit in viverra vehicula. Integer mattis turpis vitae suscipit placerat. Etiam sit amet risus blandit lectus vehicula luctus. Aliquam at rutrum tortor. Vivamus dictum id lorem eget rutrum. Pellentesque ullamcorper nibh sit amet dui auctor sodales. Cras ante ipsum, mollis vel rutrum eu, suscipit efficitur lacus. Curabitur interdum mi augue, id congue dui viverra ut. Vivamus erat tellus, euismod at pretium id, feugiat ac neque. Aliquam mollis, velit a volutpat.", image: "ac4"),
        Product(name: "Actor 5", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec faucibus elit in viverra vehicula. Integer mattis turpis vitae suscipit placerat. Etiam sit amet risus blandit lectus vehicula luctus. Aliquam at rutrum tortor. Vivamus dictum id lorem eget rutrum. Pellentesque ullamcorper nibh sit amet dui auctor sodales. Cras ante ipsum, mollis vel rutrum eu, suscipit efficitur lacus. Curabitur interdum mi augue, id congue dui viverra ut. Vivamus erat tellus, euismod at pretium id, feugiat ac neque. Aliquam mollis, velit a volutpat.", image: "ac5")]
    
    @State var cine: [Product] = [
        Product(name: "Actor 1", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec faucibus elit in viverra vehicula. Integer mattis turpis vitae suscipit placerat. Etiam sit amet risus blandit lectus vehicula luctus. Aliquam at rutrum tortor. Vivamus dictum id lorem eget rutrum. Pellentesque ullamcorper nibh sit amet dui auctor sodales. Cras ante ipsum, mollis vel rutrum eu, suscipit efficitur lacus. Curabitur interdum mi augue, id congue dui viverra ut. Vivamus erat tellus, euismod at pretium id, feugiat ac neque. Aliquam mollis, velit a volutpat.", image: "ac6"),
        Product(name: "Actor 2", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec faucibus elit in viverra vehicula. Integer mattis turpis vitae suscipit placerat. Etiam sit amet risus blandit lectus vehicula luctus. Aliquam at rutrum tortor. Vivamus dictum id lorem eget rutrum. Pellentesque ullamcorper nibh sit amet dui auctor sodales. Cras ante ipsum, mollis vel rutrum eu, suscipit efficitur lacus. Curabitur interdum mi augue, id congue dui viverra ut. Vivamus erat tellus, euismod at pretium id, feugiat ac neque. Aliquam mollis, velit a volutpat.", image: "ac7"),
        Product(name: "Actor 3", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec faucibus elit in viverra vehicula. Integer mattis turpis vitae suscipit placerat. Etiam sit amet risus blandit lectus vehicula luctus. Aliquam at rutrum tortor. Vivamus dictum id lorem eget rutrum. Pellentesque ullamcorper nibh sit amet dui auctor sodales. Cras ante ipsum, mollis vel rutrum eu, suscipit efficitur lacus. Curabitur interdum mi augue, id congue dui viverra ut. Vivamus erat tellus, euismod at pretium id, feugiat ac neque. Aliquam mollis, velit a volutpat.", image: "ac8"),
        Product(name: "Actor 4", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec faucibus elit in viverra vehicula. Integer mattis turpis vitae suscipit placerat. Etiam sit amet risus blandit lectus vehicula luctus. Aliquam at rutrum tortor. Vivamus dictum id lorem eget rutrum. Pellentesque ullamcorper nibh sit amet dui auctor sodales. Cras ante ipsum, mollis vel rutrum eu, suscipit efficitur lacus. Curabitur interdum mi augue, id congue dui viverra ut. Vivamus erat tellus, euismod at pretium id, feugiat ac neque. Aliquam mollis, velit a volutpat.", image: "ac9"),
        Product(name: "Actor 5", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec faucibus elit in viverra vehicula. Integer mattis turpis vitae suscipit placerat. Etiam sit amet risus blandit lectus vehicula luctus. Aliquam at rutrum tortor. Vivamus dictum id lorem eget rutrum. Pellentesque ullamcorper nibh sit amet dui auctor sodales. Cras ante ipsum, mollis vel rutrum eu, suscipit efficitur lacus. Curabitur interdum mi augue, id congue dui viverra ut. Vivamus erat tellus, euismod at pretium id, feugiat ac neque. Aliquam mollis, velit a volutpat.", image: "ac10")]
    
    @State var showMoreSports = false
    @State var showMusic = false
    @State var showMoreTv = false
    @State var showMoreCine = false
    
    var body: some View {
        List(cats) { c in
            NavigationLink(destination: Text(c.name)) {
                Text(c.name)
            }
        }
//        ScrollView {
//            VStack {
//                Text("Deportes").font(.system(size: 25, weight: .bold))
//                if showMoreSports {
//                    ForEach(0..<self.deportes.count) { i in
//                        ProductCard(item: self.$deportes[i])
//                    }
//                }
//                ShowMoreButton(show: $showMoreSports)
//
//
//                Text("Música").font(.system(size: 25, weight: .bold)).padding(.top, 16)
//                if showMusic {
//                    ForEach(0..<self.musica.count) { i in
//                        ProductCard(item: self.$musica[i])
//                    }
//                }
//                ShowMoreButton(show: $showMusic)
//
//
//                Text("Televisión").font(.system(size: 25, weight: .bold)).padding(.top, 16)
//                if showMoreTv {
//                    ForEach(0..<self.tv.count) { i in
//                        ProductCard(item: self.$tv[i])
//                    }
//                }
//                ShowMoreButton(show: $showMoreTv)
//
//                Text("Cine").font(.system(size: 25, weight: .bold)).padding(.top, 16)
//                if showMoreCine {
//                    ForEach(0..<self.cine.count){ i in
//                        ProductCard(item: self.$cine[i])
//                    }
//                }
//                ShowMoreButton(show: $showMoreCine)
//
//            }
//        }.navigationBarTitle("Categorías")
    }
}

struct ShowMoreButton: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var show: Bool
    
    var body: some View {
        Button(action: {
            self.show.toggle()
        }) {
            Text(self.show ? "Ver menos": "Ver más")
        }.frame(width: 250, height: 40)
        .padding(4)
        .background(Color("gris"))
        .foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
        .cornerRadius(8)
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView()
    }
}

struct Category: Identifiable {
    var id = UUID()
    var name: String
}
