//
//  AccountCreation.swift
//  msgerFireBase
//
//  Created by Mihail on 24.04.2020.
//  Copyright © 2020 loonyman. All rights reserved.
//

import SwiftUI

struct AccountCreation: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var show: Bool
    @State var name = ""
    @State var about = ""
    @State var picker = false
    @State var loading = false
    @State var imageData: Data = .init(count: 0)
    @State var alert = false
    @State private var kbHeight: CGFloat = 0.0
    
    var body: some View {
        
        ScrollView(.init(), showsIndicators: false) {
            
            VStack {
                Text("Create an Account")
                    .font(.title)
                
                HStack {
                    Spacer()
                    Button(action: {
                        self.picker.toggle()
                    }) {
                        
                        if self.imageData.count == 0 {
                            Image(systemName: "person.crop.circle.badge.plus")
                                .resizable()
                                .frame(width: 90, height: 70)
                                .foregroundColor(.gray)
                        } else {
                            
                            Image(uiImage: UIImage(data: self.imageData)!)
                                .resizable()
                                .renderingMode(.original)
                                .frame(width: 90, height: 90)
                                .clipShape(Circle())
                        }
                        
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 15)
                Text("Please enter user name")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding(.top, 12)
                
                TextField("Name", text: self.$name)
                    .keyboardType(.default)
                    .padding()
                    .background(Color("custom_gray"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.top, 10)
                
                Text("About you")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding(.top, 12)
                
                TextField("About", text: self.$about)
                    .keyboardType(.default)
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
                    
                } else {
                    
                    Button(action: {
                        
                        if self.name != "" && self.about != "" && self.imageData.count != 0 {
                            
                            self.loading.toggle()
                            
                            Helper().createUser(name: self.name, about: self.about, imageData: self.imageData) {
                                (status) in
                                
                                if status {
                                    
                                    self.show.toggle()
                                }
                                
                            }
                            
                        } else {
                            
                            self.alert.toggle()
                            
                        }
                        
                    }) {
                        Text("Create")
                            .frame(width: UIScreen.main.bounds.width - 30, height: 50)
                    }
                    .foregroundColor(.white)
                    .background(Color(.orange))
                    .cornerRadius(10)
                    
                }
                
            }
            .padding()
            .sheet(isPresented: self.$picker, content: {
                ImagePicker(picker: self.$picker, imageData: self.$imageData)
            })
                
            .alert(isPresented: self.$alert) {
                Alert(title: Text("Message"), message: Text("Please fill the contents"), dismissButton: .default(Text("Ok")))
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

