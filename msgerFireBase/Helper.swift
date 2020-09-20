//
//  Helper.swift
//  msgerFireBase
//
//  Created by Mihail on 24.04.2020.
//  Copyright © 2020 loonyman. All rights reserved.
//

import FirebaseFirestore
import FirebaseStorage
import Firebase
import Foundation

final class Helper {
    
    func updateDB(uid: String, msg: String, date: Date) {
        
        let db = Firestore.firestore()
        let myUID = Auth.auth().currentUser?.uid
        
        db.collection("msgs").document(uid).collection(myUID!).document().setData(["msg": msg, "user": myUID!, "date": date]) { err in
            
            if err != nil {
                
                print((err?.localizedDescription)!)
                return
            }
        }
        
        db.collection("msgs").document(myUID!).collection(uid).document().setData(["msg": msg, "user": myUID!, "date": date]) { err in
            
            if err != nil {
                
                print((err?.localizedDescription)!)
                return
            }
        }
    }
    
    func updateRecents(uid: String, lastMsg: String, date: Date) {
        
        let db = Firestore.firestore()
        let myUID = Auth.auth().currentUser?.uid
        
        db.collection("users").document(uid).collection("recents").document(myUID!).updateData(["lastmsg" : lastMsg, "date": date])
        
        db.collection("users").document(myUID!).collection("recents").document(uid).updateData(["lastmsg" : lastMsg, "date": date])
    }
    
    func sendMsg(user: String, uid: String, pic: String, date: Date, msg: String) {
        
        let db = Firestore.firestore()
        let myUID = Auth.auth().currentUser?.uid
        
        db.collection("users").document(uid).collection("recents").document(myUID!).getDocument { (snap, err) in
            
            if err != nil {
                
                print((err?.localizedDescription)!)
                self.setRecents(user: user, uid: uid, pic: pic, date: date, msg: msg)
                return
            }
            
            if !snap!.exists {
                
                self.setRecents(user: user, uid: uid, pic: pic, date: date, msg: msg)
           
            } else {
                
                self.updateRecents(uid: uid, lastMsg: msg, date: date)
            }
        }
        
        updateDB(uid: uid, msg: msg, date: date)
    }
    
    func setRecents(user: String, uid: String, pic: String, date: Date, msg: String) {
        
        let db = Firestore.firestore()
        let myUID = Auth.auth().currentUser?.uid
        
        let myName = UserDefaults.standard.value(forKey: "UserName") as! String
        let myPic = UserDefaults.standard.value(forKey: "pic") as! String
        
        db.collection("users").document(uid).collection("recents").document(myUID!).setData(["name": myName, "pic": myPic, "lastmsg": msg, "date": date]) { err in
            
            if err != nil {
                
                print((err?.localizedDescription)!)
                return
            }
        }
        
        db.collection("users").document(myUID!).collection("recents").document(uid).setData(["name": user, "pic": pic, "lastmsg": msg, "date": date]) { err in
            
            if err != nil {
                
                print((err?.localizedDescription)!)
                return
            }
        }
    }
    
    //Проверка пользователя на зарегистрированность
    func checkUser(completion: @escaping (Bool, String, String, String) -> Void) {
        
        let dataBase = Firestore.firestore()
        
        dataBase.collection("users").getDocuments { (snap, err) in
            
            if err != nil {
                print((err?.localizedDescription)!)
            }
            //??? перебор всех пользователей ???
            for i in snap!.documents {
                //print(i.data())
                if i.documentID == Auth.auth().currentUser?.uid {
            
                    completion(true, i.get("name") as! String, i.documentID, i.get("pic") as! String)
                    return
                }
            }
            completion(false, "", "", "")
        }
    }
    
    func createUser(name: String, about: String, imageData: Data, completion: @escaping (Bool) -> Void) {
        
        let dataBase = Firestore.firestore()
        
        let storage = Storage.storage().reference()
        
        let uid = Auth.auth().currentUser?.uid
        
        storage.child("profilepics").child(uid!).putData(imageData, metadata: nil) { ( _, err ) in
            
            if err != nil {
                
                print((err?.localizedDescription)!)
                return
            }
            
            storage.child("profilepics").child(uid!).downloadURL { (url, err) in
                
                if err != nil {
                    
                    print((err?.localizedDescription)!)
                    return
                }
                
                dataBase.collection("users").document(uid!).setData(["name": name, "about": about, "pic": "\(url!)", "uid": uid!]) { (err) in
                    
                    if err != nil {
                        
                        print((err?.localizedDescription)!)
                        return
                    }
                    
                    completion(true)
                    
                    UserDefaults.standard.set(true, forKey: "status")
                    UserDefaults.standard.set(name, forKey: "UserName")
                    UserDefaults.standard.set(uid, forKey: "UID")
                    UserDefaults.standard.set("\(url!)", forKey: "pic")
                    
                    NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                    
                }
                
            }
        }
        
    }
}
