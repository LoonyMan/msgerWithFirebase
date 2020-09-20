//
//  Home.swift
//  msgerFireBase
//
//  Created by Mihail on 20.04.2020.
//  Copyright © 2020 loonyman. All rights reserved.
//


import Firebase
import SwiftUI

struct Home: View {
    
    //
    @State var newKey = ""
    //
    @State var showQRView = false
    @State var myuid = UserDefaults.standard.value(forKey: "UserName") as! String
    @EnvironmentObject var datas : MainObservable
    @State var show = false
    @State var chat = false
    @State var uid = ""
    @State var name = ""
    @State var pic = ""
    
    var body: some View {
        
        ZStack {
            
            NavigationLink(destination: ChatView(name: self.name, pic: self.pic, uid: self.uid, chat: self.$chat), isActive: self.$chat) {
                
                Text("")
            }
            
            VStack {
                
                
                
                if self.datas.recents.isEmpty {
                    
                    if self.datas.noRecents {
                        
                        VStack {
                            
                            Text("No chat history :(")
                                .padding()
                            Text("Let's write to friends!")
                        }
                        
                    } else {
                        
                        Indicator()
                    }
                    
                } else {
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        VStack(spacing: 12) {
                            
                            ForEach(datas.recents.sorted(by: { $0.stamp > $1.stamp })) { i in
                                
                                Button(action: {
                                    
                                    self.uid = i.id
                                    self.name = i.name
                                    self.pic = i.pic
                                    self.chat.toggle()
                                    
                                }) {
                                    RecentCellView(url: i.pic, name: i.name, time: i.time, date: i.date, lastmsg: i.lastmsg)
                                }
                                
                            }
                        }.padding()
                    }
                }
                
                
            }.navigationBarTitle("Home")
                .navigationBarItems(leading:
                    Button(action: {
                        
                        UserDefaults.standard.set("", forKey: "UserName")
                        UserDefaults.standard.set("", forKey: "UID")
                        UserDefaults.standard.set("", forKey: "pic")
                        
                        try! Auth.auth().signOut()
                        
                        UserDefaults.standard.set(false, forKey: "status")
                        
                        NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                    }) {
                        
                        Text("Sign Out")
                    },
                                    trailing:
                    NavigationLink(destination: QRCodeView(), isActive: $showQRView) {
                        Button(action: {
                            self.show.toggle()
                            //self.showQRView.toggle()
                        }) {
                            Image(systemName: "square.and.pencil")
                                .resizable()
                                .frame(width: 25, height: 25)
                        }
                    }
                    
//                    .sheet(isPresented: $showQRScanner) {
//                        QRCodeScanner(data: self.$newKey, show: self.$showQRScanner)
//                    }
                    
            )
        }.sheet(isPresented: self.$show) {
            NewChatView(name: self.$name, uid: self.$uid, pic: self.$pic, show: self.$show, chat: self.$chat)
        }
    }
}



struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
