//
//  Utilities.swift
//  GetStars
//
//  Created by Alejandro Miranda on 11/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

import Firebase

struct ImageLoader: Identifiable {
    var id: Int
    var image: UIImage
    init(image: UIImage, id: Int) {
        self.image = image
        self.id = id
    }
    
    func isContained(array: [ImageLoader], img: ImageLoader) -> Bool {
        for i in array {
            if i.id == img.id {
                return true
            }
        }
        return false
    }
}

struct UrlLoader: Identifiable {
    var id: Int
    var url: URL
    
    init(url: URL, id: Int) {
        self.id = id
        self.url = url
    }
    
    func isContained(array: [UrlLoader], url: UrlLoader) -> Bool {
        for i in array {
            if i.id == url.id {
                return true
            }
        }
        return false
    }
}

extension Color {
    static let neuBackground = Color(hex: "f0f0f3")
    static let dropShadow = Color(hex: "aeaec0").opacity(0.4)
    static let dropLight = Color(hex: "ffffff")
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        // scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff

        self.init(red: Double(r) / 0xff, green: Double(g) / 0xff, blue: Double(b) / 0xff)
    }
}
