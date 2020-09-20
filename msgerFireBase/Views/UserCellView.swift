//
//  UserCellView.swift
//  msgerFireBase
//
//  Created by Mihail on 06.07.2020.
//  Copyright © 2020 loonyman. All rights reserved.
//
import SDWebImageSwiftUI
import SwiftUI

struct UserCellView: View {
    
    var url : String
    var name : String
    var about : String
    
    var body: some View {
        HStack {
            AnimatedImage(url: URL(string: url))
                .resizable()
                .renderingMode(.original)
                .frame(width: 55, height: 55)
                .clipShape(Circle())
            
            VStack {
                
                HStack {
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(name)
                            .foregroundColor(.black)
                        Text(about)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    
                }
                
                Divider()
            }
        }
    }
}

