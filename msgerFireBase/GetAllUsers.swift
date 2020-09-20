//
//  GetAllUsers.swift
//  msgerFireBase
//
//  Created by Mihail on 06.07.2020.
//  Copyright © 2020 loonyman. All rights reserved.
//
import Firebase
import Foundation

class GetAllUsers : ObservableObject {
    @Published var users = [User]()
    
    init() {
        let db = Firestore.firestore()
        
        db.collection("users").getDocuments { (snap, err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            
            for i in snap!.documents {
                
                let id = i.documentID
                let name = i.get("name") as! String
                let pic = i.get("pic") as! String
                let about = i.get("about") as! String
                
                if id != UserDefaults.standard.value(forKey: "UID") as! String {
                    
                    let user = User(id: id, name: name, pic: pic, about: about)
                    
                    self.users.append(user)
                    
                }
                
            }
        }
    }
}
