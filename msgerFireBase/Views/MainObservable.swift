//
//  MainObservable.swift
//  msgerFireBase
//
//  Created by Mihail on 06.07.2020.
//  Copyright © 2020 loonyman. All rights reserved.
//
import Firebase
import SwiftUI

class MainObservable : ObservableObject {
    
    @Published var recents = [Recent]()
    @Published var noRecents = false
    
    init() {
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        
        db.collection("users").document(uid!).collection("recents").order(by: "date", descending: true).addSnapshotListener { (snap, err) in
            
            if err != nil {
                
                print((err?.localizedDescription)!)
                self.noRecents = true
                return
            }
            
            if snap!.isEmpty {
                
                self.noRecents = true
            }
            
            
            for i in snap!.documentChanges {
                
                if i.type == .added {
                    
                    let id = i.document.documentID
                    let name = i.document.get("name") as! String
                    let pic = i.document.get("pic") as! String
                    let lastmsg = i.document.get("lastmsg") as! String
                    let stamp = i.document.get("date") as! Timestamp
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd/MM/yy"
                    let date = formatter.string(from: stamp.dateValue())
                    
                    formatter.dateFormat = "hh:mm a"
                    let time = formatter.string(from: stamp.dateValue())
                    
                    let recent = Recent(id: id, name: name, pic: pic, lastmsg: lastmsg, time: time, date: date, stamp: stamp.dateValue())
                    
                    self.recents.append(recent)
                }
                
                if i.type == .modified {
                    
                    let id = i.document.documentID
                    let lastmsg = i.document.get("lastmsg") as! String
                    let stamp = i.document.get("date") as! Timestamp
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd/MM/yy"
                    let date = formatter.string(from: stamp.dateValue())
                    
                    formatter.dateFormat = "hh:mm a"
                    let time = formatter.string(from: stamp.dateValue())
                    
                    for j in 0 ..< self.recents.count {
                        
                        if self.recents[j].id == id {
                            
                            self.recents[j].lastmsg = lastmsg
                            self.recents[j].time = time
                            self.recents[j].date = date
                            self.recents[j].stamp = stamp.dateValue()
                        }
                    }
                }
            }
        }
    }
}
