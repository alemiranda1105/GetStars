//
//  CameraController.swift
//  GetStars
//
//  Created by Alejandro Miranda on 10/09/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import UIKit
import AVFoundation
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
}

