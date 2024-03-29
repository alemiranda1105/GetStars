//
//  CreateAutograph.swift
//  GetStars
//
//  Created by Alejandro Miranda on 25/07/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import UIKit
import SwiftUI
import CoreGraphics
import ColorPickerRing
import Photos

struct CreateAutograph: View {
    private let langStr = Locale.current.languageCode
    
    @EnvironmentObject var session: SessionStore
    
    @State var currentDrawing: Drawing = Drawing()
    @State var drawings: [Drawing] = [Drawing]()
    @State var color: Color = Color.black
    @State var uiColor: UIColor = UIColor.black
    @State var lineWidth: CGFloat = 3.0
    
    @State var origin: CGPoint = CGPoint(x: 0, y: 0)
    @State var size: CGSize = CGSize(width: 0, height: 0)
    
    @State var saved: Bool = false
    @State var error: String = ""
    
    @State var showColorMenu = false
    
    private func add(drawing: Drawing, toPath path: inout Path) {
        let points = drawing.points
        if points.count > 1 {
            for i in 0..<points.count-1 {
                let current = points[i]
                let next = points[i+1]
                path.move(to: current)
                path.addLine(to: next)
            }
        }
    }

    var body: some View {

        VStack {
            if !saved {
                GeometryReader { geometry in
                    Path { path in
                        for drawing in self.drawings {
                            self.add(drawing: drawing, toPath: &path)
                        }
                        self.add(drawing: self.currentDrawing, toPath: &path)
                    }
                    .stroke(self.color, lineWidth: self.lineWidth)
                    .background(Color.white)
                        .gesture(
                            DragGesture(minimumDistance: 0.005)
                                .onChanged({ (value) in
                                    let currentPoint = value.location
                                    if currentPoint.y >= 0
                                        && currentPoint.y < geometry.size.height {
                                        self.currentDrawing.points.append(currentPoint)
                                    }
                                })
                                .onEnded({ (value) in
                                    self.drawings.append(self.currentDrawing)
                                    self.currentDrawing = Drawing()
                                    
                                    self.origin = geometry.frame(in: .global).origin
                                    self.size = geometry.size
                                })
                    )
                }
                .frame(maxHeight: .infinity)
                
                
                HStack {
                    Button(action: {
                        self.drawings.removeAll()
                        self.error = ""
                    }) {
                        Text("Delete")
                            .frame(minWidth: 0, maxWidth: 70)
                            .padding(10)
                            .background(Color("naranja"))
                            .foregroundColor(.white)
                            .cornerRadius(50)
                    }.padding()
                    
                    Spacer()
                    
                    if error != "" {
                        Text(LocalizedStringKey(self.error))
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                    Button(action: {
                        self.showColorMenu.toggle()
                    }) {
                        Text("Color")
                            .frame(minWidth: 0, maxWidth: 50)
                            .padding(10)
                            .background(Color("gris"))
                            .foregroundColor(.white)
                            .cornerRadius(50)
                        
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        if self.drawings.count >= 1 {
                            let rect = CGRect(origin: self.origin, size: self.size)
                            let img = UIApplication.shared.windows[0].rootViewController?.view.asImage(rect: rect)
                            let library: PHPhotoLibrary = PHPhotoLibrary.shared()
                            library.savePhoto(image: img!, albumName: "GetStars")
                            
                            self.session.data?.autMan += 1
                            //self.session.articles["AutMan"] = self.session.data?.autMan
                            
                            self.session.st.uploadAutMan(session: self.session, img: img!, type: "AutMan")
                            self.session.db.updateAutManDB(session: self.session)
                            
                            self.saved = true
                            
                            let defaults = UserDefaults.standard
                            defaults.set(self.session.data!.autMan, forKey: "AutMan")
                            defaults.synchronize()
                            
                            self.error = ""
                            self.drawings.removeAll()
                        } else {
                            self.error = "Draw something before save"
                        }
                    }){
                        Text("Save")
                            .frame(minWidth: 0, maxWidth: 70)
                            .padding(10)
                            .background(Color("navyBlue"))
                            .foregroundColor(.white)
                            .cornerRadius(50)
                    }.padding()
                }.sheet(isPresented: self.$showColorMenu) {
                    VStack {
                        Text("Select a color:").font(.system(size: 32, weight: .bold)).padding()
                        
                        Spacer()
                        
                        ColorPickerRing(color: self.$uiColor, strokeWidth: 30)
                            .frame(width: 300, height: 300, alignment: .center)
                        
                        HStack(spacing: 30) {
                            Button(action: {
                                self.uiColor = UIColor.black
                                self.color = Color(self.uiColor)
                                self.showColorMenu.toggle()
                            }) {
                                Text("Black")
                                    .font(.system(size: 14, weight: .semibold))
                                    .frame(minWidth: 0, maxWidth: 50)
                                    .padding(10)
                                    .background(Color.black)
                                    .foregroundColor(.white)
                                    .cornerRadius(50)
                            }
                            
                            Button(action: {
                                self.uiColor = UIColor.white
                                self.color = Color(self.uiColor)
                                self.showColorMenu.toggle()
                            }) {
                                Text("White")
                                    .font(.system(size: 14, weight: .semibold))
                                    .frame(minWidth: 0, maxWidth: 50)
                                    .padding(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 50)
                                            .stroke(Color.black, lineWidth: 2)
                                    )
                                    .background(Color.white)
                                    .foregroundColor(.black)
                                    .border(Color.black)
                                    .cornerRadius(50)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            self.color = Color(self.uiColor)
                            self.showColorMenu.toggle()
                        }) {
                            Text("Choose a color")
                                .font(.system(size: 18, weight: .semibold))
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding(10)
                                .background(Color(self.uiColor))
                                .foregroundColor(.white)
                                .cornerRadius(50)
                        }.padding()
                    }.onDisappear {
                        self.color = Color(self.uiColor)
                    }
                }
            } else {
                VStack {
                    Text("The autograph have been correctly saved")
                        .font(.system(size: 24, weight: .heavy))
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        self.saved = false
                    }) {
                        Text("Make another one")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color("navyBlue"))
                        .foregroundColor(.white)
                        .cornerRadius(50)
                        .font(.system(size: 18, weight: .bold))
                    }.padding()
                }
            }
        }
    }
}

extension UIView {
    func asImage(rect: CGRect) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

struct Drawing {
    var points: [CGPoint] = [CGPoint]()
}

#if DEBUG
struct CreateAutograph_Previews: PreviewProvider {
    static var previews: some View {
        CreateAutograph()
    }
}
#endif
