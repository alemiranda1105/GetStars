//
//  TutorialView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 21/10/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct TutorialView: View {
    @Binding var show: Bool
    
    @State var page = 1
    
    var body: some View {
        VStack {
            if self.page == 1 {
                Text("Welcome to GetStars")
                    .font(.system(size: 32, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding()
                Text("The app where you are going to be able to connect with the famous in any part of the world")
                    .font(.system(size: 23, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
                
                Text("Press the \"next\" button to continue")
                    .font(.system(size: 22, weight: .thin))
                    .multilineTextAlignment(.center)
                    .padding()
                
            } else if self.page == 2 {
                Text("In GetStars you can discover and buy the products from your idol, autographs, photos...")
                    .font(.system(size: 23, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .padding()
                
                Image("autTutorial")
                    .resizable()
                    .frame(width: 200, height: 200, alignment: .center)
                    .scaledToFit()
                
                Text("And if you want this products would be dedicated for you, everything from you home, staying safe, without be waiting in a big queue or waiting for a really long time")
                    .font(.system(size: 23, weight: .regular))
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
                
            } else if self.page == 3 {
                Text("And also, you may win some exclusive items like a ball used by him/her or an entry to the next race, everything free with our raffles created by himself, this is the only way we can garantee that the products come from an original source and you are not getting a fake product")
                    .font(.system(size: 22, weight: .regular))
                    .multilineTextAlignment(.center)
                    .padding()
                
                Image("ballTutorial")
                    .resizable()
                    .frame(width: 200, height: 113, alignment: .center)
                    .scaledToFit()
                
                Text("The are even bids where you can buy even more exclusive products")
                    .font(.system(size: 22, weight: .regular))
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
                
                Text("Press next and discover our exclusive product...")
                    .font(.system(size: 23, weight: .thin))
                    .multilineTextAlignment(.center)
                    .padding()
                
            } else {
                Text("Could you imagine that this person who you are watching in the TV just send a video to you and wishing you the best luck for the test you have tomorrow? Impossible, true?")
                    .font(.system(size: 23, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .padding()
                
                Text("Now, with GetStars that's possible, with our \"Live\" videos now the stars will be closer to us than never with these dedicated  videos in exclusive for you")
                    .font(.system(size: 23, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding()
                
                Image("videoTutorial")
                    .resizable()
                    .frame(width: 200, height: 114, alignment: .center)
                    .scaledToFit()
                
                Spacer()
                
                Text("Press START to discover more")
                    .font(.system(size: 18, weight: .thin))
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            HStack {
                Button(action: {
                    if self.page > 1 {
                        self.page -= 1
                    }
                }) {
                    Text("Back")
                }.frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .background(Color("naranja"))
                .foregroundColor(.white)
                .cornerRadius(50)
                .font(.system(size: 18, weight: .bold))
                .padding()
                
                Button(action: {
                    self.page += 1
                    
                    if self.page >= 5 {
                        UserDefaults.standard.setValue(false, forKey: "tutorial")
                        self.show = false
                    }
                    
                }) {
                    if self.page >= 4 {
                        Text("Start")
                    } else {
                        Text("Next")
                    }
                }.frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .background(Color("navyBlue"))
                .foregroundColor(.white)
                .cornerRadius(50)
                .font(.system(size: 18, weight: .bold))
                .padding()
            }
        }
    }
}
