//
//  Extensions.swift
//  msgerFireBase
//
//  Created by Mihail on 19.05.2020.
//  Copyright © 2020 loonyman. All rights reserved.
//

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
