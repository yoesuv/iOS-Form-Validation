//
//  ContentView.swift
//  Form Login & Register
//
//  Created by Yusuf Saifudin on 01/11/21.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(
                        header: Text("Email"),
                        footer: TextFooter(message: $viewModel.inlineErrorEmail.wrappedValue),
                        content: {
                            TextField("Email", text: $viewModel.email)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                            
                        })
                    Section(
                        header: Text("Password"),
                        footer: TextFooter(message: $viewModel.inlineErrorPassword.wrappedValue),
                        content: {
                            SecureField("Password", text: $viewModel.password)
                            
                        })
                }
                Button(action: {
                    
                }, label: {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 60)
                        .overlay(Text("LOGIN").foregroundColor(.white))
                        
                })
                .padding()
                .disabled(!$viewModel.isFormValid.wrappedValue)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
