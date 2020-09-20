//
//  ChatView.swift
//  msgerFireBase
//
//  Created by Mihail on 06.07.2020.
//  Copyright © 2020 loonyman. All rights reserved.
//
import Firebase
import SwiftUI

struct ChatView: View {
    
    var name : String
    var pic : String
    var uid : String
    @Binding var chat : Bool
    @State var msgs = [Msg]()
    @State var txt = ""
    @State var noMsgs = false
    
    var body: some View {
        VStack {
            
            if msgs.isEmpty {
                
                if self.noMsgs {
                    
                    Text("Let's write!")
                        .foregroundColor(Color.black.opacity(0.5))
                        .padding(.top)
                    
                    Spacer()
                } else {
                    
                    Spacer()
                    Indicator()
                    Spacer()
                }
                
            } else {
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(spacing: 6) {
                        
                        ForEach(self.msgs) { i in
                            HStack {
                                
                                if i.user == UserDefaults.standard.value(forKey: "UID") as! String {
                                    
                                    Spacer()
                                    Text(i.msg)
                                        .padding()
                                        .foregroundColor(.white)
                                        .background(Color.blue.opacity(0.85))
                                        .clipShape(ChatBubble(myMsg: true))
                                } else {
                                    
                                    Text(i.msg)
                                        .padding()
                                        .foregroundColor(.white)
                                        .background(Color.green.opacity(0.85))
                                        .clipShape(ChatBubble(myMsg: false))
                                    Spacer()
                                }
                            }
                        }
                    }
                }
                
            }
            
            HStack {
                
                TextField("Enter Message", text: self.$txt)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    
                    Helper().sendMsg(user: self.name, uid: self.uid, pic: self.pic, date: Date(), msg: self.txt)
                    self.txt = ""
                }) {
                    
                    Text("Send")
                }
            }
            .navigationBarTitle("\(name)", displayMode: .inline)
            //                .navigationBarItems(leading:
            //                    Button(action: {
            //                        self.chat.toggle()
            //                    }, label: {
            //                        Image(systemName: "arrow.left")
            //                            .resizable()
            //                            .frame(width: 20, height: 20)
            //                    }))
        }
        .padding()
        .onAppear {
            
            self.getMsgs()
        }
    }
    
    func getMsgs() {
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        
        db.collection("msgs").document(uid!).collection(self.uid).order(by: "date", descending: false).addSnapshotListener { (snap, err) in
            
            if err != nil {
                print((err?.localizedDescription)!)
                self.noMsgs = true
                return
            }
            
            if snap!.isEmpty {
                
                self.noMsgs = true
            }
            
            for i in snap!.documentChanges {
                
                if i.type == .added {
                    
                    let id = i.document.documentID
                    let msg = i.document.get("msg") as! String
                    let user = i.document.get("user") as! String
                    
                    let message = Msg(id: id, msg: msg, user: user)
                    
                    self.msgs.append(message)
                }
            }
        }
    }
}
