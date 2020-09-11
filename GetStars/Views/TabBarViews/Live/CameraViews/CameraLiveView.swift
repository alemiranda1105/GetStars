//
//  CameraLiveView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 10/09/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import UIKit
import AVFoundation

// Camaras
import CameraKit_iOS
import CameraManager

struct CameraLiveView: View {
    @ObservedObject var cameraObject: CameraController = CameraController.shared
    
    var body: some View {
        ZStack(alignment: .bottom) {
            CameraViewController().environmentObject(self.cameraObject)
                .zIndex(1000000)
            
            HStack{
                Button(action: {
                    print("Grabando")
                    
                }) {
                    Image(systemName: "video.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(100)
                }
                Button(action: {
                    print("Cambiar Camara")
                    self.cameraObject.changeCamera()
                }) {
                    Image(systemName: "arrow.clockwise")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(100)
                }
            }.zIndex(1000001)
        }
    }
}

final class CameraViewController: UIViewController {
    var previewView: UIView!
    @ObservedObject var cameraObject = CameraController.shared
    
    override func viewDidLoad() {
        // Setup Camera
        self.cameraObject.camera.shouldUseLocationServices = false
        self.cameraObject.camera.cameraOutputMode = .videoWithMic
        self.cameraObject.camera.cameraDevice = .front
        
        previewView = UIView(frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        previewView.contentMode = UIView.ContentMode.scaleAspectFit
        view.addSubview(previewView)
        self.cameraObject.camera.addPreviewLayerToView(view)
        
    }
    
}

extension CameraViewController : UIViewControllerRepresentable{
    public typealias UIViewControllerType = CameraViewController
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<CameraViewController>) -> CameraViewController {
        return CameraViewController()
    }
    
    public func updateUIViewController(_ uiViewController: CameraViewController, context: UIViewControllerRepresentableContext<CameraViewController>) {
        
    }
}


struct CameraLiveView_Previews: PreviewProvider {
    static var previews: some View {
        CameraLiveView()
    }
}
