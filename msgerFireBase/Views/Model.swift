//
//  Model.swift
//  msgerFireBase
//
//  Created by Mihail on 06.07.2020.
//  Copyright © 2020 loonyman. All rights reserved.
//

import Foundation

struct Recent : Identifiable {
    var id : String
    var name : String
    var pic : String
    var lastmsg : String
    var time : String
    var date : String
    var stamp : Date

}

struct User : Identifiable {
    var id : String
    var name : String
    var pic : String
    var about : String
}

struct Msg : Identifiable {
    
    var id : String
    var msg : String
    var user : String
}
