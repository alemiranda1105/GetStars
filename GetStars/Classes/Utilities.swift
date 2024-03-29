//
//  Utilities.swift
//  GetStars
//
//  Created by Alejandro Miranda on 11/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit
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

class UrlLoader: Identifiable {
    var id: Int
    var url: URL
    
    var name: String = ""
    
    init(url: URL, id: Int) {
        self.id = id
        self.url = url
    }
    
    func setName(name: String) {
        self.name = name
    }
    
    func isContained(array: [UrlLoader], url: UrlLoader) -> Bool {
        for i in array {
            if i.id == url.id {
                return true
            }
            if i.url == url.url {
                return true
            }
        }
        return false
    }
    
    func getNewId(array: [UrlLoader]) -> Int {
        return array.count
    }
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

extension Color {

    func uiColor() -> UIColor {

        let components = self.components()
        return UIColor(red: components.r, green: components.g, blue: components.b, alpha: components.a)
    }

    func components() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {

        let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0

        let result = scanner.scanHexInt64(&hexNumber)
        if result {
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000ff) / 255
        }
        return (r, g, b, a)
    }
}

extension Double {
    var dollarString:String {
        return String(format: "%.2f", self)
    }
}

extension UIApplication {
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}

func generateDocumentId(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map{ _ in letters.randomElement()! })
}

func hexToString(color: UIColor) -> String {
    if color == UIColor.black {
        return "000000"
    } else if color == UIColor.white {
        return "FFFFFF"
    }
    
    let components = color.cgColor.components
    let r = components![0]
    let g = components![1]
    let b = components![2]
    let hexString = String(format: "%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    return hexString
}

// Cambio de atributos navigationBar
struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }
}

func validateEmail(enteredEmail:String) -> Bool {
    let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
    return emailPredicate.evaluate(with: enteredEmail)
}
