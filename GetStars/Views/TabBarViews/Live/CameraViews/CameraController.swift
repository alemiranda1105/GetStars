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
    
    func changeCamera() {
        if self.camera.cameraDevice == .back {
            self.camera.cameraDevice = .front
        } else {
            self.camera.cameraDevice = .back
        }
    }
    
    func startRecording() {
        self.camera.startRecordingVideo()
    }
    
    func stopRecording() {
        self.camera.stopVideoRecording { (video, error) -> Void in
            if error != nil {
                self.camera.showErrorBlock("Error ocurred", "Cannot save video")
            } else {
                self.saveVideo(video: video)
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

