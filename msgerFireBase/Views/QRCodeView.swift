//
//  QRCodeView.swift
//  msgerFireBase
//
//  Created by Mihail on 16.07.2020.
//  Copyright © 2020 loonyman. All rights reserved.
//
import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeView: View {
    
    @State var showScanner = false
    @State var newKey = ""
    @State var stringForQRCode = "cryptoKey"
    
    var body: some View {
        
        Image(uiImage: generateQRCodeImage(with: stringForQRCode))
            .resizable()
            .interpolation(.none)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        .navigationBarItems(trailing:
            Button(action: {
                self.showScanner.toggle()
            }) {
                Text("QRScanner")
            }
            .sheet(isPresented: $showScanner) {
                QRCodeScanner(data: self.$newKey, show: self.$showScanner)
            }
        )
    }
    
    func generateQRCodeImage(with string: String) -> UIImage {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        let data = Data(string.utf8)
        
        filter.setValue(data, forKey: "inputMessage")
        
        guard let qrCodeImage = filter.outputImage,
            let qrCodeCGImage = context.createCGImage(qrCodeImage, from: qrCodeImage.extent) else { return UIImage(systemName: "xmark")! }
        
        return UIImage(cgImage: qrCodeCGImage)
    }
}

