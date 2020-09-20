//
//  ContentView.swift
//  msgerFireBase
//
//  Created by Mihail on 20.04.2020.
//  Copyright © 2020 loonyman. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    
    var body: some View {
        
        VStack {
            
            if status {
                NavigationView {
                    Home().environmentObject(MainObservable())
                }
                
                
            } else {

                NavigationView {
                    
                    FirstPage()
                }
            }
            
        }.onAppear {
            NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main) { (_) in
                
                let status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                
                self.status = status
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
