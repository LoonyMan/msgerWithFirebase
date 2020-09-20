//
//  QRScanner.swift
//  msgerFireBase
//
//  Created by Mihail on 16.07.2020.
//  Copyright © 2020 loonyman. All rights reserved.
//
import CodeScanner
import SwiftUI

struct QRCodeScanner: View {
    
    @Binding var data: String
    @Binding var show: Bool
    
    var body: some View {
        ZStack {
            CodeScannerView(codeTypes: [.qr], completion: self.handleScan)
                .onTapGesture {
                    self.show.toggle()
            }
        }
        
    }
    
    private func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        switch result {
        case .success(let string):
            print("Success with \(string)")
            
            self.data = string
            self.show.toggle()
        case .failure(let error):
            print("Scanning failed \(error)")
        }
    }
}
