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

// Camara
import CameraManager

struct CameraLiveView: View {
    @EnvironmentObject var session: SessionStore
    
    @ObservedObject var cameraObject: CameraController = CameraController.shared
    
    @State var recording: Bool = false
    @State var time = 0
    @State var progress: Float = 0.0
    
    // El timer no funciona de manera correcta, una iteración = 4x 
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var recorded = false
    
    @Binding var message: String
    @Binding var email: String
    
    private func checkGrabacion() {
        print("Timer hit")
        if self.time >= 60 {
            self.time = 0
            self.uploadRecord()
        } else {
            self.time += 1
            self.progress += 0.25
        }
        print("\(self.time)")
    }
    
    private func uploadRecord() {
        self.recording = false
        let dg = DispatchGroup()
        self.cameraObject.stopRecording(key: "prueba", email: "amiranda110500@gmail.com", dg: dg)
        dg.notify(queue: DispatchQueue.global(qos: .background)) {
            print("Subido live temporal - Cambio a LivePlayer")
            self.recorded = true
        }
    }
    
    var body: some View {
        Group {
            if self.recorded {
                LivePlayerView(recorded: self.$recorded, email: self.$email)
                    .environmentObject(self.cameraObject)
                    .environmentObject(self.session)
            } else {
                VStack {
                    ZStack(alignment: .bottom) {
                        
                        VStack {
                            Spacer()
                            Text(self.message)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.gray.opacity(0.7))
                                .cornerRadius(20)
                            Spacer()
                        }.zIndex(1000004)
                        
                        CameraViewController().environmentObject(self.cameraObject)
                            .zIndex(1000000)
                        
                        HStack {
                            if !self.recording {
                                Button(action: {
                                    print("Modo flash")
                                    self.cameraObject.changeFlashMode()
                                }) {
                                    Image(systemName: "bolt")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                        .padding()
                                        .background(Color("gris"))
                                        .foregroundColor(.white)
                                        .cornerRadius(100)
                                }
                            }
                            Spacer()
                        }.padding()
                        .zIndex(1000002)
                        
                        HStack(alignment: .center){
                            Button(action: {
                                print("Grabando")
                                self.recording.toggle()
                                if self.recording {
                                    self.cameraObject.startRecording()
                                } else {
                                    self.uploadRecord()
                                }
                            }) {
                                if !self.recording {
                                    Image(systemName: "video.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .padding()
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(100)
                                    
                                } else {
                                   Text("\(self.time/4)")
                                       .frame(width: 40, height: 40)
                                       .padding()
                                       .background(Color.red)
                                       .foregroundColor(.white)
                                       .cornerRadius(100)
                                    .onReceive(timer) { t in
                                        self.checkGrabacion()
                                    }
                                }
                                
                            }.padding(.horizontal, 90)
                            
                        }.padding()
                        .zIndex(1000001)
                        
                        HStack {
                            Spacer()
                            if !self.recording {
                                Button(action: {
                                    print("Cambiar Camara")
                                    self.cameraObject.changeCamera()
                                }) {
                                    if !self.recording {
                                        Image(systemName: "arrow.clockwise")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                            .padding()
                                            .background(Color("gris"))
                                            .foregroundColor(.white)
                                            .cornerRadius(100)
                                    }
                                }
                            }
                        }.padding()
                        .zIndex(1000002)
                    }
                }
            }
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
        self.cameraObject.camera.shouldFlipFrontCameraImage = false
        self.cameraObject.camera.cameraOutputQuality = .hd1920x1080
        self.cameraObject.camera.videoAlbumName = "GetStarsLives"
        
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
