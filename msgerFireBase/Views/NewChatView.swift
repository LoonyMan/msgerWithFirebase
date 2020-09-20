//
//  NewChatView.swift
//  msgerFireBase
//
//  Created by Mihail on 06.07.2020.
//  Copyright © 2020 loonyman. All rights reserved.
//

import SwiftUI

struct NewChatView: View {
    
    @ObservedObject var datas = GetAllUsers()
    @Binding var name : String
    @Binding var uid : String
    @Binding var pic : String
    @Binding var show : Bool
    @Binding var chat : Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            
            
            if self.datas.users.isEmpty {
                
                Indicator()
                
            } else {
                
                Text("Select to chat")
                    .font(.title)
                    .foregroundColor(Color.black.opacity(0.5))
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(spacing: 12) {
                        
                        ForEach(datas.users) { i in
                            
                            Button(action: {
                                
                                self.uid = i.id
                                self.name = i.name
                                self.pic = i.pic
                                self.show.toggle()
                                self.chat.toggle()
                                
                            }) {
                                UserCellView(url: i.pic, name: i.name, about: i.about)
                            }
                            
                        }
                    }
                }
                
            }
        }.padding()
    }
}

