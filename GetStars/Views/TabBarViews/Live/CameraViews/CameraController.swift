//
//  CameraController.swift
//  GetStars
//
//  Created by Alejandro Miranda on 10/09/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import CameraManager

class CameraController: ObservableObject {
    @Published var camera = CameraManager()
    
    static let shared = CameraController()
    
    // Settings camara
    func changeCamera() {
        if self.camera.cameraDevice == .back {
            self.camera.cameraDevice = .front
        } else {
            self.camera.cameraDevice = .back
        }
    }
    
    func changeFlashMode() {
        if self.camera.flashMode == .off {
            self.camera.flashMode = .on
        } else {
            self.camera.flashMode = .off
        }
    }
    
    // Funciones camara
    func startRecording() {
        self.camera.startRecordingVideo()
    }
    
    func stopRecording(key: String, email: String) {
        self.camera.stopVideoRecording { (video, error) -> Void in
            if error != nil {
                self.camera.showErrorBlock("Error ocurred", "Cannot save video")
            } else {
                let st = StarsST()
                st.uploadLiveToUser(key: key, email: email, url: video!)
            }
        }
    }
    
    fileprivate func saveVideo(video: URL?) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: video!)}) { saved, error in
                if saved {
                    print("----- Video guardado bro -----")
                } else {
                    print(error?.localizedDescription ?? "")
                    print("----- Error guardando el video -----")
                }
            }
    }
}

