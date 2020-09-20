//
//  Indicator.swift
//  msgerFireBase
//
//  Created by Mihail on 24.04.2020.
//  Copyright © 2020 loonyman. All rights reserved.
//

import SwiftUI

struct Indicator: UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<Indicator>) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        return indicator
    }
    
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Indicator>) {
        
    }
}
