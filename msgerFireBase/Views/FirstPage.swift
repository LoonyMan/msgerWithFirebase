//
//  FirstPage.swift
//  msgerFireBase
//
//  Created by Mihail on 20.04.2020.
//  Copyright © 2020 loonyman. All rights reserved.
//

import Firebase
import SwiftUI

struct FirstPage: View {
    
    @State var ccode = ""
    @State var number = ""
    @State var show = false
    @State var msg = ""
    @State var alert = false
    @State var ID = ""
    @State private var kbHeight: CGFloat = 0
    
    var body: some View {
        ScrollView(.init(), showsIndicators: false) {
            ZStack {
                VStack(spacing: 20) {
                    //Image("")
                    Text("Verify your number")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                    Text("Please enter your number to verify account")
                        .multilineTextAlignment(.center)
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.top, 12)
                    
                    HStack {
                        
                        TextField("+7", text: $ccode)
                            .keyboardType(.numberPad)
                            .frame(width: 45)
                            .padding()
                            .background(Color("custom_gray"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.top, 15)
                        
                        TextField("Number", text: $number)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color("custom_gray"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.top, 15)
                    }
                    
                    NavigationLink(destination: SecondPage(show: $show, ID: $ID), isActive: $show) {
                        Button(action: {
                            
                            //for testing
                            Auth.auth().settings?.isAppVerificationDisabledForTesting = true
                            
                            let number = "+" + self.ccode + self.number
                            
                            PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil) { (ID, err) in
                                
                                if err != nil {
                                    self.msg = (err?.localizedDescription)!
                                    self.alert.toggle()
                                    return
                                }
                                
                                self.ID = ID!
                                self.show.toggle()
                            }
                        }) {
                            Text("Send")
                                .frame(width: UIScreen.main.bounds.width - 30, height: 50)
                        }
                        .foregroundColor(.white)
                        .background(Color(.orange))
                        .cornerRadius(10)
                    }
                        
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
                    
                }
                    .padding()
                    .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                    .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                    .alert(isPresented: $alert) {
                        Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("Ok")))
                    }
            
            }
        }
        .padding(.bottom, self.kbHeight)
        .animation(.linear(duration: 0.15))
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .onAppear() {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (notify) in
                
                let data = notify.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
                
                let height = data.cgRectValue.height - (UIApplication.shared.windows.first?.safeAreaInsets.bottom)!
                
                self.kbHeight = height
                
                print(self.kbHeight)
                
            }
            
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (_) in
                self.kbHeight = 0
            }
        }
    }
}

struct FirstPage_Previews: PreviewProvider {
    static var previews: some View {
        FirstPage()
    }
}


