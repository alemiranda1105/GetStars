//
//  TermsView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 17/10/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import Firebase
import PDFKit

struct TermsView: View {
    @State var privacy = ""
    @State var terms = ""
    
    @State var page = 0
    private var paginas = ["Terms", "Privacy policy"]
    
    private func getUrls() {
        let storage = Storage.storage()
        let ref = storage.reference()
        let privPath = ref.child("terminosDeUso/PrivacyPolicy.pdf")
        let termsPath = ref.child("terminosDeUso/Terms.pdf")
        
        privPath.downloadURL { url, error in
            if error != nil {
                print(error?.localizedDescription ?? "")
                self.privacy = "Something has gone wrong, please try again"
            } else {
                self.privacy = url?.absoluteString ?? "Something has gone wrong, please try again"
                print("Obtenidos")
            }
        }
        
        termsPath.downloadURL { url, error in
            if error != nil {
                print(error?.localizedDescription ?? "")
                self.terms = "Something has gone wrong, please try again"
            } else {
                self.terms = url?.absoluteString ?? "Something has gone wrong, please try again"
                print("Obtenidos")
            }
        }
    }
    
    var body: some View {
        Group {
            
            Picker("", selection: self.$page) {
                ForEach(0 ..< self.paginas.count) { p in
                    Text(self.paginas[p])
                }
            }.pickerStyle(SegmentedPickerStyle())
            .padding()
            
            if self.page == 0 {
                if self.terms == "" {
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                } else {
                    PDFKitView(url: URL(string: self.terms)!)
                }
                
            } else {
                if self.terms == "" {
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                } else {
                    PDFKitView(url: URL(string: self.privacy)!)
                }
            }
            
        }.navigationBarTitle(Text("Terms and privacy"), displayMode: .inline)
        .onAppear(perform: self.getUrls)
    }
}

private struct PDFKitView: View {
    let url: URL
    var body: some View {
        PDFKitController(url)
    }
}

private struct PDFKitController: UIViewRepresentable {
    let url: URL
    
    init(_ url: URL) {
        self.url = url
    }
    
    func makeUIView(context: UIViewRepresentableContext<PDFKitController>) -> PDFKitController.UIViewType {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: self.url)
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitController>) {
        
    }
    
}
