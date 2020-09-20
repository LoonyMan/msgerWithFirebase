//
//  ChatBubble.swift
//  msgerFireBase
//
//  Created by Mihail on 06.07.2020.
//  Copyright © 2020 loonyman. All rights reserved.
//

import SwiftUI

struct ChatBubble : Shape {
    
    var myMsg : Bool
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight, myMsg ? .bottomLeft : .bottomRight], cornerRadii: CGSize(width: 16, height: 16))
        
        return Path(path.cgPath)
    }
    
    
}
