//
//  SecondPage.swift
//  msgerFireBase
//
//  Created by Mihail on 20.04.2020.
//  Copyright © 2020 loonyman. All rights reserved.
//
import Firebase
import SwiftUI

struct SecondPage: View {
    
    @State var code = ""
    @Binding var show : Bool
    @Binding var ID : String
    @State var msg = ""
    @State var alert = false
    @State var creation = false
    @State var loading = false
    @State private var kbHeight: CGFloat = 0.0
    
    var body: some View {
        
        ScrollView(.init(), showsIndicators: false) {
            ZStack(alignment: .topLeading) {
                
                GeometryReader { _ in
                    VStack(spacing: 20) {
                        //Image("")
                        Text("Verification code")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                        Text("Please enter the verification code")
                            .font(.body)
                            .foregroundColor(.gray)
                            .padding(.top, 12)
                        
                        TextField("Code", text: self.$code)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color("custom_gray"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.top, 10)
                        
                        
                        if self.loading {
                            
                            HStack {
                                
                                Spacer()
                                
                                Indicator()
                                
                                Spacer()
                            }
                        }
                            
                        else {
                            
                            Button(action: {
                                self.loading.toggle()
                                
                                let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.ID, verificationCode: self.code)
                                
                                Auth.auth().signIn(with: credential) { (res, err) in
                                    
                                    if err != nil {
                                        self.msg = (err?.localizedDescription)!
                                        self.alert.toggle()
                                        return
                                    }
                                    
                                    Helper().checkUser { (exists, user, uid, pic) in
                                        
                                        if exists {
                                            
                                            UserDefaults.standard.set(true, forKey: "status")
                                            UserDefaults.standard.set(user, forKey: "UserName")
                                            UserDefaults.standard.set(uid, forKey: "UID")
                                            UserDefaults.standard.set(pic, forKey: "pic")
                                            //?
                                            NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                                            
                                        } else {
                                            
                                            self.loading.toggle()
                                            self.creation.toggle()
                                            
                                        }
                                    }
                                    
                                    
                                }
                            }) {
                                Text("Verify")
                                    .frame(width: UIScreen.main.bounds.width - 30, height: 50)
                            }
                            .foregroundColor(.white)
                            .background(Color(.orange))
                            .cornerRadius(10)
                            
                        }
                    }
                }
                
                Button(action: {
                    self.show.toggle()
                }) {
                    Image(systemName: "chevron.left").font(.title)
                    
                }.foregroundColor(.orange)
            }
            .padding()
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .alert(isPresented: $alert) {
                Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("Ok"), action: {
                    self.loading.toggle()
                }))
            }
            .sheet(isPresented: self.$creation) {
                AccountCreation(show: self.$creation)
            }
        }
        .padding(.bottom, self.kbHeight)
        .animation(.linear(duration: 0.15))
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (notify) in
                
                let data = notify.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
                
                let height = data.cgRectValue.height - (UIApplication.shared.windows.first?.safeAreaInsets.bottom)!
                
                self.kbHeight = height
                
                
            }
            
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (_) in
                
                self.kbHeight = 0
            }
        }
        
    }
}

