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
import Photos

struct CreateAutograph: View {
    private let langStr = Locale.current.languageCode
    
    @EnvironmentObject var session: SessionStore
    
    @State var currentDrawing: Drawing = Drawing()
    @State var drawings: [Drawing] = [Drawing]()
    @State var color: Color = Color.black
    @State var lineWidth: CGFloat = 3.0
    
    @State var origin: CGPoint = CGPoint(x: 0, y: 0)
    @State var size: CGSize = CGSize(width: 0, height: 0)
    
    @State var saved: Bool = false
    @State var error: String = ""
    
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
                        .background(Color(white: 0.95))
                        .gesture(
                            DragGesture(minimumDistance: 0.1)
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
                        Text("Borrar")
                        .frame(minWidth: 0, maxWidth: 70)
                        .padding(10)
                        .background(Color("naranja"))
                        .foregroundColor(.white)
                        .cornerRadius(50)
                    }.padding()
                    
                    Spacer()
                    
                    if error != "" {
                        Text((error))
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        if self.drawings.count >= 1 {
                            let rect = CGRect(origin: self.origin, size: self.size)
                            let img = UIApplication.shared.windows[0].rootViewController?.view.asImage(rect: rect)
                            let library: PHPhotoLibrary = PHPhotoLibrary.shared()
                            library.savePhoto(image: img!, albumName: "GetStars")
                            
                            self.session.data?.autMan += 1
                            self.session.articles["AutMan"] = self.session.data?.autMan
                            
                            self.session.st.uploadFile(session: self.session, img: img!, type: "AutMan")
                            self.session.db.updateAutManDB(session: self.session)
                            
                            self.saved = true
                            
                            let defaults = UserDefaults.standard
                            defaults.set(self.session.data!.autMan, forKey: "AutMan")
                            defaults.synchronize()
                            
                            self.error = ""
                            self.drawings.removeAll()
                        } else {
                            self.error = self.langStr == "en" ? "Draw something before save": "Haga un autógrafo antes de guardar"
                        }
                    }){
                        Text("Guardar")
                        .frame(minWidth: 0, maxWidth: 70)
                        .padding(10)
                        .background(Color("navyBlue"))
                        .foregroundColor(.white)
                        .cornerRadius(50)
                    }.padding()
                }
            } else {
                VStack {
                    Text("El autógrafo ha sido guardado con éxito")
                        .font(.system(size: 24, weight: .heavy))
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        self.saved = false
                    }) {
                        Text("Realizar otro autógrafo")
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

struct CreateAutograph_Previews: PreviewProvider {
    static var previews: some View {
        CreateAutograph()
    }
}
