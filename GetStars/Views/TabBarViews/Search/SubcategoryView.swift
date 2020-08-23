//
//  SubcategoryView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 16/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct SubcategoryView: View {
    @EnvironmentObject var session: SessionStore
    
    @State var data: [Person] = [Person]()
    @State var loading = true
    
    var cat: String
    
    func getFamous() {
        let st = StarsST()
        let db = StarsDB()
        var imgUrl = [URL]()
        var url = URL(string: "")
        let dg = DispatchGroup()
        
        db.readKeys(dg: dg)
        dg.notify(queue: DispatchQueue.global(qos: .background)) {
            
            var c = ""
            switch self.cat {
            case "Sports":
                c = "deportes"
                break
            case "Music":
                c = "musica"
                break
            case "Tv":
                c = "television"
                break
            case "Movies":
                c = "cine"
                break
            default:
                c = ""
                break
            }
            
            db.readFamousByCategory(cat: c, dg: dg)
            dg.wait()
            
            let keys = db.getCatId()
            for i in keys {
                st.getImage(key: i, dg: dg)
                dg.wait()
                
                imgUrl.append(st.getImgUrl())
                url = st.getImgUrl()
                db.readFamous(key: i, dg: dg)
                dg.wait()
                
                print("Famoso \(self.cat) leído")
                let name = db.getName()
                let desc = db.getDesc()
                self.data.append(Person(name: name, description: desc, image: url!))
                self.loading = false
            }
        }
    }
    
    var body: some View {
        GeometryReader { g in
            Group {
                if self.loading {
                    ActivityIndicator(isAnimating: .constant(true), style: .medium)
                    .frame(width: g.size.width, height: g.size.height, alignment: .center)
                    .onAppear(perform: self.getFamous)
                } else {
                    ScrollView {
                        ForEach(0..<self.data.count, id: \.self) { product in
                            PersonCard(person: self.$data[product]).frame(width: g.size.width)
                        }
                    }.navigationBarTitle(LocalizedStringKey(self.cat))
                    .navigationViewStyle(StackNavigationViewStyle())
                }
            }
        }
    }
}

#if DEBUG
struct SubcategoryView_Previews: PreviewProvider {
    static var previews: some View {
        SubcategoryView(cat: "Preview")
    }
}
#endif
