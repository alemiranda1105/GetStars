//
//  AutographProfileView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 11/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct AutographProfileView: View {
    @EnvironmentObject var session: SessionStore
    
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct AutographProfileView_Previews: PreviewProvider {
    static var previews: some View {
        AutographProfileView().environmentObject(SessionStore())
    }
}
